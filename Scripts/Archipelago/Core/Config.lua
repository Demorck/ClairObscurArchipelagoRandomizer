---@class ConfigDefaults
---@field host string Server host and port
---@field port string Server port (deprecated, use host)
---@field slot string Player slot name
---@field password string Slot password
---@field gameName string Game name for AP
---@field itemsHandling integer Items handling flags
---@field tags string[] AP tags (e.g., DeathLink)
---@field version integer[] AP client version [major, minor, patch]
---@field deathlink boolean Whether DeathLink is enabled
---@field colors table<string, string> UI color codes
---@field messageFormat any Message rendering format

---@class Config
---@field defaults ConfigDefaults Default configuration values
---@field current ConfigDefaults Current active configuration
local Config = {}


-- Default configuration
Config.defaults = {
    -- Connection
    host     = "",
    port     = "",
    slot     = "bebou",
    password = "",

    -- AP configuration
    gameName      = "Clair Obscur Expedition 33",
    itemsHandling = 7,
    tags          = { "Lua-APClientPP" },
    version       = {0, 5, 4},

    -- Features
    deathlink = false,

    -- UI Colors 
    colors = {
        currentPlayer = "EE00EE",
        otherPlayer   = "FAFAD2",
        progression   = "AF99EF",
        useful        = "6D8BE8",
        filler        = "00EEEE",
        trap          = "FA8072",
        location      = "00FF7F",
        entrance      = "6495ED"
    },

    messageFormat = nil
}


Config.current = {}

---Initialize configuration with default values
function Config:Init()
    self.current = self:DeepCopy(self.defaults)

    local apclientpp = require("lua-apclientpp")
    self.current.messageFormat = apclientpp.RenderFormat.TEXT
end


---Update multiple configuration values at once
---@param updates table<string, any> Key-value pairs to update
function Config:Update(updates)
    for key, value in pairs(updates) do
        if self.current[key] ~= nil then
            self.current[key] = value
        else
            Logger:warn("Unknown config key: " .. key)
        end
    end
end

---Get a configuration value
---@param key string Configuration key
---@return any value The configuration value
function Config:Get(key)
    return self.current[key]
end

---Set a single configuration value
---@param key string Configuration key
---@param value any Value to set
function Config:Set(key, value)
    if self.current[key] == nil then
        Logger:warn("Setting unknown config key: " .. key)
    end

    self.current[key] = value
end

---Set connection parameters all at once
---@param host string Server host (without port)
---@param port string Server port
---@param slot string Player slot name
---@param password string Slot password
---@param deathlink boolean Whether to enable DeathLink
function Config:SetConnection(host, port, slot, password, deathlink)
    self.current.host = host .. ":" .. port
    self.current.slot = slot
    self.current.password = password
    self.current.deathlink = deathlink

    self:UpdateDeathLinkTag(deathlink)
end


---Update the DeathLink tag in the tags array
---Adds or removes "DeathLink" from tags based on enabled state
---@param enabled boolean Whether DeathLink should be enabled
---@private
function Config:UpdateDeathLinkTag(enabled)
    local tags = self.current.tags
    local hasDeathLink = false
    local deathLinkIndex = nil

    for i, tag in ipairs(tags) do
        if tag == "DeathLink" then
            hasDeathLink = true
            deathLinkIndex = i
            break
        end
    end

    if enabled and not hasDeathLink then
        table.insert(tags, "DeathLink")
    elseif not enabled and hasDeathLink then
        table.remove(tags, deathLinkIndex)
    end
end


---Deep copy a table recursively
---@param orig table The table to copy
---@return table copy Deep copy of the table
---@private
function Config:DeepCopy(orig)
    local copy
    if type(orig) == 'table' then
        copy = {}
        for k, v in pairs(orig) do
            copy[k] = self:DeepCopy(v)
        end
    else
        copy = orig
    end
    return copy
end

return Config