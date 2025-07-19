AP_REF     = require "Archipelago/core"
Data       = require "Data"
Storage    = require "Storage"
Inventory  = require "Inventory"
Characters = require "Characters"
Archipelago = require "Archipelago"


local running = true

local UEHelpers = require "UEHelpers"

function TestSomeFunctions()
   AP_REF:Connect()
   -- Archipelago.Init()

   -- if Archipelago.waitingForSync then
   --    Archipelago.waitingForSync = false
   --    Archipelago.Sync()
   -- end
end

function PrintMessage()
   
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


LoopAsync(33, function ()
   if Archipelago.waitingForSync then
         Archipelago.waitingForSync = false
         Archipelago.Sync()
   end

   -- if Archipelago.CanReceiveItems() then
   --    Archipelago.ProcessItemsQueue()
   -- end













    if not Archipelago.waitingForSync then
      Archipelago.waitingForSync = true
   end

   return false
end)