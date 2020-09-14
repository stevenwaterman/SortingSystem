print("Cleaning Up")

while turtle.inspect() do
  turtle.turnLeft()
end

turtle.turnLeft()
turtle.turnLeft()


while turtle.suck() do
  turtle.dropDown()
end

sleep(3)

for slot=1,16 do
  turtle.select(slot)
  turtle.dropDown()
end

turtle.turnLeft()
turtle.turnLeft()

while turtle.suckDown() do
  turtle.drop()
end

turtle.turnLeft()
turtle.turnLeft()

shell.run("/programs/_done.lua")