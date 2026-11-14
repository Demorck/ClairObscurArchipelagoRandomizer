---Quest-related hooks
---@class QuestHooks
local QuestHooks = {}

---Register all quest hooks
---@param hookManager HookManager
function QuestHooks:Register(hookManager)

    hookManager:Register(
        "/Game/Gameplay/Quests/System/BP_QuestSystem.BP_QuestSystem_C:UpdateActivitySubTaskStatus",
        function(self, objective_name, status)
            if not Archipelago:IsConnected() then return end

            local objectiveName = objective_name:get():ToString()
            local statusValue = status:get()

            Logger:info("Game change subquest: " .. objectiveName .. " to " .. statusValue)

            -- Vanilla quest hooks can update multiple quests
            -- Finishing Esquie's Nest sets Esquie's Nest to Completed and Sea Cliff to Started
            -- If Sea Cliff is completed before Esquie's Nest there is regression
            if objectiveName == CONSTANTS.QUEST.GOLDEN_PATH.SEA_CLIFF then
                if statusValue == QUEST_STATUS.COMPLETED then
                    Storage:Set("sea_cliff_back_exit_open", true)
                    Storage:Update("QuestHooks: Sea Cliff complete")
                end
                
                if statusValue ~= QUEST_STATUS.COMPLETED and
                Storage:Get("sea_cliff_back_exit_open") then
                    Logger:info("Quest persistence: SEA_CLIFF is already completed")
                    Quests:SetObjectiveStatus(CONSTANTS.QUEST.GOLDEN_PATH.QUEST_NAME, CONSTANTS.QUEST.GOLDEN_PATH.SEA_CLIFF, QUEST_STATUS.COMPLETED)
                end
            end

            -- Defeating an axon sets Axon Defeated quest to completed and Enter the Monolith to Started
            -- If an axon is defeated after entering the monolith there is regression
            if objectiveName == CONSTANTS.QUEST.GOLDEN_PATH.ENTER_MONOLITH then
                if statusValue == QUEST_STATUS.COMPLETED then
                    Storage:Set("monolith_interior_portal_unlocked", true)
                    Storage:Update("QuestHooks: Enter the Monolith completed")
                end

                if statusValue ~= QUEST_STATUS.COMPLETED and
                Storage:Get("monolith_interior_portal_unlocked") then
                    QuestHooks:RequestMonolithRestore()
                end
            end

            -- Auto-complete forced camps
            --TODO: Seems to not work for Post SM
            if objectiveName == CONSTANTS.QUEST.FORCED_CAMPS.POST_SPRING_MEADOWS and statusValue == QUEST_STATUS.STARTED then
                Quests:SetObjectiveStatus(CONSTANTS.QUEST.FORCED_CAMPS.QUEST_NAME,
                                          CONSTANTS.QUEST.FORCED_CAMPS.POST_SPRING_MEADOWS,
                                          QUEST_STATUS.COMPLETED)
            elseif objectiveName == CONSTANTS.QUEST.FORCED_CAMPS.POST_LUMIERE_ATTACK and statusValue == QUEST_STATUS.STARTED then
                Quests:SetObjectiveStatus(CONSTANTS.QUEST.FORCED_CAMPS.QUEST_NAME,
                                          CONSTANTS.QUEST.FORCED_CAMPS.POST_LUMIERE_ATTACK,
                                          QUEST_STATUS.COMPLETED)
            elseif objectiveName == CONSTANTS.QUEST.FORCED_CAMPS.POST_AXON_2 and statusValue == QUEST_STATUS.STARTED then
                Quests:SetObjectiveStatus(CONSTANTS.QUEST.FORCED_CAMPS.QUEST_NAME,
                                          CONSTANTS.QUEST.FORCED_CAMPS.POST_SPRING_MEADOWS,
                                          QUEST_STATUS.COMPLETED)
                Quests:SetObjectiveStatus(CONSTANTS.QUEST.FORCED_CAMPS.QUEST_NAME,
                                          CONSTANTS.QUEST.FORCED_CAMPS.POST_LUMIERE_ATTACK,
                                          QUEST_STATUS.COMPLETED)
            end

            -- Gestral rewards
            if string.find(objectiveName, "FindLostGestral") and
               statusValue == QUEST_STATUS.COMPLETED then
                if Options:IsEnabled("gestral_shuffle") then
                    Archipelago:SendLocationCheck(objectiveName)
                end
            end
        end,
        "Quest - Objective Update"
    )

    Logger:info("Quest hooks registered")
end

function QuestHooks:RequestMonolithRestore()

    -- Not necessary unless the player uses the debug command.
    -- We can remove if we want to allow restoring the monolith regardless of its previous state.
    if not Storage:Get("monolith_interior_portal_unlocked") then
        Logger:warn("Quest persistence: Monolith restore ignored because it has not been unlocked before")
        return
    end

    -- Prevents extra polling
    if Quests:GetObjectiveStatus(CONSTANTS.QUEST.GOLDEN_PATH.QUEST_NAME, CONSTANTS.QUEST.GOLDEN_PATH.ENTER_MONOLITH) == QUEST_STATUS.COMPLETED then
        Logger:info("Quest persistence: ENTER_MONOLITH is already completed")
        return
    end

    -- Needs a delay so it doesn't try to fire at the same time as teleporting to camp. Otherwise the player will fall through the floor
    -- Added a debug command in case this doesn't fire properly
    Logger:info("Quest persistence: ENTER_MONOLITH restore scheduled in 10 seconds")
    ExecuteWithDelay(10000, function()
        if Quests:GetObjectiveStatus(CONSTANTS.QUEST.GOLDEN_PATH.QUEST_NAME, CONSTANTS.QUEST.GOLDEN_PATH.ENTER_MONOLITH) ~= QUEST_STATUS.COMPLETED then
            Logger:info("Quest persistence: restoring ENTER_MONOLITH")
            Quests:SetObjectiveStatus(CONSTANTS.QUEST.GOLDEN_PATH.QUEST_NAME, CONSTANTS.QUEST.GOLDEN_PATH.ENTER_MONOLITH, QUEST_STATUS.COMPLETED)
        end
    end)
end

return QuestHooks