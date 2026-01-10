---@class APClientDependencies
---@field logger Logger Logger instance
---@field config Config Configuration manager
---@field eventDispatcher EventDispatcher Event dispatcher for AP events

---@class APClientState
---@field DISCONNECTED integer Client is disconnected
---@field CONNECTING integer Client is trying to connect
---@field CONNECTED integer Client is connected to slot

---@class APClient
---@field logger Logger Logger instance
---@field config Config Configuration manager
---@field eventDispatcher EventDispatcher Event dispatcher
---@field client any The underlying lua-apclientpp client instance
---@field isConnecting boolean Whether connection is in progress
---@field wantToConnect boolean Whether we want to maintain connection
---@field AP any The AP library (lua-apclientpp)
local APClient = {}

---Create a new APClient instance
---@param dependencies APClientDependencies
---@return APClient
function APClient:New(dependencies)
    local instance = {
        logger = dependencies.logger,
        config = dependencies.config,
        eventDispatcher = dependencies.eventDispatcher,

        -- State
        client = nil,
        isConnecting = false,
        wantToConnect = false,

        -- AP library
        AP = nil,
    }

    setmetatable(instance, { __index = APClient })
    instance:Initialize()

    return instance
end

---Initialize the AP library (lua-apclientpp)
---@private
function APClient:Initialize()
    self.AP = require("lua-apclientpp")
    if not self.AP then
        error("lua-apclientpp not found! Cannot continue.")
    end

    self.logger:info("AP library loaded successfully")
end

---Connect to the Archipelago server
---Initiates connection to the AP server with current configuration
---@return boolean success True if connection initiated successfully
function APClient:Connect()
    if self.client then
        self.logger:warn("Already connected or connecting")
        return false
    end

    self.isConnecting = true
    self.wantToConnect = true

    local host = self.config:Get("host")
    local gameName = self.config:Get("gameName")
    local slot = self.config:Get("slot")

    self.logger:info(string.format(
        "Connecting to AP server - Host: %s, Game: %s, Slot: %s",
        host, gameName, slot
    ))

    -- Create client
    local uuid = ""
    self.client = self.AP(uuid, gameName, host)

    -- Update UI
    self:UpdateConnectionUI("TRYING_TO_CONNECT")

    -- Set up handlers
    self:SetupHandlers()

    return true
end

---Disconnect from the Archipelago server
---Closes connection and cleans up resources
function APClient:Disconnect()
    if not self.client then
        self.logger:warn("Not connected")
        return
    end

    self.logger:info("Disconnecting from AP server...")

    self.client = nil
    self.wantToConnect = false
    self.isConnecting = false

    -- Update UI
    self:UpdateConnectionUI("DISCONNECTED")

    -- Unregister hooks
    if Hooks then
        Hooks:Unregister()
    end

    collectgarbage("collect")
end

---Toggle connection state (connect if disconnected, disconnect if connected)
function APClient:Toggle()
    if self.wantToConnect then
        self:Disconnect()
    else
        self:Connect()
    end
end

---Set up event handlers for AP client
---Registers callbacks for socket events, room events, and game events
---@private
function APClient:SetupHandlers()
    -- Socket events
    self.client:set_socket_connected_handler(function()
        self:OnSocketConnected()
    end)

    self.client:set_socket_error_handler(function(msg)
        self:OnSocketError(msg)
    end)

    self.client:set_socket_disconnected_handler(function()
        self:OnSocketDisconnected()
    end)

    -- Room events
    self.client:set_room_info_handler(function()
        self:OnRoomInfo()
    end)

    self.client:set_slot_refused_handler(function(reasons)
        self:OnSlotRefused(reasons)
    end)

    -- Game events (delegated to event dispatcher)
    self.client:set_slot_connected_handler(function(slot_data)
        self.eventDispatcher:OnSlotConnected(slot_data)
    end)

    self.client:set_items_received_handler(function(items)
        self.eventDispatcher:OnItemsReceived(items)
    end)

    self.client:set_location_checked_handler(function(locations)
        self.eventDispatcher:OnLocationsChecked(locations)
    end)

    self.client:set_bounced_handler(function(data)
        self.eventDispatcher:OnBounced(data)
    end)

    self.client:set_retrieved_handler(function(data)
        self.eventDispatcher:OnRetrieved(data)
    end)
end

---Socket connected callback
---@private
function APClient:OnSocketConnected()
    self.logger:info("Socket connected successfully")
    self:UpdateConnectionUI("CONNECTED")
end

---Socket error callback
---@private
---@param msg string Error message
function APClient:OnSocketError(msg)
    self.logger:error("Socket error: " .. tostring(msg))
    self:UpdateConnectionUI("DISCONNECTED")

    if not self.isConnecting then
        self.wantToConnect = false
    end
end

---Socket disconnected callback
---@private
function APClient:OnSocketDisconnected()
    self.logger:info("Socket disconnected")
    self:UpdateConnectionUI("DISCONNECTED")

    if not self.isConnecting then
        self.wantToConnect = false
    end
end

