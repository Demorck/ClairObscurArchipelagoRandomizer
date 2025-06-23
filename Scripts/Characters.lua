local Characters = {}

local BluePrintName = "AC_jRPG_CharactersManager_C"

function Characters.RemoveCharacterFromParty(name)
    ---@class UAC_jRPG_CharactersManager_C
    local manager = FindFirstOf(BluePrintName)

    local fname = FName(name)
    manager:RemoveCharacterFromParty(fname)
end
























return Characters