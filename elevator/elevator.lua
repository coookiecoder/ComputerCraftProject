maintenance = peripheral.wrap("left")
maintenance.clear()

modem = peripheral.wrap("back")
relay_list = modem.getNamesRemote()

maintenance.setCursorPos(1, 1)
maintenance.write("select clutch")

line = 3

for index = 1, table.getn(relay_list) do
    maintenance.setCursorPos(1, line)
    maintenance.write(relay_list[index])

    line = line + 1
end

event, size, x, y = os.pullEvent("monitor_touch")

clutch = relay_list[y - 2]

maintenance.clear()

maintenance.setCursorPos(1, 1)
maintenance.write("select gearshift")

line = 3

for index = 1, table.getn(relay_list) do
    maintenance.setCursorPos(1, line)
    maintenance.write(relay_list[index])

    line = line + 1
end

event, size, x, y = os.pullEvent("monitor_touch")
gearshift = relay_list[y - 2]

maintenance.clear()

maintenance.setCursorPos(1, 1)
maintenance.write("clutch :")

maintenance.setCursorPos(1, 2)
maintenance.write(clutch)

maintenance.setCursorPos(1, 4)
maintenance.write("gearshift :")

maintenance.setCursorPos(1, 5)
maintenance.write(gearshift)

modem.callRemote(clutch, "setOutput", "front", true)
