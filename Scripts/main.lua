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
ClientBP      = require "ClientBP"
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
   local a = FindAllOf("BP_jRPG_Enemy_World_Base_Seamless_C")

   local result = {}

   for _, actor in ipairs(a) do
    ---@cast actor ABP_jRPG_Enemy_World_Base_Seamless_C
      if actor.SelectedEncounter ~= nil then
         local rowName = actor.SelectedEncounter["RowName"]:ToString()
         local actorName = actor:GetFName():ToString()

         local cleanName = actorName:match("^BP_EnemyWorld_(.-)_C")

         if result[rowName] == nil then
               result[rowName] = {}
         end

         local alreadyPresent = false
         for _, name in ipairs(result[rowName]) do
               if name == cleanName then
                  alreadyPresent = true
                  break
               end
         end
         if not alreadyPresent then
               table.insert(result[rowName], cleanName)
         end
      end
   end

   for encounter, enemies in pairs(result) do
      print(encounter .. " = [" .. table.concat(enemies, ", ") .. "]")
   end
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