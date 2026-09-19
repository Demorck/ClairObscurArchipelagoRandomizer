---Item Receiver
---Handles reception and processing of items from Archipelago
local CapacityHandler = require("Archipelago.Effects.CapacityHandler")
local TrapHandler = require("Archipelago.Effects.TrapHandler")

---@class ItemReceiver
local ItemReceiver = {}

ItemReceiver.HANDLERS_BY_TYPE = {
    ["Area"]                   = function(item) return ItemReceiver:HandleAreaItem(item) end,
    ["Character"]              = function(item) return ItemReceiver:HandleCharacterItem(item) end,
    ["Other"]                  = function(item) return ItemReceiver:HandleOtherItem(item) end,
    ["Exploration capacities"] = function(item) return CapacityHandler:Handle(item) end,
    ["Trap"]                   = function(item) return TrapHandler:Handle(item) end,
}

ItemReceiver.INVENTORY_TYPES = {
    ["Picto"] = true, ["Weapon"] = true, ["Journal"] = true,
    ["Merchant Unlock"] = true, ["Quest item"] = true, ["Upgrade material"] = true,
}

---Receive and process an item from Archipelago
---@param item_data table Item data from AP
---@return boolean success True if item was processed successfully
function ItemReceiver:ReceiveItem(item_data)
    local local_item_data = Data.items_by_AP_name[item_data["name"]] ---@type ItemData

    if local_item_data == nil then
        Logger:error("Item data nil when receiving item: " .. Dump(item_data))
        return false
    end

    local handler_fn = self.HANDLERS_BY_TYPE[local_item_data.type]
    if handler_fn ~= nil then
        return handler_fn(local_item_data)
    end

    -- Anything else goes straight to the inventory
    local level = self:GetLevelItem(local_item_data.type, item_data["id"])
    Logger:debug(("Item %q (type %s) sent to inventory as %s")
        :format(local_item_data.name, local_item_data.type, local_item_data.internal_name))

    return Inventory:AddItem(local_item_data.internal_name, local_item_data.quantity, level)
end

function ItemReceiver:HandleOtherItem(item_data)
    if item_data.name == "Chroma Pack" then
        local how_much_chroma = 0
        if Options.values.chroma_pack_type == 0 then
            how_much_chroma = Archipelago.chroma
        else
            local min = math.min(Options.values.min_chroma_pack, Options.values.max_chroma_pack)
            local max = math.max(Options.values.min_chroma_pack, Options.values.max_chroma_pack)
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
                return math.ceil(Archipelago.max_level_gear * i / #t)
            end
        end
        return 15
    end

    local level = 15
    local gear_option = Options.values.gear_scaling
    if  gear_option == Options.GEAR_SCALING.SPHERE_PLACEMENT or
        gear_option == Options.GEAR_SCALING.BALANCED_RANDOM then
        if gear_type == "Picto" then
            level = FindIDinTable(Archipelago.pictos_data)
        elseif gear_type == "Weapon" then
            level = FindIDinTable(Archipelago.weapons_data)
        end
    elseif gear_option == Options.GEAR_SCALING.ORDER_RECEIVED then
        local total_gear = (Data.count_by_type["Picto"] or 0) + (Data.count_by_type["Weapon"] or 0)
        if gear_type == "Picto" then
            Storage:Increment("pictosIndex")
        elseif gear_type == "Weapon" then
            Storage:Increment("weaponsIndex")
        end

        local percent = (Storage:Get("pictosIndex") + Storage:Get("weaponsIndex")) / total_gear
        level = math.ceil(Archipelago.max_level_gear * percent)
    elseif gear_option == Options.GEAR_SCALING.FULL_RANDOM then
        level = math.random(1, Archipelago.max_level_gear)
    end

    Logger:debug(("Gear %s id=%s -> level %d (scaling %d, pictos=%d weapons=%d)")
        :format(gear_type, tostring(id), level, Options.values.gear_scaling,
            Storage:Get("pictosIndex"), Storage:Get("weaponsIndex")))
    return level
end

return ItemReceiver