---Room info received - send connect request to slot
---@private
function APClient:OnRoomInfo()
    self.logger:info("Room info received, connecting to slot...")

    local slot = self.config:Get("slot")
    local password = self.config:Get("password")
    local itemsHandling = self.config:Get("itemsHandling")
    local tags = self.config:Get("tags")
    local version = self.config:Get("version")

    self.client:ConnectSlot(slot, password, itemsHandling, tags, version)
end

---Slot connection refused callback
---@private
---@param reasons string[] Array of refusal reasons
function APClient:OnSlotRefused(reasons)
    self.logger:error("Slot refused: " .. table.concat(reasons, ", "))
    self:UpdateConnectionUI("DISCONNECTED")
end

---Update connection UI status
---@private
---@param status "DISCONNECTED"|"TRYING_TO_CONNECT"|"CONNECTED"
function APClient:UpdateConnectionUI(status)
    ---@type ABP_ArchipelagoHelper_C
    local helper = FindFirstOf("BP_ArchipelagoHelper_C")

    if helper and helper:IsValid() then
        local statusEnum = E_CLIENT_INFOS[status]
        if statusEnum then
            helper:ChangeAPTextConnect(statusEnum)
            helper:SetConnection(status == "CONNECTED")
        end
    end
end

---Poll the client to process network events
---Should be called regularly
function APClient:Poll()
    if not self.client then
        return
    end

    local ok, err = pcall(function()
        self.client:poll()
    end)

    if not ok then
        self.logger:error("Poll error: " .. tostring(err))
    end
end

---Check if currently connected to an AP slot
---@return boolean connected True if connected to slot
function APClient:IsConnected()
    return self.client ~= nil and
           self.client:get_state() == self.AP.State.SLOT_CONNECTED
end

---Get the underlying AP client instance
---@return any client The lua-apclientpp client
function APClient:GetClient()
    return self.client
end

---Send location checks to the AP server
---@param locationIds number[] Array of location IDs to check
---@return boolean success True if sent successfully
function APClient:SendLocationChecks(locationIds)
    if not self:IsConnected() then
        self.logger:warn("Cannot send location checks - not connected")
        return false
    end

    ExecuteAsync(function()
        self.client:LocationChecks(locationIds)
    end)

    return true
end

---Send completion status to AP server (goal completed)
---@return boolean success True if sent successfully
function APClient:SendCompletion()
    if not self:IsConnected() then
        self.logger:warn("Cannot send completion - not connected")
        return false
    end

    self.client:StatusUpdate(self.AP.ClientStatus.GOAL)
    self.logger:info("Sent completion status to AP")

    return true
end

---Send bounce message (e.g., for DeathLink)
---@param data table Data to bounce
---@param games table|nil Game filter
---@param slots table|nil Slot filter
---@param tags table|nil Tags for filtering
---@return boolean success True if sent successfully
function APClient:Bounce(data, games, slots, tags)
    if not self:IsConnected() then
        self.logger:warn("Cannot send bounce - not connected")
        return false
    end

    self.client:Bounce(data, games or {}, slots or {}, tags or {})
    return true
end

---Sync with the AP server (request all items)
---@return boolean success True if sync initiated
function APClient:Sync()
    if not self:IsConnected() then
        return false
    end

    self.client:Sync()
    return true
end

---Get current player information
---@return table<string, any> info Player information table
function APClient:GetPlayerInfo()
    if not self:IsConnected() then
        return {}
    end

    local playerNumber = self.client:get_player_number()

    return {
        slot = self.client:get_slot(),
        seed = self.client:get_seed(),
        number = playerNumber,
        alias = self.client:get_player_alias(playerNumber),
        game = self.client:get_player_game(playerNumber)
    }
end

---Get item name from item ID
---@param itemId number The item ID
---@param game string The game name
---@return string|nil itemName The item name, or nil if not found
function APClient:GetItemName(itemId, game)
    if not self:IsConnected() then
        return nil
    end

    return self.client:get_item_name(itemId, game)
end

---Get location name from location ID
---@param locationId number The location ID
---@param game string The game name
---@return string|nil locationName The location name, or nil if not found
function APClient:GetLocationName(locationId, game)
    if not self:IsConnected() then
        return nil
    end

    return self.client:get_location_name(locationId, game)
end

---Get location ID from location name
---@param locationName string The location name
---@return number|nil locationId The location ID, or nil if not found
function APClient:GetLocationId(locationName)
    if not self:IsConnected() then
        return nil
    end

    return self.client:get_location_id(locationName)
end

---Set data storage value on AP server
---@param key string Storage key
---@param value any Value to store
---@param wantReply boolean Whether to request a reply
---@param operations table Operations to perform
---@return boolean success True if set successfully
function APClient:SetDataStorage(key, value, wantReply, operations)
    if not self:IsConnected() then
        return false
    end

    self.client:Set(key, value, wantReply or false, operations or {})
    return true
end

---Get current server time
---@return number serverTime Server timestamp in seconds
function APClient:GetServerTime()
    if not self:IsConnected() then
        return 0
    end

    return self.client:get_server_time()
end

return APClient