bottomInventory = messaging.receive()
middleInventory = inventory.get()

local bottomSlot = #middleInventory + 1

local middleSlot = 1
while middleInventory[middleSlot] ~= nil do
  middleSlot = middleSlot + 1
end

local bottomSlot = 1
while bottomInventory[bottomSlot] ~= nil do
  turtle.select(middleSlot)
  inventory.setSlot(bottomInventory[bottomSlot])

  middleSlot = middleSlot + 1
  bottomSlot = bottomSlot + 1
end

state.setSlice("combine")