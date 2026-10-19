---@class CharacterEntry
---@field id string hardcoded name used by the game
---@field ap string Real name used by everyone
---@field weapon string starting weapon item
---@field skills string[] default skills

---@type CharacterEntry[]
local ENTRIES = {
    { id = "Frey",    ap = "Gustave", weapon = "Noahram",   skills = { "Combo1_Gustave", "UnleashCharge" } },
    { id = "Maelle",  ap = "Maelle",  weapon = "Maellum",   skills = { "OffensiveSwitch", "Percee" } },
    { id = "Lune",    ap = "Lune",    weapon = "Lunerim",   skills = { "IceGust", "Immolation" } },
    { id = "Sciel",   ap = "Sciel",   weapon = "Scieleson", skills = { "Grimprediction", "Foretelling2" } },
    { id = "Verso",   ap = "Verso",   weapon = "Verleso",   skills = { "Combo1", "FromFire" } },
    { id = "Monoco",  ap = "Monoco",  weapon = "Monocaro",  skills = { "ChalierRelentlessSword", "StalactCombo" } },
}

local CHARACTERS = { ALL = ENTRIES, BY_ID = {} }

for _, entry in ipairs(ENTRIES) do
    CHARACTERS.BY_ID[entry.id] = entry
end

---Default value of the `characters` storage field
---@return table<string, boolean>
function CHARACTERS.BuildUnlockDefaults()
    local unlocked = {}
    for _, entry in ipairs(ENTRIES) do
        unlocked[entry.id] = false
    end
    return unlocked
end

return CHARACTERS