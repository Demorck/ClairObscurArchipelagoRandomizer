local CONST = {
    MAX_LEVEL_GEAR = 33,
    NUMBER_OF_PICTOS = 190,
    NUMBER_OF_WEAPONS = 100,
    OPTIONS = {
        GEAR_SCALING = {
            SPHERE_PLACEMENT = 0,
            ORDER_RECEIVED   = 1,
            BALANCED_RANDOM  = 2,
            FULL_RANDOM      = 3
        }
    },
    NID = {
        DIVE_GUID = { -- NID_EsquieUnderwaterUnlocked
            A = 0xffffffffc6049eb0,
            B = 0x4851b254,
            C = 0xffffffffe484769a,
            D = 0xffffffffb9f84714,
        },
        FB_GRADIENT_TUTORIAL = { -- NID_ForgottenBattlefield_GradientCounterTutorial
            A = 0x30e2946e,
            B = 0x432cb0e8,
            C = 0x363ed298,
            D = 0x11577e30,
        },
        FW_JUMP_TUTORIAL = { -- NID_Goblu_JumpTutorial
            A = 0xffffffff8e3263a7,
            B = 0x493bf6fd,
            C = 0xfffffffff260549a,
            D = 0xfffffffff74ea0db,
        },
        REACHER_LVL6_MAELLE = {  -- NID_MaelleRelationshipLvl6_Quest
            A = 0xffffffffe3367623,
            B = 0x40bcb33c,
            C = 0x788d9cb7,
            D = 0xffffffffffe1b656
        },
        RELATION_LVL6_LUNE = { -- NID_LuneRelationshipLvl6_Quest
            A = 0x2a55f5a4,
            B = 0x4ef0b15c,
            C = 0x7b4d53b6,
            D = 0xfffffffff3e5cc39
        },
        RELATION_LVL6_MONOCO = { -- NID_Monoco_RelationshipLvl6_Quest
            A = 0xffffffffa73a9b68,
            B = 0x4aceacd1,
            C = 0x721bcb90,
            D = 0x1f428538
        }
    },
    QUESTS = {
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
}

return CONST


  -- [17:15:30.1134016] [Lua] NID_GommageCineSeen
  -- [17:15:30.1136885] [Lua] 2dc8b1d6-44563a7b-ffffffffce3474b2-ffffffffe791d807
  -- [17:15:30.1138468] [Lua] NID_CharacterOverviewTutorial
  -- [17:15:30.1141059] [Lua] 21ca87f4-4e358a24-ffffffffddeaba84-ffffffff881a95db
  -- [17:15:30.1142354] [Lua] NID_PictosTutorial
  -- [17:15:30.1143596] [Lua] ffffffff8d843b41-4bd492a5-72e60b91-9ead34e
  -- [17:15:30.1145374] [Lua] NID_FirstLancelierBeaten
  -- [17:15:30.1148174] [Lua] 6e8d109-4c064007-ffffffffa98fa190-ffffffffe7eacfee
  -- [17:15:30.1150160] [Lua] NID_LuneUnlock1
  -- [17:15:30.1151539] [Lua] 606d3e62-4bc427ff-ffffffff9bffad97-284286a0
  -- [17:15:30.1153735] [Lua] NID_LuminaTutorial
  -- [17:15:30.1155183] [Lua] fffffffff87b8c10-46c612a9-ffffffffb90e29a9-500396dd
  -- [17:15:30.1157300] [Lua] NID_EntryWorldMap
  -- [17:15:30.1159344] [Lua] 430e49b6-4dee3a1b-7c2d329b-17f480fb
  -- [17:15:30.1160844] [Lua] NID_MaelleUnlock1
  -- [17:15:30.1162823] [Lua] 73067fa-4fa91572-2f2932a5-1b1fb722
  -- [17:15:30.1164025] [Lua] NID_MaelleUnlock
  -- [17:15:30.1166134] [Lua] 3a601f56-44a2228f-ffffffffd7d77594-ffffffffe7374a08
  -- [17:15:30.1167474] [Lua] NID_Goblu_JumpTutorial
  -- [17:15:30.1168681] [Lua] ffffffff8e3263a7-493bf6fd-fffffffff260549a-fffffffff74ea0db
  -- [17:15:30.1170873] [Lua] NID_MaelleUnlock1
  -- [17:15:30.1172820] [Lua] ffffffffefdc9a38-4f931063-3386c793-3f81a2e2
  -- [17:15:30.1174140] [Lua] NID_CuratorTutorial
  -- [17:15:30.1176512] [Lua] 7d5f9151-4a9038ed-37ecd191-ffffffffbc5cceb1
  -- [17:15:30.1178119] [Lua] NID_CuratorExpeditionTutorial1
  -- [17:15:30.1180692] [Lua] fffffffff9ef27d7-4862e895-2315d98-ffffffffa6b77155
  -- [17:15:30.1185788] [Lua] NID_ScielUnlock
  -- [17:15:30.1188506] [Lua] ffffffffd863d1f9-4730f13b-ffffffffa8d3fb8f-ffffffffe465e774
  -- [17:15:30.1191719] [Lua] NID_GestralVillage_TalkToTheChief
  -- [17:15:30.1193363] [Lua] ffffffffd9761a73-47b1d711-238dbd93-781aae5c
  -- [17:15:30.1194713] [Lua] NID_CIN_EnteringEsquieNestPlayed
  -- [17:15:30.1195931] [Lua] ffffffffc8c70cd3-4fe1a9cc-5c8aa99b-ffffffffd37034f2
  -- [17:15:30.1197145] [Lua] NID_EsquieNest_FrancoisDefeated1
  -- [17:15:30.1198642] [Lua] ffffffffd0a6dfb1-454b657f-6e9cefbf-ffffffffdbfe9929
  -- [17:15:30.1200137] [Lua] NID_EsquieNest_FrancoisDefeated
  -- [17:15:30.1201538] [Lua] ffffffffae65dd07-458c4ad1-390fdb89-ffffffffacfd953e
  -- [17:15:30.1202854] [Lua] NID_ForgottenBattlefield_GradientCounterTutorial
  -- [17:15:30.1204429] [Lua] 30e2946e-432cb0e8-363ed298-11577e30
  -- [17:15:30.1205983] [Lua] NID_DuallistIntroPlayed
  -- [17:15:30.1207468] [Lua] 2c768577-486f9298-58f131b5-ffffffffe6f96f87
  -- [17:15:30.1209047] [Lua] NID_Camp_DS_CampMaelleLune
  -- [17:15:30.1213849] [Lua] 541e32d9-4886c428-fffffffffb2c1399-2629b2d9
  -- [17:15:30.1215879] [Lua] NID_Lumiere_MyFlowerCINPlayed
  -- [17:15:30.1218400] [Lua] 71bae11f-4574e90d-ffffffffe907fbab-4f471ab7
  -- [17:15:30.1233944] [Lua] NID_MonocoStation_StalactAttack1
  -- [17:15:30.1235684] [Lua] ffffffffbedc3616-4c3359e2-ffffffffa24c01b5-4e081257
  -- [17:15:30.1237144] [Lua] NID_MonocoStation_GrandisFashion_EloquenceBattle
  -- [17:15:30.1238706] [Lua] ffffffffd8ad6611-4162c20f-58a7a2af-4fa5cd79
  -- [17:15:30.1240060] [Lua] NID_OldL_MonocoSmash
  -- [17:15:30.1242035] [Lua] ffffffffb1fd5ca7-43796a7c-fad8e89-733ee79a
  -- [17:15:30.1243607] [Lua] NID_OldLumiere_VersoDisapeared
  -- [17:15:30.1246128] [Lua] 79ffe61f-42911df0-7200c3a0-67dfbf1b
  -- [17:15:30.1247274] [Lua] NID_EsquieArmbandUnlocked
  -- [17:15:30.1249318] [Lua] ffffffff894303d3-43248548-ffffffffdf5951b6-4725db32
  -- [17:15:30.1250532] [Lua] NID_Camp_DS_Sisters_Trigger
  -- [17:15:30.1252506] [Lua] ffffffffcd2568aa-4bbd270b-102ed3a0-5fac0324
  -- [17:15:30.1254115] [Lua] NID_JoyMaskDefeated2
  -- [17:15:30.1255611] [Lua] 1262ed04-4c4b3314-ffffffffa7a281a2-ffffffff99720310
  -- [17:15:30.1257252] [Lua] NID_AngerMaskDefeated1
  -- [17:15:30.1259163] [Lua] 60e6aed-4743c27d-41a222ab-22d097c0
  -- [17:15:30.1260709] [Lua] NID_SireneDefeated
  -- [17:15:30.1262327] [Lua] 657b4f90-4b864cfd-fffffffff74824a7-4bb2e0fc
  -- [17:15:30.1263628] [Lua] NID_SadnessMaskDefeated1
  -- [17:15:30.1265134] [Lua] ffffffffad00a708-4e8296c4-61f60a98-ffffffffd4cb487b
  -- [17:15:30.1266728] [Lua] NID_SireneDefeated1
  -- [17:15:30.1268036] [Lua] ffffffffe56beae9-48567fe3-16054abb-ffffffff9eb3ae57
  -- [17:15:30.1269095] [Lua] NID_SireneDefeated
  -- [17:15:30.1270651] [Lua] 190f0499-4f3bc25d-ffffffffb0d85d80-52bbc94e
  -- [17:15:30.1272279] [Lua] NID_DatingSciel
  -- [17:15:30.1273665] [Lua] ffffffffc9740bc8-429d79a7-ffffffffde87bb82-ffffffffd824aa6e
  -- [17:15:30.1274836] [Lua] NID_EsquieHardWaterUnlock1
  -- [17:15:30.1276636] [Lua] 6a9553f7-4df3dc95-21419590-ffffffffcca043aa
  -- [17:15:30.1277647] [Lua] NID_ScielUnlock
  -- [17:15:30.1280025] [Lua] ffffffffa082f7f0-4a94eab3-59a693a0-7c60205b
  -- [17:15:30.1281656] [Lua] NID_Camp_AfterMeetingRealRenoir
  -- [17:15:30.1283987] [Lua] ffffffffdf673638-42b372b3-ffffffff8fc8bb8a-2a98f8f2
  -- [17:15:30.1285856] [Lua] NID_CampAftermathDialogs
  -- [17:15:30.1287167] [Lua] 1c5f62cb-44df660f-ffffffff9a3f22a8-19516533
  -- [17:15:30.1288340] [Lua] NID_Camp_DS_AftermathLadies_Trigger
  -- [17:15:30.1289709] [Lua] 117dbeb4-4b2e5608-54b7d8bb-10acdb08
  -- [17:15:30.1291188] [Lua] NID_LuneRelationshipLvl6_Quest
  -- [17:15:30.1293033] [Lua] 2a55f5a4-4ef0b15c-7b4d53b6-fffffffff3e5cc39
  -- [17:15:30.1294466] [Lua] NID_MaelleRelationshipLvl6_Quest
  -- [17:15:30.1295813] [Lua] ffffffffe3367623-40bcb33c-788d9cb7-ffffffffffe1b656
  -- [17:15:30.1296943] [Lua] NID_Monoco_RelationshipLvl6_Quest
  -- [17:15:30.1298312] [Lua] ffffffffa73a9b68-4aceacd1-721bcb90-1f428538
  -- [17:15:30.1299408] [Lua] NID_EsquieUnderwaterUnlocked
  -- [17:15:30.1301219] [Lua] ffffffffc6049eb0-4851b254-ffffffffe484769a-ffffffffb9f84714
  -- [17:15:30.1303154] [Lua] NID_Lumiere_MyFlowerCINPlayed1
  -- [17:15:30.1304451] [Lua] ffffffffaa6633b1-4feda61d-92eed80-ffffffffcd949751
  -- [17:15:30.1305614] [Lua] NID_Reacher_AliciaDefeated1
  -- [17:15:30.1307290] [Lua] ffffffff88b11d0f-4862554e-ffffffffdda35eb0-ffffffff9310cdd8
  -- [17:15:30.1308490] [Lua] NID_AliciaEncountered
  -- [17:15:30.1309673] [Lua] ffffffffb155c643-4303f75c-389c1f86-ffffffffa7f09b7c
  -- [17:15:30.1310863] [Lua] NID_Reacher_AliciaDefeated
  -- [17:15:30.1312294] [Lua] 426cc205-4586ee41-ffffffffdd4f6587-7ecd78a4
  -- [17:15:30.1313718] [Lua] NID_Camp_DS_CampScielEsquie
  -- [17:15:30.1329619] [Lua] ffffffff8bca1363-4e12c628-3c39afaa-ffffffffd03a3b5c
  -- [17:15:30.1331360] [Lua] NID_MetCleaInFlyingHouse
  -- [17:15:30.1333103] [Lua] 70e5f818-4badd566-25a359b3-ffffffffded04d35
  -- [17:15:30.1335100] [Lua] NID_MetSimon
  -- [17:15:30.1336322] [Lua] fffffffffd4eaf4d-4aa4b3ae-ffffffffd1ed1ba1-6108c00a