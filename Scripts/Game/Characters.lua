---@class Characters
local Characters = {}

--- Return the Characters manager
---@return UAC_jRPG_CharactersManager_C | nil
function Characters:GetManager()
    local manager = FindFirstOf(CONSTANTS.BLUEPRINT.CHARACTERS_MANAGER) ---@cast manager UAC_jRPG_CharactersManager_C

    if manager ~= nil and manager:IsValid() then
        Logger:info("Retrieving Characters manager succeeds")
        return manager
    else
        Logger:error("Retrieving Characters manager fails")
        return nil
    end
end

--- Remove a character from the party
---@param name any
function Characters:RemoveCharacterFromParty(name)
    ---@class UAC_jRPG_CharactersManager_C
    local manager = self:GetManager() ---@cast manager UAC_jRPG_CharactersManager_C

    if manager == nil then return end

    local fname = FName(name)
    Logger:callMethod(manager, "RemoveCharacterFromParty", fname)
end

--- Add a character to the collection
---@param name any
function Characters:AddCharacter(name)
    Logger:info("Adding character to party: " .. name)
    local helper = ClientBP:GetHelper() ---@cast helper ABP_ArchipelagoHelper_C

    local found = {}
    local struct = {}
    local fname = FName(name)
    AddingCharacterFromArchipelago = true
    Logger:callMethod(helper, "AddCharacterToCollectionFromHardcodedName", fname, found, struct)
end

function Characters:AddEveryone()
    Logger:info("Adding everyone to party...")

    for i, char in ipairs(CONSTANTS.GAME.TABLE.CHARACTERS_ID) do
        Inventory:AddItem(CONSTANTS.GAME.TABLE.CHARACTERS_WEAPONS[i], 1, 1)
        self:AddCharacter(char)
    end


    Logger:info("Setting everyone to level 1...")
    local char_data = FindAllOf(CONSTANTS.BLUEPRINT.CHARACTERS_DATA) ---@cast char_data UBP_CharacterData_C[]
    if char_data == nil then return end
    for _, char in ipairs(char_data) do
        Logger:callMethod(char, "SetLevel", 1)
        char.IsExcluded = true
    end
end

--- Enable a character when receiving it (remove the exclusion and set its level to maxlevel-5 or 1)
---@param name string
function Characters:EnableCharacter(name)
    local maxlevel = Characters:GetMaxLevel()
    local level_char = maxlevel > 5 and maxlevel - 5 or maxlevel
    local helper = self:GetManager() ---@cast helper UAC_jRPG_CharactersManager_C

    local char_data = FindAllOf(CONSTANTS.BLUEPRINT.CHARACTERS_DATA) ---@cast char_data UBP_CharacterData_C[]
    if char_data == nil then return end

    for _, char in ipairs(char_data) do
        if char.HardcodedNameID:ToString() == name and char.IsExcluded then
            char.IsExcluded = false
            Logger:info("Setting character " .. name .. " to level " .. level_char)
            Logger:callMethod(char, "SetLevel", level_char)
            Logger:callMethod(helper, "AddCharacterToParty", FName(name))
        end
    end
end

function Characters:SetExcludedCharacterByName(name, locked)
    local char_data = FindAllOf(CONSTANTS.BLUEPRINT.CHARACTERS_DATA) ---@cast char_data UBP_CharacterData_C[]
    if char_data == nil then return end

    for _, char in ipairs(char_data) do
        if char.HardcodedNameID:ToString() == name and char.IsExcluded then
            char.IsExcluded = locked
        end
    end
end

function Characters:UnlockCharacter(name)
    self:SetExcludedCharacterByName(name, false)
end

function Characters:LockCharacter(name)
    self:SetExcludedCharacterByName(name, true)
end

--- Count the number of enabled characters (not excluded)
---@return integer 
function Characters:NumberOfEnabledCharacters()
    local enabled_count = 0
    local char_data = FindAllOf(CONSTANTS.BLUEPRINT.CHARACTERS_DATA) ---@cast char_data UBP_CharacterData_C[]
    if char_data == nil then return enabled_count end

    for _, char in ipairs(char_data) do
        if not char.IsExcluded then
            enabled_count = enabled_count + 1
        end
    end

    return enabled_count
end

