local width, height = term.getSize()

local function update(text)
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
    term.setCursorPos(1, 9)
    term.clearLine()
    term.setCursorPos(math.floor(width / 2 - string.len(text) / 2), 9)
    write(text)
end

local function bar(ratio)
    term.setBackgroundColor(colors.gray)
    term.setTextColor(colors.lime)
    term.setCursorPos(1, 11)

    for i = 1, width do
        if (i / width < ratio) then
            write("]")
        else
            write(" ")
        end
    end
end

local function download(path)
    update("Downloading " .. path .. "...")

    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
    term.setCursorPos(1, 13)
    term.clearLine()
    term.setCursorPos(1, 14)
    term.clearLine()
    term.setCursorPos(1, 15)
    term.clearLine()
    term.setCursorPos(1, 16)
    term.clearLine()
    term.setCursorPos(1, 17)
    term.clearLine()
    term.setCursorPos(1, 13)

    print("Accessing https://raw.githubusercontent.com/WhyKickAmooCow/luamqtt-computercraft/main/" .. path)
    local rawData = http.get("https://raw.githubusercontent.com/WhyKickAmooCow/luamqtt-computercraft/main/" .. path)
    local data = rawData.readAll()
    local file = fs.open(path, "w")
    file.write(data)
    file.close()
end

function install()
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.yellow)
    term.clear()

    local str = "LuaMQTT:ComputerCraft Installer"
    term.setCursorPos(math.floor(width / 2 - #str / 2), 2)
    write(str)

    local total = 13

    update("Installing...")
    bar(0)

    download("LICENSE")
    bar(1 / total)
    download("README.md")
    bar(2 / total)

    update("Creating mqtt folder...")
    fs.makeDir("mqtt")
    download("mqtt/bitwrap.lua")
    bar(3 / total)
    download("mqtt/cc_websocket.lua")
    bar(4 / total)
    download("mqtt/client.lua")
    bar(5 / total)
    download("mqtt/const.lua")
    bar(6 / total)
    download("mqtt/init.lua")
    bar(7 / total)
    download("mqtt/ioloop.lua")
    bar(8 / total)
    download("mqtt/luasocket.lua")
    bar(9 / total)
    download("mqtt/protocol.lua")
    bar(10 / total)
    download("mqtt/protocol4.lua")
    bar(11 / total)
    download("mqtt/protocol5.lua")
    bar(12 / total)
    download("mqtt/tools.lua")
    bar(13 / total)

    update("Creating examples folder...")
    fs.makeDir("examples")
    download("examples/cc_websocket.lua")

    update("Installation finished!")

    sleep(1)

    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
    term.clear()

    term.setCursorPos(1, 1)
    write("Finished installation!\nPress any key to close...")

    os.pullEventRaw()

    term.clear()
    term.setCursorPos(1, 1)
end

install()
