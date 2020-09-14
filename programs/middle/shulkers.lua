-- local modem = peripheral.wrap("right")

-- local inventoryFile = fs.open("inventory", "r")
-- local inventorySerial = inventoryFile.readAll()
-- local inventory = textutils.unserialize(inventorySerial)

-- for slot, content in ipairs(inventory) do
--   if content ~= nil and content.name == "minecraft:stone" then
--     turtle.select(slot)
--     turtle.dropDown()
--   end
-- end
-- sleep(1)
-- modem.transmit(1005, 1, "done")

print("Searching for Shulkers")
shell.run("/programs/_done.lua")