---@class InventoryDependencies
---@field archipelago Archipelago
---@field storage Storage
---@field logger Logger

---Inventory-related hooks
---@class InventoryHooks
local InventoryHooks = {}

local LAST_STAND_ITEMS = {
    LastStandCritical = true, LastStandSpeed = true, LastStandPowerful = true,
    LastStandShell = true, SoloFighter = true,
}

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

            local is_lost_gestral = itemName == "LostGestral"
            local is_shop_item = archipelago.options.shopsanity == 1 and Utils.StringHelper.StartsWith(itemName, "Shop:")
            local is_game_using_this_function = not Contains(CONSTANTS.RUNTIME.TABLE_CURRENT_AP_FUNCTION, "AddItemToInventory")

            if not is_lost_gestral and not LAST_STAND_ITEMS[itemName] and not is_shop_item then
                return
            end


            local invManager = context:get() ---@cast invManager UAC_jRPG_InventoryManager_C

            if is_lost_gestral then
                if archipelago.options.gestral_shuffle == 1 then
                    -- Remove gestral if shuffled
                    if not is_game_using_this_function then
                        invManager:RemoveItemFromInventory(FName(itemName), 1, true)
                    else
                        storage.gestral_found = storage.gestral_found + 1
                    end
                else
                    storage.gestral_found = storage.gestral_found + 1
                end

                storage:Update("InventoryHooks:AddItemToInventory - LostGestral")

            
            elseif is_shop_item then
                Archipelago:ForceSendLocationCheck(itemName)
                Storage:CheckMerchant(itemName, true)
                Storage:Update("Hook - AC_jRPG_InventoryManager_C:AddItemToInventory")

            --- Hidden Gestral Arena
            elseif not is_game_using_this_function then
                invManager:RemoveItemFromInventory(FName(itemName), 1, false)
            end
        end,
        "Inventory - Add Item"
    )

    logger:info("Inventory hooks registered")
end

return InventoryHooks