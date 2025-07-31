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
local UEHelpers = require "UEHelpers"

function TestSomeFunctions()
   AP_REF:Connect()
end

function PrintMessage()
   Quests:UnlockNextGestral()
end

function Debug_things()
end

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

