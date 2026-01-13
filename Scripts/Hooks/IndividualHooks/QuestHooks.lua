---Quest-related hooks
---@class QuestHooks
local QuestHooks = {}

---Register all quest hooks
---@param hookManager HookManager
---@param dependencies table
function QuestHooks:Register(hookManager, dependencies)
    local archipelago = dependencies.archipelago
    local storage = dependencies.storage ---@type Storage
    local logger = dependencies.logger
    local quests = dependencies.quests

    hookManager:Register(
        "/Game/Gameplay/Quests/System/BP_QuestSystem.BP_QuestSystem_C:UpdateActivitySubTaskStatus",
        function(self, objective_name, status)
            if not archipelago.apSystem then return end

            local objectiveName = objective_name:get():ToString()
            local statusValue = status:get()

            logger:info("Game change subquest: " .. objectiveName .. " to " .. statusValue)

            -- Initialize after Lumiere
            if not storage:Get("initialized_after_lumiere") and
               objectiveName == "2_SpringMeadow" and
               statusValue == QUEST_STATUS.STARTED then
                InitSaveAfterLumiere()
                return
            end

            -- Reset on Lumiere beginning
            if objectiveName == "1_LumiereBeginning" and statusValue ~= QUEST_STATUS.COMPLETED then
                storage:Set("initialized_after_lumiere", false)
                storage:Update("QuestHooks:UpdateActivitySubTaskStatus")
                return
            end

            -- Auto-complete forced camps
            --TODO: Seems to not work for Post SM
            if objectiveName == CONSTANTS.QUEST.FORCED_CAMPS.POST_SPRING_MEADOWS and statusValue == QUEST_STATUS.STARTED then
                quests:SetObjectiveStatus(CONSTANTS.QUEST.FORCED_CAMPS.QUEST_NAME,
                                          CONSTANTS.QUEST.FORCED_CAMPS.POST_SPRING_MEADOWS,
                                          QUEST_STATUS.COMPLETED)
            elseif objectiveName == CONSTANTS.QUEST.FORCED_CAMPS.POST_LUMIERE_ATTACK and statusValue == QUEST_STATUS.STARTED then
                quests:SetObjectiveStatus(CONSTANTS.QUEST.FORCED_CAMPS.QUEST_NAME,
                                          CONSTANTS.QUEST.FORCED_CAMPS.POST_LUMIERE_ATTACK,
                                          QUEST_STATUS.COMPLETED)
            elseif objectiveName == CONSTANTS.QUEST.FORCED_CAMPS.POST_AXON_2 and statusValue == QUEST_STATUS.STARTED then
                quests:SetObjectiveStatus(CONSTANTS.QUEST.FORCED_CAMPS.QUEST_NAME,
                                          CONSTANTS.QUEST.FORCED_CAMPS.POST_SPRING_MEADOWS,
                                          QUEST_STATUS.COMPLETED)
                quests:SetObjectiveStatus(CONSTANTS.QUEST.FORCED_CAMPS.QUEST_NAME,
                                          CONSTANTS.QUEST.FORCED_CAMPS.POST_LUMIERE_ATTACK,
                                          QUEST_STATUS.COMPLETED)
            end

            -- Gestral rewards
            if string.find(objectiveName, "FindLostGestral") and
               statusValue == QUEST_STATUS.COMPLETED then
                if archipelago.options.gestral_shuffle == 1 then
                    archipelago:SendLocationCheck(objectiveName)
                end
            end
        end,
        "Quest - Objective Update"
    )

    logger:info("Quest hooks registered")
end

return QuestHooks