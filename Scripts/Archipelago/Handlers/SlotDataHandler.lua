---@class SlotDataHandlerDependencies
---@field logger Logger Logger instance for logging item reception events
---@field storage Storage Storage instance for tracking received items
---@field apClient APClient AP client for getting item names and player info

---@class SlotDataHandler
---@field logger Logger Logger instance for debugging and tracking
---@field storage Storage Storage manager for persistent data
---@field apClient APClient Client for AP server communication
---@field archipelago Archipelago|nil Reference to main Archipelago instance (set after creation)
local SlotDataHandler = {}

---Create a new SlotDataHandler instance
---@param dependencies SlotDataHandlerDependencies Required dependencies
---@return SlotDataHandler handler New SlotDataHandler instance
function SlotDataHandler:New(dependencies)
    local instance = {
        logger = dependencies.logger,
        storage = dependencies.storage,
        apClient = dependencies.apClient,
        archipelago = nil, -- sera set après
    }

    setmetatable(instance, { __index = SlotDataHandler })
    return instance
end

---Set the Archipelago reference (called after initialization)
---This is needed because of circular dependencies between SlotDataHandler and Archipelago
---@param archipelago Archipelago The main Archipelago facade instance
function SlotDataHandler:SetArchipelago(archipelago)
    self.archipelago = archipelago
end

---Handle the slot data received from the AP server
---This is the main entry point called by the EventDispatcher
---@param slotData table<string, any> The slot data
function SlotDataHandler:Handle(slotData)
    self.logger:info("Processing slot data...")

    -- Mark as connected
    if self.archipelago then
        self.archipelago.hasConnectedPrior = true
        self.archipelago.trying_to_connect = false
    end

    -- Register hooks
    if Hooks then
        Hooks:Register()
    end

    -- Load storage
    if Storage then
        Storage:Load()
    end

    -- Check if can receive items
    if not self:CanReceiveItems() then
        if self.archipelago then
            self.archipelago.waitingForSync = true
        end
    end

    -- Process slot data
    self:ProcessSlotData(slotData)

    -- Load game data
    if Data then
        Data.Load()
    end
end

---Process the slot data
---TODO: CHANGES THIS WHEN ARCHIPELAGO IS REFACTORED
---@param slotData table<string, any> The slot data
function SlotDataHandler:ProcessSlotData(slotData)
    -- Extract player info
    local playerInfo = self.apClient:GetPlayerInfo()

    if self.archipelago then
        self.archipelago.seed = playerInfo.seed
        self.archipelago.slot = playerInfo.slot
    end

    -- Death link
    if slotData.death_link ~= nil and self.archipelago then
        self.archipelago.death_link = slotData.death_link
    end

    -- Options and data
    if self.archipelago then
        self.archipelago.options = slotData.options or {}
        self.archipelago.totals = slotData.totals or {}
        self.archipelago.pictos_data = slotData.pictos or {}
        self.archipelago.weapons_data = slotData.weapons or {}
    end

    -- Max gear level
    if CONSTANTS then
        CONSTANTS.CONFIG.MAX_LEVEL_GEAR = slotData.max_gear_level or CONSTANTS.CONFIG.DEFAULT_MAX_LEVEL_GEAR
    end

    -- Log received data
    self.logger:info("Slot Data Received:")
    if self.archipelago then
        self.logger:info("  Options: " .. Dump(self.archipelago.options))
        self.logger:info("  Totals: " .. Dump(self.archipelago.totals))
    end
end

---Check if the player is in a valid state to receive items
---Items should only be processed when player is in-game and initialized
---@return boolean canReceive True if items can be received
---TODO: DUPLICATE OF ItemsHandler:CanReceiveItems()
---@private
function SlotDataHandler:CanReceiveItems()
    if not ClientBP then return false end

    return ClientBP:IsInitialized() and
           not ClientBP:IsMainMenu() and
           not ClientBP:IsLumiereActI() and
           ClientBP:InLevel()
end

return SlotDataHandler