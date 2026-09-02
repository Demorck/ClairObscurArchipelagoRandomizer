---@class Battle
local Battle = {}

---Return the Battle manager
---@return UAC_jRPG_BattleManager_C | nil
function Battle:GetManager()
    local manager = FindFirstOf(CONSTANTS.BLUEPRINT.BATTLE_MANAGER) ---@cast manager UAC_jRPG_BattleManager_C
    
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
    local goal = CONSTANTS.GOAL[Options.values.goal]

    return goal ~= nil and goal.encounter == encounter_name
end

--- Return true if the encounter is a boss but not the goal
---@param encounter_name string
---@return boolean
function Battle:IsBossNotGoal(encounter_name)
    local row = Data:FindEntry(Data.locations, encounter_name) ---@cast row LocationData | table<LocationData> | nil

    if row == nil then 
        Logger:warn("This encounter in IsBossNotGoal is nil: " .. encounter_name)
        return false 
    end

    if type(row) == "table" then
        for _, r in ipairs(row) do
            if (r.type == "Boss" or r.type == "Tower") and not Battle:IsEncounterGoal(encounter_name) then
                return true
            end
        end
    end

    if (row.type == "Boss" or row.type == "Tower") and not Battle:IsEncounterGoal(encounter_name) then
        return true
    end
    
    return false
end

function Battle:GetMerchantLocationName(encounter_name)
    if not Utils.StringHelper.StartsWith(encounter_name, "Merchant") then
        return nil
    end

    for _, shop in pairs(Data.shops) do
        if not shop.has_fight then
            goto continue
        end

        -- Merchant's name is DT_'Merchant_SMTH'
        local _, _, current_merchant_name = string.find(shop.datatable, ".*%.DT_(.*)", 1, false)
        if encounter_name == current_merchant_name then
            local _, _, prefix = string.find(shop.unlock_item, "(.*- )", 1, false)
            local suffix = "Fight"
            return prefix .. suffix
        end 

        ::continue::
    end

    return nil
end

---Return true if we are currently in a battle
---@return boolean
function Battle:InBattle()
    local battle_manager = self:GetManager() ---@cast battle_manager UAC_jRPG_BattleManager_C | nil
    if battle_manager == nil then return false end

    if not battle_manager:IsValid() then
        return false
    end

    if battle_manager.EncounterName == nil or battle_manager.EncounterName:ToString() == "None" then
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
    if encounter_name == "MS_Monoco" then
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