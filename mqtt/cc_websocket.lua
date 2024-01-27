local string_sub = string.sub

-- module table
local cc_websocket = {}

-- Open network connection to .host and .port in conn table
-- Store opened socket to conn table
-- Returns true on success, or false and error text on failure
function cc_websocket.connect(conn)
    local sock, err = http.websocket(
        conn.uri,
        -- string.format("%s://%s:%d/mqtt", conn.secure and "wss" or "ws", conn.host, conn.port),
        { ["Sec-WebSocket-Protocol"] = "mqtt" })
    if not sock then
        return false, "socket.connect failed: " .. err
    end
    conn.sock = sock
    return true
end

-- Shutdown network connection
function cc_websocket.shutdown(conn)
    conn.sock:close()
end

-- Send data to network connection
function cc_websocket.send(conn, data, i, j)
    if i then
        conn.sock.send(string_sub(data, i, j), true)
        return data:len()
    else
        conn.sock.send(data, true)
        return data:len()
    end
end

-- Receive given amount of data from network connection
function cc_websocket.receive(conn, size)
    if (not conn.recieved_value) or conn.recieved_value == '' then
        local value, is_binary = conn.sock.receive(conn.timeout)
        if not value then return nil, "timeout" end

        conn.recieved_value = value
    end

    local retval = string_sub(conn.recieved_value, 1, size)
    conn.recieved_value = string_sub(conn.recieved_value, size + 1)

    -- if ok then
    -- 	print("    luasocket.receive:", size, require("mqtt.tools").hex(ok))
    -- elseif err ~= "timeout" then
    -- 	print("    luasocket.receive:", ok, err)
    -- end

    -- print(string.format("read %d bytes, recv length remaining: %d, retval length: %d", size, conn.recieved_value:len(),
    --     retval:len()))

    return retval
end

function cc_websocket.settimeout(conn, timeout)
    conn.timeout = timeout
end

-- export module table
return cc_websocket

-- vim: ts=4 sts=4 sw=4 noet ft=lua
