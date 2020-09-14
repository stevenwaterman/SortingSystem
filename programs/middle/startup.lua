local function readPosition()
  local file = fs.open("/position", "r")
  local position = file.readAll()
  file.close()
  return position
end

local function wait()
  while true do
    sleep(1000)
  end
end

local function waitForIdle()
  shell.run("/programs/_waitForIdle.lua")
end

local function watchState()
  shell.run("/programs/_state.lua", x, y)
end

local function main()
  shell.run("/programs/_main.lua", x, y)
end

local function takeInventory()
  shell.run("/programs/_setState.lua", x, "any", "takeInventory")
end

local x = nil
local y = nil

local function getCoords()
  shell.run("/management/getType.lua")
  shell.run("rm /position")
  shell.run("/programs/_getPosition.lua")
  x = readPosition()
  y = os.getComputerLabel()
  local modem = peripheral.wrap("right")
  modem.transmit(1005, 1, "Done")
  wait()
end

parallel.waitForAny(watchState, getCoords, waitForIdle)
parallel.waitForAll(watchState, main)