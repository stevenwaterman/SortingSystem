local modem = peripheral.wrap("right")

local function getPosition()
  modem.open(1007)
  while true do
    local event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    if channel == 1007 then
      modem.close(1007)
      return tostring(math.floor(distance))
    end
  end
end

local function writePosition(newPosition)
  file = fs.open("/position", "w")
  file.write(newPosition)
  file.close()
end
  
local function broadcastPosition(newPosition)
  while true do
    modem.transmit(1008, 1, newPosition)
    sleep(1)
  end
end

local function waitForDone(newPosition)
  modem.open(1011)
  local done = 0
  while done < 2 do
    local event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    if channel == 1011 and message == newPosition then
      done = done + 1
    end
  end
  modem.close(1011)
end

local position = getPosition()
writePosition(position)
print("Position Set")

a = function()
  broadcastPosition(position)
end

b = function()
  waitForDone(position)
end
parallel.waitForAny(a, b)
