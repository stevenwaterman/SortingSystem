local modem = peripheral.wrap("right")

local function getPosition()
  modem.open(1008)
  while true do
    local event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    if channel == 1008 and distance == 2 then
      modem.close(1008)
      return message
    end
  end
end

local function writePosition(newPosition)
  file = fs.open("/position", "w")
  file.write(newPosition)
  file.close()
end

local position = getPosition()
writePosition(position)
print("Position Set")
modem.transmit(1011, 1, position)
modem.transmit(1005, 1, "Done")
