---@class Game_Constants
local GAME = {
    TABLE = 
    {
        CHARACTERS_ID = {"Frey", "Maelle", "Lune", "Sciel", "Verso", "Monoco" },
        CHARACTERS_WEAPONS = {"Noahram", "Maellum", "Lunerim", "Scieleson", "Verleso", "Monocaro" },
        CHARACTERS_DEFAULT_SKILLS = {
            Frey = {
                "Combo1_Gustave", "UnleashCharge"
            },
            Maelle = {
                "OffensiveSwitch", "Percee"
            }, 
            Lune = {
                "IceGust", "Immolation"
            },
            Sciel = {
                "Grimprediction", "Foretelling2"
            },
            Verso = {
                "Combo1", "FromFire"
            },
            Monoco = {
                "ChalierRelentlessSword", "StalactCombo"
            }
        },

        WORLDMAP_CAPACITIES = { "Base", "HardenLands", "Swim", "SwimBoost", "Fly" },
        EXPLORATION_CAPACITIES = { "AttackInWorld", "FreeAim", "FreeAimTeleport", "Overlay", "GameMenu", "FastTravel", "Camp" },


        SAVE_NOTIFICATION = {   -- Meme/niche/our references
                                "<- Imagine a baguette spinning", "Yezzdia did the Poptracker", "Noeva will be raised as promise", 
                                "Not saving...", "Did you know that vaporeon...", "My wife makes me happy ! :)",
                                "Quoi ? Feur !", "https://isaaconnect.com", "Apagnan", "N'oubliez pas vos cramptés",

                                -- Zelda references
                                "It's dangerous to go alone", "I AM ERROR", "I will draw you into the Dark World!", 
                                "Ahhh, you are a bad boy, Link!", "Twenty-three is number one!", "We are fine here. We will greet the morning...Together.",
                                "Dancing will be fun!", "I'll give you reasons to fear Veran", --"Four swords ?",
                                "The wind... It is blowing...", "I have the power of a god!", --"FSA",
                                "Link... I... See you later...", "Great fortune awaits! Hurry and assemble your party!", "Choo choo!",
                                "I'm still your Zelda.", "Ravio is ALL about helping heroes.", --"TH",
                                "The flow of time is always cruel.", "To become an immortal dragon is to lose oneself.", "Get creative with what you've got!",


                                -- Expedition 33 references
                                "What lovely feet", "COE33 won the GOTY"
                            },


                            
        MAP_NAME = {
            ASSETS_TABLE   = {  "Level_Goblu_Main_V5", "Level_AncientSanctuary_Main_V2", "Level_RedForest_Main", "LevelMain_EsquieNest", "Level_OraneForest_Main",
                                "Level_Side_CleasWorkShop_V2", "Level_Main_ForgottenBattlefield_V2", "Level_Side_FrozenHeart", "Level_Main_GestralVillage_V2",
                                "Level_MonocoStation", "Level_Lumiere_Main_V2", "Level_PaintressIntro_Main", "Level_OldLumiere_Main", "Level_Reacher_Main_V2",
                                "Level_SeaCliff_Main_V2", "Level_Sirene_Main_V2", "Level_Side_TwilightSanctuary", "Level_Visages_Main_V1", "Level_YellowForest_Main",
                                "CleasTower_GroundFloorEntrance", "Level_Side_VersosDraft", "Level_Camp_Main", "Level_WorldMap_Main_V2" },

            READABLE_TABLE = {  "GoblusLair", "AncientSanctuary", "SideLevel_RedForest", "EsquieNest", "SideLevel_OrangeForest",
                                "SideLevel_CleasFlyingHouse", "ForgottenBattlefield", "SidelLevel_FrozenHearts", "GestralVillage",
                                "MonocoStation", "Lumiere", "Monolith_Interior_PaintressIntro", "OldLumiere", "SideLevel_Reacher",
                                "SeaCliff", "Sirene", "SideLevel_TwilightSanctuary", "Visages", "SideLevel_YellowForest",
                                "SideLevel_CleasTower_Entrance", "SideLevel_VersosDraft", "Camps", "WorldMap" }
        },

        SHOP_DATATABLE_BY_MAP = {
            ["Level_Goblu_Main_V5"]                      = { "DT_Merchant_GoblusLair.DT_Merchant_GoblusLair"},
            ["Level_Main_GestralVillage_V2"]             = { "CustomizationMerchants/DT_Merchant_GV_1_CustoSuits_Guys.DT_Merchant_GV_1_CustoSuits_Guys", "CustomizationMerchants/DT_Merchant_GV_1_CustoSuits_Ladies.DT_Merchant_GV_1_CustoSuits_Ladies", "DT_Merchant_GestralVillage1.DT_Merchant_GestralVillage1", "DT_Merchant_GestralVillage2.DT_Merchant_GestralVillage2", "DT_Merchant_GestralVillage3.DT_Merchant_GestralVillage3"},
            ["Level_SeaCliff_Main_V2"]                   = { "DT_Merchant_SeaCliff.DT_Merchant_SeaCliff"},
            ["Level_Main_ForgottenBattlefield_V2"]       = { "DT_Merchant_ForgottenBattlefield.DT_Merchant_ForgottenBattlefield"},
            ["Level_MonocoStation"]                      = { "DT_Merchant_GrandisStation.DT_Merchant_GrandisStation"},
            ["Level_OldLumiere_Main"]                    = { "DT_Merchant_OldLumiere.DT_Merchant_OldLumiere"},
            ["Level_Visages_Main_V1"]                    = { "DT_Merchant_Visages.DT_Merchant_Visages"},
            ["Level_Sirene_Main_V2"]                     = { "DT_Merchant_Sirene.DT_Merchant_Sirene"},
            ["Level_Monolith_Interior_Climb_Main"]       = { "DT_Merchant_Monolith.DT_Merchant_Monolith", "DT_Merchant_MonocosMountain.DT_Merchant_MonocosMountain"},
            ["Level_Lumiere_Main_V2"]                    = { "DT_Merchant_Lumiere.DT_Merchant_Lumiere"},
            ["Level_YellowForest_Main"]                  = { "DT_Merchant_YellowForest.DT_Merchant_YellowForest"},
            ["Level_OraneForest_Main"]                   = { "DT_Merchant_OrangeForest.DT_Merchant_OrangeForest"},
            ["Level_Side_FrozenHeart"]                   = { "CustomizationMerchants/DT_Merchant_FH_Custo_Danseuse.DT_Merchant_FH_Custo_Danseuse"},
            ["Level_Reacher_Main_V2"]                    = { "DT_Merchant_Reacher.DT_Merchant_Reacher"},
            ["Level_Monolith_Floor_1"]                   = { "DT_Merchant_Optional3.DT_Merchant_Optional3" },
            ["Level_Side_CleasWorkShop_V2"]              = { "DT_Merchant_CleaIsland.DT_Merchant_CleaIsland"},
            ["Level_Side_TwilightSanctuary"]             = { "DT_Merchant_TwilightSanctuary.DT_Merchant_TwilightSanctuary"},
            ["Level_Side_VersosDraft"]                   = { "CustomizationMerchants/DT_Merchant_Osquio.DT_Merchant_Osquio", "DT_Merchant_VersosDraft.DT_Merchant_VersosDraft"},
            ["Level_WorldMap_Main_V2"]                   = { "CustomizationMerchants/DT_Merchant_WM_1.DT_Merchant_WM_1", "CustomizationMerchants/DT_Merchant_WM_2.DT_Merchant_WM_2", "CustomizationMerchants/DT_Merchant_WM_3_GustaveSuit.DT_Merchant_WM_3_GustaveSuit", "CustomizationMerchants/DT_Merchant_WM_4.DT_Merchant_WM_4", "CustomizationMerchants/DT_Merchant_WM_5.DT_Merchant_WM_5", "CustomizationMerchants/DT_Merchant_WM_6.DT_Merchant_WM_6", "CustomizationMerchants/DT_Merchant_WM_7.DT_Merchant_WM_7", "CustomizationMerchants/DT_Merchant_WM_8.DT_Merchant_WM_8", "CustomizationMerchants/DT_Merchant_WM_9.DT_Merchant_WM_9", "CustomizationMerchants/DT_Merchant_WM_9_Sirene.DT_Merchant_WM_9_Sirene", "CustomizationMerchants/DT_Merchant_WM_10.DT_Merchant_WM_10", "CustomizationMerchants/DT_Merchant_WM_11.DT_Merchant_WM_11", "CustomizationMerchants/DT_Merchant_WM_12.DT_Merchant_WM_12", "CustomizationMerchants/DT_Merchant_WM_13.DT_Merchant_WM_13", "CustomizationMerchants/DT_Merchant_WM_14.DT_Merchant_WM_14", "CustomizationMerchants/DT_Merchant_WM_15.DT_Merchant_WM_15", "CustomizationMerchants/DT_Merchant_WM_16.DT_Merchant_WM_16", "CustomizationMerchants/DT_Merchant_WM_17.DT_Merchant_WM_17", "CustomizationMerchants/DT_Merchant_WM_Chic.DT_Merchant_WM_Chic", },
            ["SmallLevel_CrulerBrulerWeaponry_Blockout"] = { "DT_Merchant_CoastalCave_Bruler.DT_Merchant_CoastalCave_Bruler", "DT_Merchant_CoastalCave_Cruler.DT_Merchant_CoastalCave_Cruler"}
        },

        WORLDMAP_DIVE_POSITION = {
            N_OF_SIRENE = {
                X = -324977.38906072, 
                Y = 95615.723324887, 
                Z = 0,
                NAME_AP = "World Map: Dive - N of Sirene"
            },
            NEAR_THE_CROWS = {
                X = -401420.23656072, 
                Y = -49355.726539823, 
                Z = 0,
                NAME_AP = "World Map: Dive - Near The Crows"
            },
            S_OF_SINISTER_CAVE = {
                X = -405667.1027116, 
                Y = 252859.2109331, 
                Z = 0,
                NAME_AP = "World Map: Dive - S of Sinister Cave"
            },
            BELOW_FLOATING_CEMETERY = { 
                X = -543486.48471066, 
                Y = -69062.958281085, 
                Z = 0,
                NAME_AP = "World Map: Dive - Below Floating Cemetery"
            },
            BELOW_GESTRAL_TOWER = { 
                X = -467553.83258783, 
                Y = 169528.96519204, 
                Z = 0,
                NAME_AP = "World Map: Dive - Near Gestral Beach Tower"
            },
            BELOW_THE_CHOSEN_PATH = {
                X = -480573.79194773, 
                Y = 59389.64078752, 
                Z = 0,
                NAME_AP = "World Map: Dive - Below The Chosen Path"
            },
            BELOW_ENDLESS_TOWER = {
                X = -697692.23045245, 
                Y = -23388.701439278, 
                Z = 0,
                NAME_AP = "World Map: Dive - Below Endless Tower"
            },
            NEAR_THE_MEADOWS = {
                X = -774962.12823495, 
                Y = 85405.206397979, 
                Z = 0,
                NAME_AP = "World Map: Dive - Near The Meadows"
            },
            EAST_OF_LUMIERE = {   
                X = -827703.85963173, 
                Y = 129434.95928411, 
                Z = 0,
                NAME_AP = "World Map: Dive - East of Lumiere"
            },
            NEAR_SE_MANOR_DOOR = {
                X = -763619.93138162, 
                Y = 161666.68827581, 
                Z = 0,
                NAME_AP = "World Map: Dive - Near SE Manor Door"
            },
            UNDER_SERPENPHARE = { 
                X = -593980.70235564, 
                Y = 128062.42748221, 
                Z = 0,
                NAME_AP = "World Map: Dive - Under Serpenphare"
            },
            NE_OF_WHITE_SAND = {
                X = -549044.05472752, 
                Y = 201473.2868461, 
                Z = 0,
                NAME_AP = "World Map: Dive - NE of White Sands"
            },

        }
    },


    BATTLE = {
        STATUS_EFFECT = {
            BURN            = 1,
            FROZEN          = 2,
            STUN            = 3,
            INVERTED        = 4,
            MARKED          = 5,
            CURSED          = 6,
            BOUND           = 7,
            EXHAUST         = 8,
            DIZZY           = 9,
            SILENCE         = 10,
            RAGE            = 11,
            POWERFUL        = 12,
            RUSH            = 13,
            SHELL           = 14,
            PRECISION       = 15,
            POWERLESS       = 16,
            SLOW            = 17,
            DEFENSLESS      = 18,
            BLIND           = 19,
            BUFF_LOW_HEALTH = 20,
            REGEN           = 21,
            BERSERK         = 22,
            CHARMED         = 23,
            BARBAPAPA       = 24,

        }
    }

}


return GAME