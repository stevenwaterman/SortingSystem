local x, y, subState, requestedItem, inventorySlotStr = ...

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

if subState == "start" then
  shell.run("/programs/_setState.lua", x, "any", "search", "emptying", requestedItem, 1)
elseif subState == "emptying" then
  turtle.dig()

  local inventorySlot = tonumber(inventorySlotStr)

  if inventorySlot > 16 then
    shell.run("/programs/_setState.lua", x, "any", "search", "done", requestedItem)
  else
    local inventory = readInventory()
    local slotInventory = inventory[inventorySlot]
  
    if slotInventory == nil then
      shell.run("/programs/_setState.lua", x, "any", "search", "emptying", requestedItem, inventorySlot + 1)
    else
      local anyMatch = false
      for index, item in pairs(slotInventory) do
        if item ~= nil then
          local match = anyMatch or item.name == requestedItem
          anyMatch = anyMatch or match
        end
      end
  
      if anyMatch then
        turtle.select(inventorySlot)
        turtle.place()
        local sucked = true
        while sucked do
          sucked = turtle.suck()
          if sucked then
            turtle.dropDown()
          end
        end
        shell.run("/programs/_setState.lua", x, "any", "search", "filling", requestedItem, inventorySlot)
      else
        shell.run("/programs/_setState.lua", x, "any", "search", "emptying", requestedItem, inventorySlot + 1)
      end
    end
  end

elseif subState == "filling" then
  local inventorySlot = tonumber(inventorySlotStr)
  local inventory = readInventory()
  local slotContents = {}
  while true do
    os.pullEvent("turtle_inventory")

    local item = turtle.getItemDetail()
    table.insert(slotContents, item)
    inventory[inventorySlot] = slotContents
    writeInventory(inventory)
    
    turtle.drop()
  end

elseif subState == "done" then
  shell.run("/programs/_done.lua")
end