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
AddingCharacterFromArchipelago = false

function TestSomeFunctions()
   Characters:ModifyPartyIfNeeded()
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

function Contains(table, val)
   for i=1,#table do
      if table[i] == val then 
         return true
      end
   end
   return false
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
   if Storage.initialized_after_lumiere then
      return false
   end

   Logger:info("The festival ended...")
   Characters:AddEveryone()
   Characters:EnableOnlyUnlockedCharacters()
   Characters:EnableCharactersInPartyOnlyUnlocked()
   Inventory:Adding999Recoat()
   Capacities:UnlockAllExplorationCapacities()

   Storage.initialized_after_lumiere = true
   Storage:Update("InitSaveAfterLumiere")
   Logger:info("Lumiere is done, ciao")
end
