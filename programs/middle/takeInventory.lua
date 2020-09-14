local function emptying()
    local contents = nil;
    while true do
        local sucked = turtle.suck()
        if sucked then
            item = turtle.getItemDetail()
            if item == nil then
                return contents
            else
                if contents == nil then
                  contents = {
                    name = item.name,
                    count = 0
                  }
                end
                contents.count = contents.count + item.count;
                turtle.dropDown()
            end
        else
          return contents
        end
    end
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
  local data = textutils.unserialize(serialisedInventory)
  inventoryFile.close()
  return data
end

local function writeInventory(data)
  local inventoryFile = fs.open("inventory", "w")
  local serialisedData = textutils.serialise(data)
  inventoryFile.write(serialisedData)
  inventoryFile.close()
end

local x, y, subState, inventorySlot = ...

if subState == nil then
  local inventory = {nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil}
  writeInventory(inventory)

elseif substate == "emptying" then
  if inventorySlot > 16 then
    shell.run("/programs/setState.lua", x, "any", "takeInventory", "done")
  else
    local inventory = readInventory()
    inventory[inventorySlot] = emptying()
    sleep(1)
    shell.run("/programs/setState.lua", x, "any", "takeInventory", "filling", inventorySlot)
    writeInventory(inventory)
  end

elseif substate == "filling" then
  filling()

elseif subState == "done" then
  shell.run("/programs/_done.lua")
end