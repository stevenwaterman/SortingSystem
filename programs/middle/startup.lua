local function readPosition()
  local file = fs.open("/position", "r")
  local position = file.readAll()
  file.close()
  return position
end

local function getCoords()
  shell.run("/management/getType.lua")
  shell.run("rm /position")
  shell.run("/programs/_getPosition.lua")
end

local function waitForIdle()
  shell.run("/programs/_waitForIdle.lua")
end

local function watchState()
  shell.run("/programs/_state.lua")
end

local function boot()
  parallel.waitForAll(getCoords, waitForIdle)
  local type = os.getComputerLabel()
  local position = readPosition()
  shell.run("/programs/_main.lua", type, position)
end

parallel.waitForAll(watchState, boot)