--- Removing from battle team all excluded characters
function Characters:DisableInPartyExcludedCharacters()
    local char_data = FindAllOf(CONSTANTS.BLUEPRINT.CHARACTERS_DATA) ---@cast char_data UBP_CharacterData_C[]
    if char_data == nil then return end

    for _, char in ipairs(char_data) do
        if char.IsExcluded then
            self:EnableInParty(char.HardcodedNameID:ToString(), false)
        end
    end
end

--- Count the number of characters in battle team, separated by enabled and excluded
--- TODO: Renaming function
---@return integer 
---@return integer
function Characters:NumberOfCharactersInPartyEnabled()
    local in_party_count = 0
    local not_in_party_count = 0
    local char_data = FindAllOf(CONSTANTS.BLUEPRINT.CHARACTERS_DATA) ---@cast char_data UBP_CharacterData_C[]
    local helper = FindFirstOf("BP_jRPG_GI_Custom_C") ---@cast helper UBP_jRPG_GI_Custom_C
    if char_data == nil then return 0, 0 end

    for _, char in ipairs(char_data) do
        local in_party = Logger:callMethod(helper, "IsCharacterInParty", char.HardcodedNameID)
        if not char.IsExcluded and in_party then
            in_party_count = in_party_count + 1
        elseif char.IsExcluded and in_party then
            not_in_party_count = not_in_party_count + 1
        end
    end

    return in_party_count, not_in_party_count
end

