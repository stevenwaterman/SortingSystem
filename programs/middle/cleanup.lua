for slot=1,16 do
  turtle.select(slot)
  local item = turtle.getItemDetail()
  if item ~= nil and item.name ~= "minecraft:shulker_box" then
    turtle.dropDown()
    turtle.dig()
  end
end

local nextSlot = 1
for slot=1,16 do
  turtle.select(slot)
  local item = turtle.getItemDetail()
  if item ~= nil then
    local moved = false
    while not moved and nextSlot < slot do
      moved = turtle.transferTo(nextSlot)
      nextSlot = nextSlot + 1
    end
  end
end

shell.run("/programs/_done.lua")