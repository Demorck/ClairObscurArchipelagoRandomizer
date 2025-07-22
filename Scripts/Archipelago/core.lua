
local AP = require "lua-apclientpp"
if AP == nil then
    error("lua-apclientpp not found ! Abort")
    return
end
local AP_REF = {}
local DEBUG = true
local connected = false


AP_REF.APClient = nil ---@type APClient
AP_REF.APGameName = "Clair Obscur Expedition 33"
AP_REF.APItemsHandling = 7 
AP_REF.APTags = {"Lua-APClientPP"}
AP_REF.Message_format = AP.RenderFormat.TEXT

AP_REF.APCurrentPlayerColor = "EE00EE"
AP_REF.APOtherPlayerColor = "FAFAD2"
AP_REF.APProgessionColor = "AF99EF"
AP_REF.APUsefulColor = "6D8BE8"
AP_REF.APFillerColor = "00EEEE"
AP_REF.APTrapColor = "FA8072"
AP_REF.APLocationColor = "00FF7F"
AP_REF.APEntranceColor = "6495ED"

-- TODO: user input
AP_REF.APHost = "localhost:64896"
AP_REF.APSlot = "BONJOUR"
AP_REF.APPassword = ""
AP_REF.Version = {0, 5, 4}

AP_REF.clientEnabled = true
AP_REF.clientDisabledMessage = ""

AP_REF.APColors = {
    red="EE0000",
    blue="6495ED",
    green="00FF7F",
    yellow="FAFAD2",
    cyan="00EEEE",
    magenta="EE00EE",
    black="000000",
    white="FFFFFF",
    red_bg="FF0000",
    blue_bg="0000FF",
    green_bg="00FF00",
    yellow_bg="FFFF00",
    cyan_bg="00FFFF",
    magenta_bg="FF00FF",
    black_bg="000000",
    white_bg="FFFFFF"
}


local function debug_print(str)
	if DEBUG then
		print("DEBUG: " .. str)
	end
end

local function callback_passthrough()
    a = 1 + 1
end

local function callback_passthrough_one_arg(pass)
    debug_print(pass)
    a = 1 + 1
end

local function callback_passthrough_two_arg(pass1, pass2)
    debug_print(pass1)
    debug_print(pass2)
    a = 1 + 1
end

local function callback_passthrough_three_arg(pass1, pass2, pass3)
    debug_print(pass1)
    debug_print(pass2)
    debug_print(pass3)
    a = 1 + 1
end


AP_REF.on_socket_connected = callback_passthrough
AP_REF.on_socket_error = callback_passthrough_one_arg
AP_REF.on_socket_disconnected = callback_passthrough
AP_REF.on_room_info = callback_passthrough
AP_REF.on_slot_connected = callback_passthrough_one_arg
AP_REF.on_slot_refused = callback_passthrough_one_arg
AP_REF.on_items_received = callback_passthrough_one_arg
AP_REF.on_location_info = callback_passthrough_one_arg
AP_REF.on_location_checked = callback_passthrough_one_arg
AP_REF.on_data_package_changed = callback_passthrough_one_arg
AP_REF.on_print = callback_passthrough_one_arg
AP_REF.on_print_json = callback_passthrough_two_arg
AP_REF.on_bounced = callback_passthrough_one_arg
AP_REF.on_retrieved = callback_passthrough_three_arg
AP_REF.on_set_reply = callback_passthrough_one_arg

local function socket_connected()
		debug_print("Socket connected")
end

local function socket_error_handler(msg)
		debug_print("Socket error")
		debug_print(msg)
end

local function socket_disconnected_handler()
    debug_print("Socket disconnected")
end

local function room_info_handler()
    debug_print("Room info")
    
    AP_REF.APClient:ConnectSlot(AP_REF.APSlot, AP_REF.APPassword, AP_REF.APItemsHandling, AP_REF.APTags, AP_REF.Version)
end

local function on_slot_refused(reasons)
    debug_print("DEBUG: Slot refused: " .. table.concat(reasons, ", "))
end


local function set_items_received_handler(callback)
	function items_received_handler(items)
		callback(items)
	end
	AP_REF.APClient:set_items_received_handler(items_received_handler)
end

local function set_slot_connected_handler(callback)
	function slot_connected_handler(slot_data)
		debug_print("Slot Connected")
		callback(slot_data)
	end
	AP_REF.APClient:set_slot_connected_handler(slot_connected_handler)
end

local function set_location_info_handler(callback)
	function location_info_handler(items)
		debug_print("Locations info")
		callback(items)
	end
	AP_REF.APClient:set_location_info_handler(location_info_handler)
end
local function set_location_checked_handler(callback)
	function location_checked_handler(locations)
		debug_print("Locations checked")
		callback(locations)
	end
	AP_REF.APClient:set_location_checked_handler(location_checked_handler)
end

function APConnect(host)
    local uuid = ""
	debug_print("Trying to connect at host: " .. host .. " with the game: " .. AP_REF.APGameName)
    AP_REF.APClient = AP(uuid, AP_REF.APGameName, host)
    debug_print("Connecting")
    AP_REF.APClient:set_socket_connected_handler(socket_connected)
	AP_REF.APClient:set_socket_error_handler(socket_error_handler)
	AP_REF.APClient:set_socket_disconnected_handler(socket_disconnected_handler)
	AP_REF.APClient:set_room_info_handler(room_info_handler)
    AP_REF.APClient:set_slot_refused_handler(on_slot_refused)

    
    set_items_received_handler(AP_REF.on_items_received)
    set_slot_connected_handler(AP_REF.on_slot_connected)
    set_items_received_handler(AP_REF.on_items_received)
    set_location_info_handler(AP_REF.on_location_info)
    set_location_checked_handler(AP_REF.on_location_checked)
end

-- Just for now, to connect and disconnect easily
local want_to_connect = false

LoopAsync(33, function ()
    if want_to_connect then
        if AP_REF.APClient ~= nil then
            AP_REF.APClient:poll()
        else
            APConnect(AP_REF.APHost)
        end
    else 
        if AP_REF.APClient ~= nil then
            AP_REF.APClient = nil
            collectgarbage("collect")
        end
    end
    return false
end)

function AP_REF.Connect(self)
    want_to_connect = not want_to_connect
end

return AP_REF