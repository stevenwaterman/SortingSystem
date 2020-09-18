if ourRequests == nil or shulkerNumber > 16 then
  state.setSlice("done")
else
  local shulkerRequests = ourRequests[shulkerNumber]
  if shulkerRequests == nil then
    state.setSlice("empty", { shulkerNumber = shulkerNumber + 1 })
  else
    local remaining = 0
    for slot, amount in pairs(shulkerRequests) do
      remaining = remaining + amount
    end

    turtle.select(shulkerNumber)
    turtle.place()

    local continue = true
    while continue and remaining > 0 do
      local taken, stackNumber = inventory.take()
      if taken then
        local extractAmount = shulkerRequests[stackNumber]
        if extractAmount ~= nil then
          remaining = remaining - extractAmount
          local stackSize = turtle.getItemDetail().count
          turtle.dropUp(extractAmount)
        end
        turtle.dropDown()
      else
        continue = false
      end
    end

    state.setSlice("fill")
  end
end



