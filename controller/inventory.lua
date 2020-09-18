settings.define("Inventory", {
  description = "the current inventory", 
  default = {},
  type = "table"
})

function update()
  receive = function()
    local data = messaging.receiveAll()
    settings.set("Inventory", data)
    settings.save()
  end

  trigger = function()
    state.setGlobal("reportInventory")
  end

  parallel.waitForAll(receive, trigger)
end

function get()
  return settings.get("Inventory")
end

function print()
  textutils.pagedPrint(textutils.serialise(get()))
end

function getExtractRequest(requestedAmounts)
  local inventory = get()

  local request = {}
  for slice=1,messaging.sliceCount do
    local inventorySlice = inventory[slice]
    if inventorySlice ~= nil then
      request[slice] = {}

      local anyShulkers = false
      for shulker=1,16 do
        local inventoryShulker = inventorySlice[shulker]
        if inventoryShulker ~= nil then
          request[slice][shulker] = {}

          local anySlots = false
          for slot=1,27 do
            local inventorySlot = inventory[slice][shulker][slot]
            if inventorySlot ~= nil then
              for itemName, itemAmount in pairs(requestedAmounts) do
                if inventorySlot.name == itemName then
                  anyShulkers = true
                  anySlots = true
                  local extractAmount = math.min(itemAmount, inventorySlot.count)
                  request[slice][shulker][slot] = extractAmount
                  local remainingAmount = itemAmount - extractAmount
                  if remainingAmount == 0 then
                    requestedAmounts[itemName] = nil
                  else
                    requestedAmounts[itemName] = remainingAmount
                  end
                end
              end
            end
          end

          if not anySlots then
            request[slice][shulker] = nil
          end
        end
      end

      if not anyShulkers then
        request[slice] = nil
      end
    end
  end

  return request
end

function getItemCounts()
  local inventoryData = inventory.get()
  local counts = {}

  for _, sliceData in pairs(inventoryData) do
    for _, shulkerData in pairs(sliceData) do
      for _, stackData in pairs(shulkerData) do
        local name = stackData.name
        local count = stackData.count
        local currentCount = counts[name] or 0
        counts[name] = currentCount + count
      end
    end
  end

  return counts
end