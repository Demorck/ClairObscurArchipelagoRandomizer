---@class ItemDataInternal
---@field name string Human-readable item name
---@field id number Archipelago item ID

---@class ItemsHandler
---@field queue table<NetworkItem>
local ItemsHandler = {}

ItemsHandler.queue = {}

local ITEMS_PER_TICK = 5

---Handle a batch of items received from the AP server
---This is the main entry point called by the EventDispatcher
---Filters and processes each item, ensuring they haven't been received before
---@param items NetworkItem[] Array of items received from server
function ItemsHandler:Handle(items)
    -- Don't process if player is in a state where they can't receive items
    if not Archipelago:CanReceiveItems() then
        Logger:info(("%d pending items (CanReceiveItems false)"):format(#items))
        Archipelago.waitingForSync = true
        return
    end

    for _, item in ipairs(items) do
        self.queue[#self.queue+1] = item
    end
end
function ItemsHandler:Drain()
    if #self.queue == 0 or not Archipelago:CanReceiveItems() then
        return  -- on garde la file, on réessaiera au tick suivant
    end

    local t0 = os.clock()
    local names = {}

    local dirty = false
    for _ = 1, math.min(ITEMS_PER_TICK, #self.queue) do
        local item = table.remove(self.queue, 1)
        names[#names + 1] = tostring(item.item)
        if self:ProcessItem(item) then dirty = true end
    end

    if dirty then
        Storage:Update("ItemsHandler:Drain")
    end

    local dt = os.clock() - t0
    if dt > 0.008 then   -- ~une demi-frame à 60 fps
        Logger:warn(("Small drain: %.1f ms, items %s"):format(dt * 1000, table.concat(names, ",")))
    end
end

---Process a single item from the server
---Validates the item hasn't been processed before, gets item data, and passes to Archipelago
---@param item NetworkItem The item to process
---@private
function ItemsHandler:ProcessItem(item)
    if not item.index or item.index <= Storage:Get("lastSavedItemIndex") then
        return false
    end

    local itemData = self:GetItemData(item.item)
    if not itemData then
        Logger:error("Item data is nil for item: " .. item.item)
        return false
    end

    local received = Archipelago and Archipelago:ReceiveItem(itemData)
    if received then
        Logger:info(string.format(
            "Received item: %s (%d) at index: %d for player: %d",
            itemData.name, item.item, item.index, item.player
        ))

        Storage:Set("lastReceivedItemIndex", item.index)
        return true
    end

    return false
end

---Convert an Archipelago item ID to internal item data
---Queries the AP server for the item name based on current game
---@param itemId number Archipelago item ID
---@return ItemDataInternal|nil itemData Item data with name and ID, or nil if not found
---@private
function ItemsHandler:GetItemData(itemId)
    self.gameName = self.gameName or ArchipelagoSystem:GetClient():GetPlayerInfo().game
    local itemName = ArchipelagoSystem:GetClient():GetItemName(itemId, self.gameName)

    if not itemName then
        return nil
    end

    return {
        name = itemName,
        id = itemId
    }
end

return ItemsHandler