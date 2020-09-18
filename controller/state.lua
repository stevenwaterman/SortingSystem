function setGlobal(globalState, config)
  local nullSafeConfig = config or {}

  local data = {
    globalState = globalState,
    globalConfig = nullSafeConfig
  }
  modem.transmit("globalState", data)
end

function waitForDone()
  local done = {}
  local filter = function(data)
    return data.subState == "done" and done[data.slice] == nil
  end

  for i=1,messaging.sliceCount do
    local data = modem.receive("sliceState", filter)
    done[data.slice] = true
  end
end