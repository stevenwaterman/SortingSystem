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

local function getCoords()
  shell.run("/management/getType.lua")
  shell.run("rm /position")
  shell.run("/programs/_getPosition.lua")
  x = readPosition()
  y = os.getComputerLabel()
  print("Got Coords: "..x..","..y)
  shell.run("/programs/_done.lua")
end

local function waitForCoords()
  parallel.waitForAll(getCoords, waitForIdle)
end

parallel.waitForAny(watchState, waitForCoords)
parallel.waitForAll(watchState, main)