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

RegisterHook("/Game/jRPGTemplate/Blueprints/Components/AC_jRPG_BattleManager.AC_jRPG_BattleManager_C:OnBattleEndVictory", function (self)
    if AP_REF.APClient == nil then return end


    local current_context = self:get() ---@cast current_context UAC_jRPG_BattleManager_C

    local encounter_name = current_context.EncounterName:ToString()

    if Battle:IsEncounterGoal(encounter_name) then
        Logger:info("Goal achieved: " .. encounter_name .. " ! Bravo !")
        Archipelago:SendVictory()
    end

    if Battle:IsBossNotGoal(encounter_name) then
        Logger:info("Boss defeated but not a goal: " .. encounter_name)
        Archipelago:SendLocationCheck(encounter_name)
    end
end)

RegisterHook("/Game/jRPGTemplate/Blueprints/Components/AC_jRPG_BattleManager.AC_jRPG_BattleManager_C:RollBattleRewards", function (self, rewards)
    if AP_REF.APClient == nil then return end
    local battle_rewards = rewards:get() ---@cast battle_rewards FS_BattleRewards
    battle_rewards.RolledLootEntries_12_64C7AB394C92E36998E1CAB6944CA883:Empty()
end)