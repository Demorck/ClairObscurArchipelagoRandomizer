---Archipelago options coming from the slot data
---Every option the mod reads must be declared here, with its default and its kind
---@class Options
local Options = {}

---How a category of locations is handled by the apworld
Options.EXCLUSION = {
    EXCLUDED = 0,  -- locations are removed from the pool
    FILLER   = 1,  -- locations exist but only hold filler
    INCLUDED = 2,  -- locations can hold progression
}

---How the level of a received weapon or picto is decided
Options.GEAR_SCALING = {
    SPHERE_PLACEMENT = 0,
    ORDER_RECEIVED   = 1,
    BALANCED_RANDOM  = 2,
    FULL_RANDOM      = 3,
}

---@class OptionSpec
---@field default number|boolean value used when the slot data omits the option
---@field toggle boolean|nil true when the option is on/off and should be read as a boolean
---@field values table<string, number> | nil enum used by the option

---@type table<string, OptionSpec>
Options.SPEC = {
    goal                      = { default = 0 },
    gear_scaling              = { default = 0, values = Options.GEAR_SCALING },
    starting_char             = { default = 0 },
    chroma_pack_type          = { default = 0 },
    min_chroma_pack           = { default = 0 },
    max_chroma_pack           = { default = 0 },
    location_per_shop         = { default = 0 },
    extra_location_per_shop   = { default = 0 },

    exclude_endgame_locations = { default = 0, values = Options.EXCLUSION },
    exclude_endless_tower     = { default = 0, values = Options.EXCLUSION },

    -- On/off
    char_shuffle              = { default = 0, toggle = true },
    shuffle_free_aim          = { default = 0, toggle = true },
    gestral_shuffle           = { default = 0, toggle = true },
    shopsanity                = { default = 0, toggle = true },
    show_shop_items           = { default = 0, toggle = true },
    create_hint               = { default = 0, toggle = true },
    create_hint_extra         = { default = 0, toggle = true },
}

---@type table<string, any>
Options.values = {}

---Reading an option that was never declared is a bug, not a nil
setmetatable(Options.values, {
    __index = function(_, key)
        Logger:error("Reading undeclared option: " .. tostring(key))
        return nil
    end
})

---@param raw any
---@return boolean
local function ToBoolean(raw)
    return raw == true or raw == 1
end

---@param values table<string, any>
---@param value any
---@return boolean
local function IsDeclaredValue(values, value)
    for _, declared in pairs(values) do
        if declared == value then return true end
    end

    return false
end

---Fill the options from the slot data, falling back to the declared defaults
---@param slot_options table<string, any>|nil
function Options:Load(slot_options)
    slot_options = slot_options or {}

    for key, spec in pairs(self.SPEC) do
        local received = slot_options[key]

        if received == nil then
            Logger:warn(("Option %q missing from slot data, using default"):format(key))
            received = spec.default
        end

        local value = received
        if spec.toggle then
            value = ToBoolean(received)
        end

        if spec.values ~= nil and not IsDeclaredValue(spec.values, value) then
            Logger:error(("Option %q got the unknown value %s, using default")
                :format(key, tostring(value)))
            value = spec.default
        end

        rawset(self.values, key, value)
    end

    for key in pairs(slot_options) do
        if self.SPEC[key] == nil then
            Logger:warn(("Slot data carries option %q, which the mod ignores"):format(key))
        end
    end
end

---@param key string
---@return boolean
function Options:IsEnabled(key)
    local spec = self.SPEC[key]
    if spec == nil or not spec.toggle then
        Logger:error("IsEnabled called on non toggle option: " .. tostring(key))
        return false
    end

    return self.values[key] == true
end

return Options