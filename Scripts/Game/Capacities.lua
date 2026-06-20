---@class Capacities
local Capacities = {}

---Return the Exploration Progression manager
---@return UBP_ExplorationProgressionSystem_C | nil
function Capacities:GetManager()
    local ExplorationProgression = FindFirstOf(CONSTANTS.BLUEPRINT.EXPLORATION_SYSTEM) ---@cast ExplorationProgression UBP_ExplorationProgressionSystem_C
    if ExplorationProgression ~= nil and ExplorationProgression:IsValid() then
        Logger:info("Retrieving Exploration Progression manager succeeds")
        return ExplorationProgression
    else
        Logger:error("Retrieving Exploration Progression manager fails")
        return nil
    end
end

function Capacities:IsExplorationCapacityUnlocked(capacity)
    local ExplorationProgression = self:GetManager() ---@cast ExplorationProgression UBP_ExplorationProgressionSystem_C
    if ExplorationProgression == nil then return end

    local result = {}
    Logger:callMethod(ExplorationProgression, "IsExplorationCapacityUnlocked", capacity, result)
    
    return result.IsUnlocked
end

function Capacities:IsPaintBreakUnlocked()
    local ExplorationProgression = self:GetManager() ---@cast ExplorationProgression UBP_ExplorationProgressionSystem_C
    if ExplorationProgression == nil then return end

    local result = {}

    Logger:callMethod(ExplorationProgression, "GetFreeAimDamageLevel", result)
    
    return result.FreeAimDamageLevel == 1
end

function Capacities:SetDestroyPaintedRock(want_to_unlock)
    local ExplorationProgression = self:GetManager() ---@cast ExplorationProgression UBP_ExplorationProgressionSystem_C
    if ExplorationProgression == nil then return end

    local to_int = 0
    if want_to_unlock then to_int = 1 end

    table.insert(CONSTANTS.RUNTIME.TABLE_CURRENT_AP_FUNCTION, "UnlockFreeAimDamageLevel")
    Logger:callMethod(ExplorationProgression, "UnlockFreeAimDamageLevel", to_int)
    Remove(CONSTANTS.RUNTIME.TABLE_CURRENT_AP_FUNCTION, "UnlockFreeAimDamageLevel")
end

--- Unlock the next world map ability
function Capacities:UnlockNextWorldMapAbility()
    Logger:info("Unlocking next world map ability...")
    local ExplorationProgression = self:GetManager() ---@cast ExplorationProgression UBP_ExplorationProgressionSystem_C
    if ExplorationProgression == nil then return end
    local abilities = Capacities:GetWorldMapAbilities()

    local new = false
    for i, capacity in ipairs(CONSTANTS.GAME.TABLE.WORLDMAP_CAPACITIES) do
        local row = abilities[capacity]
        if not row.is_unlocked then
            local t = { i }

            
            table.insert(CONSTANTS.RUNTIME.TABLE_CURRENT_AP_FUNCTION, "UnlockWorldMapCapacities")
            -- ExplorationProgression:UnlockWorldMapCapacities(t)
            Logger:callMethod(ExplorationProgression, "UnlockWorldMapCapacities", t)

            if capacity == "Base" then
                local t = { i + 1 }
                -- ExplorationProgression:UnlockWorldMapCapacities(t)
                Logger:callMethod(ExplorationProgression, "UnlockWorldMapCapacities", t)
            end

            Storage:Update("UnlockSpecificWorldMapCapacity")
            Remove(CONSTANTS.RUNTIME.TABLE_CURRENT_AP_FUNCTION, "UnlockWorldMapCapacities")
            new = true
            break
        end
    end

    if not new then
        Save:WriteFlagByName(CONSTANTS.NID.DIVE_GUID.NAME, true)
    end
end

