local type, position = ...
local modem = peripheral.wrap("right")
modem.open(1003)

local state = "idle"
local subState = nil
local config1 = nil
local config2 = nil
local config3 = nil

local function waitForStateChange()
  local event, newState, newSubState, newConfig1, newConfig2, newConfig3 = os.pullEvent("stateChange")
  state = newState
  subState = newSubState
  config1 = newConfig1
  config2 = newConfig2
  config3 = newConfig3
end

local function wait()
  while true do
    sleep(1000)
  end
end

local function run()
  print("Running "..state)
  shell.run("programs/"..state..".lua", type, position, subState, config1, config2, config3)
  wait()
end

while true do
  parallel.waitForAny(waitForStateChange, run)
end