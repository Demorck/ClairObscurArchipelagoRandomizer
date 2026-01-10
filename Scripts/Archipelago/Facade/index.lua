---Facade
---Exports all Facade modules
local Facade = {
    ItemReceiver = require("Archipelago.Facade.ItemReceiver"),
    CapacityHandler = require("Archipelago.Facade.CapacityHandler"),
    TrapHandler = require("Archipelago.Facade.TrapHandler"),
    DeathLinkManager = require("Archipelago.Facade.DeathLinkManager"),
    LocationSender = require("Archipelago.Facade.LocationSender"),
}

return Facade
