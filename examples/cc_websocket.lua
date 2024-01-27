local mqtt = require("mqtt")

local keep_alive = 60

-- create mqtt client
local client = mqtt.client {
    -- NOTE: this broker is not working sometimes; comment username = "..." below if you still want to use it
    -- uri = "test.mosquitto.org",
    uri = "wss://broker.emqx.io:8084/mqtt",
    clean = true,
    keep_alive = keep_alive
}

print("created MQTT client", client)

client:on {
    connect = function(connack)
        if connack.rc ~= 0 then
            print("connection to broker failed:", connack:reason_string(), connack)
            return
        end
        print("connected:", connack) -- successful connection

        -- subscribe to test topic and publish message after it
        assert(client:subscribe { topic = "test", qos = 1, callback = function(suback)
            print("subscribed:", suback)

            -- publish test message
            print('publishing test message "hello" to "luamqtt/simpletest" topic...')
            assert(client:publish {
                topic = "test",
                payload = "hello",
                qos = 1
            })
        end })
    end,

    message = function(msg)
        assert(client:acknowledge(msg))

        print("received:", msg)

        if msg.payload == "disconnect" then
            print("disconnecting...")
            assert(client:disconnect())
        end
    end,

    error = function(err)
        print("MQTT client error:", err)
    end,

    close = function()
        print("MQTT conn closed")
    end
}


parallel.waitForAny(
    function()
        -- run io loop for client until connection close
        -- please note that in sync mode background PINGREQ's are not available, and automatic reconnects too
        print("running client in synchronous input/output loop")
        mqtt.run_sync(client)
        print("done, synchronous input/output loop is stopped")
    end,
    function()
        while true do
            os.sleep(keep_alive)
            client:send_pingreq()
        end
    end
)
