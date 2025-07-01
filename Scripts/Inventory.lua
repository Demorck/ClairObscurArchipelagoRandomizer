local Inventory = {}

local BluePrintName = "AC_jRPG_InventoryManager_C"

function Inventory.GetInventoryManager()
    local playerInventory = FindFirstOf(BluePrintName)

    return playerInventory
end

function Inventory.AddGold(amount)
    --- @class UAC_jRPG_InventoryManager_C
    local playerInventory = FindFirstOf(BluePrintName)
    if playerInventory ~= nil then
        playerInventory:ReceiveGold(amount, "")
    end
end

function Inventory.AddItem(itemName, amount)
    --- @class UAC_jRPG_InventoryManager_C
    local playerInventory = FindFirstOf(BluePrintName)
    if playerInventory == nil then
    else
        local name = FName(itemName)
        ---@class FS_LootContext
        --- It's the default level of pictos/weapon when looting. 99 is level 32 for example which is the max
        local lootContext = {
            EncounterLevel_3_FF609CBA4F19C630FF9FF0B543BB3BAB = 99
        } 
        local returned = {}
        playerInventory:AddItemToInventory(name, amount, lootContext, returned)
    end
end

return Inventory