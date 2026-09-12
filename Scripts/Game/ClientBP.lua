---@class ClientBP
local ClientBP = {}

local last_logs = {}
local cachedHelper = nil
local LEVEL_NAME_TTL = 0.5

local cachedLevelName = ""
local cachedLevelNameAt = -1

function ClientBP:GetHelper()
    if cachedHelper ~= nil and cachedHelper:IsValid() then
        return cachedHelper
    end

    local helper = FindFirstOf(CONSTANTS.BLUEPRINT.AP_HELPER) ---@type ABP_ArchipelagoHelper_C
    if helper ~= nil and helper:IsValid() then
        cachedHelper = helper
        return helper
    end

    cachedHelper = nil
    return nil
end

function ClientBP:CallHelper(method, ...)
    local args = { ... }

    local function Try()
        local helper = self:GetHelper() ---@cast helper ABP_ArchipelagoHelper_C
        if helper == nil then return false end

        return pcall(function() helper[method](helper, table.unpack(args)) end)
    end

    if Try() then return true end

    cachedHelper = nil

    if Try() then return true end

    Logger:warn("Helper call failed twice: " .. method)

    return false
end

---@param classification integer
---@return any|nil icon nil when the helper actor is gone
function ClientBP:GetAPIcon(classification)
    local helper = self:GetHelper() ---@cast helper ABP_ArchipelagoHelper_C
    if helper == nil then return nil end

    local ok, icon = pcall(function() return helper.IconAP:Find(classification):get() end)
    if not ok then
        cachedHelper = nil
        return nil
    end

    return icon
end

---@return any|nil texture nil when the helper actor is gone
function ClientBP:GetSaveIconTexture()
    local helper = self:GetHelper() ---@cast helper ABP_ArchipelagoHelper_C
    if helper == nil then return nil end

    local ok, texture = pcall(function() return helper.BaguetteTexture end)
    if not ok then
        cachedHelper = nil
        return nil
    end

    return texture
end

function ClientBP:GetWBPConnectionSettings()
    local helper = FindFirstOf(CONSTANTS.BLUEPRINT.WBP_AP_SETTINGS) ---@type UWBP_AP_ConnectionSettings_C
    if helper ~= nil and helper:IsValid() then
        return helper
    end

    return nil
end

--- Not used yet
---@param message string The styled string
function ClientBP:PushToLogger(message)
    table.insert(last_logs, message)
    if #last_logs > 10 then
        table.remove(last_logs, 1)
    end

    self:CallHelper("AddToLogger", message)
end

function ClientBP:FeetTrap()
    self:CallHelper("FeetTrap")
end

function ClientBP:IsMainMenu()
    return self:IsLevel("Level_MainMenu")
end

function ClientBP:InLevel()
    return self:GetLevelName() ~= ""
end

function ClientBP:IsLevel(name)
    return self:GetLevelName() == name
end

function ClientBP:GetLevelName()
    local now = os.clock()
    if now - cachedLevelNameAt < LEVEL_NAME_TTL then
        return cachedLevelName
    end

    local world = UEHelpers.GetWorld()
    if world == nil or not world:IsValid() then
        return cachedLevelName
    end

    cachedLevelName = Trim(world:GetFName():ToString())
    cachedLevelNameAt = now

    return cachedLevelName
end

function ClientBP:IsInitialized()
    local a = self:GetHelper() ---@cast a ABP_ArchipelagoHelper_C

    return a ~= nil
end

function ClientBP:ToggleConsole()
    self:CallHelper("ToggleConsole")
end

function ClientBP:UpdateConnectionUI(status)
    ExecuteInGameThread(function()
        local statusEnum = E_CLIENT_INFOS[status]
        if statusEnum == nil then return end

        self:CallHelper("ChangeAPTextConnect", statusEnum)
        self:CallHelper("SetConnection", status == "CONNECTED")
    end)
end

RegisterCustomEvent("ModLoader_Initiation", function(ctx)
    if Archipelago:IsInitialized() then
        for _, message in ipairs(last_logs) do
            ClientBP:CallHelper("AddToLogger", message)
        end
    end
end)

RegisterCustomEvent("RefreshUIFromLua", function (ctx)
    ClientBP:UpdateConnectionUI(ArchipelagoSystem:IsConnected() and "CONNECTED" or "DISCONNECTED")

    local wbp_settings = ClientBP:GetWBPConnectionSettings()
    if wbp_settings ~= nil then
        wbp_settings.TextVersion:SetText(FText(CONSTANTS.VERSION))
    end
end)

return ClientBP