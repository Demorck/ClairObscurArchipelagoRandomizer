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
    self:LogSessionHeader()
end

function SlotDataHandler:LogSessionHeader()
    local player = Archipelago:GetPlayer()
    local goal = CONSTANTS.GOAL[Options.values.goal]

    Logger:info("=============== SESSION ===============")
    Logger:info(("Mod version  : %s"):format(CONSTANTS.VERSION))
    Logger:info(("Seed         : %s"):format(tostring(player.seed)))
    Logger:info(("Slot         : %s (player %s)"):format(tostring(player.slot), tostring(player.number)))
    Logger:info(("Goal         : %s"):format(goal and goal.name or "unknown"))
    Logger:info(("Max gear lvl : %d"):format(Archipelago.max_level_gear))
    Logger:info(("Data loaded  : %d items, %d locations, %d shops")
        :format(#Data.items, #Data.locations, #Data.shops))

    local keys = {}
    for key in pairs(Options.values) do table.insert(keys, key) end
    table.sort(keys)

    for _, key in ipairs(keys) do
        Logger:info(("  option %-26s = %s"):format(key, tostring(Options.values[key])))
    end

    Logger:info("=======================================")
end

return SlotDataHandler