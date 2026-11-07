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

            if objectiveName == CONSTANTS.QUEST.GOLDEN_PATH.ENTER_MONOLITH then
                if statusValue == QUEST_STATUS.COMPLETED
                    and not Storage:Get("monolith_interior_portal_unlocked") then
                    Storage:Set("monolith_interior_portal_unlocked", true)
                    Storage:Update("QuestHooks:Monolith portal unlocked")
                elseif statusValue == QUEST_STATUS.STARTED
                    and Storage:Get("monolith_interior_portal_unlocked") then
                    Quests:SetObjectiveStatus(
                        CONSTANTS.QUEST.GOLDEN_PATH.QUEST_NAME,
                        CONSTANTS.QUEST.GOLDEN_PATH.ENTER_MONOLITH,
                        QUEST_STATUS.COMPLETED
                    )
                end
            end

            if objectiveName == CONSTANTS.QUEST.GOLDEN_PATH.SEA_CLIFF
                and statusValue == QUEST_STATUS.STARTED
                and Storage:Get("sea_cliff_back_exit_open") then
                Quests:SetObjectiveStatus(
                    CONSTANTS.QUEST.GOLDEN_PATH.QUEST_NAME,
                    CONSTANTS.QUEST.GOLDEN_PATH.SEA_CLIFF,
                    QUEST_STATUS.COMPLETED
                )
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

return QuestHooks