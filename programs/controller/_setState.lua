local x, y, state, subState, config1, config2, config3 = ...

if subState == nil then
  subState = "start"
end

local data = {
  x = x,
  y = y,
  state = state,
  subState = subState,
  config1 = config1,
  config2 = config2,
  config3 = config3
}

local message = textutils.serialise(data)
print(message)
local modem = peripheral.wrap("top")
modem.transmit(1003,1,message)
os.queueEvent("modem_message", "top", 1003, 1, message, 0)
print("Sent")