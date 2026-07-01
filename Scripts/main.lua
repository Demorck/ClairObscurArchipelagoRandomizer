Logger     = require "Logger"
Hooks      = require "Hooks.index"
Data       = require "Data"
Debug      = require "Archipelago.Debug"
Storage    = require "Storage.index" ---@type Storage
Inventory  = require "Game.Inventory"
Capacities = require "Game.Capacities"
Characters = require "Game.Characters"
Quests     = require "Game.Quests"
Save       = require "Game.Save"
ClientBP   = require "Game.ClientBP"
Battle     = require "Game.Battle"
CONSTANTS  = require "Constants.index"
Utils      = require "Utils.index"
Commands   = require "Commands"

Dump = Utils.TableHelper.Dump
Contains = Utils.TableHelper.Contains
Trim = Utils.StringHelper.Trim
Remove = Utils.TableHelper.Remove


Archipelago          = require "Archipelago"
ArchipelagoSystem    = require "Archipelago.Init"
Archipelago.apSystem = ArchipelagoSystem

Commands:RegisterKeybinds()

-- Just for compatbility for now
AP_REF               = {
   APClient = nil,
}

NEEDED_TO_INIT = false

setmetatable(AP_REF, {
   __index = function(t, key)
      if key == "APClient" then
         if ArchipelagoSystem and ArchipelagoSystem:IsConnected() then
            return ArchipelagoSystem:GetClient():GetClient()
         end
         return nil
      end
      return rawget(t, key)
   end
})

AddingCharacterFromArchipelago = false
FLAG_COMMAND = false

-- And maybe the party issues in act 3 ? there is one iirc

RegisterCustomEvent("ConnectButtonPressed", function(Context, settings)
   local settings = settings:get() ---@type FS_AP_Settings
   local hostStr = settings.host_5_57D7FAAE4EE105D7FFBA43836D0EB068:ToString()
   local portStr = settings.port_6_667302EB4A0B1D65E7126FA80C5F37A9:ToString()
   local slotStr = settings.slot_8_F865C5C946B8CEFF2A3CBC95B903BC9C:ToString()
   local passwordStr = settings.password_9_29E90B5A490FB64EF37D899B7FE35702:ToString()
   local deathlinkBool = settings.death_link_16_BD6444064CB7AF2080DA9F86599CD9A0

   CONSTANTS.RUNTIME.CHANGE_SAVE_ICON = settings.save_icon_18_CAE18D2E4FC0450B5A48BABB660DF652

   print(hostStr ..  " - " .. portStr ..  " - " ..slotStr ..  " - " ..passwordStr ..  " - " .. tostring(deathlinkBool) ..  " - " .. tostring(CONSTANTS.RUNTIME.CHANGE_SAVE_ICON))

   print("[COE33AP - Before connection] Connect button pressed")

   ExecuteAsync(function()
      ArchipelagoSystem:SetConnectionConfig(hostStr, portStr, slotStr, passwordStr, deathlinkBool)
      ArchipelagoSystem:ToggleConnection()
   end)
end)

