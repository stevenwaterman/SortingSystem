local function emptying()
    local contents = {};
    while turtle.suck() do
      item = turtle.getItemDetail()
      table.insert(contents, item)
      turtle.dropDown()
    end
    return contents
end

local function filling()
    while true do
        os.pullEvent("turtle_inventory")
        turtle.drop()
    end
end

local function readInventory()
  local inventoryFile = fs.open("inventory", "r")
  local serialisedData = inventoryFile.readAll()
  local data = textutils.unserialize(serialisedData)
  inventoryFile.close()
  return data
end

local function writeInventory(data)
  local inventoryFile = fs.open("inventory", "w")
  local serialisedData = textutils.serialise(data)
  inventoryFile.write(serialisedData)
  inventoryFile.close()
end

local x, y, subState, inventorySlotStr = ...
local inventorySlot = tonumber(inventorySlotStr)

if subState == "start" then
  local inventory = {nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil}
  writeInventory(inventory)
  shell.run("/programs/_setState.lua", x, "any", "takeInventory", "emptying", 1)

elseif subState == "emptying" then
  turtle.dig()

  if inventorySlot > 16 then
    shell.run("/programs/_setState.lua", x, "any", "takeInventory", "done")
  else
    local inventory = readInventory()

    turtle.select(inventorySlot)
    if turtle.getItemDetail(inventorySlot) ~= nil then
      turtle.place()
      inventory[inventorySlot] = emptying()
      sleep(1)
      writeInventory(inventory)
      shell.run("/programs/_setState.lua", x, "any", "takeInventory", "filling", inventorySlot)
    else
      shell.run("/programs/_setState.lua", x, "any", "takeInventory", "emptying", inventorySlot+1)
    end
  end

elseif subState == "filling" then
  filling()

elseif subState == "done" then
  shell.run("/programs/_done.lua")
end