sliceCount = 32

function receiveAll()
  local responses = {}
  local filter = function(data)
    return responses[data.slice] == nil
  end

  for i=1,sliceCount do
    local data = modem.receive("controllerMessage", filter)
    responses[data.slice] = data.message
  end
  return responses
end
