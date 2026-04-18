---@class DebugCommands
local DebugCommands = {}

function DebugCommands:DebugFunction1()
    Save:SaveGame()
end

function DebugCommands:DebugFunction2()
    Archipelago:Sync()
    Archipelago:SendAlreadyChecked()
end

function DebugCommands:DebugFunction3()
    FLAG_COMMAND = not FLAG_COMMAND
    print(FLAG_COMMAND)
end

function DebugCommands:DebugFunction4()
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