local Characters = {}

local BluePrintName = "AC_jRPG_CharactersManager_C"
local Characters_name = {"Frey", "Maelle", "Lune", "Sciel", "Verso", "Monoco" }

local helper_bp = "BP_ArchipelagoHelper_C"

function Characters:RemoveCharacterFromParty(name)
    ---@class UAC_jRPG_CharactersManager_C
    local manager = FindFirstOf(BluePrintName)

    local fname = FName(name)
    manager:RemoveCharacterFromParty(fname)
end


function Characters:AddCharacter(name)
    Logger:info("Adding character to party: " .. name)
    local helper = FindFirstOf(helper_bp) ---@type ABP_ArchipelagoHelper_C

    local found = {}
    local struct = {}
    local fname = FName(name)
    Logger:callMethod(helper, "AddCharacterToCollectionFromHardcodedName", fname, found, struct)
end

function Characters:AddEveryone()
    Logger:info("Adding everyone to party...")
    for _, char in ipairs(Characters_name) do
        self:AddCharacter(char)
    end
end


function Characters:KillAll()
    Logger:info("Killing all characters...")
    self:SetHPAll(0)
end

function Characters:SetHPAll(hp)
    Logger:info("Setting all characters' HP to " .. hp .. "...")
    local helper = FindFirstOf(BluePrintName) ---@cast helper UAC_jRPG_CharactersManager_C

    for _, char in ipairs(Characters_name) do
        local fname = FName(char)
        helper:SetCharacterHP(fname, hp)
    end
end

---Save a character's data
---@param name string Hardcoded Name
function Characters:SaveCharacter(name)
    Logger:info("Saving character: " .. name)
    local char_manager = FindFirstOf(BluePrintName) ---@type UAC_jRPG_CharactersManager_C

    local out = {}
    char_manager:GetCharacterData(FName(name), out)
    local char_data = out["CharacterData"] ---@type UBP_CharacterData_C

    local helper = FindFirstOf(helper_bp) ---@type ABP_ArchipelagoHelper_C

    local out = {}
    helper:GetCharacterStateFromData(char_data, out) ---@cast out FS_jRPG_CharacterSaveState

    FREY_DATA = out
    print("1 - " .. FREY_DATA.CurrentLevel_49_97AB711D48E18088A93C8DADFD96F854)

    char_manager:RemoveCharacterFromCollection(char_data)
    print("2 - " .. FREY_DATA.CurrentLevel_49_97AB711D48E18088A93C8DADFD96F854)

end

return Characters