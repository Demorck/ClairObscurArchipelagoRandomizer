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
local OtherHooks     = require "Hooks.IndividualHooks.OtherHooks"
local ShopHooks      = require "Hooks.IndividualHooks.ShopHooks"


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

    ChestHook:Register(hookManager)
    BattleHooks:Register(hookManager)
    SaveHooks:Register(hookManager)
    QuestHooks:Register(hookManager)
    LocationHooks:Register(hookManager)
    CharacterHooks:Register(hookManager)
    InventoryHooks:Register(hookManager)
    UIHooks:Register(hookManager)
    CapacityHook:Register(hookManager)

    if Options:IsEnabled("shopsanity") then
        ShopHooks:Register(hookManager)
    end

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

return Hooks