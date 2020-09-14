local x, y = ...

modem = peripheral.wrap("right")
modem.open(1003)

while true do
  local event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
  if channel == 1003 then
    local data = textutils.unserialize(message)

    if data.x == "any" or data.x == x then
      if data.y == "any" or data.y == y then
        os.queueEvent("stateChange", data.state, data.subState, data.config1, data.config2, data.config3)
      end
    end
  end
end