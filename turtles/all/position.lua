settings.define("Position", {
  description = "the current type, coordinates, and logical slice of this turtle", 
  default = {nil, nil, nil, nil, nil},
  type = "table"
})

function get()
  local position = settings.get("Position")

  if position ~= nil then
    return table.unpack(position)
  else
    return refresh()
  end
end

function refresh()
  print("Using GPS")

  local type, x, y, z, slice = nil

  while x == nil do
    x, y, z = gps.locate()
    if x ~= x then
      x = nil
      print("GPS Failure")
      sleep(0.5 + math.random())
    end
  end

  type = os.getComputerLabel()
  slice = math.floor((z-1)/2) * 8 + x

  settings.set("Position", {type, x, y, z, slice})
  settings.save()

  print("GPS Success")
  return type, x, y, z, slice
end

