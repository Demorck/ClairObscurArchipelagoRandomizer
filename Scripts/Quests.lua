---@class Quests
local Quests = {}

local BluePrintName = "BP_QuestSystem_C"

---@enum
QUEST_STATUS = {
    NOT_STARTED = 0,
    STARTED     = 1,
    COMPLETED   = 2,
    CANCELED    = 3,
    FAILED      = 4
}

local QUESTS_NAME = {
    GESTRALS = {
        Name = "Bonus_LostGestrals",
        Objectives= {
            "FindLostGestral_1",
            "FindLostGestral_2",
            "FindLostGestral_3",
            "FindLostGestral_4",
            "FindLostGestral_5",
            "FindLostGestral_6",
            "FindLostGestral_7",
            "FindLostGestral_8",
            "FindLostGestral_9",
        }
    }
}

function Quests:UnlockNextGestral()
    Logger:info("Unlocking next gestral...")
    local quest_system = FindFirstOf(BluePrintName) ---@cast quest_system UBP_QuestSystem_C

    local fname = FName(QUESTS_NAME.GESTRALS.Name)
    local objectives = quest_system.QuestStatuses:Find(fname):get() ---@type FS_QuestStatusData
    for _, gestral_name in ipairs(QUESTS_NAME.GESTRALS.Objectives) do
        local gestral_fname = FName(gestral_name)
        local status = objectives.ObjectivesStatus_8_EA1232C14DA1F6DDA84EBA9185000F56:Find(gestral_fname):get() ---@type E_QuestStatus
        if status ~= QUEST_STATUS.STARTED and status ~= QUEST_STATUS.COMPLETED then
            Logger:info("Unlocking gestral: " .. gestral_name)
            local key = FName(gestral_name)
            objectives.ObjectivesStatus_8_EA1232C14DA1F6DDA84EBA9185000F56:Add(key, QUEST_STATUS.STARTED)
        end
    end

    Save:SaveGame()
end

function Quests:SetObjectiveStatus(quest_name, objective_name, status)
    Logger:info("Setting objective status: " .. objective_name .. "(" .. quest_name .. ") to " .. status)
    local quest_system = FindFirstOf(BluePrintName) ---@cast quest_system UBP_QuestSystem_C

    local fname = FName(quest_name)
    local quest_data = quest_system.QuestStatuses:Find(fname):get() ---@type FS_QuestStatusData
    quest_data.ObjectivesStatus_8_EA1232C14DA1F6DDA84EBA9185000F56:ForEach(function (key, value)
        local name = key:get():ToString()
        if name == objective_name then
            Logger:info("Checking objective: " .. name)
            value:set(status)
        end
    end)

    Save:SaveGame()
end

function Quests:GetObjectiveStatus(quest_name, objective_name)
    Logger:info("Getting objective status: " .. objective_name .. "(" .. quest_name .. ")")
    local quest_system = FindFirstOf(BluePrintName) ---@cast quest_system UBP_QuestSystem_C

    local fname = FName(quest_name)
    local quest_data = quest_system.QuestStatuses:Find(fname):get() ---@type FS_QuestStatusData
    local status = nil
    status = quest_data.ObjectivesStatus_8_EA1232C14DA1F6DDA84EBA9185000F56:Find(FName(objective_name)):get()

    if status then
        return QUEST_STATUS[status]
    end

    return nil
end

return Quests