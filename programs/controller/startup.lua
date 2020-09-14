modem = peripheral.wrap("top")

local turtleCount = 48

local function watchDone()
  modem.open(1005)
  local doneCount = 0
  while doneCount < turtleCount do
    local event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    if channel == 1005 then
      doneCount = doneCount + 1
      print(doneCount)
    end
  end
  modem.close(1005)
  shell.run("/controller/_setState.lua", "any", "any", "idle")
end

print("Booting!")
watchDone()
watchDone()

while true do
  print("Ready!")
  local item = read()
  shell.run("/controller/_setState.lua", "any", "any", "shulkers", "start", item)
  watchDone()
end