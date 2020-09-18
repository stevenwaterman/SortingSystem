os.loadAPI("/controller/modem.lua")
os.loadAPI("/controller/state.lua")
os.loadAPI("/controller/messaging.lua")
os.loadAPI("/controller/inventory.lua")
os.loadAPI("/controller/extractRequest.lua")

local speaker = peripheral.wrap("right")

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

local function completeTask(sText, bAddSpaces)
  return completeMultipleChoice(sText, {"extract", "refreshCache", "exec", "fill", "updateInventory", "showInventory"}, bAddSpaces)
end

local function readTask()
  return read(nil, {}, completeTask)
end

print("Booting Up!")
state.setGlobal("boot")
state.waitForDone()

settings.load()

while true do
  print("")
  print("Ready! Enter Task:")
  redstone.setOutput("left", true)
  speaker.playSound("minecraft:entity.player.levelup", 0.5)

  local task = readTask()

  redstone.setOutput("left", false)
  if task == "refreshCache" then
    state.setGlobal("refreshCache")
    state.waitForDone()

    inventory.update()
    state.setGlobal("idle")
    
  elseif task == "updateInventory" then
    inventory.update()

  elseif task == "extract" then
    local request = extractRequest.getRequest()
    term.clear()
    print("Working")
    state.setGlobal("extract", {allRequests = request})
    state.waitForDone()
    print("Flushing")
    sleep(30)
    inventory.update()
    state.setGlobal("idle")

  elseif task == "showInventory" then
    inventory.print()

  elseif task == "exec" then
    type = read()
    code = read()
    state.setGlobal("exec"..type, {code = code})
    state.waitForDone()

  elseif task == "fill" then
    state.setGlobal("fill")
    state.waitForDone()
    inventory.update()
  end
end