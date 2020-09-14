local type, position, state, subState, config1, config2, config3 = ...

local data = {
  x = position,
  y = type,
  state = state,
  subState = subState,
  config1 = config1,
  config2 = config2,
  config3 = config3
}

local message = textutils.serialise(data)
local modem = peripheral.wrap("top")
modem.transmit(1003,1,message)
os.queueEvent("modem_message", "top", 1003, 1, message, 0)