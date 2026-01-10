---@class ItemsHandlerDependencies
---@field logger Logger Logger instance for logging item reception events
---@field storage Storage Storage instance for tracking received items
---@field apClient APClient AP client for getting item names and player info


---@class ItemDataInternal
---@field name string Human-readable item name
---@field id number Archipelago item ID

---@class ItemsHandler
---@field logger Logger Logger instance for debugging and tracking
---@field storage Storage Storage manager for persistent data
---@field apClient APClient Client for AP server communication
---@field archipelago Archipelago|nil Reference to main Archipelago instance (set after creation)
local ItemsHandler = {}

---Create a new ItemsHandler instance
---@param dependencies ItemsHandlerDependencies Required dependencies
---@return ItemsHandler handler New ItemsHandler instance
function ItemsHandler:New(dependencies)
    local instance = {
        logger = dependencies.logger,
        storage = dependencies.storage,
        apClient = dependencies.apClient,
        archipelago = nil,
    }

    setmetatable(instance, { __index = ItemsHandler })
    return instance
end

---Set the Archipelago reference (called after initialization)
---This is needed because of circular dependencies between ItemsHandler and Archipelago
---@param archipelago Archipelago The main Archipelago facade instance
function ItemsHandler:SetArchipelago(archipelago)
    self.archipelago = archipelago
end

---Handle a batch of items received from the AP server
---This is the main entry point called by the EventDispatcher
---Filters and processes each item, ensuring they haven't been received before
---@param items NetworkItem[] Array of items received from server
function ItemsHandler:Handle(items)
    -- Don't process items if game hasn't initialized past Lumiere Act I
    if not Storage.initialized_after_lumiere then
        return
    end

    -- Don't process if player is in a state where they can't receive items
    if not self:CanReceiveItems() then
        return
    end

    -- Process each item individually
    for _, item in ipairs(items) do
        self:ProcessItem(item)
    end
end

---Process a single item from the server
---Validates the item hasn't been processed before, gets item data, and passes to Archipelago
---@param item NetworkItem The item to process
---@private
function ItemsHandler:ProcessItem(item)

    if not item.index or item.index <= Storage.lastSavedItemIndex then
        return
    end

    local itemData = self:GetItemData(item.item)
    if not itemData then
        self.logger:error("Item data is nil for item: " .. item.item)
        return
    end

    if self.archipelago and self.archipelago:ReceiveItem(itemData) then
        self.logger:info(string.format(
            "Received item: %s (%d) at index: %d for player: %d",
            itemData.name, item.item, item.index, item.player
        ))

        Storage.lastReceivedItemIndex = item.index
        Storage:Update("ItemsHandler:ProcessItem")
    end
end

---Convert an Archipelago item ID to internal item data
---Queries the AP server for the item name based on current game
---@param itemId number Archipelago item ID
---@return ItemDataInternal|nil itemData Item data with name and ID, or nil if not found
---@private
function ItemsHandler:GetItemData(itemId)
    local playerInfo = self.apClient:GetPlayerInfo()
    local itemName = self.apClient:GetItemName(itemId, playerInfo.game)

    if not itemName then
        return nil
    end

    return {
        name = itemName,
        id = itemId
    }
end

---Check if the player is in a valid state to receive items
---Items should only be processed when player is in-game and initialized
---@return boolean canReceive True if items can be received
---@private
function ItemsHandler:CanReceiveItems()
    if not ClientBP then return false end

    return ClientBP:IsInitialized() and
           not ClientBP:IsMainMenu() and
           not ClientBP:IsLumiereActI() and
           ClientBP:InLevel()
end

return ItemsHandler