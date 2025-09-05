local Debug = require("Archipelago.Debug")
local config = require("Archipelago.Config")

--- Comments are from the API from black-silver: https://github.com/black-sliver/apclientpp
--- @class APHandlers
local M = {}


--- called when the socket is connected.
function M.socket_connected()
    Debug.print("Socket connected", "Archipelago.Handlers.socket_connected")
    local a = FindFirstOf("BP_ArchipelagoHelper_C") ---@cast a ABP_ArchipelagoHelper_C
    a:ChangeAPTextConnect(E_CLIENT_INFOS.CONNECTED)
end

--- called when connect or a ping failed - no action required, reconnect is automatic.
--- @param msg string
function M.socket_error_handler(msg)
    Debug.print("Socket error", "Archipelago.Handlers.socket_error_handler", warn)
    Debug.print(msg, "Archipelago.Handlers.socket_error_handler", warn)
    local a = FindFirstOf("BP_ArchipelagoHelper_C") ---@cast a ABP_ArchipelagoHelper_C
    a:ChangeAPTextConnect(E_CLIENT_INFOS.DISCONNECTED)
end

--- called when the socket gets disconnected - no action required, reconnect is automatic.
function M.socket_disconnected_handler()
    Debug.print("Socket disconnected", "Archipelago.Handlers.socket_disconnected_handler")
    local a = FindFirstOf("BP_ArchipelagoHelper_C") ---@cast a ABP_ArchipelagoHelper_C
    a:ChangeAPTextConnect(E_CLIENT_INFOS.DISCONNECTED)
end

--- called when the server sent room info. send ConnectSlot from this callback.
--- When we connected, the server send a packet with theses infos
function M.room_info_handler()
    Debug.print("Room info", "Archipelago.Handlers.room_info_handler")
    config.APClient:ConnectSlot(config.APSlot, config.APPassword, config.APItemsHandling, config.APTags, config.Version)
end

--- called as reply to ConnectSlot (just above) when successful.
---@param callback fun(slot_data: table) slot_data
function M.set_slot_connected_handler(callback)
    config.APClient:set_slot_connected_handler(function(slot_data)
        Debug.print("Slot Connected", "Archipelago.Handlers.set_slot_connected_handler")
        callback(slot_data)
    end)
end

--- called as reply to ConnectSlot failed. argument is reason.
--- @param reasons table The reasons that the connection has been declined
function M.slot_refused_handler(reasons)
    Debug.print("Slot refused: " .. table.concat(reasons, ", "), "Archipelago.Handlers.slot_refused_handler", warn)
    local a = FindFirstOf("BP_ArchipelagoHelper_C") ---@cast a ABP_ArchipelagoHelper_C
    a:ChangeAPTextConnect(E_CLIENT_INFOS.DISCONNECTED)
end

--- called when receiving items - previously received after connect and new over time
--- @param callback fun(items: NetworkItem[])
function M.set_items_received_handler(callback)
    config.APClient:set_items_received_handler(function(items)
        -- Debug.print("Receiving items: Archipelago.Handlers.set_items_received_handler: ")
        callback(items)
    end)
end

--- called as reply to `LocationScouts` (view the item, can be used for hint)
--- @param callback fun(items: NetworkItem[])
function M.set_location_info_handler(callback)
    config.APClient:set_location_info_handler(function(items)
        Debug.print("Locations info", "Archipelago.Handlers.set_location_info_handler")
        callback(items)
    end)
end

---called when a local location was remotely checked or was already checked when connecting
---@param callback fun(locations: int64[])
function M.set_location_checked_handler(callback)
    config.APClient:set_location_checked_handler(function(locations)
        Debug.print("Locations checked", "Archipelago.Handlers.set_location_checked_handler")
        callback(locations)
    end)
end

function M.set_bounced_handler(callback)
    config.APClient:set_bounced_handler(function(json)
        Debug.print("Bounced ! " .. json, "Archipelago.Handler.set_bounced_handler")
        callback(json)
    end)
end

return M
