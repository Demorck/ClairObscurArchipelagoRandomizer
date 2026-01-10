---Manages persistent game state with schema-based validation
local StorageSchema = require("Storage.StorageSchema")

---@class Storage
---@field schema StorageSchema
---@field data table
local Storage = {}

-- Internal data storage
Storage.schema = StorageSchema
Storage.data = {}

---Initialize storage with default values from schema
function Storage:Initialize()
    self.data = {}

    for fieldName, _ in pairs(self.schema.fields) do
        self.data[fieldName] = self.schema:GetDefaultValue(fieldName)
    end

    self.data.initialized = false
end

---Validate a value against the schema
---@param key string Field name
---@param value any Value to validate
---@return boolean isValid True if valid
---@return string|nil errorMessage Error message if invalid
function Storage:Validate(key, value)
    return self.schema:Validate(key, value)
end

---Get a value from storage
---@param key string Field name
---@return any value The stored value, or nil if key doesn't exist
function Storage:Get(key)
    if self.schema.fields[key] == nil then
        Logger:warn("Attempted to get unknown storage key: " .. key)
        return nil
    end
    return self.data[key]
end

---Set a value in storage with validation
---@param key string Field name
---@param value any Value to set
---@return boolean success True if value was set successfully
function Storage:Set(key, value)
    local isValid, errorMessage = self:Validate(key, value)

    if not isValid then
        Logger:error("Storage validation failed: " .. (errorMessage or "unknown error"))
        return false
    end

    self.data[key] = value
    return true
end

function Storage:Increment(key)
    if self.schema.fields[key] == nil then
        Logger:warn("Attempted to increment unknown storage key: " .. key)
        return
    end

    if self.data[key] == nil then
        self.data[key] = 0
    end

    self.data[key] = self.data[key] + 1
end

---Get all storage data (for debugging or serialization)
---@return table data All storage data
function Storage:GetAll()
    return self.data
end

---Load storage from JSON file
function Storage:Load()
    local file = JSON.read_file(Storage:GetFilePath())

    if file ~= nil then
        -- Load each field from file using schema
        for fieldName, _ in pairs(self.schema.fields) do
            local jsonKey = self.schema:GetJsonKey(fieldName)
            local value = file[jsonKey]

            if value ~= nil then
                -- Validate and set the value
                local isValid, errorMessage = self:Validate(fieldName, value)
                if isValid then
                    self.data[fieldName] = value
                else
                    Logger:warn(string.format(
                        "Invalid value in save file for '%s': %s. Using default.",
                        fieldName, errorMessage or "unknown error"
                    ))
                    self.data[fieldName] = self.schema:GetDefaultValue(fieldName)
                end
            else
                -- Use default value if not in file
                self.data[fieldName] = self.schema:GetDefaultValue(fieldName)
            end
        end

        Logger:info("Storage loaded from " .. Storage:GetFilePath())
        Logger:info("Last received item index: " .. self.data.lastReceivedItemIndex)
        Logger:info("Last saved item index: " .. self.data.lastSavedItemIndex)
        Logger:info("Pictos index: " .. self.data.pictosIndex)
        Logger:info("Weapons index: " .. self.data.weaponsIndex)
        Logger:info("Lumiere done: " .. tostring(self.data.initialized_after_lumiere))
        Logger:info("Tickets: " .. Dump(self.data.tickets))
        Logger:info("Characters: " .. Dump(self.data.characters))
        Logger:info("Free Aim unlocked: " .. tostring(self.data.free_aim_unlocked))
        Logger:info("Number of gestral rescued: " .. self.data.gestral_found)
    else
        Storage:Update("Storage:Load - New file")
    end

    self.data.initialized = true
end

---Save storage to JSON file
---@param from string|nil Source of the update (for logging)
function Storage:Update(from)
    local player = Archipelago:GetPlayer()

    if not (player["seed"] and player["slot"]) then
        return
    end

    -- Build the values table using schema
    local values = {
        from = from or "Storage:Update"
    }

    for fieldName, _ in pairs(self.schema.fields) do
        -- Skip 'initialized' and 'transition_lumiere' as they're not persisted
        if fieldName ~= "initialized" and fieldName ~= "transition_lumiere" then
            local jsonKey = self.schema:GetJsonKey(fieldName)
            values[jsonKey] = self.data[fieldName]
        end
    end

    JSON.write_file(Storage:GetFilePath(), values)
end

---Get the file path for storage
---@return string filepath Path to the storage JSON file
function Storage:GetFilePath()
    local player = Archipelago:GetPlayer()
    return player["seed"] .. "_" .. player["slot"] .. ".json"
end

-- Setup metatable for backward compatibility
-- Allows direct access like Storage.tickets instead of Storage:Get("tickets")
setmetatable(Storage, {
    __index = function(t, key)
        -- Allow access to methods and special fields
        if key == "data" or key == "schema" or key == "Initialize" or
           key == "Validate" or key == "Get" or key == "Set" or
           key == "GetAll" or key == "Load" or key == "Update" or
           key == "GetFilePath" then
            return rawget(t, key)
        end

        -- For data fields, use Get method
        if t.schema.fields[key] then
            return t.data[key]
        end

        return rawget(t, key)
    end,

    __newindex = function(t, key, value)
        -- Allow direct setting of special fields
        if key == "data" or key == "schema" then
            rawset(t, key, value)
            return
        end

        -- For data fields, use Set method
        if t.schema.fields[key] then
            t:Set(key, value)
        else
            rawset(t, key, value)
        end
    end
})

-- Initialize storage with default values
Storage:Initialize()

return Storage
