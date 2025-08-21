local Capacities = {}
local CapacitiesBluePrintName = "BP_ExplorationProgressionSystem_C"


local WorldMapCapacities = { "Base", "HardenLands", "Swim", "SwimBoost", "Fly" }
local ExplorationCapacities = { "FreeAim", "AttackInWorld", "FreeAimTeleport", "Overlay", "GameMenu", "FastTravel", "Camp" }


function Capacities:UnlockDestroyPaintedRock()
    local ExplorationProgression = FindFirstOf(CapacitiesBluePrintName)---@cast ExplorationProgression UBP_ExplorationProgressionSystem_C
    ExplorationProgression:UnlockFreeAimDamageLevel(1)
end

function Capacities:UnlockNextWorldMapAbility()
    local ExplorationProgression = FindFirstOf(CapacitiesBluePrintName) ---@cast ExplorationProgression UBP_ExplorationProgressionSystem_C
    local abilities = Capacities:GetWorldMapAbilities()

    for _, capacity in ipairs(WorldMapCapacities) do
        local row = abilities[capacity]
        if not row.isUnlocked then
            local t = { row.enumerator }
            ExplorationProgression:UnlockWorldMapCapacities(t)
            break
        end
    end
end

function Capacities:UnlockSpecificWorldMapCapacity(capacity_to_unlock)
    local ExplorationProgression = FindFirstOf(CapacitiesBluePrintName) ---@cast ExplorationProgression UBP_ExplorationProgressionSystem_C
    local abilities = Capacities:GetWorldMapAbilities()
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

function Capacities:GetWorldMapAbilities()
    local ExplorationProgression = FindFirstOf(CapacitiesBluePrintName) ---@cast ExplorationProgression UBP_ExplorationProgressionSystem_C

    local result = {}

   for key, value in ipairs(WorldMapCapacities) do
      local out = {}
      ExplorationProgression:IsWorldMapCapacityUnlocked(key, out)

      result[value] = {
        enumerator = key,
        is_unlocked = out.IsUnlocked
      }
   end

   return result
end

function Capacities:UnlockExplorationCapacity(capacity_to_unlock)
    local ExplorationProgression = FindFirstOf(CapacitiesBluePrintName) ---@cast ExplorationProgression UBP_ExplorationProgressionSystem_C

    local index = -1
    for i, value in ipairs(ExplorationCapacities) do
        if value == capacity_to_unlock then
            index = i
        end
    end

    if index == -1 then
        return
    end

    ExplorationProgression:SetExplorationCapacityUnlocked(index, true)
end

function Capacities:UnlockAllExplorationCapacities()
    local ExplorationProgression = FindFirstOf(CapacitiesBluePrintName) ---@cast ExplorationProgression UBP_ExplorationProgressionSystem_C

    for i, capacity in ipairs(ExplorationCapacities) do
        ExplorationProgression:SetExplorationCapacityUnlocked(i, true)
    end
end

return Capacities