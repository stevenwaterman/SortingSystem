function receive()
  local type, x, y, z, slice = position.get()
  
  local filter = function(data)
    return data.type == type and data.slice == slice
  end

  local data = modem.receive("sliceMessage", filter)
  return data.message
end

function send(type, message)
  local myType, x, y, z, slice = position.get()
  if type == myType then
    error("Tried to send message to self")
  end

  local data = {
    message = message,
    type = type,
    slice = slice
  }

  modem.transmit("sliceMessage", data)
end

function report(message)
  local myType, x, y, z, slice = position.get()
  local data = {
    message = message,
    slice = slice
  }
  modem.transmit("controllerMessage", data)
end

function waitForTurtleDone(desiredCount)
  local type, x, y, z, slice = position.get()

  local doneTypes = {
    connector = false,
    top = false,
    middle = false,
    bottom = false
  }
  
  local filter = function(data)
    return data.slice == slice and not doneTypes[data.type]
  end

  print("Waiting for "..desiredCount.." turtles")

  local count = 0
  while count < desiredCount do
    local data = modem.receive("turtleDone", filter)
    doneTypes[data.type] = true
    count = count + 1
    print(data.type.." done. "..count.."/"..desiredCount)
  end
end

function turtleDone()
  local type, x, y, z, slice = position.get()
  local message = {
    slice = slice,
    type = type
  }
  modem.transmit("turtleDone", message)
end