---@class DebugCommands
local DebugCommands = {}

function DebugCommands:DebugFunction1()
    Save:SaveGame()
end

function DebugCommands:DebugFunction2()
end

function DebugCommands:DebugFunction3()
    registerhooks()
end

function DebugCommands:DebugFunction4()
    RestartCurrentMod()
end

function DebugCommands:ToggleConsole()
    ClientBP:ToggleConsole()
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

    RegisterKeyBind(Key.F5, { ModifierKey.CONTROL }, function()
        ExecuteInGameThread(function()
            self:ToggleConsole()
        end)
    end)
end


return DebugCommands