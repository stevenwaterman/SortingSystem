local x, y, state, subState, config1, config2, config3 = ...

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
local modem = peripheral.wrap("right")
modem.transmit(1003,1,message)
os.queueEvent("modem_message", "right", 1003, 1, message, 0)