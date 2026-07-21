---Facade
---Exports all Facade modules
local Facade = {
    ItemReceiver = require("Archipelago.Facade.ItemReceiver"),
    CapacityHandler = require("Archipelago.Facade.CapacityHandler"),
    TrapHandler = require("Archipelago.Facade.TrapHandler"),
    DeathLinkManager = require("Archipelago.Facade.DeathLinkManager"),
    LocationManager = require("Archipelago.Facade.LocationManager"),
}

return Facade
