messaging.waitForTurtleDone(2)
if slot == 8 then
  state.setSlice("agree")
else
  state.setSlice("empty", { slot = slot + 1 })
end