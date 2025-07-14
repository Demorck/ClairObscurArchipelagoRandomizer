AP_REF         = require "Archipelago/core"
Inventory  = require "Inventory"
Characters = require "Characters"
Archipelago = require "Archipelago"

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
   print("DEBUG: Printed ! :)")
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