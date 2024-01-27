# LuaMQTT ComputerCraft

A fork of [LuaMQTT](https://github.com/xHasKx/luamqtt) slightly modified to work within computercraft over websockets. As websockets yield, ioloop does not work. The provided example shows how to maintain a connection using parallel coroutines to send PINGREQs to the broker instead of relying on ioloop.
