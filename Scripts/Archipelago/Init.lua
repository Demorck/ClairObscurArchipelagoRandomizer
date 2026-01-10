local Config = require "Archipelago.Core.Config"
local APClient = require "Archipelago.Core.APClient"
local EventDispatcher = require "Archipelago.Core.EventDispatcher"
local Handlers = require "Archipelago.Handlers.index"

-- Connection states
E_CLIENT_INFOS = {
    DISCONNECTED = 0,
    TRYING_TO_CONNECT = 1,
    CONNECTED = 2
}

local ArchipelagoSystem = {}

function ArchipelagoSystem:Initialize()
    -- Initialize config
    local config = Config
    config:Init()

    -- Create event dispatcher
    local eventDispatcher = EventDispatcher:New({
        logger = Logger
    })

    -- Create AP client
    local apClient = APClient:New({
        logger = Logger,
        config = config,
        eventDispatcher = eventDispatcher
    })

    -- Create handlers
    local slotDataHandler = Handlers.SlotDataHandler:New({
        logger = Logger,
        storage = Storage,
        apClient = apClient
    })

    local itemsHandler = Handlers.ItemsHandler:New({
        logger = Logger,
        storage = Storage,
        apClient = apClient
    })

    local locationsHandler = Handlers.LocationsHandler:New({
        logger = Logger,
        apClient = apClient
    })

    local deathLinkHandler = Handlers.DeathLinkHandler:New({
        logger = Logger
    })

    -- Set archipelago reference (for legacy compatibility)
    slotDataHandler:SetArchipelago(Archipelago)
    itemsHandler:SetArchipelago(Archipelago)
    deathLinkHandler:SetArchipelago(Archipelago)

    -- Register handlers with dispatcher
    eventDispatcher:RegisterHandler("slotConnected", function(data)
        slotDataHandler:Handle(data)
    end)

    eventDispatcher:RegisterHandler("itemsReceived", function(data)
        itemsHandler:Handle(data)
    end)

    eventDispatcher:RegisterHandler("locationsChecked", function(data)
        locationsHandler:Handle(data)
    end)

    eventDispatcher:RegisterHandler("bounced", function(data)
        deathLinkHandler:Handle(data)
    end)


    -- Store references
    self.config = config
    self.apClient = apClient
    self.eventDispatcher = eventDispatcher

    -- Setup polling loop
    self:SetupPollingLoop()

    Logger:info("Archipelago system initialized")

    return self
end

function ArchipelagoSystem:SetupPollingLoop()
    LoopAsync(1000, function()
        if self.apClient.wantToConnect then
            if self.apClient.client then
                self.apClient:Poll()

                -- Sync if waiting
                if Archipelago and Archipelago.waitingForSync then
                    self.apClient:Sync()
                    Archipelago.waitingForSync = false
                end
            else
                self.apClient:Connect()
            end
        end

        return false
    end)
end

--- Set connection configuration
---@param host string
---@param port string
---@param slot string
---@param password string
---@param deathlink boolean
function ArchipelagoSystem:SetConnectionConfig(host, port, slot, password, deathlink)
    self.config:SetConnection(host, port, slot, password, deathlink)

    -- Update Archipelago legacy reference
    if Archipelago then
        Archipelago.death_link = deathlink
    end
end

--- Toggle connection
function ArchipelagoSystem:ToggleConnection()
    if self.apClient.wantToConnect then
        Logger:info("Disconnecting...")
        self.apClient:Disconnect()

        if Hooks then
            Hooks:Unregister()
        end
    else
        Logger:info("Connecting...")
        Logger:initialize()
        self.apClient:Connect()
    end
end

--- Check if connected
---@return boolean
function ArchipelagoSystem:IsConnected()
    return self.apClient:IsConnected()
end

--- Get AP client
---@return APClient
function ArchipelagoSystem:GetClient()
    return self.apClient
end

-- Initialize and return
local system = ArchipelagoSystem:Initialize()

return system