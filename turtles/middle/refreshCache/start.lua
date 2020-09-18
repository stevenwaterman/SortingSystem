local shulkerCount = 0
for i=1,16 do
  turtle.select(i)
  if turtle.getItemDetail() ~= nil then
    shulkerCount = shulkerCount + 1
  end
end

if shulkerCount == 0 then
  inventory.clear()
  state.setSlice("done")
else
  local start = math.ceil(shulkerCount / 2) + 1
  for i=start,shulkerCount do
    turtle.select(i)
    turtle.dropDown()
  end
  
  state.setSlice("clear")
end

