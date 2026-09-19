Logger       = require "Logger"
Hooks        = require "Hooks.index"
Data         = require "Data"
Debug        = require "Archipelago.Debug"
Storage      = require "Storage.index"              ---@type Storage
Inventory    = require "Game.Inventory"
Capacities   = require "Game.Capacities"
Characters   = require "Game.Characters"
Quests       = require "Game.Quests"
Save         = require "Game.Save"
ClientBP     = require "Game.ClientBP"
Battle       = require "Game.Battle"
CONSTANTS    = require "Constants.index"
Utils        = require "Utils.index"
Commands     = require "Commands"
Regions      = require "Constants.RegionConstants"
RuntimeState = require "RuntimeState"
Options      = require "Archipelago.Options"
MerchantLocations = require "Archipelago.MerchantLocations"
NewGameSetup = require "Game.NewGameSetup"
UEHelpers    = require "UEHelpers"

Dump = Utils.TableHelper.Dump
Contains = Utils.TableHelper.Contains
Trim = Utils.StringHelper.Trim
Remove = Utils.TableHelper.Remove


Archipelago          = require "Archipelago"
ArchipelagoSystem    = require "Archipelago.Init"
Archipelago.apSystem = ArchipelagoSystem

Commands:RegisterKeybinds()

-- And maybe the party issues in act 3 ? there is one iirc
AddingCharacterFromArchipelago = false

RegisterCustomEvent("ConnectButtonPressed", function(Context, settings)
   local ap_settings = settings:get() ---@type FS_AP_Settings
   local hostStr = ap_settings.host_5_57D7FAAE4EE105D7FFBA43836D0EB068:ToString()
   local portStr = ap_settings.port_6_667302EB4A0B1D65E7126FA80C5F37A9:ToString()
   local slotStr = ap_settings.slot_8_F865C5C946B8CEFF2A3CBC95B903BC9C:ToString()
   local passwordStr = ap_settings.password_9_29E90B5A490FB64EF37D899B7FE35702:ToString()
   local deathlinkBool = ap_settings.death_link_16_BD6444064CB7AF2080DA9F86599CD9A0

   RuntimeState.change_save_icon = ap_settings.save_icon_18_CAE18D2E4FC0450B5A48BABB660DF652
   
   print("[COE33AP - Before connection] Connect button pressed")

   ArchipelagoSystem:SetConnectionConfig(hostStr, portStr, slotStr, passwordStr, deathlinkBool)
   ArchipelagoSystem.pendingToggle = true   
end)

print("[COE33AP - Before Connection] Main initialized")