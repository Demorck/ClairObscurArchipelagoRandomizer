local Battle = {}

local BluePrintName = "AC_jRPG_BattleManager_C"
local goals = {"L_Boss_Paintress_P1", "L_Boss_Curator_P1", "TowerBattle_33", "Boss_SimonALPHA*1"}

function Battle:GetManager()
    local manager = FindFirstOf(BluePrintName)

    if manager ~= nil and manager:IsValid() then
        Logger:info("Retrieving Battle manager succeeds")
        return manager
    else
        Logger:error("Retrieving Battle manager fails")
        return nil
    end
end

---Return true if the encounter defeated is the goal
---@param encounter_name any
function Battle:IsEncounterGoal(encounter_name)
    local goal = Archipelago.options.goal

    if goal == 0 then
        return encounter_name == "L_Boss_Paintress_P1"
    elseif goal == 1 then
        return encounter_name == "L_Boss_Curator_P1"
    elseif goal == 2 then
        return encounter_name == "TowerBattle_33"
    elseif goal == 3 then
        return encounter_name == "Boss_SimonALPHA*1"
    else
        return false
    end
end

function Battle:IsBossNotGoal(encounter_name)
    local row = Data:FindEntry(Data.locations, encounter_name) ---@cast row LocationData | nil

    if row == nil then 
        Logger:warn("This encounter in IsBossNotGoal is nil: " .. encounter_name)
        return false end

    if (row.type == "Boss" or row.type == "Tower") and not Battle:IsEncounterGoal(encounter_name) then
        return true
    end

    return false
end

function Battle:InBattle()
    local battle_manager = self:GetManager() ---@cast battle_manager UAC_jRPG_BattleManager_C | nil

    if battle_manager ~= nil and battle_manager:IsValid() then
        return false
    end

    if battle_manager.EncounterName == nil then
        return false
    end

    return true
end

return Battle