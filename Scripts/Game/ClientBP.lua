---@class ClientBP
local ClientBP = {}

local BlueprintName = "BP_ArchipelagoHelper_C"
local last_logs = {}


function ClientBP:GetHelper()
    local helper = FindFirstOf(BlueprintName) ---@type ABP_ArchipelagoHelper_C

    if helper:IsValid() then
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

    if a == nil then
        return ""
    end

    local out = {}
    
    a:GetLevelName(out)
    
    if not out then return "" end
    return Trim(out["LevelName"]:ToString())
end

function ClientBP:IsInitialized()
    local a = self:GetHelper() ---@cast a ABP_ArchipelagoHelper_C

    return a ~= nil
end

function ClientBP:InCinematic()
    local a = FindFirstOf("BP_CinematicSystem_C") ---@type UBP_CinematicSystem_C
    if a == nil then return true end

    return a.IsPlayingCinematic
end

function ClientBP:ToggleConsole()
    local helper = self:GetHelper() ---@cast helper ABP_ArchipelagoHelper_C

    helper:ToggleConsole()
end


RegisterCustomEvent("ModLoader_Initiation", function(ctx)
   if Archipelago:IsInitialized() then
        for _, message in ipairs(last_logs) do
            ClientBP:PushToLogger(message)
        end
   end
end)

return ClientBP