---Chest-related hooks
---@class ChestHooks
local ChestHooks = {}


---Register all chest hooks
---@param hookManager HookManager Hook manager instance
---@param dependencies table Dependencies (archipelago, storage, logger)
function ChestHooks:Register(hookManager, dependencies)
    local archipelago = dependencies.archipelago
    local storage = dependencies.storage
    local logger = dependencies.logger

    -- When items are added from chest to inventory
    hookManager:Register(
        "/Game/Gameplay/GPE/Chests/BP_Chest_Regular.BP_Chest_Regular_C:AddItemsFromChestToInventory",
        self:OnItemAddedFromChestToInventory(archipelago, storage),
        "Chest - Item Collection"
    )

    -- Set chest contents to zero (remove vanilla loot)
    hookManager:Register(
        "/Game/Gameplay/GPE/Chests/BP_Chest_Regular.BP_Chest_Regular_C:RollChestItems",
        self:OnRollItemsToRemove(archipelago, storage),
        "Chest - Remove Vanilla Loot"
    )

    -- Update chest visual feedback
    hookManager:Register(
        "/Game/Gameplay/GPE/Chests/BP_Chest_Regular.BP_Chest_Regular_C:UpdateFeedbackParametersFromLoot",
        self:UpdateVisualFeedback(archipelago, storage),
        "Chest - Update Visual Feedback"
    )

    logger:info("Chest hooks registered")
end

function ChestHooks:OnItemAddedFromChestToInventory(archipelago, storage)
    return function(Context)
        if not archipelago.apSystem then return end
        if not storage.initialized_after_lumiere then return end

        local chest = Context:get() ---@type ABP_Chest_Regular_C
        local chestName = chest.ChestSetupHandle["RowName"]:ToString()

        archipelago:SendLocationCheck(chestName)
    end
end

function ChestHooks:OnRollItemsToRemove(archipelago, storage)
    return function(_, _, itemsToLoot)
        if not archipelago.apSystem then return end
        if not storage.initialized_after_lumiere then return end

        local map = itemsToLoot:get() ---@type TMap<FName, int32>
        map:Empty()
    end
end

function ChestHooks:UpdateVisualFeedback(archipelago, storage)
    return function(self)
        if not archipelago.apSystem then return end
        if not storage.initialized_after_lumiere then return end

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