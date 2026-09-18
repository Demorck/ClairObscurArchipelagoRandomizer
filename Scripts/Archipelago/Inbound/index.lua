local SlotDataHandler = require "Archipelago.Inbound.SlotDataHandler"
local ItemsHandler = require "Archipelago.Inbound.ItemsHandler"
local LocationsHandler = require "Archipelago.Inbound.LocationsHandler"
local DeathLinkHandler = require "Archipelago.Inbound.DeathLinkHandler"
local JSONHandler = require "Archipelago.Inbound.JSONHandler"
local ScoutedLocationHandler = require "Archipelago.Inbound.ScoutedLocationHandler"

return {
    SlotDataHandler = SlotDataHandler,
    ItemsHandler = ItemsHandler,
    LocationsHandler = LocationsHandler,
    DeathLinkHandler = DeathLinkHandler,
    JSONHandler = JSONHandler,
    ScoutedLocationHandler = ScoutedLocationHandler
}