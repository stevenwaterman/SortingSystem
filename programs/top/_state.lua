modem = peripheral.wrap("right")
modem.open(1003)

local function readPosition()
  local file = fs.open("/position", "r")
  local position = file.readAll()
  file.close()
  return position
end

while true do
  local event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
  if channel == 1003 then
    local data = textutils.unserialize(message)
    local type = os.getComputerLabel()
    local position = readPosition()

    -- print(position)
    -- print(data.y)
    -- print(data.x)

    if data.y == "any" or data.y == type then
      if data.x == "any" or data.x == position then
        -- print(data.state)
        state = data.state
        subState = data.subState
        config1 = data.config1
        config2 = data.config2
        config3 = data.config3
    
        os.queueEvent("stateChange", state, subState, config, config2, config3)
      end
    end
  end
end