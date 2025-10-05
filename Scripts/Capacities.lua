local Capacities = {}
local CapacitiesBluePrintName = "BP_ExplorationProgressionSystem_C"


local WorldMapCapacities = { "Base", "HardenLands", "Swim", "SwimBoost", "Fly" }
local ExplorationCapacities = { "FreeAim", "AttackInWorld", "FreeAimTeleport", "Overlay", "GameMenu", "FastTravel", "Camp" }

---Return the Exploration Progression manager
---@return UBP_ExplorationProgressionSystem_C | nil
function Capacities:GetManager()
    local ExplorationProgression = FindFirstOf(CapacitiesBluePrintName) ---@cast ExplorationProgression UBP_ExplorationProgressionSystem_C
    if ExplorationProgression ~= nil and ExplorationProgression:IsValid() then
        Logger:info("Retrieving Exploration Progression manager succeeds")
        return ExplorationProgression
    else
        Logger:error("Retrieving Exploration Progression manager fails")
        return nil
    end
end

--- Unlock the ability to destroy painted rocks
function Capacities:UnlockDestroyPaintedRock()
    local ExplorationProgression = self:GetManager() ---@cast ExplorationProgression UBP_ExplorationProgressionSystem_C
    if ExplorationProgression == nil then return end

    table.insert(TABLE_CURRENT_AP_FUNCTION, "UnlockDestroyPaintedRock")
    ExplorationProgression:UnlockFreeAimDamageLevel(1)
    Remove(TABLE_CURRENT_AP_FUNCTION, "UnlockDestroyPaintedRock")
end

--- Unlock the next world map ability
function Capacities:UnlockNextWorldMapAbility()
    Logger:info("Unlocking next world map ability...")
    local ExplorationProgression = self:GetManager() ---@cast ExplorationProgression UBP_ExplorationProgressionSystem_C
    if ExplorationProgression == nil then return end
    local abilities = Capacities:GetWorldMapAbilities()

    for _, capacity in ipairs(WorldMapCapacities) do
        local row = abilities[capacity]
        if not row.isUnlocked then
            local t = { row.enumerator }
            -- Logger:callMethod(ExplorationProgression, "UnlockWorldMapCapacities", t)
            ExplorationProgression:UnlockWorldMapCapacities(t)

            if capacity == "Base" then
                local t = { row.enumerator + 1 }
                ExplorationProgression:UnlockWorldMapCapacities(t)
            end
            break
        end
    end
end

--- Unlock a specific world map capacity
---@param capacity_to_unlock string the internal name of capacity to unlock
function Capacities:UnlockSpecificWorldMapCapacity(capacity_to_unlock)
    local ExplorationProgression = self:GetManager() ---@cast ExplorationProgression UBP_ExplorationProgressionSystem_C
    if ExplorationProgression == nil then return end
    
    local index = 0
    for i, capacity in ipairs(WorldMapCapacities) do
        if capacity == capacity_to_unlock then
            index = i
        end
    end

    if index == 0 then return end

    local t = { index }
    ExplorationProgression:UnlockWorldMapCapacities(t)
end

--- Get the status of all world map abilities
---@return table<string, {enumerator: integer, is_unlocked: boolean}>
function Capacities:GetWorldMapAbilities()
    Logger:info("Getting world map abilities...")
    local ExplorationProgression = self:GetManager() ---@cast ExplorationProgression UBP_ExplorationProgressionSystem_C
    if ExplorationProgression == nil then return {} end
    local result = {}

   for key, value in ipairs(WorldMapCapacities) do
      local out = {}
    --   Logger:callMethod(ExplorationProgression, "IsWorldMapCapacityUnlocked", key, out)
      ExplorationProgression:IsWorldMapCapacityUnlocked(key, out)

      result[value] = {
        enumerator = key,
        is_unlocked = out.IsUnlocked
      }
   end

   return result
end

---Unlock a specific exploration capacity
---@param capacity_to_unlock string the internal name of capacity to unlock
function Capacities:UnlockExplorationCapacity(capacity_to_unlock)
    Logger:info("Unlocking exploration capacity: " .. capacity_to_unlock)
    local ExplorationProgression = self:GetManager() ---@cast ExplorationProgression UBP_ExplorationProgressionSystem_C
    if ExplorationProgression == nil then return end
    
    local index = -1
    for i, value in ipairs(ExplorationCapacities) do
        if value == capacity_to_unlock then
            index = i
        end
    end

    if index == -1 then
        return
    end

    -- Logger:callMethod(ExplorationProgression, "SetExplorationCapacityUnlocked", index, true)
    ExplorationProgression:SetExplorationCapacityUnlocked(index, true)
end

---Unlock all exploration capacities, except Free Aim if it's shuffled
function Capacities:UnlockAllExplorationCapacities()
    Logger:info("Unlocking all exploration capacities...")
    local ExplorationProgression = self:GetManager() ---@cast ExplorationProgression UBP_ExplorationProgressionSystem_C
    if ExplorationProgression == nil then return end

    for i, _ in ipairs(ExplorationCapacities) do
        if Archipelago.options.shuffle_free_aim == 1 then
            if ExplorationCapacities[i] ~= "FreeAim" then
                ExplorationProgression:SetExplorationCapacityUnlocked(i, true)
            else
                Storage.free_aim_unlocked = false
            end
        else
            Storage.free_aim_unlocked = true
            ExplorationProgression:SetExplorationCapacityUnlocked(i, true)
        end
    end
end

function Capacities:DisableFreeAimIfNeeded()
    if Archipelago.options.shuffle_free_aim == 1 and not Storage.free_aim_unlocked then
        Logger:info("Disabling Free Aim...")
        local ExplorationProgression = self:GetManager() ---@cast ExplorationProgression UBP_ExplorationProgressionSystem_C
        if ExplorationProgression == nil then return end
        
        ExplorationProgression:SetExplorationCapacityUnlocked(1, false)
    end
end

return Capacities