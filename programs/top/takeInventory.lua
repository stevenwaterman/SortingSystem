local x, y, subState, inventorySlot = ...

if subState == nil then
  shell.run("/programs/setState.lua", "any", x, "takeInventory", "emptying", 1)
elseif subState == "done" then
  shell.run("/programs/_done.lua")
end