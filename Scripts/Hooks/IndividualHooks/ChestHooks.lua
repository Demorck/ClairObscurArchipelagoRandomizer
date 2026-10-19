---Chest-related hooks
---@class ChestHooks
local ChestHooks = {}


---Register all chest hooks
---@param hookManager HookManager Hook manager instance
function ChestHooks:Register(hookManager)

    -- When items are added from chest to inventory
    hookManager:Register(
        "/Game/Gameplay/GPE/Chests/BP_Chest_Regular.BP_Chest_Regular_C:AddItemsFromChestToInventory",
        self:OnItemAddedFromChestToInventory(),
        "Chest - Item Collection"
    )

    -- Set chest contents to zero (remove vanilla loot)
    hookManager:Register(
        "/Game/Gameplay/GPE/Chests/BP_Chest_Regular.BP_Chest_Regular_C:RollChestItems",
        self:OnRollItemsToRemove(),
        "Chest - Remove Vanilla Loot"
    )

    -- Update chest visual feedback
    hookManager:Register(
        "/Game/Gameplay/GPE/Chests/BP_Chest_Regular.BP_Chest_Regular_C:UpdateFeedbackParametersFromLoot",
        self:UpdateVisualFeedback(),
        "Chest - Update Visual Feedback"
    )

    Logger:info("Chest hooks registered")
end

function ChestHooks:OnItemAddedFromChestToInventory()
    return function(Context)
        if not Archipelago:IsInitialized() then return end

        local chest = Context:get() ---@type ABP_Chest_Regular_C
        local chestName = chest.ChestSetupHandle["RowName"]:ToString()

        
        if not Archipelago:IsInitialized() then
            Logger:warn("Loot checked while the mod is not Initialized, check lost (or in checked stuff in Storage): " .. chestName)
            return
        end


        Archipelago:SendLocationCheck(chestName)
    end
end

function ChestHooks:OnRollItemsToRemove()
    return function(_, _, itemsToLoot)
        if not Archipelago:IsInitialized() then return end

        local map = itemsToLoot:get() ---@type TMap<FName, int32>
        map:Empty()
    end
end

function ChestHooks:UpdateVisualFeedback()
    return function(self)
        if not Archipelago:IsConnected() then return end

        local chest = self:get() ---@type ABP_Chest_Regular_C

        -- Set dust color to blue/green
        chest.ColorWhenOpening.R = 0
        chest.ColorWhenOpening.G = 0
        chest.ColorWhenOpening.B = 1

        local fx = chest.FX_Chest
        if fx then
            local color = {
                R = 0.0,
                G = 1.0,
                B = 0.0,
                A = 1.0
            } ---@type FLinearColor

            fx:SetColorParameter(FName("Color"), color)
            chest:UpdateVisuals()
        end
    end
end

return ChestHooks