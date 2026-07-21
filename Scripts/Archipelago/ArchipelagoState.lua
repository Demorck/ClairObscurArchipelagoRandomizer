---@class ArchipelagoOptions
---@field gear_scaling number
---@field starting_char number
---@field goal number
---@field char_shuffle number
---@field shuffle_free_aim number
---@field exclude_endgame_locations number
---@field shopsanity number
---@field location_per_shop number
---@field extra_location_per_shop number
---@field exclude_endless_tower number

---Archipelago State Module
---Centralizes all Archipelago global state and configuration
---@class ArchipelagoState
local ArchipelagoState = {}

-- Connection information
ArchipelagoState.seed = nil
ArchipelagoState.slot = nil

-- Slot data options
local function CreateDefaultOptions()
    ---@type ArchipelagoOptions
    return {
        gear_scaling = 0,
        starting_char = 0,
        goal = 0,
        char_shuffle = 0,
        shuffle_free_aim = 0,
        exclude_endgame_locations = 0,
        shopsanity = 0,
        location_per_shop = 0,
        extra_location_per_shop = 0,
        exclude_endless_tower = 0,
    }
end

---@type ArchipelagoOptions
ArchipelagoState.options = CreateDefaultOptions()

-- Totals (items, locations, etc.)
ArchipelagoState.totals = {}

-- Gear scaling data
ArchipelagoState.weapons_data = {}  
ArchipelagoState.pictos_data = {}

-- Shop
ArchipelagoState.shop_data = {}

-- Connection flags
ArchipelagoState.trying_to_connect = false
ArchipelagoState.hasConnectedPrior = false
ArchipelagoState.waitingForSync = false

-- DeathLink state
ArchipelagoState.death_link = false
ArchipelagoState.canDeathLink = false
ArchipelagoState.wasDeathLinked = false
ArchipelagoState.lastDeathLink = 0.0

-- Gommage counter, not used yet
ArchipelagoState.current_year_gommage = 34

-- Number of players in multiworld, not used yet
ArchipelagoState.number_of_players = 0

-- Reference to AP system (initialized later)
ArchipelagoState.apSystem = nil

ArchipelagoState.pendingLocationsFlush = false
ArchipelagoState.want_to_scout_shop = false

---Initialize state with default values
function ArchipelagoState:Initialize()
    self.seed = nil
    self.slot = nil
    self.options = CreateDefaultOptions()
    self.totals = {}
    self.weapons_data = {}
    self.pictos_data = {}
    self.trying_to_connect = false
    self.hasConnectedPrior = false
    self.waitingForSync = false
    self.death_link = false
    self.canDeathLink = false
    self.wasDeathLinked = false
    self.lastDeathLink = 0.0
    self.current_year_gommage = 34
    self.number_of_players = 0
    self.apSystem = nil
end

---Reset state (for disconnection)
function ArchipelagoState:Reset()
    self:Initialize()
end

---Get a state value
---@param key string State key
---@return any value The state value
function ArchipelagoState:Get(key)
    return self[key]
end

---Set a state value
---@param key string State key
---@param value any Value to set
function ArchipelagoState:Set(key, value)
    self[key] = value
end

return ArchipelagoState
