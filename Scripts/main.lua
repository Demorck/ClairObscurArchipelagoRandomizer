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
RequestInitLumiere = false

function TestSomeFunctions()
   AP_REF.APClient:Get({"flags"})
end
function PrintMessage()
end

function Debug_things()
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

function Dump(o, depth)
   depth = depth or 0
   local indent = string.rep('  ', depth * 4)

   if type(o) == 'table' then
      local s = '{\n'
      for k,v in pairs(o) do
         if type(k) == "userdata" then k = k:get()  end
         
         if type(k) == 'string' then k = '"'..k..'"'
         elseif type(k) == "number" then k = k
         elseif string.find(tostring(k), "FName") then k = k:ToString()
         else k = type(k)
         end

         if string.find(tostring(v), "FName") then v = v:ToString()
         elseif type(v) == "userdata" then v = v:get() 
            if string.find(tostring(v), "FName") then v = v:ToString()
         end
         
         if type(v) == 'string' then v = '"'..v..'"'
         elseif type(v) == "number" then v = v
         else v = type(v) end
         end
         
         s = s .. indent .. '['.. k .. '] = ' .. Dump(v, depth + 1) .. ',\n'
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

function Trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
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


LoopAsync(333, function ()
   if AP_REF.APClient == nil then return false end

   if Archipelago.waitingForSync then
         Archipelago.waitingForSync = false
         Archipelago:Sync()

         -- if RequestInitLumiere and Archipelago:CanReceiveItems() and not Storage.initialized_after_lumiere then
         --    RequestInitLumiere = false
         --    InitSaveAfterLumiere()
         -- end
   end

    if not Archipelago.waitingForSync then
      Archipelago.waitingForSync = true
   end

   return false
end)

RegisterHook("/Script/Engine.PlayerController:ClientRestart", function(self, NewPawn)
   if AP_REF.APClient == nil then return end

   -- Hooks:Unregister()
   -- Hooks:Register()
end)

function InitSaveAfterLumiere()
   Logger:info("The festival ended...")
   Characters:AddEveryone()
   Characters:EnableOnlyUnlockedCharacters()
   Inventory:Adding999Recoat()
   Capacities:UnlockAllExplorationCapacities()

   Storage.initialized_after_lumiere = true
   Storage:Update()
   Logger:info("Lumiere is done, ciao")
end

RegisterHook("/Game/Gameplay/Save/BP_SaveManager.BP_SaveManager_C:SaveGameToFile", function(self, SaveName)
   ---@cast self UBP_SaveManager_C
   ---@cast SaveName FName

   local data = FindFirstOf("BP_SaveGameData_C") ---@type UBP_SaveGameData_C
   if data == nil or not data:IsValid() then
      print("Impossible to save: SaveGameData nil")
      return
   end

   local flags = data.UnlockedSpawnPoints ---@type TArray<FS_LevelSpawnPointsData>
   local new = false
   flags:ForEach(function (index, element)
      local value = element:get() ---@type FS_LevelSpawnPointsData

      local level_name = value.LevelAssetName_7_D872F94549A7C2601ECF70AC3C4BAB27:ToString()
      if Storage.flags[level_name] == nil then
         Storage.flags[level_name] = {}
      end

      local points = value.SpawnPointTags_3_511D41A44873049B1F83559F7CCBA8D7 ---@type TArray<FGameplayTag>
      points:ForEach(function (i, point)
         local tag = point:get() ---@type FGameplayTag
         local tagname = tag.TagName:ToString()
         if Storage.flags[level_name][tagname] == nil then
            Storage.flags[level_name][tagname] = true
            new = true
         end
      end)
   end)

   if new then
      Storage:Update()
      local operation = {
         operation = "update",
         value = Storage.flags
      }
      AP_REF.APClient:Set("flags", Storage.flags, false, {operation})
   end
end)

-- {"last_saved":-1,"lumiere_done":false,"characters":[],"last_received":-1,"tickets":{"Sirene":false,"SeaCliff":false,"OldLumiere":false,"SideLevel_AxonPath":false,"GoblusLair":false,"Monolith_Interior_PaintressIntro":false,"SideLevel_CleasFlyingHouse":false,"SideLevel_OrangeForest":false,"AncientSanctuary":false,"SideLevel_YellowForest":false,"SideLevel_RedForest":false,"SidelLevel_FrozenHearts":false,"Lumiere":false,"SideLevel_CleasTower_Entrance":false,"ForgottenBattlefield":false,"MonocoStation":false,"Visages":false,"EsquieNest":false,"SideLevel_Reacher":false,"GestralVillage":false,"SideLevel_TwilightSanctuary":false},"weapons_index":-1,"pictos_index":-1}