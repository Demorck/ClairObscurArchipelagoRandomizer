Logger      = require "Logger"
Hooks       = require "Hooks"
AP_REF      = require "Archipelago/Init"
Data        = require "Data"
Debug       = require "Archipelago.Debug"
Storage     = require "Storage"
Inventory   = require "Inventory"
Capacities  = require "Capacities"
Characters  = require "Characters"
Quests      = require "Quests" ---@type Quests
Save        = require "Save"
Archipelago = require "Archipelago"
ClientBP    = require "ClientBP"
Battle      = require "Battle"
local UEHelpers = require "UEHelpers"

function TestSomeFunctions()
   AP_REF:Connect()
end

function PrintMessage()
   local interactible = FindAllOf("BP_jRPG_MapTeleportPoint_Interactible_C") ---@cast interactible ABP_jRPG_MapTeleportPoint_Interactible_C[]
   local a = FindFirstOf("BP_ArchipelagoHelper_C") ---@cast a ABP_ArchipelagoHelper_C

   for _, tp in ipairs(interactible) do
         local scene = tp.LevelDestination


         print(tp.LevelDestination.RowName:ToString())
   end
end

function Debug_things()
   Inventory:AddItem("Consumable_Respec", 1)
end


RegisterCustomEvent("ConnectButtonPressed", function(Context, host, port, slot, password)
   local a = FindFirstOf("BP_ArchipelagoHelper_C") ---@cast a ABP_ArchipelagoHelper_C
   local host = host:get():ToString()
   local port = port:get():ToString()
   local slot = slot:get():ToString()
   local password = password:get():ToString()

   AP_REF:set_config(host, port, slot, password)

   AP_REF:Connect()
end)

function Dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. Dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

RegisterKeyBind(Key.F1, { ModifierKey.CONTROL }, function()
    ExecuteInGameThread(function()
        TestSomeFunctions()
    end)
end)

RegisterKeyBind(Key.F2, { ModifierKey.CONTROL }, function()
    ExecuteInGameThread(function()
        PrintMessage()
    end)
end)


RegisterKeyBind(Key.F3, { ModifierKey.CONTROL }, function()
    ExecuteInGameThread(function()
        Debug_things()
    end)
end)


LoopAsync(33, function ()
   if AP_REF.APClient == nil then return false end

   if Archipelago.waitingForSync then
         Archipelago.waitingForSync = false
         Archipelago.Sync()
   end

    if not Archipelago.waitingForSync then
      Archipelago.waitingForSync = true
   end

   return false
end)

RegisterHook("/Game/Gameplay/Audio/BP_AudioControlSystem.BP_AudioControlSystem_C:OnPauseMenuOpened", function (context)
   local buttons = FindAllOf("WBP_BaseButton_C") ---@cast buttons UWBP_BaseButton_C[]

   for _, value in ipairs(buttons) do
      local name = value:GetFName():ToString()
      if name == "TeleportPlayerButton" then
         value:SetVisibility(0)
         local content = value.ButtonContent
         if content ~= nil and content:IsValid() then
            local overlay = content:GetContent() ---@cast overlay UOverlay
            if overlay ~= nil and overlay:IsValid() then
               local wrapping_text = overlay:GetChildAt(0) ---@cast wrapping_text UWBP_WrappingText_C
                  if wrapping_text ~= nil and wrapping_text:IsValid() then
                     wrapping_text.ContentText = FText("I'M STUCK ! (stepbro)")
                     wrapping_text:UpdateText()
               end
            end
         end
      end
   end
end)

RegisterHook("/Game/Gameplay/Quests/System/BP_QuestSystem.BP_QuestSystem_C:UpdateActivitySubTaskStatus", function (self, objective_name, status)
    local quest_system = self:get() ---@type UBP_QuestSystem_C
    local objective_name_param = objective_name:get():ToString()
    local status_param = status:get()
    
    if objective_name_param == "1_LumiereBeginning" and status_param == 2 then
      InitSaveAfterLumiere()
    elseif objective_name_param == "1_ForcedCamp_PostSpringMeadows" and status_param == 1 then
      Quests:SetObjectiveStatus("Main_ForcedCamps", "1_ForcedCamp_PostSpringMeadows", QUEST_STATUS.STARTED)
    end
end)

function InitSaveAfterLumiere()
   Characters:AddEveryone()
   Inventory:Adding999Recoat()
   Capacities:UnlockAllExplorationCapacities()
end

-- RegisterHook("/Game/LevelTools/BP_jRPG_MapTeleportPoint.BP_jRPG_MapTeleportPoint_C:ProcessChangeMap", function(self)
--    local mappoint = self:get() ---@type ABP_jRPG_MapTeleportPoint_C

--    print(mappoint.DestinationAreaName:ToString())
-- end)

RegisterHook("/Game/jRPGTemplate/Blueprints/Basics/FL_jRPG_CustomFunctionLibrary.FL_jRPG_CustomFunctionLibrary_C:GetCurrentLevelData", function (self, _worldContext, found, levelData, rowName)
   --  local name = rowName:get()
   --  local level = name:ToString() ---@type string

   --  if level == "WorldMap" then
   --    local interactible = FindAllOf("BP_jRPG_MapTeleportPoint_Interactible_C") ---@cast interactible ABP_jRPG_MapTeleportPoint_Interactible_C[]
   --    if interactible == nil then
   --       print("nullos")
   --       return
   --    end
   --    local a = FindFirstOf("BP_ArchipelagoHelper_C") ---@cast a ABP_ArchipelagoHelper_C

   --    for _, tp in ipairs(interactible) do
   --          local scene = tp.LevelDestination


   --          print(tp.LevelDestination.RowName:ToString())
   --    end
   --  end
end)