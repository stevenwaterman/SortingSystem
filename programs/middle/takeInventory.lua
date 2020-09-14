-- local sliceState = "emptying"

-- local modem = peripheral.wrap("right")

-- local positionFile = fs.open("position", "r")
-- local position = positionFile.readAll()
-- positionFile.close()

-- local function transmitStateChange(newState)
--   print("transmitting state change to "..newState)
--   local stateChangeMessage = {
--     position = position,
--     state = newState
--   }
--   local serialisedMessage = textutils.serialise(stateChangeMessage)
--   modem.transmit(1004, 1, serialisedMessage)
--   os.queueEvent("modem_message", "right", 1004, 1, serialisedMessage, 0)
-- end

-- local function whileInState(state)
--   curriedGuard = function()
--     while sliceState == state do
--         local event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
--         if channel == 1004 and message ~= nil then
--           messageData = textutils.unserialize(message)
--           if messageData.position == position then
--             sliceState = messageData.state
--             print("moved to "..sliceState)
--           end
--         end
--     end
--   end
--   return curriedGuard
-- end

-- local function emptying()
--     local contents = nil;
--     while true do
--         local sucked = turtle.suck()
--         if sucked then
--             item = turtle.getItemDetail()
--             if item == nil then
--                 transmitStateChange("filling")
--                 return contents
--             else
--                 if contents == nil then
--                   contents = {
--                     name = item.name,
--                     count = 0
--                   }
--                 end
--                 contents.count = contents.count + item.count;
--                 turtle.dropDown()
--             end
--         else
--           transmitStateChange("filling")
--           return contents
--         end
--     end
-- end

-- local function filling()
--     while true do
--         os.pullEvent("turtle_inventory")
--         turtle.drop()
--     end
-- end


-- local inventory = {nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil}

-- local function emptyAndUpdate(slot)
--   return function()
--     contents = emptying()
--     inventory[slot] = contents
--     while true do
--       sleep(1000)
--     end
--   end
-- end

-- for inventorySlot=1,16 do
--     turtle.select(inventorySlot)
--     local shulker = turtle.getItemDetail() ~= null
    
--     if shulker then
--         turtle.place()
--         parallel.waitForAny(emptyAndUpdate(inventorySlot), whileInState("emptying"))
--         parallel.waitForAny(filling, whileInState("filling"))
--         turtle.dig()
--     end 
-- end

-- local inventoryFile = fs.open("inventory", "w")
-- local serialisedInventory = textutils.serialise(inventory)
-- inventoryFile.write(serialisedInventory)
-- inventoryFile.close()

-- modem.transmit(1005, 1, "done")

print("Taking Inventory")
shell.run("/programs/_done.lua")