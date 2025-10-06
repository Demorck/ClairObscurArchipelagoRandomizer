local Battle = {}

local BluePrintName = "AC_jRPG_BattleManager_C"
local goals = {"L_Boss_Paintress_P1", "L_Boss_Curator_P1", "TowerBattle_33", "Boss_SimonPhase2*1"}

---Return the Battle manager
---@return UAC_jRPG_BattleManager_C | nil
function Battle:GetManager()
    local manager = FindFirstOf(BluePrintName) ---@cast manager UAC_jRPG_BattleManager_C
    
    if manager ~= nil and manager:IsValid() then
        Logger:info("Retrieving Battle manager succeeds")
        return manager
    else
        Logger:error("Retrieving Battle manager fails")
        return nil
    end
end

---Return true if the encounter defeated is the goal
---@param encounter_name string
---@return boolean
function Battle:IsEncounterGoal(encounter_name)
    local goal = Archipelago.options.goal

    if goal == 0 then
        return encounter_name == "L_Boss_Paintress_P1"
    elseif goal == 1 then
        return encounter_name == "L_Boss_Curator_P1"
    elseif goal == 2 then
        return encounter_name == "TowerBattle_33"
    elseif goal == 3 then
        return encounter_name == "Boss_SimonPhase2*1"
    else
        return false
    end
end

--- Return true if the encounter is a boss but not the goal
---@param encounter_name string
---@return boolean
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

---Return true if we are currently in a battle
---@return boolean
function Battle:InBattle()
    local battle_manager = self:GetManager() ---@cast battle_manager UAC_jRPG_BattleManager_C | nil
    if battle_manager == nil then return false end

    if not battle_manager:IsValid() then
        return false
    end

    if battle_manager.EncounterName == nil then
        return false
    end

    return true
end

--- Check if the battle can unlock a character
---@param encounter_name string
function Battle:IsBattleCanUnlockCharacter(encounter_name)

    -- Lune
    if encounter_name == "SM_FirstPortier_NoTuto*1" or encounter_name == "SM_FirstPortier*1" then
        return true, "Lune"
    end

    -- Maelle
    if encounter_name == "GO_Curator_JumpTutorial*1" or encounter_name == "GO_Curator_JumpTutorial_NoTuto*1" then
        return true, "Maelle"
    end


    -- Sciel
    if encounter_name == "GV_Sciel*1" then
        return true, "Sciel"
    end

    -- Monoco
    if encounter_name == "MM_Stalact_GradientAttackTutorial*1" then
        return true, "Monoco"
    end

    -- Verso
    if encounter_name == "SC_LampMaster" then
        return true, "Verso"
    end

    -- if encounter == Renoir just kill Gustave because he's so weak.

    return false, nil

end

return Battle