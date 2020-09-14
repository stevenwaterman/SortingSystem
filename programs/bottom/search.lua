local x, y, subState, requestedItem, inventorySlotStr = ...

local function filling()
  while true do
    local sucked = turtle.suck()
    if sucked then
      turtle.dropUp()
    else
      return
    end
  end
end

turtle.select(1)

if subState == "start" then
  redstone.setOutput("bottom", false)
elseif subState == "emptying" then
  while true do
    os.pullEvent("turtle_inventory")

    local item = turtle.getItemDetail()
    if item ~= nil then
      if item.name == requestedItem then
        local space = turtle.dropDown()
        if not space then
          turtle.drop()
        else
          redstone.setOutput("bottom", true)
        end
      else
        turtle.drop()
      end
    end
  end

elseif subState == "filling" then
  filling()
  sleep(1)
  local inventorySlot = tonumber(inventorySlotStr)
  shell.run("/programs/_setState.lua", x, "any", "search", "emptying", requestedItem, inventorySlot + 1)
  
elseif subState == "done" then
  shell.run("/programs/_done.lua")
end