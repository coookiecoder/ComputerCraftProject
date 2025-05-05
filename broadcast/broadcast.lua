modem = peripheral.wrap("back")

monitor_list = modem.getNamesRemote()

message_file = fs.open("message", "r")
message = message_file.readAll()
message_file.close()

monitor_debug = peripheral.wrap("top")
monitor_debug.clear()

for index = 1, table.getn(monitor_list) do
    monitor_debug.setCursorPos(1, index)
    monitor_debug.write(monitor_list[index])

    modem.callRemote(monitor_list[index], "clear")
    modem.callRemote(monitor_list[index], "setCursorPos", 1, 1)
    modem.callRemote(monitor_list[index], "write", message)
end

monitor_debug.setCursorPos(1, table.getn(monitor_list) + 2)
monitor_debug.write(message)
