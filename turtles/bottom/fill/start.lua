turtle.select(1)
turtle.suckDown()
if turtle.getItemCount() == 0 then
  print("Barrel Empty, ending")
  state.setSlice("done")
else
  
  state.setSlice("fill")
end