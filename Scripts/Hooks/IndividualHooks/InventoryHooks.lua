---@class InventoryDependencies
---@field archipelago Archipelago
---@field storage Storage
---@field logger Logger

---Inventory-related hooks
---@class InventoryHooks
local InventoryHooks = {}

---Register all inventory hooks
---@param hookManager HookManager
---@param dependencies InventoryDependencies
function InventoryHooks:Register(hookManager, dependencies)
    local archipelago = dependencies.archipelago
    local storage = dependencies.storage
    local logger = dependencies.logger

    hookManager:Register(
        "/Game/jRPGTemplate/Blueprints/Components/AC_jRPG_InventoryManager.AC_jRPG_InventoryManager_C:AddItemToInventory",
        function(context, ItemHardcodedName, _, _, _)
            if not archipelago:IsInitialized() then return end

            local itemName = ItemHardcodedName:get():ToString()
            local invManager = context:get() ---@cast invManager UAC_jRPG_InventoryManager_C

            if itemName == "LostGestral" then
                if archipelago.options.gestral_shuffle == 1 then
                    -- Remove gestral if shuffled
                    if not Contains(CONSTANTS.RUNTIME.TABLE_CURRENT_AP_FUNCTION, "AddItemToInventory") then
                        invManager:RemoveItemFromInventory(FName(itemName), 1, true)
                    else
                        storage.gestral_found = storage.gestral_found + 1
                    end
                else
                    storage.gestral_found = storage.gestral_found + 1
                end

                storage:Update("InventoryHooks:AddItemToInventory - LostGestral")

            --- Hidden Gestral Arena
            elseif (itemName == "LastStandCritical" or itemName == "LastStandSpeed" or itemName == "LastStandPowerful" or itemName == "LastStandShell" or itemName == "SoloFighter") and
                   not Contains(CONSTANTS.RUNTIME.TABLE_CURRENT_AP_FUNCTION, "AddItemToInventory") then
                    invManager:RemoveItemFromInventory(FName(itemName), 1, true)
            end
        end,
        "Inventory - Add Item"
    )

    logger:info("Inventory hooks registered")
end

return InventoryHooks