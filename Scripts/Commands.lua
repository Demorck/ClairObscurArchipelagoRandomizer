---@class DebugCommands
local DebugCommands = {}

function DebugCommands:DebugFunction1()
    Save:SaveGame()
end

function DebugCommands:DebugFunction2()
    Archipelago:Sync()
end

function DebugCommands:DebugFunction3()
    Save:WriteFlagByName(CONSTANTS.NID.FB_GRADIENT_TUTORIAL.NAME, true)
    Save:WriteFlagByName(CONSTANTS.NID.FW_JUMP_TUTORIAL.NAME, true)
end

function DebugCommands:DebugFunction4()
end

function DebugCommands:RegisterKeybinds()
    RegisterKeyBind(Key.F1, { ModifierKey.CONTROL }, function()
        ExecuteInGameThread(function()
            self:DebugFunction1()
        end)
    end)

    RegisterKeyBind(Key.F2, { ModifierKey.CONTROL }, function()
        ExecuteInGameThread(function()
            self:DebugFunction2()
        end)
    end)

    RegisterKeyBind(Key.F3, { ModifierKey.CONTROL }, function()
        ExecuteInGameThread(function()
            self:DebugFunction3()
        end)
    end)

    RegisterKeyBind(Key.F4, { ModifierKey.CONTROL }, function()
        ExecuteInGameThread(function()
            self:DebugFunction4()
        end)
    end)
end


return DebugCommands