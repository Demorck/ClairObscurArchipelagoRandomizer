---@class SlotDataHandler
local SlotDataHandler = {}

---Handle the slot data received from the AP server
---This is the main entry point called by the EventDispatcher
---@param slotData table<string, any> The slot data
function SlotDataHandler:Handle(slotData)
    Logger:info("Processing slot data...")

    -- Mark as connected
    Archipelago.hasConnectedPrior = true
    Archipelago.trying_to_connect = false
    
    -- Process slot data
    self:ProcessSlotData(slotData)

    -- Register hooks
    Hooks:Register()

    -- Load storage
    Storage:Load()

    Archipelago.pendingLocationsFlush = true

    -- Check if can receive items
    if not Archipelago:CanReceiveItems() then
        Archipelago:Sync()
    end

    -- Load game data
    Data.Load()

    Archipelago.want_to_scout_shop = false
end

---Process the slot data
---TODO: CHANGES THIS WHEN ARCHIPELAGO IS REFACTORED
---@param slotData table<string, any> The slot data
function SlotDataHandler:ProcessSlotData(slotData)
    -- Extract player info
    local playerInfo = Archipelago:GetClient():GetPlayerInfo()

    Archipelago.seed = playerInfo.seed
    Archipelago.slot = playerInfo.slot

    -- Death link
    if slotData.death_link ~= nil and Archipelago then
        Archipelago.death_link = slotData.death_link
    end

    -- Options and data
    Options:Load(slotData.options)
    Archipelago.totals = slotData.totals or {}
    Archipelago.pictos_data = slotData.pictos or {}
    Archipelago.weapons_data = slotData.weapons or {}
    Archipelago.shop_data = slotData.shops or {}
    Archipelago.chroma = slotData.chroma or nil
    Archipelago.max_level_gear = slotData.max_gear_level or 33

    -- Log received data
    Logger:info("Slot Data Received:")
    Logger:info("  Options: " .. Dump(Options.values))
end

return SlotDataHandler