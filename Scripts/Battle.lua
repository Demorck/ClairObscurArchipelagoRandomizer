local Battle = {}

local BluePrintName = "AC_jRPG_BattleManager_C"

---Return true if the encounter defeated is the goal
---@param encounter_name any
function Battle.IsEncounterGoal(encounter_name)
    local goal = AP_REF.goal

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

RegisterHook("/Game/jRPGTemplate/Blueprints/Components/AC_jRPG_BattleManager.AC_jRPG_BattleManager_C:OnBattleEndVictory", function (self)
    if AP_REF.APClient == nil then return end
    local current_context = self:get() ---@type UAC_jRPG_BattleManager_C

    local encounter_name = current_context.EncounterName:ToString()

    if Battle.IsEncounterGoal(encounter_name) then
        Archipelago:SendVictory()
    end
end)
