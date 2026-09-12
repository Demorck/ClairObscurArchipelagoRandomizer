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

    -- Register handlers with dispatcher
    eventDispatcher:RegisterHandler("slotConnected", function(data)
        ExecuteInGameThread(function ()
            Handlers.SlotDataHandler:Handle(data)
        end)
    end)

    eventDispatcher:RegisterHandler("itemsReceived", function(data)
        ExecuteInGameThread(function ()
            Handlers.ItemsHandler:Handle(data)
        end)
    end)

    eventDispatcher:RegisterHandler("locationsChecked", function(data)
        ExecuteInGameThread(function ()
            Handlers.LocationsHandler:Handle(data)
        end)
    end)

    eventDispatcher:RegisterHandler("bounced", function(data)
        ExecuteInGameThread(function ()
            Handlers.DeathLinkHandler:Handle(data)
        end)
    end)

    eventDispatcher:RegisterHandler("json", function (data)
        ExecuteInGameThread(function ()
            Handlers.JSONHandler:Handle(data)
        end)
    end)

    eventDispatcher:RegisterHandler("onScouted", function(data)
        ExecuteInGameThread(function ()
            Handlers.ScoutedLocationHandler:Handle(data)
        end)
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

GameState = { canReceiveItems = false, isInitialized = false }

--TODO: return true when ap is disconnected 
function ArchipelagoSystem:SetupPollingLoop()
    local pollTicks = 0
    local pollHandle
    pollHandle = LoopInGameThreadWithDelay(250, function()
        if self.pendingToggle then
            self.pendingToggle = false
            self:ToggleConnection()
        end

        if self.apClient.wantToConnect then
            if self.apClient.client then
                self.apClient:Poll()
                self.apClient:DrainPendingCalls()
                if Archipelago and Archipelago.waitingForSync and Archipelago:CanReceiveItems() then
                    if self.apClient:Sync() then
                        Archipelago.waitingForSync = false
                    end
                end
            else
                self.apClient:Connect()
            end
        end
    end)

    local loopHandle
    loopHandle = LoopInGameThreadWithDelay(500, function()
        GameState.canReceiveItems = Archipelago:CanReceiveItems()
        GameState.isInitialized   = Archipelago:IsInitialized()

        Storage:Flush()

        if Archipelago and Archipelago.pendingLocationsFlush and self:IsConnected() then
            Archipelago.pendingLocationsFlush = false
            Archipelago:SendAlreadyChecked()
        end

        if Archipelago and NEEDED_TO_INIT and GameState.isInitialized then
            NEEDED_TO_INIT = false
            InitSaveAfterLumiere()
        end

        if Archipelago.hasConnectedPrior and not self.apClient.wantToConnect then
            CancelDelayedAction(loopHandle)
        end
    end)

    local itemLoop
    itemLoop = LoopInGameThreadWithDelay(100, function()
        Handlers.ItemsHandler:Drain()
    end)

    local saveLoopHandle
    saveLoopHandle = LoopInGameThreadWithDelay(1000 * 60 * 10, function()
        Save:SaveGame()
        if not self.apClient.wantToConnect then
            CancelDelayedAction(saveLoopHandle)
        end
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
        Storage:Flush()
        self.apClient:Disconnect()

        if Hooks then
            ExecuteInGameThread(function() Hooks:Unregister() end)
        end
    else
        Logger:info("Connecting...")
        Logger:startSession()
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