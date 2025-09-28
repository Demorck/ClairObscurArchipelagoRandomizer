--
local config = require("Archipelago.Config")
local handlers = require("Archipelago.Handlers")
local client = require("Archipelago.Client")

E_CLIENT_INFOS = {
    DISCONNECTED = 0,
    TRYING_TO_CONNECT = 1,
    CONNECTED = 2
}

local AP = require "lua-apclientpp"
if AP == nil then
    error("lua-apclientpp not found! Abort")
    return
end

local AP_REF = config
AP_REF.APClient = nil ---@type APClient
AP_REF.AP = AP

client.setup(AP_REF, AP, handlers)

-- Just for now, to connect and disconnect easily
local want_to_connect = false

--- Main async loop for polling or disconnecting the AP client.
LoopAsync(333, function ()
    if want_to_connect then
        if AP_REF.APClient ~= nil then
            AP_REF.APClient:poll()
            local a = ClientBP:GetHelper() ---@cast a ABP_ArchipelagoHelper_C
            -- a.Connected = true
        else
            client.connect()
        end
    else
        if AP_REF.APClient ~= nil then
            Logger:info("Disconnecting from Archipelago server...")
            AP_REF.APClient = nil
            local a = ClientBP:GetHelper() ---@cast a ABP_ArchipelagoHelper_C
            -- a.Connected = false
            collectgarbage("collect")
        end
    end
    return false
end)


function AP_REF:set_config(host, port, slot, password, deathlink)
    config.APHost = host .. ":" .. port
    config.APSlot = slot
    config.APPassword = password

    Archipelago.death_link = deathlink
    config.deathlink = deathlink
    if deathlink then
        table.insert(config.APTags, "DeathLink")
    else
        for index, value in ipairs(config.APTags) do
            if value == "DeathLink" then
                table.remove(config.APTags, index)
                break
            end
        end
    end
end


--- Toggles the connection to the Archipelago server.
---@param self any Ignored (used for method call syntax).
function AP_REF.Connect(self)
    want_to_connect = not want_to_connect

    if want_to_connect then
        Logger:initialize()
    else 
        Hooks:Unregister()
        local a = FindFirstOf("BP_ArchipelagoHelper_C") ---@cast a ABP_ArchipelagoHelper_C
        a:ChangeAPTextConnect(E_CLIENT_INFOS.DISCONNECTED)
    end

end

function AP_REF:IsConnected()
    return AP_REF.APClient ~= nil
end

return AP_REF
