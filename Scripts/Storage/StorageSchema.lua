---Storage Schema Definition
---Defines the structure, types, default values, and validation rules for Storage
---@class StorageSchema
local StorageSchema = {}

---@class FieldSchema
---@field type string Type of the field: "number", "boolean", "string", "table"
---@field default any Default value for the field
---@field jsonKey string|nil Optional JSON key name (if different from internal name)
---@field validator function|nil Optional validation function

---Schema definition for all storage fields
---@type table<string, FieldSchema>
StorageSchema.fields = {
    -- Initialization flags
    initialized = {
        type = "boolean",
        default = false,
    },

    initialized_after_lumiere = {
        type = "boolean",
        default = false,
        jsonKey = "lumiere_done"
    },

    transition_lumiere = {
        type = "boolean",
        default = false,
    },

    -- Item tracking indices
    lastReceivedItemIndex = {
        type = "number",
        default = -1,
        jsonKey = "last_received",
        validator = function(value)
            return value >= -1
        end
    },

    lastSavedItemIndex = {
        type = "number",
        default = -1,
        jsonKey = "last_saved",
        validator = function(value)
            return value >= -1
        end
    },

    pictosIndex = {
        type = "number",
        default = -1,
        jsonKey = "pictos_index",
        validator = function(value)
            return value >= -1
        end
    },

    weaponsIndex = {
        type = "number",
        default = -1,
        jsonKey = "weapons_index",
        validator = function(value)
            return value >= -1
        end
    },

    -- Game progress counters
    dive_items = {
        type = "number",
        default = 0,
        validator = function(value)
            return value >= 0
        end
    },

    gestral_found = {
        type = "number",
        default = 0,
        validator = function(value)
            return value >= 0
        end
    },

    -- Boolean flags
    free_aim_unlocked = {
        type = "boolean",
        default = false,
    },

    -- Location tracking
    currentLocation = {
        type = "string",
        default = "None",
    },

    -- Complex data structures (tables)
    tickets = {
        type = "table",
        default = {
            GoblusLair                       = false,
            AncientSanctuary                 = false,
            SideLevel_RedForest              = false,
            EsquieNest                       = false,
            SideLevel_OrangeForest           = false,
            SideLevel_CleasFlyingHouse       = false,
            ForgottenBattlefield             = false,
            SidelLevel_FrozenHearts          = false,
            GestralVillage                   = false,
            MonocoStation                    = false,
            Lumiere                          = false,
            Monolith_Interior_PaintressIntro = false,
            OldLumiere                       = false,
            SideLevel_Reacher                = false,
            SideLevel_AxonPath               = false,
            SeaCliff                         = false,
            Sirene                           = false,
            SideLevel_TwilightSanctuary      = false,
            Visages                          = false,
            SideLevel_YellowForest           = false,
            SideLevel_CleasTower_Entrance    = false,
            SideLevel_VersosDraft            = false,
        }
    },

    characters = {
        type = "table",
        default = {
            Frey   = false,
            Maelle = false,
            Lune   = false,
            Sciel  = false,
            Verso  = false,
            Monoco = false
        }
    },

    progressive_rock = {
        type = "number",
        default = 0,
        validator = function (value)
            return value >= 0 and value <= 5
        end
    },
}

---Get the JSON key for a field (or use the field name if no jsonKey is defined)
---@param fieldName string Internal field name
---@return string jsonKey The key to use in JSON serialization
function StorageSchema:GetJsonKey(fieldName)
    local field = self.fields[fieldName]
    if not field then
        return fieldName
    end
    return field.jsonKey or fieldName
end

---Get the internal field name from a JSON key
---@param jsonKey string JSON key name
---@return string|nil fieldName Internal field name, or nil if not found
function StorageSchema:GetFieldName(jsonKey)
    for fieldName, field in pairs(self.fields) do
        local key = field.jsonKey or fieldName
        if key == jsonKey then
            return fieldName
        end
    end
    return nil
end

---Deep copy a table (for default values)
---@param orig table Original table to copy
---@return table copy Deep copy of the table
local function deepCopy(orig)
    local copy
    if type(orig) == 'table' then
        copy = {}
        for k, v in pairs(orig) do
            copy[k] = deepCopy(v)
        end
    else
        copy = orig
    end
    return copy
end

---Get the default value for a field (with deep copy for tables)
---@param fieldName string Field name
---@return any defaultValue Default value for the field
function StorageSchema:GetDefaultValue(fieldName)
    local field = self.fields[fieldName]
    if not field then
        return nil
    end

    -- Deep copy tables to avoid shared references
    if field.type == "table" then
        return deepCopy(field.default)
    end

    return field.default
end

---Validate a value against the schema
---@param fieldName string Field name
---@param value any Value to validate
---@return boolean isValid True if valid
---@return string|nil errorMessage Error message if invalid
function StorageSchema:Validate(fieldName, value)
    local field = self.fields[fieldName]

    -- Check if field exists in schema
    if not field then
        return false, "Field '" .. fieldName .. "' does not exist in schema"
    end

    -- Check type
    local valueType = type(value)
    if valueType ~= field.type then
        return false, string.format(
            "Type mismatch for field '%s': expected %s, got %s",
            fieldName, field.type, valueType
        )
    end

    -- Run custom validator if present
    if field.validator then
        local isValid = field.validator(value)
        if not isValid then
            return false, string.format(
                "Validation failed for field '%s' with value: %s",
                fieldName, tostring(value)
            )
        end
    end

    return true, nil
end

---Get all field names
---@return string[] fieldNames Array of all field names
function StorageSchema:GetAllFieldNames()
    local names = {}
    for fieldName, _ in pairs(self.fields) do
        table.insert(names, fieldName)
    end
    return names
end

return StorageSchema
