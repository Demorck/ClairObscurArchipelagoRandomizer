---@class RegionEntry
---@field name      string | nil Internal name. 
---@field ap        string | nil Region name in AP
---@field area      boolean | nil true when an Area unlocks this region (own storage item)
---@field level     number Progression level, used by apworld for excluding stuff
---@field levels    table<string, string[]> | nil UE level assets belonging to this region mapped by their shops
---@field aliases   string[] | nil Datatable for shop in this region
---@field asset     string | nil Asset name if the level has only one (for dev purpose only)

---@type RegionEntry[]
local ENTRIES = {
    -- Regions unlocked by an "Area - x" item (they own a storage ticket)
    {
        name = "AncientSanctuary", 
        ap = "Ancient Sanctuary", 
        level = 4, area = true,
        levels = {
            ["Level_AncientSanctuary_Main_V2"] = {},
        },
    },
    {
        name = "SideLevel_RedForest", 
        ap = "Crimson Forest", 
        level = 24, area = true,
        levels = {
            ["Level_RedForest_Main"] = {},
        },
    },
    {
        name = "SideLevel_TwilightSanctuary", 
        ap = "Endless Night Sanctuary", 
        level = 21, area = true,
        aliases = { "Twilight Sanctuary" },
        levels = {
            ["Level_Side_TwilightSanctuary"] = { "DT_Merchant_TwilightSanctuary.DT_Merchant_TwilightSanctuary" },
        },
    },
    {
        name = "SideLevel_CleasTower_Entrance", 
        ap = "Endless Tower", 
        level = 21, area = true,
        levels = {
            ["CleasTower_GroundFloorEntrance"] = {},
        },
    },
    {
        name = "EsquieNest", 
        ap = "Esquie's Nest", 
        level = 5, area = true,
        aliases = { "Esquie’s Nest", "Esquies Nest" },
        levels = {
            ["LevelMain_EsquieNest"] = {},
        },
    },
    {
        name = "SideLevel_OrangeForest", 
        ap = "Falling Leaves", 
        level = 14, area = true,
        aliases = { "Yellow Forest" },
        levels = {
            ["Level_OraneForest_Main"] = { "DT_Merchant_OrangeForest.DT_Merchant_OrangeForest" },
        },
    },
    {
        name = "SideLevel_CleasFlyingHouse", 
        ap = "Flying Manor", 
        level = 28, area = true,
        asset = "Level_Side_CleasWorkShop_V2",
        levels = {
            ["Level_Side_CleasWorkShop_V2"] = { "DT_Merchant_CleaIsland.DT_Merchant_CleaIsland" },
            ["Level_CleaFlyingHouse_Main"] = {},
        },
    },
    {
        name = "GoblusLair", 
        ap = "Flying Waters", 
        level = 3, area = true,
        aliases = { "Goblus Lair" },
        levels = {
            ["Level_Goblu_Main_V5"] = { "DT_Merchant_GoblusLair.DT_Merchant_GoblusLair" },
        },
    },
    {
        name = "ForgottenBattlefield", 
        ap = "Forgotten Battlefield", 
        level = 8, area = true,
        levels = {
            ["Level_Main_ForgottenBattlefield_V2"] = {
                "DT_Merchant_ForgottenBattlefield.DT_Merchant_ForgottenBattlefield",
            },
        },
    },
    {
        name = "SidelLevel_FrozenHearts", 
        ap = "Frozen Hearts", 
        level = 21, area = true,
        levels = {
            ["Level_Side_FrozenHeart"] = {
                "CustomizationMerchants/DT_Merchant_FH_Custo_Danseuse.DT_Merchant_FH_Custo_Danseuse",
            },
        },
    },
    {
        name = "GestralVillage", 
        ap = "Gestral Village", 
        level = 4, area = true,
        levels = {
            ["Level_Main_GestralVillage_V2"] = {
                "CustomizationMerchants/DT_Merchant_GV_1_CustoSuits_Guys.DT_Merchant_GV_1_CustoSuits_Guys",
                "CustomizationMerchants/DT_Merchant_GV_1_CustoSuits_Ladies.DT_Merchant_GV_1_CustoSuits_Ladies",
                "DT_Merchant_GestralVillage1.DT_Merchant_GestralVillage1",
                "DT_Merchant_GestralVillage2.DT_Merchant_GestralVillage2",
            },
        },
    },
    {
        name = "Lumiere", 
        ap = "Lumiere", 
        level = 16, area = true,
        levels = {
            ["Level_Lumiere_Main_V2"] = { "DT_Merchant_Lumiere.DT_Merchant_Lumiere" },
        },
    },
    {
        name = "MonocoStation", 
        ap = "Monoco's Station", 
        level = 1, area = true,
        aliases = { "Grandis Station" },
        levels = {
            ["Level_MonocoStation"] = { "DT_Merchant_GrandisStation.DT_Merchant_GrandisStation" },
        },
    },
    {
        name = "OldLumiere", 
        ap = "Old Lumiere", 
        level = 10, area = true,
        levels = {
            ["Level_OldLumiere_Main"] = { "DT_Merchant_OldLumiere.DT_Merchant_OldLumiere" },
        },
    },
    {
        -- FIXME: items.json sends "Level_PaintressIntro_Main" as internal_name, see the RowName
        name = "Monolith_Interior_PaintressIntro", 
        ap = "The Monolith", 
        level = 15, area = true,
        aliases = { "Monolith" },
        asset = "Level_PaintressIntro_Main",
        levels = {
            ["Level_PaintressIntro_Main"] = {},
            ["Level_Monolith_Interior_Climb_Main"] = {
                "DT_Merchant_Monolith.DT_Merchant_Monolith",
                "DT_Merchant_MonocosMountain.DT_Merchant_MonocosMountain",
            }
        },
    },
    {
        name = "Sirene", 
        ap = "Sirene", 
        level = 13, area = true,
        levels = {
            ["Level_Sirene_Main_V2"] = { "DT_Merchant_Sirene.DT_Merchant_Sirene" },
        },
    },
    {
        name = "SeaCliff", 
        ap = "Stone Wave Cliffs", 
        level = 7, area = true,
        aliases = { "Sea Cliff" },
        levels = {
            ["Level_SeaCliff_Main_V2"] = { "DT_Merchant_SeaCliff.DT_Merchant_SeaCliff" },
        },
    },
    {
        name = "SideLevel_Reacher", 
        ap = "The Reacher", 
        level = 20, area = true,
        aliases = { "Reacher" },
        levels = {
            ["Level_Reacher_Main_V2"] = { "DT_Merchant_Reacher.DT_Merchant_Reacher" },
        },
    },
    {
        name = "SideLevel_VersosDraft", 
        ap = "Verso's Drafts", 
        level = 29, area = true,
        levels = {
            ["Level_Side_VersosDraft"] = {
                "CustomizationMerchants/DT_Merchant_Osquio.DT_Merchant_Osquio",
                "DT_Merchant_VersosDraft.DT_Merchant_VersosDraft",
            },
        },
    },
    {
        name = "Visages", 
        ap = "Visages", 
        level = 11, area = true,
        levels = {
            ["Level_Visages_Main_V1"] = { "DT_Merchant_Visages.DT_Merchant_Visages" },
        },
    },
    {
        name = "SideLevel_YellowForest", 
        ap = "Yellow Harvest", 
        level = 7, area = true,
        levels = {
            ["Level_YellowForest_Main"] = { "DT_Merchant_YellowForest.DT_Merchant_YellowForest" },
        },
    },
    {
        name = "Camps", 
        ap = "Camp", 
        level = 1,
        aliases = { "Camps" },
        levels = {
            ["Level_Camp_Main"] = {},
        },
    },
    {
        name = "WorldMap", 
        ap = "World Map", 
        level = 1,
        levels = {
            ["Level_WorldMap_Main_V2"] = {
                "CustomizationMerchants/DT_Merchant_WM_1.DT_Merchant_WM_1",
                "CustomizationMerchants/DT_Merchant_WM_2.DT_Merchant_WM_2",
                "CustomizationMerchants/DT_Merchant_WM_3_GustaveSuit.DT_Merchant_WM_3_GustaveSuit",
                "CustomizationMerchants/DT_Merchant_WM_4.DT_Merchant_WM_4",
                "CustomizationMerchants/DT_Merchant_WM_5.DT_Merchant_WM_5",
                "CustomizationMerchants/DT_Merchant_WM_6.DT_Merchant_WM_6",
                "CustomizationMerchants/DT_Merchant_WM_7.DT_Merchant_WM_7",
                "CustomizationMerchants/DT_Merchant_WM_8.DT_Merchant_WM_8",
                "CustomizationMerchants/DT_Merchant_WM_9.DT_Merchant_WM_9",
                "CustomizationMerchants/DT_Merchant_WM_9_Sirene.DT_Merchant_WM_9_Sirene",
                "CustomizationMerchants/DT_Merchant_WM_10.DT_Merchant_WM_10",
                "CustomizationMerchants/DT_Merchant_WM_11.DT_Merchant_WM_11",
                "CustomizationMerchants/DT_Merchant_WM_12.DT_Merchant_WM_12",
                "CustomizationMerchants/DT_Merchant_WM_13.DT_Merchant_WM_13",
                "CustomizationMerchants/DT_Merchant_WM_14.DT_Merchant_WM_14",
                "CustomizationMerchants/DT_Merchant_WM_15.DT_Merchant_WM_15",
                "CustomizationMerchants/DT_Merchant_WM_16.DT_Merchant_WM_16",
                "CustomizationMerchants/DT_Merchant_WM_17.DT_Merchant_WM_17",
                
                "CustomizationMerchants/DT_Merchant_WM_Chic.DT_Merchant_WM_Chic",
                "CustomizationMerchants/DT_Merchant_GestralVillage3.DT_Merchant_GestralVillage3",
            },
        },
    },
    {
        name = "SmallLevel_CoastalCave",
        ap = "Coastal Cave", 
        level = 1,
        levels = {
            ["SmallLevel_CrulerBrulerWeaponry_Blockout"] = {
                "DT_Merchant_CoastalCave_Bruler.DT_Merchant_CoastalCave_Bruler",
                "DT_Merchant_CoastalCave_Cruler.DT_Merchant_CoastalCave_Cruler",
            },
        },
    },
    {
        name = "SideLevel_AxonPath",
        ap = "Renoir's Drafts", 
        level = 31,
        area = true,
        levels = {
            ["Level_Monolith_Floor_1"] = {
                "DT_Merchant_Optional3.DT_Merchant_Optional3",
            },
        },
        aliases = { "Renoir’s Drafts" }
    },


    {
        name = "SmallLevel_Visages",
        ap = "Isle of the Eyes", 
        level = 22,
        levels = {
            ["SmallLevel_MF_Zone_01"] = {},
        },
    },
    {
        name = "SpringMeadows",
        ap = "Spring Meadows", 
        level = 1,
        levels = {
            ["Level_SpringMeadows_Main_V2"] = {},
        },
    },

    -- Basically regions created by AP or without a proper level (some of them ARE level but not logically in a level. For now)
    { ap = "Abbest Cave", level = 1 },
    { ap = "Ancient Sanctuary or Forgotten Battlefield", level = 1 },
    { ap = "Crushing Cavern", level = 9 },
    { ap = "Dark Gestral Arena", level = 25 },
    { ap = "Dark Shores", level = 23 },
    { ap = "Endless Tower Stage 2", level = 22 },
    { ap = "Endless Tower Stage 3", level = 23 },
    { ap = "Endless Tower Stage 4", level = 24 },
    { ap = "Endless Tower Stage 5", level = 25 },
    { ap = "Endless Tower Stage 6", level = 26 },
    { ap = "Endless Tower Stage 7", level = 27 },
    { ap = "Endless Tower Stage 8", level = 28 },
    { ap = "Endless Tower Stage 9", level = 29 },
    { ap = "Endless Tower Stage 10", level = 30 },
    { ap = "Endless Tower Stage 11", level = 31 },
    { ap = "Endless Tower Superbosses", level = 33 },
    { ap = "Esoteric Ruins", level = 1 },
    { ap = "Esquie's Nest or Monolith", level = 1 },
    { ap = "Floating Cemetery", level = 1 },
    { ap = "Flying Casino", level = 1 },
    { ap = "Hidden Gestral Arena", level = 6 },
    { ap = "Isle of the Eyes - The Crows", level = 1 },
    { ap = "Lost Woods", level = 1 },
    { ap = "Painting Workshop", level = 1 },
    { ap = "Red Woods", level = 1 },
    { ap = "Sacred River", level = 1 },
    { ap = "Sinister Cave", level = 13 },
    { ap = "Sirene's Dress", level = 20, aliases = { "Sirene’s Dress" } },
    { ap = "Sky Island", level = 20 },
    { ap = "Stone Wave Cliffs Cave", level = 8 },
    { ap = "Sunless Cliffs", level = 31 },
    { ap = "The Carousel", level = 1 },
    { ap = "The Chosen Path", level = 20 },
    { ap = "The Crows", level = 1 },
    { ap = "The Fountain", level = 1 },
    { ap = "The Small Bourgeon", level = 1 },
    { ap = "White Sands", level = 1 },
    { ap = "WM: First Continent North", level = 1 },
    { ap = "WM: First Continent South", level = 1 },
    { ap = "WM: North Sea", level = 1 },
    { ap = "WM: Outside Gestral Village", level = 1 },
    { ap = "WM: Second Continent NE", level = 1 },
    { ap = "WM: Second Continent NW", level = 1 },
    { ap = "WM: Second Continent South", level = 1 },
    { ap = "WM: Sky", level = 1 },
    { ap = "WM: South Sea", level = 1 },
    { ap = "WM: Underwater", level = 1 },
}


