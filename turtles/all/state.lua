function setGlobal(globalState, config)
  local nullSafeConfig = config or {}

  local data = {
    globalState = globalState,
    globalConfig = nullSafeConfig
  }
  modem.transmit("globalState", data)
end

function setSlice(subState, config)
  local type, x, y, z, slice = position.get()
  local nullSafeConfig = config or {}

  local data = {
    slice = slice,
    subState = subState,
    subConfig = nullSafeConfig,
  }
  modem.transmit("sliceState", data)
end

local globalState = "boot"
local subState = "start"
local globalConfig = {}
local subConfig = {}

local function watchGlobalState()
  local data = modem.receive("globalState")
  globalState = data.globalState
  subState = "start"
  globalConfig = data.globalConfig
  subConfig = {}
end

local function watchSubState()
  local type, x, y, z, slice = position.get()
  local filter = function(data)
    return data.slice == slice
  end

  local data = modem.receive("sliceState", filter)
  subState = data.subState
  for key, value in pairs(data.subConfig) do
    subConfig[key] = value
  end
end

local function runStateScript()
  if globalState == "idle" then
    print("Idle")
  end

  if subState == "done" then
    print("Done")
  end

  local scriptPath = "/programs/"..globalState.."_"..subState..".lua"
  if fs.exists(scriptPath) then
    local env = {}
    for key, value in pairs(globalConfig) do
      env[key] = value
    end
    for key, value in pairs(subConfig) do 
      env[key] = value
    end
    os.run(env, scriptPath)
    print("Script Done")
  end
end

local function runStateScriptThenSleep()
  runStateScript()
  while true do
    sleep(1000)
  end
end

function watchState()
  print("Watching State")
  while true do
    parallel.waitForAny(watchGlobalState, watchSubState, runStateScriptThenSleep)
  end
end

