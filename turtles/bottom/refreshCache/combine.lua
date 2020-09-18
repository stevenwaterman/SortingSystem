for i=1,16 do
  turtle.select(i)
  turtle.dropUp()
end

inventory.clear()
state.setSlice("done")