local idle = false
while not idle do
  local event, newState, newSubState, newConfig1, newConfig2, newConfig3 = os.pullEvent("stateChange")
  -- print("new state: "..newState)
  if newState == "idle" then
    idle = true
    -- print("Idle now!")
  end
end
