--
local config = require("Archipelago.Config")
local handlers = require("Archipelago.Handlers")
local client = require("Archipelago.Client")

local AP = require "lua-apclientpp"
if AP == nil then
    error("lua-apclientpp not found! Abort")
    return
end

local AP_REF = config
AP_REF.APClient = nil

client.setup(AP_REF, AP, handlers)

-- Just for now, to connect and disconnect easily
local want_to_connect = false

--- Main async loop for polling or disconnecting the AP client.
LoopAsync(33, function ()
    if want_to_connect then
        if AP_REF.APClient ~= nil then
            AP_REF.APClient:poll()
        else
            client.connect()
        end
    else 
        if AP_REF.APClient ~= nil then
            AP_REF.APClient = nil
            collectgarbage("collect")
        end
    end
    return false
end)


--- Toggles the connection to the Archipelago server.
---@param self any Ignored (used for method call syntax).
function AP_REF.Connect(self)
    want_to_connect = not want_to_connect
end

return AP_REF
