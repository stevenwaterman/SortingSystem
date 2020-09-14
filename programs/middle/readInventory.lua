local x, y = ...

local function readInventory()
  local inventoryFile = fs.open("inventory", "r")
  local serialisedData = inventoryFile.readAll()
  local data = textutils.unserialize(serialisedData)
  inventoryFile.close()
  return data
end


local data = {
  x = x,
  inventory = readInventory()
}
local message = textutils.serialise(data)
local modem = peripheral.wrap("right")
modem.transmit(1006, 1, message)
shell.run("/programs/_done.lua")