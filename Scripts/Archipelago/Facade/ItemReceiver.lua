---Item Receiver
---Handles reception and processing of items from Archipelago
local ArchipelagoState = require("Archipelago.ArchipelagoState")

---@class ItemReceiver
local ItemReceiver = {}

---Receive and process an item from Archipelago
---@param item_data table Item data from AP
---@return boolean success True if item was processed successfully
function ItemReceiver:ReceiveItem(item_data)
    local local_item_data = nil ---@type ItemData

    for _, item in pairs(Data.items) do
        if item.name == item_data["name"] then
            local_item_data = item
            break
        end
    end

    if local_item_data == nil then
        Logger:error("Item data nil when receiving item: " .. Dump(item_data))
        return false
    end

    print(Dump(local_item_data))
    -- Handle different item types
    if local_item_data.type == "Area" then
        return self:HandleAreaItem(local_item_data)
    end

    if local_item_data.type == "Exploration capacities" then
        local CapacityHandler = require("Archipelago.Facade.CapacityHandler")
        return CapacityHandler:Handle(local_item_data)
    end

    if local_item_data.type == "Trap" then
        local TrapHandler = require("Archipelago.Facade.TrapHandler")
        return TrapHandler:Handle(local_item_data)
    end

    if local_item_data.type == "Character" then
        return self:HandleCharacterItem(local_item_data)
    end

    -- Handle gear items (Weapon, Picto, etc.)
    if local_item_data ~= nil then
        local level = self:GetLevelItem(local_item_data.type, item_data["id"])

        if Inventory:AddItem(local_item_data.internal_name, local_item_data.quantity, level) then
            return true
        end
    else
        Logger:error("Item not found in local data: " .. Dump(item_data))
        return false
    end

    return false
end

---Handle Area items (tickets)
---@param item_data ItemData
---@return boolean success
function ItemReceiver:HandleAreaItem(item_data)
    Storage:UnlockArea(item_data.internal_name)
    Storage:Update("ItemReceiver:HandleAreaItem")

    -- Handle specific area unlocks
    if item_data.name == "Area - Esquie's Nest" then
        Quests:SetObjectiveStatus("Main_GoldenPath", "6_EsquieNest", QUEST_STATUS.STARTED)
    elseif item_data.name == "Area - Stone Wave Cliffs" then
        Quests:SetObjectiveStatus("Main_ForcedCamps", "4_ForcedCamp_PostEsquieNest", QUEST_STATUS.COMPLETED)
    elseif item_data.name == "Area - Old Lumiere" then
        Quests:SetObjectiveStatus("Main_GoldenPath", "10_OldLumiere", QUEST_STATUS.STARTED)
    elseif item_data.name == "Area - The Monolith" then
        Quests:SetObjectiveStatus("Main_GoldenPath", "12_Axon2", QUEST_STATUS.COMPLETED)
        Quests:SetObjectiveStatus("Main_GoldenPath", "13_EnterTheMonolith", QUEST_STATUS.STARTED)
    elseif item_data.name == "Area - The Reacher" then
        Save:WriteFlagByID("NID_MaelleRelationshipLvl6_Quest", true)
    elseif item_data.name == "Area - Lumiere" then
        Quests:SetObjectiveStatus("Main_GoldenPath", "16_GoBackToLumiereAndDefeatRenoir", QUEST_STATUS.STARTED)
    end

    return true
end

---Handle Character items
---@param item_data ItemData
---@return boolean success
function ItemReceiver:HandleCharacterItem(item_data)
    local internal_name = item_data.internal_name
    Characters:EnableCharacter(internal_name)
    local ok = Storage:UnlockCharacter(internal_name)

    if not ok then Logger:error("ItemReceiver:HandleCharacterItem when trying to unlock " .. internal_name) end

    Storage:Update("ItemReceiver:HandleCharacterItem")
    return true
end

---Get the level of an item based on gear scaling options
---@param gear_type string Type of gear (Weapon, Picto)
---@param id integer Item ID
---@return integer level Item level
function ItemReceiver:GetLevelItem(gear_type, id)
    local function FindIDinTable(t)
        for i, v in ipairs(t) do
            if id == v then
                return math.ceil(CONSTANTS.CONFIG.MAX_LEVEL_GEAR * i / #t)
            end
        end
        return 15
    end

    local level = 15
    if  ArchipelagoState.options.gear_scaling == CONSTANTS.CONFIG.OPTIONS.GEAR_SCALING.SPHERE_PLACEMENT or
        ArchipelagoState.options.gear_scaling == CONSTANTS.CONFIG.OPTIONS.GEAR_SCALING.BALANCED_RANDOM then
        if gear_type == "Picto" then
            level = FindIDinTable(ArchipelagoState.pictos_data)
        elseif gear_type == "Weapon" then
            level = FindIDinTable(ArchipelagoState.weapons_data)
        end
    elseif ArchipelagoState.options.gear_scaling == 1 then
        local percent = 0
        percent = (Storage.pictosIndex + Storage.weaponsIndex) / (CONSTANTS.CONFIG.NUMBER_OF_PICTOS + CONSTANTS.CONFIG.NUMBER_OF_WEAPONS)
        if gear_type == "Picto" then
            Storage.pictosIndex = Storage.pictosIndex + 1
        elseif gear_type == "Weapon" then
            Storage.weaponsIndex = Storage.weaponsIndex + 1
        end
        Storage:Update("ItemReceiver:GetLevelItem")
        level = math.ceil(CONSTANTS.CONFIG.MAX_LEVEL_GEAR * percent)
    elseif ArchipelagoState.options.gear_scaling == 3 then
        level = math.random(1, CONSTANTS.CONFIG.MAX_LEVEL_GEAR)
    end

    return level
end

return ItemReceiver
