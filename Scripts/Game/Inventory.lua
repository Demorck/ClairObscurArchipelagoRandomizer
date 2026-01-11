local Inventory = {}

local InventoryBluePrintName = "AC_jRPG_InventoryManager_C"

local CONSUMABLE_ITEM = {
    "PartyHealConsumable",
    "Consumable_Revive_Level0",
    "Consumable_Revive_Level1",
    "Consumable_Revive_Level2",
    "Consumable_Energy_Level0",
    "Consumable_Energy_Level1",
    "Consumable_Energy_Level2",
    "Consumable_Health_Level0",
    "Consumable_Health_Level1",
    "Consumable_Health_Level2"
}

---@return UAC_jRPG_InventoryManager_C | nil
function Inventory:GetInventoryManager()
    local playerInventory = FindFirstOf(InventoryBluePrintName) ---@cast playerInventory UAC_jRPG_InventoryManager_C

    if playerInventory ~= nil and playerInventory:IsValid() then
        Logger:info("Retrieving Inventory manager succeeds")
        return playerInventory
    else
        Logger:error("Retrieving Inventory manager fails")
        return nil
    end
end

function Inventory.AddGold(amount)
    --- @class UAC_jRPG_InventoryManager_C
    local playerInventory = Inventory:GetInventoryManager()
    if playerInventory ~= nil then
        -- playerInventory:ReceiveGold(amount, "")
        Logger:callMethod(playerInventory, "ReceiveGold", amount, "")
    end
end

--- TODO: Modify lootcontext
function Inventory:AddItem(itemName, amount, item_level)
    --- @class UAC_jRPG_InventoryManager_C
    local playerInventory = Inventory:GetInventoryManager()
    local level = item_level or 45
    Logger:info("Adding item to inventory: " .. itemName .. " x" .. amount .. " with level " .. level)
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
    table.insert(TABLE_CURRENT_AP_FUNCTION, "AddItemToInventory")
    Logger:callMethod(playerInventory, "AddItemToInventory", name, amount, lootContext, returned)
    Remove(TABLE_CURRENT_AP_FUNCTION, "AddItemToInventory")

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

function Inventory.GetInventory()
    local GI = FindFirstOf("BP_jRPG_GI_Custom_C") ---@cast GI UBP_jRPG_GI_Custom_C
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

function Inventory.HasItem(itemName)
    local inventory_table = Inventory.GetInventory()

    for key, _ in pairs(inventory_table) do
        if key == itemName then
            return true
        end
    end

    return false
end

function Inventory:GetAmountOfItem(itemName)
    if not Inventory.HasItem(itemName) then return 0 end

    local inventory_table = Inventory.GetInventory()
    for key, value in pairs(inventory_table) do
        if key == itemName then
            return value
        end
    end

    return -1
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
    for _, consumable in ipairs(CONSUMABLE_ITEM) do
        Inventory:SetItemQuantity(consumable, 0)
    end
end

return Inventory