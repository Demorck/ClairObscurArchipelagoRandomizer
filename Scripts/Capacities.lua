local Capacities = {}
local CapacitiesBluePrintName = "BP_ExplorationProgressionSystem_C"


local WorldMapCapacities = { "Base", "HardenLands", "Swim", "SwimBoost", "Fly" }


function Capacities.UnlockDestroyPaintedRock()

end

function Capacities.UnlockNextWorldMapAbility()
    local ExplorationProgression = FindFirstOf(CapacitiesBluePrintName) ---@cast ExplorationProgression UBP_ExplorationProgressionSystem_C
    local abilities = Capacities.GetWorldMapAbilities()

    for i, value in ipairs(abilities) do
        if not value then
        end
    end
end

function Capacities.GetWorldMapAbilities()
    local ExplorationProgression = FindFirstOf(CapacitiesBluePrintName) ---@cast ExplorationProgression UBP_ExplorationProgressionSystem_C

    local result = {}

   for key, value in ipairs(WorldMapCapacities) do
      local out = {}
      ExplorationProgression:IsWorldMapCapacityUnlocked(key, out)

      result[value] = out.IsUnlocked
   end

   return result
end