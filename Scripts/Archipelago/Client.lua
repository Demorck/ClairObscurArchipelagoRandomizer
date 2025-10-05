local config = require("Archipelago.Config")
local Debug = require("Archipelago.Debug")

local M = {}

--- Setup the client with Archipelago callbacks and handlers.
---@param AP_REF table The reference of archipelago
---@param AP any The APClient constructor (from lua-apclientpp).
---@param handlers table Handlers for events (like receive an item, connect to the room, etc.)
function M.setup(AP_REF, AP, handlers)
    M.AP = AP
    M.handlers = handlers
    M.config = config
    M.AP_REF = AP_REF

    for k, v in pairs(Debug.callbacks) do
        AP_REF[k] = v
    end
end


--- Connects to the Archipelago server using configuration.
function M.connect()
    local uuid = ""
    Logger:info("Trying to connect at host: " .. M.config.APHost .. " with the game: " .. M.config.APGameName .. " and slot: " .. M.config.APSlot)

    M.AP_REF.APClient = M.AP(uuid, M.config.APGameName, M.config.APHost)
    
    local a = FindFirstOf("BP_ArchipelagoHelper_C") ---@cast a ABP_ArchipelagoHelper_C
    a:ChangeAPTextConnect(E_CLIENT_INFOS.TRYING_TO_CONNECT)
    Archipelago.trying_to_connect = true

    M.AP_REF.APClient:set_socket_connected_handler(M.handlers.socket_connected)
    M.AP_REF.APClient:set_room_info_handler(M.handlers.room_info_handler)
    M.AP_REF.APClient:set_slot_refused_handler(M.handlers.slot_refused_handler)
    M.AP_REF.APClient:set_socket_error_handler(M.handlers.socket_error)
    M.AP_REF.APClient:set_socket_disconnected_handler(M.handlers.socket_disconnected)


    M.handlers.set_items_received_handler(AP_REF.on_items_received)
    M.handlers.set_slot_connected_handler(AP_REF.on_slot_connected)
    M.handlers.set_location_info_handler(AP_REF.on_location_info)
    M.handlers.set_location_checked_handler(AP_REF.on_location_checked)
    M.handlers.set_bounced_handler(AP_REF.on_bounced)
    M.handlers.set_retrieved_handler(AP_REF.on_retrieved_data)
    -- M.handlers.set_socket_error_handler(AP_REF.on_socket_error)
    -- M.handlers.set_socket_disconnected_handler(AP_REF.on_socket_disconnected)

    -- function APSocketDisconnected()
    --     a:ChangeAPTextConnect(E_CLIENT_INFOS.DISCONNECTED)
    --     a:SetConnection(false)
    -- end

    -- AP_REF.on_socket_error = APSocketDisconnected
    -- AP_REF.on_socket_disconnected = APSocketDisconnected
end



return M