--- Ensure that the battle team is correct: no excluded characters, at least one enabled character
function Characters:ModifyPartyIfNeeded()
    local helper = FindFirstOf("BP_jRPG_GI_Custom_C") ---@cast helper UBP_jRPG_GI_Custom_C
    if not helper or not helper:IsValid() then return end

    local locked_in_party = {}
    local unlocked_in_party = {}
    local unlocked_not_in_party = {}

    for _, char_id in ipairs(CONSTANTS.GAME.TABLE.CHARACTERS_ID) do
        local in_party = Logger:callMethod(helper, "IsCharacterInParty", FName(char_id))
        local is_unlocked = Storage:IsCharacterUnlocked(char_id)

        self:SetExcludedCharacterByName(char_id, not is_unlocked)
        if in_party then
            if is_unlocked then
                table.insert(unlocked_in_party, char_id)
            else
                table.insert(locked_in_party, char_id)
            end
        else
            if is_unlocked then
                table.insert(unlocked_not_in_party, char_id)
            end
        end
    end

    local added = 0
    -- Si aucun personnage non exclu est dans la party, en rajouter au maximum 3 (toujours non exclu)
    if #unlocked_in_party == 0 then
        Logger:info("No enabled characters in party, adding up to 3 unlocked ones...")
        for _, char_id in ipairs(unlocked_not_in_party) do
            if added >= 3 then break end
            self:EnableInParty(char_id, true)
            added = added + 1
        end
    end

    -- Si au moins un personnage exclus est dans la party, l'enlever.
    if #locked_in_party > 0 then
        Logger:info("Found " .. #locked_in_party .. " excluded characters in party, removing them...")
        if #unlocked_in_party > 0 or added > 0 then
            for _, char_id in ipairs(locked_in_party) do
                self:EnableInParty(char_id, false)
            end
        else
            Logger:warn("Cannot remove locked characters because there are NO unlocked characters available to take their place!")
        end
    end

    -- Si aucun des personnages exclus et au moins un personnage non exclu est dans la party, ne rien faire
    -- (This happens naturally if the two above conditions are false)
end


--- Enable in party only the characters that are unlocked
function Characters:EnableCharactersInPartyOnlyUnlocked()
    -- Redirect to the exact same logic
    self:ModifyPartyIfNeeded()
end

function Characters:EnableCharactersInCollectionOnlyUnlocked()
    local char_data = FindAllOf(CONSTANTS.BLUEPRINT.CHARACTERS_DATA) ---@cast char_data UBP_CharacterData_C[]
    if char_data == nil then return end
    if Characters:HasExcludedCharactersInCollection() then return end

    Logger:info("Enabling characters in collection only if unlocked...")

    for _, char in ipairs(char_data) do
        local char_name = char.HardcodedNameID:ToString()
        if Storage:IsCharacterUnlocked(char_name) then
            char.IsExcluded = false
        else
            char.IsExcluded = true
        end
    end
end

function Characters:HasExcludedCharactersInCollection()
    local char_data = FindAllOf(CONSTANTS.BLUEPRINT.CHARACTERS_DATA) ---@cast char_data UBP_CharacterData_C[]
    if char_data == nil then return false end

    for _, char in ipairs(char_data) do
        local char_name = char.HardcodedNameID:ToString()
        if char.IsExcluded and Storage:IsCharacterUnlocked(char_name) then
            return true
        end

        if not char.IsExcluded and not Storage:IsCharacterUnlocked(char_name) then
            return true
        end
    end

    return false
end

--- Disable everyone from the party
function Characters:DisableEveryoneFromParty()
    Logger:info("Disabling everyone from party...")

    for _, char in ipairs(CONSTANTS.GAME.TABLE.CHARACTERS_ID) do
        self:EnableInParty(char, false)
    end
end

--- Enable or disable a specific character in the party
--- @param name string the internal name of the character
--- @param enable boolean true to enable, false to disable
function Characters:EnableInParty(name, enable)
    local helper = self:GetManager() ---@cast helper UAC_jRPG_CharactersManager_C
    if helper == nil then return end

    local fname = FName(name)
    if enable then
        Logger:callMethod(helper, "AddCharacterToParty", fname)
        -- helper:AddCharacterToParty(fname)
    else
        Logger:callMethod(helper, "RemoveCharacterFromParty", fname)
        -- helper:RemoveCharacterFromParty(fname)
    end
end

--- Kill all characters (set their HP to 0)
function Characters:KillAll()
    Logger:info("Killing all characters...")
    local bm = Battle:GetManager() --- @cast bm UAC_jRPG_BattleManager_C

    bm:ForceBattleEnd(2)
end

--- Set the HP of all characters to a specific value
---@param hp integer the HP value to set
function Characters:SetHPAll(hp)
    Logger:info("Setting all characters' HP to " .. hp .. "...")
    local helper = self:GetManager() ---@cast helper UAC_jRPG_CharactersManager_C
    if helper == nil then return end

    for _, char in ipairs(CONSTANTS.GAME.TABLE.CHARACTERS_ID) do
        local fname = FName(char)
        Logger:callMethod(helper, "SetCharacterHP", fname, hp)
        -- helper:SetCharacterHP(fname, hp)
    end
end

function Characters:HealEveryone()
    Logger:info("Healing every characters...")
    local helper = self:GetManager() ---@cast helper UAC_jRPG_CharactersManager_C
    if helper == nil then return end

    for _, char in ipairs(CONSTANTS.GAME.TABLE.CHARACTERS_ID) do
        local fname = FName(char)
        Logger:callMethod(helper, "RestoreHP", fname, 9999999)
    end
end

--- Get the mean level of all characters
---@return integer
function Characters:GetMeanLevel()
    local char_data = FindAllOf(CONSTANTS.BLUEPRINT.CHARACTERS_DATA) ---@cast char_data UBP_CharacterData_C[]
    if char_data == nil then return 1 end

    local s = 0;
    for _, char in ipairs(char_data) do
        s = s + char.CurrentLevel
    end

    return math.ceil(s / #char_data)
end

--- Get the max level of all characters
--- @return integer
function Characters:GetMaxLevel()
    local char_data = FindAllOf(CONSTANTS.BLUEPRINT.CHARACTERS_DATA) ---@cast char_data UBP_CharacterData_C[]
    if char_data == nil then return 1 end

    local max = 1;
    for _, char in ipairs(char_data) do
        if char.IsExcluded then goto continue end

        local current_level = char.CurrentLevel
        if current_level > max then
            max = current_level
        end

        ::continue::
    end

    return max
end

--- Return the characterdata from the internal ID
---@param name string The internal name of the character
---@return UBP_CharacterData_C | nil
function Characters:GetCharacterDataByID(name)
    local char_data = FindAllOf(CONSTANTS.BLUEPRINT.CHARACTERS_DATA) ---@cast char_data UBP_CharacterData_C[]
    if char_data == nil then return nil end

    for _, char in ipairs(char_data) do
        if char.HardcodedNameID:ToString() == name then
            return char
        end
    end

    return nil
end

return Characters