local CONSTANTS = require("Constants.index")

local FLAGS_TO_SET = {
    CONSTANTS.NID.FB_GRADIENT_TUTORIAL,
    CONSTANTS.NID.FW_JUMP_TUTORIAL,
    CONSTANTS.NID.REACHER_LVL6_MAELLE,
    CONSTANTS.NID.RELATION_LVL6_LUNE,
    CONSTANTS.NID.RELATION_LVL6_MONOCO,
}

local OBJECTIVES_TO_COMPLETE = {
    [CONSTANTS.QUEST.GOLDEN_PATH.QUEST_NAME] = {
        CONSTANTS.QUEST.GOLDEN_PATH.LUMIERE_BEGINNING,
    },

    [CONSTANTS.QUEST.LUMIERE_ACT1.QUEST_NAME] = {
        CONSTANTS.QUEST.LUMIERE_ACT1.DUEL_MAELLE,
        CONSTANTS.QUEST.LUMIERE_ACT1.FLOWER,
        CONSTANTS.QUEST.LUMIERE_ACT1.MIME,
        CONSTANTS.QUEST.LUMIERE_ACT1.FIND_TRASHMAN,
        CONSTANTS.QUEST.LUMIERE_ACT1.NEWSPAPER_PETALS,
        CONSTANTS.QUEST.LUMIERE_ACT1.PAINTER,
        CONSTANTS.QUEST.LUMIERE_ACT1.RUN_MAELLE_1,
        CONSTANTS.QUEST.LUMIERE_ACT1.RUN_MAELLE_2,
        CONSTANTS.QUEST.LUMIERE_ACT1.SCULPTURE_NEVRON,
        CONSTANTS.QUEST.LUMIERE_ACT1.SOPHIE,
    },
}

---@class NewGameSetup
local NewGameSetup = {}

function NewGameSetup:Run()
    Logger:info("Initialized after Lumière")

    Characters:AddEveryone()
    Characters:HealEveryone()

    if not Options:IsEnabled("char_shuffle") then
        Storage:UnlockCharacter("Frey")
    end

    Archipelago:Sync()

    Characters:EnableCharactersInPartyOnlyUnlocked()
    Inventory:Adding999Recoat()
    Capacities:UnlockAllExplorationCapacities()

    for _, flag in ipairs(FLAGS_TO_SET) do
        Save:WriteFlagByName(flag, true)
    end

    for quest_name, objectives in pairs(OBJECTIVES_TO_COMPLETE) do
        for _, objective in ipairs(objectives) do
            Quests:SetObjectiveStatus(quest_name, objective, QUEST_STATUS.COMPLETED)
        end
    end

    Archipelago:ScoutMerchants()
end

return NewGameSetup