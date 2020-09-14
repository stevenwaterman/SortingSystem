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

-- local function filling()
--     local processing = true
--     while processing do
--         local sucked = turtle.suck()
--         if sucked then
--             item = turtle.getItemDetail()
--             if item == nil then
--                 transmitStateChange("emptying")
--                 processing = false
--             else
--                 turtle.dropUp()
--             end
--         else
--           transmitStateChange("emptying")
--           processing = false
--         end
--     end

--     while true do
--       sleep(1000)
--     end
-- end

-- local function emptying()
--     while true do
--         os.pullEvent("turtle_inventory")
--         turtle.drop()
--     end
-- end

-- while true do
--   parallel.waitForAny(emptying, whileInState("emptying"))
--   parallel.waitForAny(filling, whileInState("filling"))
-- end

print("Taking Inventory")
shell.run("/programs/_done.lua")