modem = peripheral.wrap("top")

local turtleCount = 48

local function watchDone()
  modem.open(1005)
  local doneCount = 0
  while doneCount < turtleCount do
    local event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    if channel == 1005 then
      doneCount = doneCount + 1
      print(doneCount)
    end
  end
  modem.close(1005)
  shell.run("/controller/_setState.lua", "any", "any", "idle")
end

inventory = {}
local function watchInventory()
  modem.open(1006)
  inventory = {}
  local count = 0
  while count < turtleCount/3 do
    local event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    if channel == 1006 then
      local data = textutils.unserialise(message)
      inventory[tostring(data.x)] = data.inventory
      count = count + 1
    end
  end
  modem.close(1006)
end

local function updateInventory()
  local stateUpdate = function()
    shell.run("/controller/_setState.lua", "any", "any", "readInventory")
  end
  parallel.waitForAll(stateUpdate, watchInventory, watchDone)
end

local function completeMultipleChoice( sText, tOptions, bAddSpaces )
  local tResults = {}
  for n=1,#tOptions do
      local sOption = tOptions[n]
      if #sOption + (bAddSpaces and 1 or 0) > #sText and string.sub( sOption, 1, #sText ) == sText then
          local sResult = string.sub( sOption, #sText + 1 )
          if bAddSpaces then
              table.insert( tResults, sResult .. " " )
          else
              table.insert( tResults, sResult )
          end
      end
  end
  return tResults
end

local function completeItem(sText, bAddSpaces)
  local itemOptionsSet = {}
  for _, slice in pairs(inventory) do
    for shulkerIdx, shulker in ipairs(slice) do
      if shulker ~= nil then
        for itemIdx, item in ipairs(shulker) do
          if item ~= nil then
            local name = item.name
            name = string.gsub(name, "minecraft:", "")
            name = string.gsub(name, "_", " ")
            itemOptionsSet[name] = true
          end
        end
      end
    end
  end

  local itemOptions = {}
  for item in pairs(itemOptionsSet) do
    table.insert(itemOptions, item)
  end
  table.sort(itemOptions)

  return completeMultipleChoice(sText, itemOptions, bAddSpaces)
end

local function completeState(sText, bAddSpaces)
  return completeMultipleChoice(sText, {"search", "takeInventory", "cleanup"}, bAddSpaces)
end

local function readItem()
  return read(nil, {}, completeItem)
end

local function readState()
  return read(nil, {}, completeState)
end

local speaker = peripheral.wrap("right")

print("Booting!")
watchDone()
watchDone()
updateInventory()

while true do
  print("Ready! Enter Task:")
  redstone.setOutput("left", true)
  speaker.playSound("minecraft:entity.player.levelup", 0.5)
  local state = readState()
  redstone.setOutput("left", false)
  if state == "search" then
    local item = readItem()
    if item ~= "" then
      if string.find(item, ":") == nil then
        item = "minecraft:"..item
      end
      item = string.gsub(item, " ", "_")
      shell.run("/controller/_setState.lua", "any", "any", "search", "start", item)
      watchDone()
      updateInventory()
    end
  elseif state == "takeInventory" then
    shell.run("/controller/_setState.lua", "any", "any", "takeInventory")
    watchDone()
    updateInventory()
  elseif state == "cleanup" then
    shell.run("/controller/_setState.lua", "any", "any", "cleanup")
  end
end