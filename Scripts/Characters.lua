local Characters = {}

local BluePrintName = "AC_jRPG_CharactersManager_C"
local Characters_name = {"Frey", "Maelle", "Lune", "Sciel", "Verso", "Monoco" }
local weapons_characters = {"Noahram", "Maellum", "Lunerim", "Scieleson", "Verleso", "Monocaro" }

function Characters:GetManager()
    local manager = FindFirstOf(BluePrintName)

    if manager ~= nil and manager:IsValid() then
        Logger:info("Retrieving Characters manager succeeds")
        return manager
    else
        Logger:error("Retrieving Characters manager fails")
        return nil
    end
end

function Characters:RemoveCharacterFromParty(name)
    ---@class UAC_jRPG_CharactersManager_C
    local manager = self:GetManager() ---@cast manager UAC_jRPG_CharactersManager_C

    if manager == nil then return end

    local fname = FName(name)
    manager:RemoveCharacterFromParty(fname)
end


function Characters:AddCharacter(name)
    Logger:info("Adding character to party: " .. name)
    local helper = ClientBP:GetHelper() ---@cast helper ABP_ArchipelagoHelper_C

    local found = {}
    local struct = {}
    local fname = FName(name)
    -- Logger:callMethod(helper, "AddCharacterToCollectionFromHardcodedName", fname, found, struct)
    AddingCharacterFromArchipelago = true
    helper:AddCharacterToCollectionFromHardcodedName(fname, found, struct)
end

function Characters:AddEveryone()
    Logger:info("Adding everyone to party...")

    for i, char in ipairs(Characters_name) do
        Inventory:AddItem(weapons_characters[i], 1, 1)
        self:AddCharacter(char)
    end


    Logger:info("Setting everyone to level 1...")
    local char_data = FindAllOf("BP_CharacterData_C") ---@type UBP_CharacterData_C[]
    if char_data == nil then return end
    for _, char in ipairs(char_data) do
        char:SetLevel(1)
        char.IsExcluded = true
    end
end


function Characters:EnableCharacter(name)
    local maxlevel = Characters:GetMaxLevel()
    print("Max level is " .. maxlevel)
    local level_char = maxlevel > 5 and maxlevel - 5 or maxlevel
    local helper = self:GetManager() ---@cast helper UAC_jRPG_CharactersManager_C

    local char_data = FindAllOf("BP_CharacterData_C") ---@type UBP_CharacterData_C[]
    if char_data == nil then return end

    for _, char in ipairs(char_data) do
        if char.HardcodedNameID:ToString() == name then
            char.IsExcluded = false
            Logger:info("Setting character " .. name .. " to level " .. level_char)
            char:SetLevel(level_char)
            helper:AddCharacterToParty(FName(name))
        end
    end
end

function Characters:EnableOnlyUnlockedCharacters()
    local char_data = FindAllOf("BP_CharacterData_C") ---@type UBP_CharacterData_C[]
    if char_data == nil then return end

    -- Do it twice because if the first char is in the party and the only one AND the it's the first in the list, it won't be removed
    for i = 1, 2, 1 do
        for _, char in ipairs(char_data) do
            local name = char.HardcodedNameID:ToString()
            if Contains(Storage.characters, name) then
                self:EnableCharacter(name)
            else
                self:EnableInParty(name, false)
            end
        end
    end
end

function Characters:EnableCharactersInPartyOnlyUnlocked()
    Logger:info("Enabling characters in party only if unlocked...")

    for _, char in ipairs(Characters_name) do
        if Contains(Storage.characters, char) then
            self:EnableInParty(char, true)
        end
    end
end

function Characters:DisableEveryoneFromParty()
    Logger:info("Disabling everyone from party...")

    for _, char in ipairs(Characters_name) do
        self:EnableInParty(char, false)
    end
end

function Characters:EnableInParty(name, enable)
    local helper = self:GetManager() ---@cast helper UAC_jRPG_CharactersManager_C
    if helper == nil then return end

    local fname = FName(name)
    if enable then
        helper:AddCharacterToParty(fname)
    else
        helper:RemoveCharacterFromParty(fname)
    end
end

function Characters:KillAll()
    Logger:info("Killing all characters...")
    self:SetHPAll(0)
end

function Characters:SetHPAll(hp)
    Logger:info("Setting all characters' HP to " .. hp .. "...")
    local helper = self:GetManager() ---@cast helper UAC_jRPG_CharactersManager_C
    if helper == nil then return end

    for _, char in ipairs(Characters_name) do
        local fname = FName(char)
        helper:SetCharacterHP(fname, hp)
    end
end

function Characters:GetMeanLevel()
    local char_data = FindAllOf("BP_CharacterData_C") ---@type UBP_CharacterData_C[]
    if char_data == nil then return 1 end

    local s = 0;
    for _, char in ipairs(char_data) do
        s = s + char.CurrentLevel
    end

    return math.ceil(s / #char_data)
end

function Characters:GetMaxLevel()
    local char_data = FindAllOf("BP_CharacterData_C") ---@type UBP_CharacterData_C[]
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


return Characters