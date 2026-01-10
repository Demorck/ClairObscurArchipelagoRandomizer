---Battle-related hooks
---@class BattleHooks
local BattleHooks = {}

---Register all battle hooks
---@param hookManager HookManager
---@param dependencies table
function BattleHooks:Register(hookManager, dependencies)
    local archipelago = dependencies.archipelago ---@type Archipelago
    local storage = dependencies.storage
    local logger = dependencies.logger
    local battle = dependencies.battle
    local characters = dependencies.characters
    local inventory = dependencies.inventory
    local quests = dependencies.quests

    -- Battle victory
    hookManager:Register(
        "/Game/jRPGTemplate/Blueprints/Components/AC_jRPG_BattleManager.AC_jRPG_BattleManager_C:OnBattleEndVictory",
        function(self)
            if not archipelago.apSystem then return end
            if not storage.initialized_after_lumiere then return end

            local battleManager = self:get() ---@type UAC_jRPG_BattleManager_C
            local encounterName = battleManager.EncounterName:ToString()

            -- Check if this is the goal
            if battle:IsEncounterGoal(encounterName) then
                logger:info("Goal achieved: " .. encounterName)
                archipelago:SendVictory()
            end

            -- Check if boss (but not goal) -> send location
            if battle:IsBossNotGoal(encounterName) then
                logger:info("Boss defeated: " .. encounterName)
                archipelago:SendLocationCheck(encounterName)
            end

            -- Special case: Paintress unlocks Maelle skills
            if encounterName == "L_Boss_Paintress_P1" then
                inventory:AddItem("Quest_MaellePainterSkillsUnlock", 1, 1)
                quests:SetObjectiveStatus("Main_ForcedCamps", "10_ForcedCamp_PostLumiereAttack", QUEST_STATUS.COMPLETED)
            end

            -- Handle character unlocks (if not shuffled)
            if archipelago.options.char_shuffle == 0 then
                local canUnlock, charName = battle:IsBattleCanUnlockCharacter(encounterName)
                if canUnlock and charName then
                    if not Contains(storage.characters, charName) then
                        logger:info("Unlocking character: " .. charName)
                        AddingCharacterFromArchipelago = true
                        characters:EnableCharacter(charName)
                        table.insert(storage.characters, charName)
                        storage:Update("BattleHooks:OnBattleEndVictory")
                    end
                end
            end
        end,
        "Battle - Victory Handler"
    )

    -- All heroes killed (death link)
    hookManager:Register(
        "/Game/jRPGTemplate/Blueprints/Components/AC_jRPG_BattleManager.AC_jRPG_BattleManager_C:OnAllHeroesKilled",
        function(self)
            if not archipelago.apSystem then return end
            if not storage.initialized_after_lumiere then return end

            local battleManager = self:get() ---@type UAC_jRPG_BattleManager_C

            -- Send death link if enabled and can't send reserve team
            if archipelago.death_link and not battleManager:CanSendReserveTeam() then
                archipelago:SendDeathLink("can't parry even a single attack")
            end
        end,
        "Battle - Death Link on Party Wipe"
    )

    -- Remove battle rewards
    hookManager:Register(
        "/Game/jRPGTemplate/Blueprints/Components/AC_jRPG_BattleManager.AC_jRPG_BattleManager_C:RollBattleRewards",
        function(self, rewards)
            if not archipelago.apSystem then return end
            if not storage.initialized_after_lumiere then return end

            local battleRewards = rewards:get() ---@type FS_BattleRewards
            local keepRewards = {} ---@type table<FS_RolledLootEntry>

            -- Keep only Foot and Merchant items
            battleRewards.RolledLootEntries_12_64C7AB394C92E36998E1CAB6944CA883:ForEach(function(_, entry)
                entry = entry:get() ---@cast entry FS_RolledLootEntry
                local itemName = entry.ItemID_2_FDDBE5744EC164155E4C959474052581:ToString()

                if string.find(itemName, "Foot") or string.find(itemName, "Merchant") then
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
        end,
        "Battle - Filter Rewards"
    )

    logger:info("Battle hooks registered")
end

return BattleHooks