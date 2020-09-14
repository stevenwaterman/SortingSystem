modem = peripheral.wrap("top")
modem.open(1003)

local turtleCount = 48

local function watchDone()
  modem.open(1005)
  local doneCount = 0
  while doneCount < turtleCount do
    local event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    if channel == 1005 then
      doneCount = doneCount + 1
      print(doneCount.." done")
    end
  end
  modem.close(1005)
  shell.run("/controller/_setState.lua", "any", "any", "idle")
end

-- local function run()
--   print("Global State = "..state)
--   shell.run("controller/"..state..".lua")
--   wait()
-- end

-- local function changeStateSync(newState)
--   asyncStateChange = function()
--     transmitStateChange(newState)
--   end
--   parallel.waitForAny(watchState, asyncStateChange)
-- end

-- local function runTask(state)
--   changeStateSync(state)
--   parallel.waitForAny(watchState, watchDone, run)
-- end

-- print("Booting...")
-- sleep(3)
-- runTask("numbering")
-- runTask("takeInventory")
-- -- runTask("shulkers")
-- print("Storage System Ready!")

while true do
  print("Ready!")
  watchDone()
end