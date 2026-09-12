---Inventory-related hooks
---@class InventoryHooks
local InventoryHooks = {}

local LAST_STAND_ITEMS = {
    LastStandCritical = true, LastStandSpeed = true, LastStandPowerful = true,
    LastStandShell = true, SoloFighter = true,
}

---Register all inventory hooks
---@param hookManager HookManager
function InventoryHooks:Register(hookManager)

    hookManager:Register(
        "/Game/jRPGTemplate/Blueprints/Components/AC_jRPG_InventoryManager.AC_jRPG_InventoryManager_C:AddItemToInventory",
        function(context, ItemHardcodedName, _, _, _)
            if not Archipelago:IsInitialized() then return end

            local itemName = ItemHardcodedName:get():ToString()

            local is_lost_gestral = itemName == "LostGestral"
            local is_shop_item = Options:IsEnabled("shopsanity") and Utils.StringHelper.StartsWith(itemName, "Merchant (")
            local is_game_using_this_function = not RuntimeState:IsModCall("AddItemToInventory")

            if not is_lost_gestral and not LAST_STAND_ITEMS[itemName] and not is_shop_item then
                return
            end


            local invManager = context:get() ---@cast invManager UAC_jRPG_InventoryManager_C

            if is_lost_gestral then
                if Options:IsEnabled("gestral_shuffle") then
                    -- Remove gestral if shuffled
                    if is_game_using_this_function then
                        invManager:RemoveItemFromInventory(FName(itemName), 1, true)
                    else
                        Storage:Increment("gestral_found")
                    end
                else
                    Storage:Increment("gestral_found")
                end

                Storage:Update("InventoryHooks:AddItemToInventory - LostGestral")

            
            elseif is_shop_item then
                Archipelago:ForceSendLocationCheck(itemName)
                Storage:CheckMerchant(itemName, true)
                Storage:Update("Hook - AC_jRPG_InventoryManager_C:AddItemToInventory")

            --- Hidden Gestral Arena
            elseif is_game_using_this_function then
                invManager:RemoveItemFromInventory(FName(itemName), 1, false)
            end
        end,
        "Inventory - Add Item"
    )

    Logger:info("Inventory hooks registered")
end

return InventoryHooks