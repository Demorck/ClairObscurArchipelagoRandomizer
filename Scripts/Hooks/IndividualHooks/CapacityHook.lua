---Capacities-related hooks
---@class CapacityHook
local CapacityHook = {}

---Register all character hooks
---@param hookManager HookManager
---@param dependencies table
function CapacityHook:Register(hookManager, dependencies)
    local storage = dependencies.storage ---@type Storage
    local logger = dependencies.logger

    -- Save characters from unavoidable death
    hookManager:Register(
        "/Game/Gameplay/Exploration/BP_ExplorationProgressionSystem.BP_ExplorationProgressionSystem_C:UnlockWorldMapCapacities",
        function(ctx, _)
            if not Archipelago:IsInitialized() then
                return
            end

            local manager = ctx:get() ---@type UBP_ExplorationProgressionSystem_C
            if not Contains(TABLE_CURRENT_AP_FUNCTION, "UnlockWorldMapCapacities") then
                manager:ResetState()
                Capacities:UnlockAllExplorationCapacities()
                for i = 1, storage:Get("progressive_rock"), 1 do
                    Capacities:UnlockNextWorldMapAbility()
                end
            end
        end,
        "Capacities - Remove WM capacities"
    )

    logger:info("Capacity hook registered")
end

return CapacityHook