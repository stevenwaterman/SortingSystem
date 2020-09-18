local shulkerCount = 0
for i=1,16 do
  if turtle.getItemDetail(i) ~= nil then
    shulkerCount = shulkerCount + 1
  end
end
inventory.clear(shulkerCount)
messaging.turtleDone()