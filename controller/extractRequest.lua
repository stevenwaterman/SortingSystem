local function drawSelector(selectedIndex, startIndex, endIndex, itemsWindow, itemNames, itemCounts, requestedAmounts, searchString)
  for i=startIndex,endIndex do
    local name = itemNames[i]
    if i == selectedIndex then
      itemsWindow.setBackgroundColor(colors.white)
      itemsWindow.setTextColor(colors.black)
    elseif requestedAmounts[name] ~= nil then
      itemsWindow.setBackgroundColor(colors.yellow)
      itemsWindow.setTextColor(colors.black)
    else
      itemsWindow.setBackgroundColor(colors.black)
      itemsWindow.setTextColor(colors.white)
    end

    local cursorHeight = i - startIndex + 1
    itemsWindow.setCursorPos(1, cursorHeight)
    itemsWindow.clearLine()

    if name ~= nil then
      local count = itemCounts[name]
      local requestedCount = requestedAmounts[name]
      if requestedCount == nil then
        local text = count.." x "..name
        itemsWindow.write(text)
      else
        local text = requestedCount.."/"..count.." x "..name
        itemsWindow.write(text)
      end
    end
  end

  itemsWindow.setCursorPos(1, endIndex + 1)
  itemsWindow.setBackgroundColor(colors.black)
  itemsWindow.setTextColor(colors.white)
  itemsWindow.clearLine()
  itemsWindow.write(searchString)

  itemsWindow.redraw()
end

local function filter(itemNames, filterString)
  local filtered = {}
  for _, name in ipairs(itemNames) do
    if string.find(name, filterString) then
      table.insert(filtered, name)
    end
  end
  return filtered
end

function getRequest()
  local terminalWidth, terminalHeight = term.current().getSize()
  local windowWidth = terminalWidth
  local windowHeight = terminalHeight
  local itemsWindow = window.create(term.current(), 1, 1, windowWidth, windowHeight, false)

  local startIndex = 1
  local endIndex = startIndex + windowHeight - 2

  local searchString = ""
  local selectedIndex = 1

  local itemCounts = inventory.getItemCounts()
  local itemNames = {}
  for name, _ in pairs(itemCounts) do
    table.insert(itemNames, name)
  end
  table.sort(itemNames)
  local requestedAmounts = {}

  local filteredItemNames = filter(itemNames, searchString)

  itemsWindow.setVisible(true)
  
  local done = false
  while not done do
    local name = filteredItemNames[selectedIndex]
    drawSelector(selectedIndex, startIndex, endIndex, itemsWindow, filteredItemNames, itemCounts, requestedAmounts, searchString)
    local event, config1, config2, config3, config4, config5 = os.pullEvent()
    if event == "key" then
      local key = config1
      if key == keys.up then
        selectedIndex = math.max(1, selectedIndex - 1)
        startIndex = math.min(startIndex, selectedIndex)
        endIndex = startIndex + windowHeight - 2
      elseif key == keys.down then
        selectedIndex = math.min(#filteredItemNames, selectedIndex + 1)
        endIndex = math.max(endIndex, selectedIndex)
        startIndex = endIndex - windowHeight + 2
      elseif key == keys.left then
        local currentAmount = requestedAmounts[name] or 0
        local newAmount = currentAmount - 1
        if newAmount > 0 then
          requestedAmounts[name] = newAmount
        else
          requestedAmounts[name] = nil
        end
      elseif key == keys.right then
        local currentAmount = requestedAmounts[name] or 0
        local maxAmount = itemCounts[name]
        requestedAmounts[name] = math.min(maxAmount, currentAmount + 1)
      elseif key == keys.enter then
        done = true
      elseif key == keys.backspace then
        searchString = searchString:sub(1, -2)
        filteredItemNames = filter(itemNames, searchString)
      end
    elseif event == "char" then
      local character = config1
      searchString = searchString..character
      filteredItemNames = filter(itemNames, searchString)
      selectedIndex = math.min(#filteredItemNames, selectedIndex)
    end
  end
  itemsWindow.setVisible(false)
  return inventory.getExtractRequest(requestedAmounts)
end