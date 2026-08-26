local SlotDataHandler = require "Archipelago.Handlers.SlotDataHandler"
local ItemsHandler = require "Archipelago.Handlers.ItemsHandler"
local LocationsHandler = require "Archipelago.Handlers.LocationsHandler"
local DeathLinkHandler = require "Archipelago.Handlers.DeathLinkHandler"
local JSONHandler = require "Archipelago.Handlers.JSONHandler"
local ScoutedLocationHandler = require "Archipelago.Handlers.ScoutedLocationHandler"

return {
    SlotDataHandler = SlotDataHandler,
    ItemsHandler = ItemsHandler,
    LocationsHandler = LocationsHandler,
    DeathLinkHandler = DeathLinkHandler,
    JSONHandler = JSONHandler,
    ScoutedLocationHandler = ScoutedLocationHandler
}