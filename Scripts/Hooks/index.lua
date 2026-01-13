local HookManager    = require "Hooks.Core.HookManager"
local ChestHook      = require "Hooks.IndividualHooks.ChestHooks"
local BattleHooks    = require "Hooks.IndividualHooks.BattleHooks"
local SaveHooks      = require "Hooks.IndividualHooks.SaveHooks"
local QuestHooks     = require "Hooks.IndividualHooks.QuestHooks"
local LocationHooks  = require "Hooks.IndividualHooks.LocationHooks"
local CharacterHooks = require "Hooks.IndividualHooks.CharacterHooks"
local InventoryHooks = require "Hooks.IndividualHooks.InventoryHooks"
local UIHooks        = require "Hooks.IndividualHooks.UIHooks"
local CapacityHook   = require "Hooks.IndividualHooks.CapacityHook"


local Hooks = {}

local hookManager = nil

function Hooks:Register()
    if hookManager then
        Logger:warn("Hooks already registered")
        return
    end

    Logger:info("Registering hooks...")

    -- Create hook manager
    hookManager = HookManager:New({ logger = Logger })

    -- Dependencies for hooks
    local dependencies = {
        archipelago = Archipelago,
        storage = Storage,
        logger = Logger,
        battle = Battle,
        characters = Characters,
        inventory = Inventory,
        quests = Quests,
        save = Save,
        clientBP = ClientBP,
        capacities = Capacities
    }

    ChestHook:Register(hookManager, dependencies)
    BattleHooks:Register(hookManager, dependencies)
    SaveHooks:Register(hookManager, dependencies)
    QuestHooks:Register(hookManager, dependencies)
    LocationHooks:Register(hookManager, dependencies)
    CharacterHooks:Register(hookManager, dependencies)
    InventoryHooks:Register(hookManager, dependencies)
    UIHooks:Register(hookManager, dependencies)
    CapacityHook:Register(hookManager, dependencies)

    Logger:info("Hooks registered successfully")
end


---Unregister all hooks
function Hooks:Unregister()
    if not hookManager then
        Logger:warn("No hooks to unregister")
        return
    end

    hookManager:UnregisterAll()
    hookManager = nil

    Logger:info("All hooks unregistered")
end

---Get hook manager (for debugging)
---@return HookManager|nil
function Hooks:GetHookManager()
    return hookManager
end

return Hooks