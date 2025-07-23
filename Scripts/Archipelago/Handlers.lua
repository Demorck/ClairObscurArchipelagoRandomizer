local Debug = require("Archipelago.Debug")
local config = require("Archipelago.Config")

--- Comments are from the API from black-silver: https://github.com/black-sliver/apclientpp
local M = {}


--- called when the socket is connected.
function M.socket_connected()
    Debug.print("Socket connected")
end

--- called when connect or a ping failed - no action required, reconnect is automatic.
--- @param msg string
function M.socket_error_handler(msg)
    Debug.print("Socket error")
    Debug.print(msg)
end

--- called when the socket gets disconnected - no action required, reconnect is automatic.
function M.socket_disconnected_handler()
    Debug.print("Socket disconnected")
end

--- called when the server sent room info. send ConnectSlot from this callback.
--- When we connected, the server send a packet with theses infos
function M.room_info_handler()
    Debug.print("Room info")
    config.APClient:ConnectSlot(config.APSlot, config.APPassword, config.APItemsHandling, config.APTags, config.Version)
end

--- called as reply to ConnectSlot (just above) when successful.
---@param callback fun(slot_data: table) slot_data
function M.set_slot_connected_handler(callback)
    config.APClient:set_slot_connected_handler(function(slot_data)
        Debug.print("Slot Connected")
        callback(slot_data)
    end)
end

--- called as reply to ConnectSlot failed. argument is reason.
--- @param reasons table The reasons that the connection has been declined
function M.slot_refused_handler(reasons)
    Debug.print("DEBUG: Slot refused: " .. table.concat(reasons, ", "))
end

--- called when receiving items - previously received after connect and new over time
--- @param callback fun(items: NetworkItem[])
function M.set_items_received_handler(callback)
    config.APClient:set_items_received_handler(function(items)
        callback(items)
    end)
end

--- called as reply to `LocationScouts` (view the item, can be used for hint)
--- @param callback fun(items: NetworkItem[])
function M.set_location_info_handler(callback)
    config.APClient:set_location_info_handler(function(items)
        Debug.print("Locations info")
        callback(items)
    end)
end

---called when a local location was remotely checked or was already checked when connecting
---@param callback fun(locations: int64[])
function M.set_location_checked_handler(callback)
    config.APClient:set_location_checked_handler(function(locations)
        Debug.print("Locations checked")
        callback(locations)
    end)
end

return M
