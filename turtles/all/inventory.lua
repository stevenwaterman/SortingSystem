settings.define("Inventory", {
  description = "the current inventory", 
  default = {},
  type = "table"
})

function get()
  return settings.get("Inventory")
end

local function set(inventory)
  settings.set("Inventory", inventory)
  settings.save()
end

function canInsert()
  local item = turtle.getItemDetail(nil, true)
  if item == nil then
    return false
  end

  for i=1,27 do
    local shulkerItem = shulker[i]
    if shulkerItem == nil then
      return true
    end

    if shulkerItem ~= nil then
      if (shulkerItem.nbt == nil and shulkerItem.displayName == item.displayName and shulkerItem.name == item.name) or (shulkerItem.nbt ~= nil and shulkerItem.nbt == item.nbt) then
        local stackSpace = shulkerItem.maxCount - shulkerItem.count
        if stackSpace > 0 then
          return true
        end
      end
    end
  end

  return false
end

function clear(numberOfShulkers)
  local shulkerCount = numberOfShulkers or 0
  local inventory = {}
  for i=1,shulkerCount do
    inventory[i] = {}
  end
  set(inventory)
end

function put(allowFull)
  local item = turtle.getItemDetail(nil, true)

  if item == nil then
    return false
  end

  local dropped = turtle.drop()
  if not dropped then
    return false
  end

  local inventory = get()
  local slot = turtle.getSelectedSlot()
  local shulker = inventory[slot]

  if shulker == nil then
    shulker = {}
    inventory[slot] = shulker
  end
  
  local remaining = item.count
  for i=1,27 do
    local shulkerItem = shulker[i]
    if shulkerItem == nil then
      shulker[i] = item
      set(inventory)
      return true
    else
      if (shulkerItem.nbt == nil and shulkerItem.displayName == item.displayName and shulkerItem.name == item.name) or (shulkerItem.nbt ~= nil and shulkerItem.nbt == item.nbt) then
        local stackSpace = shulkerItem.maxCount - shulkerItem.count
        local itemsAdded = math.min(remaining, stackSpace)
        shulkerItem.count = shulkerItem.count + itemsAdded

        remaining = remaining - itemsAdded

        if remaining == 0 then
          set(inventory)
          return true
        end
      end
    end
  end
  if allowFull then
    return false
  else
    error("Cache invalid")
  end
end

function take()
  local sucked = turtle.suck()
  if not sucked then
    return false, nil
  end

  local inventory = get()
  local slot = turtle.getSelectedSlot()
  local shulker = inventory[slot]
  
  for i=1,27 do
    if shulker[i] ~= nil then
      if turtle.getItemDetail().name ~= shulker[i].name then
        error("Cache invalid, expected "..shulker[i].name.." but got "..turtle.getItemDetail().name)
      end

      shulker[i] = nil
      set(inventory)
      return true, i
    end
  end

  error("Cache invalid")
end

function setSlot(contents)
  local inventory = get()
  local slot = turtle.getSelectedSlot()
  inventory[slot] = contents
  set(inventory)
end