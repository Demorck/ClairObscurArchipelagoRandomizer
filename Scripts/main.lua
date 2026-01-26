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

RequestInitLumiere = false
AddingCharacterFromArchipelago = false
TABLE_CURRENT_AP_FUNCTION = {}
NAMEDID_TO_BE_ADDED = {}

-- And maybe the party issues in act 3 ? there is one iirc

RegisterCustomEvent("ConnectButtonPressed", function(Context, host, port, slot, password, deathlink, musicrando)
   local hostStr = host:get():ToString()
   local portStr = port:get():ToString()
   local slotStr = slot:get():ToString()
   local passwordStr = password:get():ToString()
   local deathlinkBool = deathlink:get()


   ExecuteAsync(function()
      ArchipelagoSystem:SetConnectionConfig(hostStr, portStr, slotStr, passwordStr, deathlinkBool)
      ArchipelagoSystem:ToggleConnection()
   end)
end)


function InitSaveAfterLumiere()
   if Storage.initialized_after_lumiere then
      return false
   end


   Logger:info("The festival ended...")
   Characters:AddEveryone()

   if Archipelago.options.char_shuffle == 0 then
      Storage:UnlockCharacter("Frey")
   end

   Characters:EnableCharactersInPartyOnlyUnlocked()
   Inventory:Adding999Recoat()
   Capacities:UnlockAllExplorationCapacities()

   Save:WriteFlagByID("NID_ForgottenBattlefield_GradientCounterTutorial", true)
   Save:WriteFlagByID("NID_Goblu_JumpTutorial", true)
   Save:WriteFlagByID("NID_LuneRelationshipLvl6_Quest", true)
   Save:WriteFlagByID("NID_Monoco_RelationshipLvl6_Quest", true)

   Storage:Set("initialized_after_lumiere", true)
   Storage:Update("InitSaveAfterLumiere")
   Logger:info("Lumiere is done, ciao")

   Storage.transition_lumiere = true
   Archipelago:Sync()
end

RegisterHook("/Game/Gameplay/GameActionsSystem/ReplaceCharacter/BP_GameActionInstance_ReplaceCharacter.BP_GameActionInstance_ReplaceCharacter_C:GetReplaceCharacterParameters", 
   function(ctx, param)
      local param = param:get() ---@cast param FS_ReplaceCharacterParameters
      
      param.TransferLumina_7_347621E5466692025EF4B2A21AA8E631 = false
      param.TransferLevel_11_1EDF1E544B7806EACF12E8968EE240CA = false
      param.TransferPictos_16_F3ADFDAC4F0D8D09C20CB9B1B6415108 = false
      param.TransferWeapon_18_3B0D73CF4D925EE41C43C3A35B759EE7 = false
      param.TransferAttributePoints_13_005710C0425DE39B3D97B78BAE5C34E6 = false
   end
)

RegisterHook("/Game/jRPGTemplate/Blueprints/Basics/BP_jRPG_GI_Custom.BP_jRPG_GI_Custom_C:GetAllNamedIDs",
   function(self, ids)
      local ctx = self:get() ---@type UBP_jRPG_GI_Custom_C
      local namedID = ids:get() ---@type TArray<UNamedID>


      namedID:ForEach(function (index, element)
         local value = element:get() ---@type UNamedID

         print(value.Name:ToString())
         if (value.Name:ToString() == CONSTANTS.NID.FW_JUMP_TUTORIAL.Name) then
            ctx:WritePersistentFlag(value, true)
         end
      end)
   end
)