function InitSaveAfterLumiere()
   Logger:info("Initialized after Lumière")
   Characters:AddEveryone()
   Characters:HealEveryone()

   if Archipelago.options.char_shuffle == 0 then
      Storage:UnlockCharacter("Frey")
   end

   Archipelago:Sync()

   Characters:EnableCharactersInPartyOnlyUnlocked()
   Inventory:Adding999Recoat()
   Capacities:UnlockAllExplorationCapacities()

   Save:WriteFlagByName(CONSTANTS.NID.FB_GRADIENT_TUTORIAL.NAME, true)
   Save:WriteFlagByName(CONSTANTS.NID.FW_JUMP_TUTORIAL.NAME, true)
   Save:WriteFlagByName(CONSTANTS.NID.REACHER_LVL6_MAELLE.NAME, true)
   Save:WriteFlagByName(CONSTANTS.NID.RELATION_LVL6_LUNE.NAME, true)
   Save:WriteFlagByName(CONSTANTS.NID.RELATION_LVL6_MONOCO.NAME, true)

   Quests:SetObjectiveStatus(CONSTANTS.QUEST.GOLDEN_PATH.QUEST_NAME, CONSTANTS.QUEST.GOLDEN_PATH.LUMIERE_BEGINNING, QUEST_STATUS.COMPLETED)
   Quests:SetObjectiveStatus(CONSTANTS.QUEST.LUMIERE_ACT1.QUEST_NAME, CONSTANTS.QUEST.LUMIERE_ACT1.DUEL_MAELLE, QUEST_STATUS.COMPLETED)
   Quests:SetObjectiveStatus(CONSTANTS.QUEST.LUMIERE_ACT1.QUEST_NAME, CONSTANTS.QUEST.LUMIERE_ACT1.FLOWER, QUEST_STATUS.COMPLETED)
   Quests:SetObjectiveStatus(CONSTANTS.QUEST.LUMIERE_ACT1.QUEST_NAME, CONSTANTS.QUEST.LUMIERE_ACT1.MIME, QUEST_STATUS.COMPLETED)
   Quests:SetObjectiveStatus(CONSTANTS.QUEST.LUMIERE_ACT1.QUEST_NAME, CONSTANTS.QUEST.LUMIERE_ACT1.FIND_TRASHMAN, QUEST_STATUS.COMPLETED)
   Quests:SetObjectiveStatus(CONSTANTS.QUEST.LUMIERE_ACT1.QUEST_NAME, CONSTANTS.QUEST.LUMIERE_ACT1.NEWSPAPER_PETALS, QUEST_STATUS.COMPLETED)
   Quests:SetObjectiveStatus(CONSTANTS.QUEST.LUMIERE_ACT1.QUEST_NAME, CONSTANTS.QUEST.LUMIERE_ACT1.PAINTER, QUEST_STATUS.COMPLETED)
   Quests:SetObjectiveStatus(CONSTANTS.QUEST.LUMIERE_ACT1.QUEST_NAME, CONSTANTS.QUEST.LUMIERE_ACT1.RUN_MAELLE_1, QUEST_STATUS.COMPLETED)
   Quests:SetObjectiveStatus(CONSTANTS.QUEST.LUMIERE_ACT1.QUEST_NAME, CONSTANTS.QUEST.LUMIERE_ACT1.RUN_MAELLE_2, QUEST_STATUS.COMPLETED)
   Quests:SetObjectiveStatus(CONSTANTS.QUEST.LUMIERE_ACT1.QUEST_NAME, CONSTANTS.QUEST.LUMIERE_ACT1.SCULPTURE_NEVRON, QUEST_STATUS.COMPLETED)
   Quests:SetObjectiveStatus(CONSTANTS.QUEST.LUMIERE_ACT1.QUEST_NAME, CONSTANTS.QUEST.LUMIERE_ACT1.SOPHIE, QUEST_STATUS.COMPLETED)


   -- LoopAsync(1000 * 10, function ()
   --    local pause_menu = FindFirstOf("WBP_PauseMenu_C") ---@type UWBP_PauseMenu_C
   --    pause_menu:TeleportToSafeLocation()
   --    return true
   -- end)
end

print("[COE33AP - Before Connection] Main initialized")

-- RegisterHook("/Game/Gameplay/InteractiveMusic/BP_InteractiveMusicSystem.BP_InteractiveMusicSystem_C:CreateInteractiveMusicWithContextIfNeeded",
--    function(ctx, music_context, sound, music)
--       local InteractiveMusic = music:get()

--       local audio_comp = InteractiveMusic["AudioComponent_7_F10237DD43456A26DE6840B3DC60292D"]

--       local asset = LoadAsset("/Game/Audio/WAV/MUSIC/Beta/Common/MUS_Common_ENV_Lumiere_Orchestral.MUS_Common_ENV_Lumiere_Orchestral")
--       if asset and asset:IsValid() then
--             audio_comp.Sound = asset
--       end
--       print(audio_comp.Sound:GetFullName())
--    end
-- )



--- GetNewGameData
--- InitializeLevelForNewGame
--- StartNewGame
---Function /Game/Gameplay/GameFlow/ProjectConfiguration/BP_DataAsset_ProjectConfiguration.BP_DataAsset_ProjectConfiguration_C:GetNewGameLevel
---
---
---