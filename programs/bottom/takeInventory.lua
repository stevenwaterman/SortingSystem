local function emptying()
    while true do
        os.pullEvent("turtle_inventory")
        turtle.drop()
    end
end

local function filling()
  while turtle.suck() do
    turtle.dropUp()
  end
end

local x, y, subState, inventorySlotStr = ...
local inventorySlot = tonumber(inventorySlotStr)

if subState == "emptying" then
  emptying()

elseif subState == "filling" then
  filling()
  sleep(1)
  shell.run("/programs/_setState.lua", x, "any", "takeInventory", "emptying", inventorySlot + 1)

elseif subState == "done" then
  shell.run("/programs/_done.lua")
end