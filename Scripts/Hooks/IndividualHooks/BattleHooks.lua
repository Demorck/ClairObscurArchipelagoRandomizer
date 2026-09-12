---Battle-related hooks
---@class BattleHooks
local BattleHooks = {}

---Register all battle hooks
---@param hookManager HookManager
function BattleHooks:Register(hookManager)

    -- Battle victory
    hookManager:Register(
        "/Game/jRPGTemplate/Blueprints/Components/AC_jRPG_BattleManager.AC_jRPG_BattleManager_C:OnBattleEndVictory",
        self:OnBattleVictory(),
        "Battle - Victory Handler"
    )

    -- All heroes killed (death link)
    hookManager:Register(
        "/Game/jRPGTemplate/Blueprints/Components/AC_jRPG_BattleManager.AC_jRPG_BattleManager_C:OnAllHeroesKilled",
        self:OnPartyWipe(),
        "Battle - Death Link on Party Wipe"
    )

    -- Remove battle rewards
    hookManager:Register(
        "/Game/jRPGTemplate/Blueprints/Components/AC_jRPG_BattleManager.AC_jRPG_BattleManager_C:RollBattleRewards",
        self:OnRollBattleRewards(),
        "Battle - Filter Rewards"
    )

    Logger:info("Battle hooks registered")
end


function BattleHooks:OnBattleVictory()
    return function(ctx)
        if not Archipelago:IsInitialized() then return end

        local battleManager = ctx:get() ---@type UAC_jRPG_BattleManager_C
        local encounterName = battleManager.EncounterName:ToString()

        -- Check if this is the goal
        if Battle:IsEncounterGoal(encounterName) then
            Logger:info("Goal achieved: " .. encounterName)
            Archipelago:SendVictory()
        end

        -- Check if boss (but not goal) -> send location
        if Battle:IsBossNotGoal(encounterName) then
            Logger:info("Boss defeated: " .. encounterName)
            Archipelago:SendLocationCheck(encounterName)
        end

        -- Special case: Paintress unlocks Maelle skills
        if encounterName == "L_Boss_Paintress_P1" then
            Inventory:AddItem("Quest_MaellePainterSkillsUnlock", 1, 1)
            Quests:SetObjectiveStatus("Main_ForcedCamps", "10_ForcedCamp_PostLumiereAttack", QUEST_STATUS.COMPLETED)
        end

        -- Merchant fights
        local merchant_location = Battle:GetMerchantLocationName(encounterName)
        if merchant_location ~= nil then
            Logger:info("Merchant defeated: " .. encounterName)
            Archipelago:ForceSendLocationCheck(merchant_location)
        end

        -- Handle character unlocks (if not shuffled)
        if not Options:IsEnabled("char_shuffle") then
            local canUnlock, charName = Battle:IsBattleCanUnlockCharacter(encounterName)
            if canUnlock and charName then
                if not Storage:IsCharacterUnlocked(charName) then
                    Logger:info("Unlocking character: " .. charName)
                    AddingCharacterFromArchipelago = true
                    Characters:EnableCharacter(charName)
                    Storage:UnlockCharacter(charName)
                    Storage:Update("BattleHooks:OnBattleEndVictory")
                end
            end
        end
    end
end


function BattleHooks:OnRollBattleRewards()
    return function(_, rewards)
        if not Archipelago.apSystem then return end

        local battleRewards = rewards:get() ---@type FS_BattleRewards
        local keepRewards = {} ---@type table<FS_RolledLootEntry>

        -- Keep only Foot and merchant (if shopsanity is disabled) items
        battleRewards.RolledLootEntries_12_64C7AB394C92E36998E1CAB6944CA883:ForEach(function(_, entry)
            entry = entry:get() ---@cast entry FS_RolledLootEntry
            local itemName = entry.ItemID_2_FDDBE5744EC164155E4C959474052581:ToString()

            if  string.find(itemName, "Foot") or
                not Options:IsEnabled("shopsanity") and string.find(itemName, "Merchant") then
                table.insert(keepRewards, {
                    ItemID_2_FDDBE5744EC164155E4C959474052581 = entry.ItemID_2_FDDBE5744EC164155E4C959474052581,
                    LootContextLevelOffset_9_8DB3D2484651317AEF2735A9049799C7 = entry.LootContextLevelOffset_9_8DB3D2484651317AEF2735A9049799C7,
                    Quantity_5_6316FB3244212C5481CB6E8C09995EF0 = entry.Quantity_5_6316FB3244212C5481CB6E8C09995EF0
                })
            end
        end)

        -- Replace rewards with filtered list
        battleRewards.RolledLootEntries_12_64C7AB394C92E36998E1CAB6944CA883:Empty()
        for i, reward in ipairs(keepRewards) do
            battleRewards.RolledLootEntries_12_64C7AB394C92E36998E1CAB6944CA883[i] = reward
        end
    end
end


function BattleHooks:OnPartyWipe()
    return function(ctx)
        if not Archipelago:IsInitialized() then return end

        local battleManager = ctx:get() ---@type UAC_jRPG_BattleManager_C

        -- Send death link if enabled and can't send reserve team
        if Archipelago.death_link and not battleManager:CanSendReserveTeam() then
            Archipelago:SendDeathLink("can't parry even a single attack")
        end
    end
end

return BattleHooks