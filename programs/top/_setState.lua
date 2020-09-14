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
-- print("sending "..message)
local modem = peripheral.wrap("right")
modem.transmit(1003,1,message)
os.queueEvent("modem_message", "right", 1003, 1, message, 0)