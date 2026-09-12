---Quest-related hooks
---@class QuestHooks
local QuestHooks = {}

---Register all quest hooks
---@param hookManager HookManager
function QuestHooks:Register(hookManager)

    hookManager:Register(
        "/Game/Gameplay/Quests/System/BP_QuestSystem.BP_QuestSystem_C:UpdateActivitySubTaskStatus",
        function(self, objective_name, status)
            if not Archipelago.apSystem then return end

            local objectiveName = objective_name:get():ToString()
            local statusValue = status:get()

            Logger:info("Game change subquest: " .. objectiveName .. " to " .. statusValue)

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