---@class Quests
local Quests = {}

local BluePrintName = "BP_QuestSystem_C"

---@enum
local STATUS = {
    NOT_STARTED = 1,
    STARTED     = 2,
    COMPLETED   = 3,
    CANCELED    = 4,
    FAILED      = 5
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
    local quest_system = FindFirstOf(BluePrintName) ---@cast quest_system UBP_QuestSystem_C

    local fname = FName(QUESTS_NAME.GESTRALS.Name)
    local objectives = quest_system.QuestStatuses:Find(fname):get() ---@type FS_QuestStatusData
    for _, gestral_name in ipairs(QUESTS_NAME.GESTRALS.Objectives) do
        local gestral_fname = FName(gestral_name)
        local status = objectives.ObjectivesStatus_8_EA1232C14DA1F6DDA84EBA9185000F56:Find(gestral_fname):get() ---@type E_QuestStatus
        if status ~= STATUS.STARTED and status ~= STATUS.COMPLETED then
            local key = FName(gestral_name)
            objectives.ObjectivesStatus_8_EA1232C14DA1F6DDA84EBA9185000F56:Add(key, STATUS.STARTED)
        end
    end

    Save:SaveGame()
end

return Quests