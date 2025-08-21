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
    Logger:callMethod(helper, "AddCharacterToCollectonFromHardcodedName", fname, found, struct)
end

function Characters:AddEveryone()
    Logger:info("Adding everyone to party...")
    for _, char in ipairs(Characters_name) do
        self:AddCharacter(char)
    end
end



return Characters