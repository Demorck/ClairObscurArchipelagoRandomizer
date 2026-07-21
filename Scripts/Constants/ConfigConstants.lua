---@class Gear_Scaling
---@field SPHERE_PLACEMENT  number
---@field ORDER_RECEIVED    number
---@field BALANCED_RANDOM   number
---@field FULL_RANDOM       number

---@class OPTIONS_Constants
---@field GEAR_SCALING Gear_Scaling

---@class Config_Constants
---@field MAX_LEVEL_GEAR number
---@field DEFAULT_MAX_LEVEL_GEAR number
---@field NUMBER_OF_PICTOS number
---@field NUMBER_OF_WEAPONS number
---@field OPTIONS OPTIONS_Constants
local CONFIG = {
    MAX_LEVEL_GEAR = 33,
    DEFAULT_MAX_LEVEL_GEAR = 33,
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

    REGION_LEVEL= {
        ["Ancient Sanctuary"] =  4,
        ["Crimson Forest"] = 24,
        ["Dark Shores"] = 23,
        ["Esquie's Nest"] = 5,
        ["Falling Leaves"] = 14,
        ["Flying Manor"] = 28,
        ["Forgotten Battlefield"] = 8,
        ["Frozen Hearts"] = 21,
        ["Gestral Village"] = 4,
        ["Flying Waters"] = 3,
        ["Monoco's Station"] = 1,
        ["Lumiere"] = 16,
        ["The Monolith"] = 15,
        ["Old Lumiere"] = 10,
        ["The Reacher"] = 20,
        ["Renoir's Drafts"] = 31,
        ["Stone Wave Cliffs"] = 7,
        ["Sirene"] = 13,
        ["Red Woods"] = 1,
        ["The Small Bourgeon"] = 1,
        ["Stone Wave Cliffs Cave"] = 8,
        ["The Chosen Path"] = 20,
        ["Sky Island"] = 20,
        ["Isle of the Eyes"] = 22,
        ["The Crows"] = 1,
        ["Floating Cemetery"] = 1,
        ["Coastal Cave"] = 1,
        ["Crushing Cavern"] = 9,
        ["Esoteric Ruins"] = 1,
        ["Sinister Cave"] = 13,
        ["The Fountain"] = 1,
        ["Abbest Cave"] = 1,
        ["Flying Casino"] = 1,
        ["The Carousel"] = 1,
        ["White Sands"] = 1,
        ["Sacred River"] = 1,
        ["Spring Meadows"] = 1,
        ["Endless Night Sanctuary"] = 21,
        ["Visages"] = 11,
        ["Yellow Harvest"] = 7,
        ["WM: First Continent South"] = 1,
        ["WM: First Continent North"] = 1,
        ["WM: South Sea"] = 1,
        ["WM: Second Continent South"] = 1,
        ["WM: Second Continent NE"] = 1,
        ["WM: Second Continent NW"] = 1,
        ["WM: North Sea"] = 1,
        ["WM: Outside Gestral Village"] = 1,
        ["WM: Sky"] = 1,
        ["WM: Underwater"] = 1,
        ["Lost Woods"] = 1,
        ["Painting Workshop"] = 1,
        ["Endless Tower"] = 21,
        ["Endless Tower Stage 2"] = 22,
        ["Endless Tower Stage 3"] = 23,
        ["Endless Tower Stage 4"] = 24,
        ["Endless Tower Stage 5"] = 25,
        ["Endless Tower Stage 6"] = 26,
        ["Endless Tower Stage 7"] = 27,
        ["Endless Tower Stage 8"] = 28,
        ["Endless Tower Stage 9"] = 29,
        ["Endless Tower Stage 10"] = 30,
        ["Endless Tower Stage 11"] = 31,
        ["Endless Tower Superbosses"] = 33,
        ["Dark Gestral Arena"] = 25,
        ["Hidden Gestral Arena"] = 6,
        ["Sirene's Dress"] = 20,
        ["Sunless Cliffs"] = 31,
        ["Verso's Drafts"] = 29,
        ["Isle of the Eyes - The Crows"] = 1,
        ["Ancient Sanctuary or Forgotten Battlefield"] = 1,
        ["Esquie's Nest or Monolith"] = 1,
    },

    CONSUMABLE_ITEM = {
        "PartyHealConsumable",
        "Consumable_Revive_Level0",
        "Consumable_Revive_Level1",
        "Consumable_Revive_Level2",
        "Consumable_Energy_Level0",
        "Consumable_Energy_Level1",
        "Consumable_Energy_Level2",
        "Consumable_Health_Level0",
        "Consumable_Health_Level1",
        "Consumable_Health_Level2"
    },

    VERSION = "0.3.0"
}

return CONFIG