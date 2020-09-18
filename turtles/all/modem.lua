local modem = peripheral.wrap("right")

local channels = {
  globalState = 1100,
  sliceState = 1101,
  sliceMessage = 1102,
  turtleDone = 1103,
  controllerMessage = 1104
}

function transmit(protocol, message)
  local channel = channels[protocol]
  if channel == nil then
    error("Protocol was invalid: "..protocol)
  end
  os.queueEvent("modem_message", "right", channel, 1, message, 0)
  while true do
    modem.transmit(channel, 1, message)
    sleep(0.1 + math.random())
  end
end

function receive(protocol, filter)
  local channel = channels[protocol]
  if channel == nil then
    error("Protocol was invalid: "..protocol)
  end

  modem.open(channel)
  while true do
    local event, side, receivedChannel, replyChannel, message, distance = os.pullEvent("modem_message")
    if receivedChannel == channel then
      if filter == nil or filter(message) then
        modem.close(channel)
        return message
      end
    end
  end
end