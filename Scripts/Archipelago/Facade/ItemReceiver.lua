---Item Receiver
---Handles reception and processing of items from Archipelago
local ArchipelagoState = require("Archipelago.ArchipelagoState")

---@class ItemReceiver
local ItemReceiver = {}

---Receive and process an item from Archipelago
---@param item_data table Item data from AP
---@return boolean success True if item was processed successfully
function ItemReceiver:ReceiveItem(item_data)
    local local_item_data = Data.items_by_AP_name[item_data["name"]] ---@type ItemData

    if local_item_data == nil then
        Logger:error("Item data nil when receiving item: " .. Dump(item_data))
        return false
    end

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

    if local_item_data.type == "Other" then
        return self:HandleOtherItem(local_item_data)
    end

    -- Handle gear items (Weapon, Picto, etc.)
    local level = self:GetLevelItem(local_item_data.type, item_data["id"])

    if Inventory:AddItem(local_item_data.internal_name, local_item_data.quantity, level) then
        return true
    end

    return false
end

function ItemReceiver:HandleOtherItem(item_data)
    if item_data.name == "Chroma Pack" then
        local how_much_chroma = 0
        if Archipelago.options.chroma_pack_type == 0 then
            how_much_chroma = Archipelago.chroma
        else
            local min = math.min(Archipelago.options.min_chroma_pack, Archipelago.options.max_chroma_pack)
            local max = math.min(Archipelago.options.min_chroma_pack, Archipelago.options.max_chroma_pack)
            how_much_chroma = math.random(min, max)
        end
        Inventory:AddGold(how_much_chroma)
    end

    return true
end

---Handle Area items (tickets)
---@param item_data ItemData
---@return boolean success
function ItemReceiver:HandleAreaItem(item_data)
    Storage:UnlockArea(item_data.internal_name)

    -- Handle specific area unlocks
    if item_data.name == "Area - Esquie's Nest" then
        Quests:SetObjectiveStatus("Main_GoldenPath", "6_EsquieNest", QUEST_STATUS.STARTED)
        Quests:SetObjectiveStatus("Main_ForcedCamps", "1_ForcedCamp_PostSpringMeadows", QUEST_STATUS.COMPLETED)
    elseif item_data.name == "Area - Stone Wave Cliffs" then
        Quests:SetObjectiveStatus("Main_ForcedCamps", "4_ForcedCamp_PostEsquieNest", QUEST_STATUS.COMPLETED)
    elseif item_data.name == "Area - Old Lumiere" then
        Quests:SetObjectiveStatus("Main_GoldenPath", "10_OldLumiere", QUEST_STATUS.STARTED)
    elseif item_data.name == "Area - The Monolith" then
        Quests:SetObjectiveStatus("Main_GoldenPath", "12_Axon2", QUEST_STATUS.COMPLETED)
        Quests:SetObjectiveStatus("Main_GoldenPath", "13_EnterTheMonolith", QUEST_STATUS.STARTED)
    elseif item_data.name == "Area - The Reacher" then
        Save:WriteFlagByName(CONSTANTS.NID.REACHER_LVL6_MAELLE, true)
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

        level = math.ceil(CONSTANTS.CONFIG.MAX_LEVEL_GEAR * percent)
    elseif ArchipelagoState.options.gear_scaling == 3 then
        level = math.random(1, CONSTANTS.CONFIG.MAX_LEVEL_GEAR)
    end

    return level
end

return ItemReceiver
