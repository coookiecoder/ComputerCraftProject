function display(monitor, list, line)
        for index = 1, table.getn(list) do
                maintenance.setCursorPos(1, line)
                maintenance.write(list[index])

                line = line + 1
        end
end

function displayPos(monitor, message, x, y)
        monitor.setCursorPos(x, y)
        monitor.write(message)
end

function setup()
        maintenance = peripheral.wrap("left")
        maintenance.clear()

        modem = peripheral.wrap("back")
        relay_list = modem.getNamesRemote()

        displayPos(maintenance, "select clutch", 1, 1)
        display(maintenance, relay_list, 3)

        event, size, x, y = os.pullEvent("monitor_touch")

        clutch = relay_list[y - 2]

        maintenance.clear()

        displayPos(maintenance, "select gearshift", 1, 1)

        display(maintenance, relay_list, 3)

        event, size, x, y = os.pullEvent("monitor_touch")
        gearshift = relay_list[y - 2]

        maintenance.clear()

        displayPos(maintenance, "clutch :", 1, 1)
        displayPos(maintenance, clutch, 1, 2)
        displayPos(maintenance, "gearshift :", 1, 4)
        displayPos(maintenance, gearshift, 1, 5)
        displayPos(maintenance, "number of floors :", 1, 7)
        displayPos(maintenance, table.getn(relay_list) - 2, 1, 8)

        modem.callRemote(gearshift, "setOutput", "front", false)
        os.sleep(10)
        modem.callRemote(clutch, "setOutput", "front", true)
end

function setupFloor()
        maintenance = peripheral.wrap("left")
        maintenance.clear()

        modem = peripheral.wrap("back")

        detected_floors = 1

        for index = 1, table.getn(relay_list) do
                if modem.callRemote(relay_list[index], "getInput", "front") then
                        floors[1] = relay_list[index]
                        break
                end
        end

        modem.callRemote(clutch, "setOutput", "front", false)
        modem.callRemote(gearshift, "setOutput", "front", true)

        while detected_floors < table.getn(relay_list) - 2 do
                for index = 1, table.getn(relay_list) do
                        if modem.callRemote(relay_list[index], "getInput", "front") and floors[detected_floors] ~= relay_list[index] then
                                detected_floors = detected_floors + 1
                                floors[detected_floors] = relay_list[index]
                                break
                        end
                end
        end

        displayPos(maintenance, "detected floor order : ", 1, 1)
        display(maintenance, floors, 3)

        modem.callRemote(gearshift, "setOutput", "front", false)
        while not modem.callRemote(floors[1], "getInput", "front") do
                os.sleep(1)
        end
        modem.callRemote(clutch, "setOutput", "front", true)
end

relay_list = {}
clutch = ""
gearshift = ""
floors = {}

setup()
setupFloor()
