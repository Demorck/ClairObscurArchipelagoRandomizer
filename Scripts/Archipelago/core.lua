
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
AP_REF.APHost = "localhost:38281"
AP_REF.APSlot = "Player1"
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
function APConnect(host)
    
    local uuid = ""
	debug_print("Trying to connect at host: " .. host .. " with the game: " .. AP_REF.APGameName)
    AP_REF.APClient = AP(uuid, AP_REF.APGameName, host)
    debug_print("Connecting")
    AP_REF.APClient:set_socket_connected_handler(socket_connected)
	AP_REF.APClient:set_socket_error_handler(socket_error_handler)
	AP_REF.APClient:set_socket_disconnected_handler(socket_disconnected_handler)
	AP_REF.APClient:set_room_info_handler(room_info_handler)
end

-- Need to find a function to hook to poll every frame. (ExecuteInGameThread and LoopAsync don't work)
RegisterHook("/Game/Gameplay/Save/BP_SaveManager.BP_SaveManager_C:Tick", function(self, deltaSeconds)
    local name = self:GetFullName()
    print(name)

    if AP_REF.APClient ~= nil then
        if AP_REF.APClient:get_state() == AP.State.DISCONNECTED then
            connected = false
        else
            connected = true
        end
        AP_REF.APClient:poll()
   end
end)



function AP_REF.Connect(self)
    APConnect(AP_REF.APHost)
end

return AP_REF