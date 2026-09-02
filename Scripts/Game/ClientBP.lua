---@class ClientBP
local ClientBP = {}

local last_logs = {}
local cachedHelper = nil

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
    local helper = self:GetHelper() ---@cast helper ABP_ArchipelagoHelper_C
    if helper == nil then return end
    helper:AddToLogger(message)
    table.insert(last_logs, message)
    if #last_logs > 10 then
        table.remove(last_logs, 1)
    end
end

function ClientBP:FeetTrap()
    local helper = self:GetHelper() ---@cast helper ABP_ArchipelagoHelper_C
    if helper == nil then return end

    Logger:callMethod(helper, "FeetTrap")
    -- helper:FeetTrap()
end

function ClientBP:IsMainMenu()
    return self:IsLevel("Level_MainMenu")
end

function ClientBP:InLevel()
    return self:GetLevelName() ~= ""
end

function ClientBP:IsLevel(name)
    local helper = self:GetHelper() ---@cast helper ABP_ArchipelagoHelper_C

    if helper ~= nil and helper:IsValid() then
        local levelName = self:GetLevelName()
        return levelName == name
    else
        return false
    end
end

function ClientBP:GetLevelName()
    local a = self:GetHelper() ---@cast a ABP_ArchipelagoHelper_C

    if a == nil or not a:IsValid() then
        return ""
    end

    local out = {}
    
    a:GetLevelName(out)
    
    if not out or not out["LevelName"] then return "" end
    return Trim(out["LevelName"]:ToString())
end

function ClientBP:IsInitialized()
    local a = self:GetHelper() ---@cast a ABP_ArchipelagoHelper_C

    return a ~= nil
end

function ClientBP:ToggleConsole()
    local helper = self:GetHelper() ---@cast helper ABP_ArchipelagoHelper_C

    helper:ToggleConsole()
end

function ClientBP:UpdateConnectionUI(status)
    ExecuteInGameThread(function()
        local helper = self:GetHelper() ---@cast helper ABP_ArchipelagoHelper_C
        if helper and helper:IsValid() then
            local statusEnum = E_CLIENT_INFOS[status]
            if statusEnum then
                helper:ChangeAPTextConnect(statusEnum)
                helper:SetConnection(status == "CONNECTED")
            end
        end
    end)
end

RegisterCustomEvent("ModLoader_Initiation", function(ctx)
    local helper = ClientBP:GetHelper()
    if helper == nil then return end

    if Archipelago:IsInitialized() then
        for _, message in ipairs(last_logs) do
            helper:AddToLogger(message)
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