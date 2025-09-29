---@class Quests
local Quests = {}

local BluePrintName = "BP_QuestSystem_C"

---@enum
QUEST_STATUS = {
    INVALID     = 0,
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

function Quests:GetManager()
    local quest_system = FindFirstOf(BluePrintName) ---@cast quest_system UBP_QuestSystem_C
    if quest_system ~= nil and quest_system:IsValid() then
        Logger:info("Retrieving Quest manager succeeds")
        return quest_system
    else
        Logger:error("Retrieving Quest manager fails")
        return nil
    end
end

function Quests:UnlockNextGestral()
    Logger:info("Unlocking next gestral...")
    local quest_system = self:GetManager() ---@cast quest_system UBP_QuestSystem_C | nil
    if quest_system == nil then return end

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

function Quests:SendNextGestralReward(objective_name)
    if Archipelago.options.gestral_shuffle == 0 then return end

    Logger:info("Sending reward for gestral: " .. objective_name)
    local quest_system = self:GetManager() ---@cast quest_system UBP_QuestSystem_C | nil
    if quest_system == nil then return end

    if objective_name == "FindLostGestral_1" then
        Archipelago:SendLocationCheck("Lost Gestral reward 1")
    elseif objective_name == "FindLostGestral_2" then
        Archipelago:SendLocationCheck("Lost Gestral reward 2")
    elseif objective_name == "FindLostGestral_3" then
        Archipelago:SendLocationCheck("Lost Gestral reward 3")
    elseif objective_name == "FindLostGestral_4" then
        Archipelago:SendLocationCheck("Lost Gestral reward 4")
    elseif objective_name == "FindLostGestral_5" then
        Archipelago:SendLocationCheck("Lost Gestral reward 5")
    elseif objective_name == "FindLostGestral_6" then
        Archipelago:SendLocationCheck("Lost Gestral reward 6")
    elseif objective_name == "FindLostGestral_7" then
        Archipelago:SendLocationCheck("Lost Gestral reward 7")
    elseif objective_name == "FindLostGestral_8" then
        Archipelago:SendLocationCheck("Lost Gestral reward 8")
    elseif objective_name == "FindLostGestral_9" then
        Archipelago:SendLocationCheck("Lost Gestral reward 9")
    end
end

function Quests:SetObjectiveStatus(quest_name, objective_name, status)
    Logger:info("Setting objective status: " .. objective_name .. "(" .. quest_name .. ") to " .. status)
    local quest_system = self:GetManager() ---@cast quest_system UBP_QuestSystem_C
    if quest_system == nil then return end

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
    local quest_system = self:GetManager() ---@cast quest_system UBP_QuestSystem_C
    if quest_system == nil then return end

    local fname = FName(quest_name)
    local quest_data = quest_system.QuestStatuses:Find(fname):get() ---@type FS_QuestStatusData
    local status = nil
    if quest_data == nil then
        Logger:error("Quest not found: " .. quest_name)
        return nil
    end

    status = quest_data.ObjectivesStatus_8_EA1232C14DA1F6DDA84EBA9185000F56:Find(FName(objective_name)):get()

    if status then
        return QUEST_STATUS[status]
    end

    return nil
end

return Quests