---@class Regions
local Regions = {
    ENTRIES        = ENTRIES,
    BY_NAME                   = {},   ---@type table<string, RegionEntry>
    BY_AP_NAME                = {},   ---@type table<string, RegionEntry>
    BY_LEVEL_ASSET            = {},   ---@type table<string, RegionEntry>
    DATATABLES_BY_LEVEL_ASSET = {},   ---@type table<string, string[]>
}

for _, entry in ipairs(ENTRIES) do
    Regions.BY_AP_NAME[entry.ap] = entry

    if entry.name then
        Regions.BY_NAME[entry.name] = entry
    end

    for _, alias in ipairs(entry.aliases or {}) do
        Regions.BY_AP_NAME[alias] = entry
    end

    for asset, datatables in pairs(entry.levels or {}) do
        Regions.BY_LEVEL_ASSET[asset] = entry
        Regions.DATATABLES_BY_LEVEL_ASSET[asset] = datatables

        if entry.asset == nil then
            entry.asset = asset
        end
    end
end

---Default value of the `tickets` storage field: every region gated behind an Area item
---@return table<string, boolean>
function Regions.BuildTicketDefaults()
    local tickets = {}

    for _, entry in ipairs(ENTRIES) do
        if entry.area then
            tickets[entry.name] = false
        end
    end

    return tickets
end


return Regions