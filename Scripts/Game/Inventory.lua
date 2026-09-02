---@class Inventory
local Inventory = {}

local cachedManager = nil

---@return UAC_jRPG_InventoryManager_C | nil
function Inventory:GetInventoryManager()
    if cachedManager ~= nil and cachedManager:IsValid() then
        return cachedManager
    end
    
    local playerInventory = FindFirstOf(CONSTANTS.BLUEPRINT.INVENTORY_MANAGER) ---@cast playerInventory UAC_jRPG_InventoryManager_C

    if playerInventory ~= nil and playerInventory:IsValid() then
        cachedManager = playerInventory
        return playerInventory
    else
        Logger:error("Retrieving Inventory manager fails")
        return nil
    end
end

function Inventory:AddGold(amount)
    local playerInventory = self:GetInventoryManager()
    local reason = "Archipelago"
    
    Logger:callMethod(playerInventory, "ReceiveGold", amount, reason)
end

--- TODO: Modify lootcontext
function Inventory:AddItem(itemName, amount, item_level)
    --- @class UAC_jRPG_InventoryManager_C
    local playerInventory = Inventory:GetInventoryManager()
    local level = item_level or 45
    if playerInventory == nil then
        return false
    end

    local name = FName(itemName)

    ---@class FS_LootContext
    --- It's the default level of pictos/weapon when looting. 99 is level 32 for example which is the max
    local lootContext = {
        EncounterLevel_3_FF609CBA4F19C630FF9FF0B543BB3BAB = level * 3
    }
    local returned = {}

    -- Logger:callMethod(playerInventory, "AddItemToInventory", name, amount, lootContext, returned)
    -- playerInventory:AddItemToInventory(name, amount, lootContext, returned)
    Logger:info("Adding item to inventory: " .. itemName .. " x" .. amount .. " with level " .. level .. "...")

    RuntimeState:AsModCall("AddItemToInventory", function()
        Logger:callMethod(playerInventory, "AddItemToInventory", name, amount, lootContext, returned)
    end)


    Logger:info("Item " .. itemName .. " added !")

    return true
end

function Inventory:RemoveItem(itemName, amount)
    --- @class UAC_jRPG_InventoryManager_C
    local playerInventory = Inventory:GetInventoryManager()
    if playerInventory ~= nil then
        local name = FName(itemName)
        -- playerInventory:RemoveItemFromInventory(name, amount, false)
        Logger:callMethod(playerInventory, "RemoveItemFromInventory", name, amount, false)
    end
end

function Inventory:GetInventory()
    local GI = FindFirstOf(CONSTANTS.BLUEPRINT.GI_CUSTOM) ---@cast GI UBP_jRPG_GI_Custom_C
    local inv = GI.Inventory ---@cast inv TArray<FS_jRPG_Item_DynamicData>
    local items = {} ---@cast items table<string, int32>


    local index = 1
    while inv[index].StacksAmount_2_9F82380C4167D3E4C37234817EF904DC ~= 0 do
        local item = inv[index]
        local name = item.ItemStaticData_9_59CF465348F5D7696BDFE68CB4071486.Item_HardcodedName_90_C7F763B74AAB28EF890A66854D7D95AA:ToString()
        local amount = item.StacksAmount_2_9F82380C4167D3E4C37234817EF904DC
        items[name] = amount

        index = index + 1
    end


    return items
end

function Inventory:HasItem(itemName)
    local GI = FindFirstOf(CONSTANTS.BLUEPRINT.GI_CUSTOM) ---@cast GI UBP_jRPG_GI_Custom_C
    return GI:GetItemQuantityInInventory(FName(itemName)) > 0
end

function Inventory:GetAmountOfItem(itemName)
    local GI = FindFirstOf(CONSTANTS.BLUEPRINT.GI_CUSTOM) ---@cast GI UBP_jRPG_GI_Custom_C
    return GI:GetItemQuantityInInventory(FName(itemName))
end

function Inventory:Adding999Recoat()
    Inventory:AddItem("Consumable_Respec", 999)
end

function Inventory:SetItemQuantity(item_name, amount)
    local current_amount = Inventory:GetAmountOfItem(item_name)
    if current_amount < 0 then
        return
    end

    if current_amount < amount then
        Inventory:AddItem(item_name, amount - current_amount)
    elseif current_amount > amount then
        Inventory:RemoveItem(item_name, current_amount - amount)
    end
end

function Inventory:RemoveConsumable()
    for _, consumable in ipairs(CONSTANTS.GAME.CONSUMABLE_ITEM) do
        Inventory:SetItemQuantity(consumable, 0)
    end
end

return Inventory