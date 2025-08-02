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
    local helper = FindFirstOf(helper_bp) ---@type ABP_ArchipelagoHelper_C

    local found = {}
    local struct = {}
    local fname = FName(name)
    helper:AddCharacterToCollectonFromHardcodedName(fname, found, struct)

    -- print(Dump(found))
end



return Characters