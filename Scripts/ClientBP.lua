local ClientBP = {}

local BlueprintName = "BP_ArchipelagoHelper_C"


function ClientBP:GetHelper()
    local helper = FindFirstOf(BlueprintName) ---@type ABP_ArchipelagoHelper_C

    if helper:IsValid() then
        return helper
    end

    return nil
end

--- Not used yet
---@param item integer
---@param player integer
function ClientBP:PushNotification(item, player)
    local helper = self:GetHelper() ---@cast helper ABP_ArchipelagoHelper_C
    if helper == nil then return end
    helper:AddToLogger(tostring(item), tostring(player))
end

function ClientBP:FeetTrap()
    local helper = self:GetHelper() ---@cast helper ABP_ArchipelagoHelper_C
    if helper == nil then return end

    helper:FeetTrap()
end

function ClientBP:IsMainMenu()
    return self:IsLevel("Level_MainMenu")
end

function ClientBP:IsLumiereActI()
    return self:IsLevel("Level_Lumiere_Main_V2")
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

return ClientBP