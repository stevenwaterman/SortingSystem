for shulker=1,16 do
  turtle.select(shulker)
  turtle.place()

  local continue = true

  while continue do
    if turtle.suckDown() then
      inventory.put(true)
      local remainingCount = turtle.getItemCount()
      if remainingCount > 0 then
        turtle.dropDown()
        turtle.dig()
        continue = false
      end
    else
      print("Bottom Empty, ending")
      turtle.dig()
      state.setSlice("done")
      continue = false
    end
  end
end

state.setSlice("cleanup")