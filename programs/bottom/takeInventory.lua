local function emptying()
    while true do
        os.pullEvent("turtle_inventory")
        turtle.drop()
    end
end

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

local y, x, subState, inventorySlot = ...

if subState == nil then

elseif substate == "emptying" then
  emptying()
  
elseif substate == "filling" then
  filling()
  shell.run("/programs/setState.lua", "any", x, "takeInventory", "emptying", inventorySlot + 1)

elseif subState == "done" then
  shell.run("/programs/_done.lua")
end