local type = position.get()

if type == "top" or type == "connector" then
  settings.define("Direction", {
    description = "the current direction, in quarter turns clockwise from backwards", 
    default = 0,
    type = "number"
  })
  
  function antiClockwise()
    local currentDirection = settings.get("Direction")
    local newDirection = (currentDirection - 1) % 4
    settings.set("Direction", newDirection)
    settings.save()
    turtle.turnLeft()
  end
  
  function clockwise()
    local currentDirection = settings.get("Direction")
    local newDirection = (currentDirection + 1) % 4
    settings.set("Direction", newDirection)
    settings.save()
    turtle.turnLeft()
  end

  function set(desired)
    if desired < 0 or desired > 3 then
      error("Invalid direction: "..desired)
    end

    while settings.get("Direction") ~= desired do
      clockwise()
    end
  end
  
  function forwards()
    set(0)
  end

  function towards(targetX, targetZ)
    local type, x, y, z, slice = position.get()

    if x < targetX then
      return set(1)
    end

    if x > targetX then
      return set(3)
    end

    if z < targetZ then
      return set(2)
    end

    if z > targetZ then
      return set(0)
    end

    return set(0)
  end
end

