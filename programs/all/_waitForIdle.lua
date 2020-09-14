local idle = false
while not idle do
  local event, newState, newSubState, newConfig1, newConfig2, newConfig3 = os.pullEvent("stateChange")
  if newState == "idle" then
    idle = true
  end
end
