---@class Quests_Constants
local QUESTS = {
    GOLDEN_PATH = {
        QUEST_NAME                    = "Main_GoldenPath",
        LUMIERE_BEGINNING             = "1_LumiereBeginning",
        SPRING_MEADOW                 = "2_SpringMeadow",
        GOBLU                         = "3_Goblu",
        ANCIENT_SANCTUARY             = "4_AncientSanctuary",
        GESTRAL_VILLAGE               = "5_GestralVillage",
        ESQUIE_NEST                   = "6_EsquieNest",
        SEA_CLIFF                     = "7_SeaCliff",
        FORGOTTEN_BATTLEFIELD         = "8_ForgottenBattlefield",
        MONOCO_STATION                = "9_MonocoStation",
        OLD_LUMIERE                   = "10_OldLumiere",
        AXON_1                        = "11_Axon1",
        AXON_2                        = "12_Axon2",
        ENTER_MONOLITH                = "13_EnterTheMonolith",
        DEFEAT_PAINTRESS              = "14_DefeatthePaintress",
        RETURN_LUMIERE_AFTER_MONOLITH = "15_ReturnToLumiereAfterMonolith",
        DEFEAT_RENOIR                 = "16_GoBackToLumiereAndDefeatRenoir",
        RENOIR_DEFEATED               = "17_RenoirDefeated"
    },
    FORCED_CAMPS = {
        QUEST_NAME           = "Main_ForcedCamps",
        POST_SPRING_MEADOWS  = "1_ForcedCamp_PostSpringMeadows",
        POST_GOBLU           = "2_ForcedCamp_PostGoblu",
        POST_GESTRAL_VILLAGE = "3_ForcedCamp_PostGestralVillage",
        POST_ESQUIE_NEST     = "4_ForcedCamp_PostEsquieNest",
        POST_SEA_CLIFF       = "5_ForcedCamp_PostSeaCliff",
        POST_BATTLEFIELD     = "6_ForcedCamp_PostBattlefield",
        POST_OLD_LUMIERE     = "7_ForcedCamp_PostOldLumiere",
        POST_AXON_1          = "8_ForcedCamp_Post1stAxon",
        POST_AXON_2          = "9_ForcedCamp_Post2ndAxon",
        POST_LUMIERE_ATTACK  = "10_ForcedCamp_PostLumiereAttack",
    },
    FESTIVAL = {
        QUEST_NAME         = "TheExpeditionFestival",
        MAELLE_DIALOG      = "1_MaelleDialog",
        APPRENTICES_DIALOG = "2_ApprenticesDialog",
        EMMA_DIALOG        = "3_EmmaDialog",
    },
    GESTRAL_TOURNAMENT = {
        QUEST_NAME = "TheGestralTournament",
        CHAMPION_1 = "DefeatGestralChampion_1",
        CHAMPION_2 = "DefeatGestralChampion_2",
        CHAMPION_3 = "DefeatGestralChampion_3",
        SCIEL      = "DefeatSciel",
    },
    LOST_GESTRAL = {
        QUEST_NAME = "Bonus_LostGestrals",
        GESTRAL_1  = "FindLostGestral_1",
        GESTRAL_2  = "FindLostGestral_2",
        GESTRAL_3  = "FindLostGestral_3",
        GESTRAL_4  = "FindLostGestral_4",
        GESTRAL_5  = "FindLostGestral_5",
        GESTRAL_6  = "FindLostGestral_6",
        GESTRAL_7  = "FindLostGestral_7",
        GESTRAL_8  = "FindLostGestral_8",
        GESTRAL_9  = "FindLostGestral_9",
    },
    FLYING_CASINO = {
        QUEST_NAME   = "Bonus_FlyingCasino",
        ENTER_CASINO = "EnterTheCasino",
        WIN_1        = "WinFrontlines_1",
        WIN_2        = "WinFrontlines_2",
        WIN_3        = "WinFrontlines_3",
        TALK_LOSER   = "TalkToLoser"
    },
    WARRIOR_FOREST = {
        QUEST_NAME        = "Bonus_WarriorForest",
        FIRST_ENCOUNTER   = "DefeatFirstEncounter",
        SECOND_ENCOUNTER  = "DefeatSecondEncounter",
        THIRD_ENCOUNTER   = "DefeatThirdEncounter",
        REPORT            = "ReportToGestralWarrior",
        EXPLORE_WORKSHOP  = "ExploreCleaWorkshop",
        DEFEND_WARRIOR    = "DefendGestralWarrior",
        DEFEAT_CHEVALIERE = "DefeatChevaliereAlpha"
    },
    GUSTAVE_INVENTION = {
        QUEST_NAME          = "Bonus_GustaveInvention",
        MUSHROOM            = "GiveMushroom",
        ULTIMATE_SAKAPATATE = "DefeatUltimateSakapatateUpgraded"
    },
    JOURNAL_COLLECTIR = {
        QUEST_NAME = "Bonus_JournalCollector",
        GIVE_1     = "GiveExpeditionJournals_1",
        GIVE_2     = "GiveExpeditionJournals_2",
        GIVE_3     = "GiveExpeditionJournals_3",
        GIVE_4     = "GiveExpeditionJournals_4",
        GIVE_5     = "GiveExpeditionJournals_5",
    },
    HUNTING_BOARD = {
        QUEST_NAME   = "Bonus_HuntingBoard",
        DEFEAT_ALPHA = "DefeatAlphaNevrons"
    },
    HIDDEN_GESTRAL_ARENA = {
        QUEST_NAME       = "Bonus_HiddenGestralArena",
        DEFEAT_GESTRAL_1 = "DefeatFighter_1",
        DEFEAT_GESTRAL_2 = "DefeatFighter_2",
        DEFEAT_GESTRAL_3 = "DefeatFighter_3",
        DEFEAT_GESTRAL_4 = "DefeatFighter_4",
    },
    ONE_PUNCH_MAN = {
        QUEST_NAME = "Bonus_StrongestPunch",
        DEAL_9999  = "Deal9999Dmg"
    },
    HANGING_GESTRAL = {
        QUEST_NAME = "Bonus_HangingGestral",
        HELP_KID = "HelpGestralKid",
    },
    GRANDIS_FASHION = {
        QUEST_NAME = "Bonus_GrandisFashion",
        MAELLE     = "EloquenceBattle_Maelle",
        LUNE       = "EloquenceBattle_Lune",
        SCIEL      = "EloquenceBattle_Sciel"
    },
    MONSTER_BASEMENT = {
        QUEST_NAME = "Bonus_MonsterInBasement",
        DEFEAT     = "DefeatMonsterInBasement"
    },
    MAN_BEFORE_FRACTURE = {
        QUEST_NAME = "Bonus_ManBeforeFracture",
        DEFEAT     = "DefeatOscarMask"
    },
    OLD_DOOR = {
        QUEST_NAME = "Bonus_OldDoor",
        OPEN_DOOR  = "OpenOldDoor",
        REWARD     = "GetReward"
    },
    CRUSHING_WALL = {
        QUEST_NAME     = "Bonus_CrushingWalls",
        DEFEAT_SAPLING = "DefeatGiantSapling"
    },
    GATES_OF_SKILLS = {
        QUEST_NAME = "Bonus_GatesOfSkill",
        MIGHT      = "OpenSkillDoor_Might",
        VITALITY   = "OpenSkillDoor_Vitality",
        DEFENSE    = "OpenSkillDoor_Defense",
        AGILITY    = "OpenSkillDoor_Agility",
        LUCK       = "OpenSkillDoor_Luck"
    },
    CLEA_TOWERS = {
        QUEST_NAME = "Bonus_CleaTowers",
        CLEAR_1    = "ClearCleaTower_1",
        CLEAR_2    = "ClearCleaTower_2",
        CLEAR_3    = "ClearCleaTower_3"
    },
    CARROUSEL = {
        QUEST_NAME  = "Bonus_Carrousel",
        DESTROY_ICE = "DestroyIceChunks"
    },
    CHOSEN_PATH = {
        QUEST_NAME = "Bonus_ChosenPath",
        VERSO      = "VersoChosen",
        MAELLE     = "MaelleChosen",
        LUNE       = "LuneChosen",
        SCIEL      = "ScielChosen",
        MONOCO     = "MonocoChosen",
    },
    KEY_OLD_LUMIERE = {
        QUEST_NAME = "Bonus_KeyOldLumiere",
        OPEN_DOOR = "OpenSewerDoor"
    },
    CHROMA_DOOR_MIME = {
        QUEST_NAME = "Bonus_ChromaDoorMime",
        VERSO      = "DefeatMime_Verso",
        MAELLE     = "DefeatMime_Maelle",
        LUNE       = "DefeatMime_Lune",
        SCIEL      = "DefeatMime_Sciel",
        MONOCO     = "DefeatMime_Monoco",
    },
    DARK_GESTRAL_ARENA = {
        QUEST_NAME         = "DarkGestralArena_Golgra",
        ROUND_1            = "DefeatRound1",
        ROUND_2            = "DefeatRound2",
        ROUND_3            = "DefeatRound3",
        GOLGRA_DEFEATED    = "GolgraDefeated",
        DEFEATED_BY_GOLGRA = "DefeatedByGolgra"
    },
    FACELESS_ORANGE_FOREST = {
        QUEST_NAME     = "FacelessBoy_OrangeForest",
        EXPLANATION    = "FindAnExplanation",
        KILL_SCAVENGER = "KillTheScavenger",
    },
    CLEA_WORKSHOP = {
        QUEST_NAME        = "CleaWorkshopQuest",
        FEED_PART_1       = "FeedPart1",
        FEED_PART_2       = "FeedPart2",
        FEED_PART_3       = "FeedPart3",
        FEED_PART_ALL     = "FeedAllParts",
        DEFEAT_LAMPMASTER = "DefeatLampmaster",
    },
    CLEA_FLYING_HOUSE = {
        QUEST_NAME         = "CleaFlyingHouse_4Statues",
        DEFEAT_EVEQUE      = "DefeateEveque",
        DEFEAT_DUALLISTE   = "DefeatDualliste",
        DEFEAT_LAMPMASTER  = "DefeatLampmaster",
        DEFEAT_GOBLU       = "DefeatGoblu",
        OPEN_DOOR          = "OpenTheDoor",
        DEFEAT_MIRROR_CLEA = "DefeatMirrorClea",
    },
    CLEA_DIALOGUE_TOWER = {
        QUEST_NAME      = "CleaTower_CleaDialogue",
        TALKED_CLEA     = "TalkedWithClea",
        FLOOR_11        = "CompletedFloor11",
        FLOOR_22        = "CompletedFloor22",
        FLOOR_32        = "CompletedFloor32",
        FLOOR_33        = "CompletedFloor33",
        TALKED_AFTER_33 = "TalkedWithCleaAfterFloor33",
    },
    RELATIONSHIP_MAELLE = {
        QUEST_NAME = "Relationship_Maelle",
        LEVEL_0    = "Relationship_Lvl0",
        LEVEL_1    = "Relationship_Lvl1",
        LEVEL_2    = "Relationship_Lvl2",
        LEVEL_3    = "Relationship_Lvl3",
        LEVEL_4    = "Relationship_Lvl4",
        LEVEL_5    = "Relationship_Lvl5",
        LEVEL_6    = "Relationship_Lvl6",
        LEVEL_7    = "Relationship_Lvl7"
    },
    RELATIONSHIP_LUNE = {
        QUEST_NAME = "Relationship_Lune",
        LEVEL_0    = "Relationship_Lvl0",
        LEVEL_1    = "Relationship_Lvl1",
        LEVEL_2    = "Relationship_Lvl2",
        LEVEL_3    = "Relationship_Lvl3",
        LEVEL_4    = "Relationship_Lvl4",
        LEVEL_5    = "Relationship_Lvl5",
        LEVEL_6    = "Relationship_Lvl6",
        LEVEL_7    = "Relationship_Lvl7"
    },
    RELATIONSHIP_SCIEL = {
        QUEST_NAME = "Relationship_Sciel",
        LEVEL_0    = "Relationship_Lvl0",
        LEVEL_1    = "Relationship_Lvl1",
        LEVEL_2    = "Relationship_Lvl2",
        LEVEL_3    = "Relationship_Lvl3",
        LEVEL_4    = "Relationship_Lvl4",
        LEVEL_5    = "Relationship_Lvl5",
        LEVEL_6    = "Relationship_Lvl6",
        LEVEL_7    = "Relationship_Lvl7"
    },
    RELATIONSHIP_MONOCO = {
        QUEST_NAME = "Relationship_Monoco",
        LEVEL_0    = "Relationship_Lvl0",
        LEVEL_1    = "Relationship_Lvl1",
        LEVEL_2    = "Relationship_Lvl2",
        LEVEL_3    = "Relationship_Lvl3",
        LEVEL_4    = "Relationship_Lvl4",
        LEVEL_5    = "Relationship_Lvl5",
        LEVEL_6    = "Relationship_Lvl6",
        LEVEL_7    = "Relationship_Lvl7"
    },
    RELATIONSHIP_ESQUIE = {
        QUEST_NAME = "Relationship_Esquie",
        LEVEL_0    = "Relationship_Lvl0",
        LEVEL_1    = "Relationship_Lvl1",
        LEVEL_2    = "Relationship_Lvl2",
        LEVEL_3    = "Relationship_Lvl3",
        LEVEL_4    = "Relationship_Lvl4",
        LEVEL_5    = "Relationship_Lvl5",
        LEVEL_6    = "Relationship_Lvl6",
        LEVEL_7    = "Relationship_Lvl7"
    },
    RELATIONSHIP_NOCO = {
        QUEST_NAME = "Relationship_Noco",
        LEVEL_0    = "Relationship_Lvl0",
        LEVEL_1    = "Relationship_Lvl1",
    },
    RELATIONSHIP_CONDITION = {
        QUEST_NAME               = "Relationship_Noco",
        ESQUIE_LVL5_AFTER_AXON_2 = "RdEsquie_Lvl5_ExitCampAfterSecondAxon",
    },
    NEVRON_JAR = {
        QUEST_NAME = "Nevron_JarNeedLight",
        GIVE_RESIN = "GiveResin",
        LIGHT_JAR_ = "LightJarLamp",
        KILL_IT    = "KilledJar"
    },
    NEVRON_DEMINEUR = {
        QUEST_NAME = "Nevron_DemineurMissingMine",
        GIVE_MINE  = "GiveMine",
        KILL_IT    = "KillDemineur"
    },
    NEVRON_BOURGEON = {
        QUEST_NAME   = "Nevron_SmallBourgeon",
        ACQUIRE_SKIN = "AcquireBourgeonSkin",
        GIVE_SKIN    = "GiveBourgeonSkin",
        RETURN_AFTER = "ReturnAfterSomeTime",
        KILL_IT      = "KillDemiKillCompletedBourgeonneur"
    },
    NEVRON_DANSEUSE = {
        QUEST_NAME = "Nevron_DanseuseDanceClass",
        PARRYING   = "DefeatDanseuseDanceTeacher",
        KILL_IT    = "KillDanseuseDanceTeacher"
    },
    NEVRON_PORTIER = {
        QUEST_NAME     = "Nevron_PortierDoorMaze",
        SPARE_SPIRIT   = "SparePortierSpirit",
        REACH_PUZZLE   = "ReachPuzzle",
        SUCCEED_PUZZLE = "SucceedPuzzle",
        GIVE_WOOD      = "GiveWoodBoards",
        KILL_IT        = "KillCompletedPortier"
    },
    NEVRON_CHALIER = {
        QUEST_NAME                = "Nevron_WeaponlessChalier",
        DEFEAT_CHALIER            = "DefeatChalier",
        GIVE_WOOD                 = "GiveWoodenStick",
        FORGE_WEAPON              = "ForgeGiantBrulerWeapon",
        DEFEAT_WEAPONLESS_CHALIER = "DefeatWeaponlessChalier",
        SPARE_IT                  = "SpareChalier",
        KILL_IT                   = "KillChalier",
    },
    NEVRON_BENISSEUR = {
        QUEST_NAME     = "Nevron_Benisseur",
        SPEND_CHROMA_1 = "SpendChroma_1",
        SPEND_CHROMA_2 = "SpendChroma_2",
        SPEND_CHROMA_3 = "SpendChroma_3",
        SPEND_CHROMA_4 = "SpendChroma_4",
        KILL_IT        = "KillCompletedBenisseur",
    },
    NEVRON_HEXGA = {
        QUEST_NAME   = "Nevron_Hexga",
        GIVE_CRYSTAL = "GiveHexgaCrystal",
        KILL_IT      = "KillCompletedHexga"
    },
    NEVRON_JUDGE = {
        QUEST_NAME = "Nevron_JudgeOfMercy",
        KILL_IT    = "KillJudgeOfMercy"
    },
    NEVRON_TROUBADOUR = {
        QUEST_NAME = "Nevron_Troubadour",
        DEFEAT     = "DefeatTroubadour",
        KILL_IT    = "KillCompletedTroubadour",
    },
    FESTIVAL_MAELLE = {
        QUEST_NAME = "Festival_MaelleBattle",
        WON        = "3_MaelleBattleWon",
    },
    SECONDARY_MAINPATH = {
        QUEST_NAME       = "SecondaryObjectives_MainPath",
        CURATOR_TRAINING = "CuratorTraining"
    },
    LUMIERE_ACT3_TELEPORTER = {
        QUEST_NAME          = "LumiereAct3_Teleporter",
        ACTIVATE_TELEPORTER = "ActivateGardenTeleporter",
    },
    GESTRAL_BEACH_WIPEOUT = {
        QUEST_NAME = "Gestralbeach_Wipeout",
        FINISH     = "ReachTheFinalGestral",
    },
    GESTRAL_BEACH_CLIMBWALL = {
        QUEST_NAME = "Gestralbeach_ClimbWall",
        FINISH     = "ReachTheTop",
    },
    GESTRAL_BEACH_ONLYUP = {
        QUEST_NAME = "Gestralbeach_OnlyUp",
        FINISH     = "ReachTheTop",
    },
    GESTRAL_BEACH_RACE = {
        QUEST_NAME = "Gestralbeach_GestralRace",
        BRONZE     = "BronzeMedal",
        SILVER     = "SilverMedal",
        GOLD       = "GoldMedal",
    },
    GESTRAL_BEACH_VOLLEY = {
        QUEST_NAME = "Gestralbeach_BeachVolley",
        EASY       = "BeatEasyMode",
        MEDIUM     = "BeatMediumMode",
        HARD       = "BeatHardMode",
},
    AXONS_HEART = {
        QUEST_NAME = "AxonsHearts",
        SIRENE     = "SireneHeart",
        VISAGES    = "VisagesHeart",
    },
    CLEA_ATELIER = {
        QUEST_NAME = "CleasWorkshop_Deadzones",
        PATH_1     = "Path01",
        PATH_2     = "Path02",
        PATH_3     = "Path03",
        LAMPMASTER = "BrokenLampmaster"
    },
    RED_FOREST_STATES = {
        QUEST_NAME = "RedForestStates",
        STATE_0    = "State00",
        STATE_1    = "State01",
        STATE_2    = "State02",
        STATE_3    = "State03",
        STATE_4    = "State04",
    },
    EPILOGUE = {
        QUEST_NAME         = "MainPath_Epîlogue",
        MAELLE             = "EpilogueMaelle",
        VERSO              = "EpilogueVerso",
        RENOIR_IN_PROGRESS = "RenoirFightInProgress",
    },
    DEFEAT_GOLGRA_MONOCO = {
        QUEST_NAME = "GV_DefeatGolgraWithMonoco",
        DEFEAT     = "DefeatGolgraWithMonoco",
    },
    STONE_TO_ESQUIE = {
        QUEST_NAME = "Main_EsquieNestBringStone",
        BRING_ROCK = "BringBackRock",
    },
    LUMIERE_ACT1 = {
        QUEST_NAME           = "Quests_LumiereAct1",
        FLOWER               = "PickUpFlower",
        DUEL_MAELLE          = "FinishDuelWithMaelle",
        SOPHIE               = "FoundSophie",
        MIME                 = "DefeatMime",
        FIND_TRASHMAN        = "FindTrashcanMan",
        PAINTER              = "InspiredPainter",
        NEWSPAPER_EXPEDITION = "Newspaper_Expedition",
        NEWSPAPER_PETALS     = "Newspaper_Petals",
        SCULPTURE_COLOR      = "Sculpture_Color",
        SCULPTURE_NEVRON     = "Sculpture_Nevron",
        RUN_MAELLE_1         = "RunWithMaellePart1",
        RUN_MAELLE_2         = "RunWithMaellePart2",
    },
    WRITE_IN_JOURNAL = {
        QUEST_NAME = "Camp_WriteInGustaveJournal",
        IS_WRITING = "IsWritingInJournal"
    },
    MANOR_INTERLUDE = {
        QUEST_NAME    = "Main_ManorInterlude",
        INTERLUDE     = "ManorInterlude",
        REACH_ATELIER = "ReachTheAtelier",
        ENTER_CANVAS  = "EnterTheCanvas",
    },
    BEATING_MIRROR_RENOIR_OLD_LUMIERE = {
        QUEST_NAME  = "Main_BeatingMirrorRenoirOldLumiere",
        BEATING_HIM = "BeatingMirrorRenoir"
    },
    MONOCO_STALACT = {
        QUEST_NAME = "MM_StalactStuck",
        FIRE_KEY   = "GetFireKey",
        FINISHED   = "StalactFinished",
    },
    ALPHA_EATER = {
        QUEST_NAME          = "Bonus_AlphaEater",
        GATHER_BEAST        = "GatherAlphaChroma_Beast",
        GATHER_CLEA         = "GatherAlphaChroma_Clea",
        GATHER_ENOUGH_BEAST = "GatheredEnoughAlphaChroma_Clea",
        GATHER_ENOUGH_CLEA  = "GatheredEnoughAlphaChroma_Beast",
        FINISHED            = "Finished",
    },
    COSTAL_CAVE = {
        QUEST_NAME    = "Bonus_CoastalCave",
        DEFEAT_CRULER = "DefeatCruler"
    },
    GUSTAVE_HOMMAGE = {
        QUEST_NAME     = "Bonus_GustaveHomageEarlyUnlock",
        BATTLEFIELD    = "ReadApprenticesJournal_ForgottenBattlefield",
        MONOCO_STATION = "ReadApprenticesJournal_MonocoStation",
        OLD_LUMIERE    = "ReadApprenticesJournal_OldLumiere",
        AXON_1         = "ReadApprenticesJournal_Axon1",
        AXON_2         = "ReadApprenticesJournal_Axon2",
        MONOLITH       = "ReadApprenticesJournal_EnterTheMonolith",
    },
    GPE_LUMIERE_ACT3 = {
        QUEST_NAME = "GPE_ExplosionsLumiereAct3",
        STATUS     = "ExplosionsStatus"
    }
}

return QUESTS