--- Get the status of all world map abilities
---@return table<string, {enumerator: integer, is_unlocked: boolean}>
function Capacities:GetWorldMapAbilities()
    Logger:info("Getting world map abilities...")
    local ExplorationProgression = self:GetManager() ---@cast ExplorationProgression UBP_ExplorationProgressionSystem_C
    if ExplorationProgression == nil then return {} end
    local result = {}

   for key, value in ipairs(CONSTANTS.GAME.TABLE.WORLDMAP_CAPACITIES) do
      local out = {}
    --   Logger:callMethod(ExplorationProgression, "IsWorldMapCapacityUnlocked", key, out)
    --   ExplorationProgression:IsWorldMapCapacityUnlocked(key, out)
      Logger:callMethod(ExplorationProgression, "IsWorldMapCapacityUnlocked", key, out)

      result[value] = {
        enumerator = key,
        is_unlocked = out.IsUnlocked
      }
   end

   return result
end

---Unlock a specific exploration capacity
---@param capacity_to_unlock string the internal name of capacity to unlock
---@param unlock boolean true if need to unlock, false otherwise
function Capacities:SetExplorationCapacity(capacity_to_unlock, unlock)
    Logger:info("Set exploration capacity: " .. capacity_to_unlock .. " to " .. tostring(unlock))
    local ExplorationProgression = self:GetManager() ---@cast ExplorationProgression UBP_ExplorationProgressionSystem_C
    if ExplorationProgression == nil then return end
    
    local index = -1
    for i, value in ipairs(CONSTANTS.GAME.TABLE.EXPLORATION_CAPACITIES) do
        if value == capacity_to_unlock then
            index = i
            break
        end
    end

    if index == -1 then
        return
    end

    Logger:callMethod(ExplorationProgression, "SetExplorationCapacityUnlocked", index - 1, unlock)
end

---Unlock all exploration capacities, except Free Aim if it's shuffled
function Capacities:UnlockAllExplorationCapacities()
    Logger:info("Unlocking all exploration capacities...")
    local ExplorationProgression = self:GetManager() ---@cast ExplorationProgression UBP_ExplorationProgressionSystem_C
    if ExplorationProgression == nil then return end

    for i, _ in ipairs(CONSTANTS.GAME.TABLE.EXPLORATION_CAPACITIES) do
        if Archipelago.options.shuffle_free_aim == 1 then
            if CONSTANTS.GAME.TABLE.EXPLORATION_CAPACITIES[i] ~= "FreeAim" then
                -- ExplorationProgression:SetExplorationCapacityUnlocked(i, true)
                Logger:callMethod(ExplorationProgression, "SetExplorationCapacityUnlocked", i - 1, true)
            else
                local free_aim_unlocked = Storage:Get("free_aim_unlocked")
                Storage:Set("free_aim_unlocked", free_aim_unlocked)
            end
        else
            Storage:Set("free_aim_unlocked", true)
            -- ExplorationProgression:SetExplorationCapacityUnlocked(i, true)
            Logger:callMethod(ExplorationProgression, "SetExplorationCapacityUnlocked", i - 1, true)
        end
    end
end

function Capacities:TogglePaintBreakIfNeeded()
    local unlocked = Storage:Get("paint_break_unlocked")
    local locked = not unlocked

    if locked and self:IsPaintBreakUnlocked() then
        Logger:info("Disabling paint break...")
        self:SetDestroyPaintedRock(false)
    end
    
    if unlocked and not self:IsPaintBreakUnlocked() then
        Logger:info("Enabling paint break...")
        self:SetDestroyPaintedRock(true)
    end
end

function Capacities:ToggleFreeAimIfNeeded()
    if Archipelago.options.shuffle_free_aim == 1 then
        local unlocked = Storage:Get("free_aim_unlocked")
        local locked = not unlocked

        if locked and self:IsExplorationCapacityUnlocked(1) then
            Logger:info("Disabling free aim...")
            self:SetExplorationCapacity("FreeAim", false)
        end
        if unlocked and not self:IsExplorationCapacityUnlocked(1) then
            Logger:info("Enabling free aim...")
            self:SetExplorationCapacity("FreeAim", true)
        end
    end
end

return Capacities