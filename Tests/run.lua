package.path = "Scripts/?.lua;Tests/?.lua;" .. package.path
require("stubs")

require("test_regions")
require("test_runtime_state")
require("test_goals")
require("test_options")
require("test_storage")
require("test_merchants_locations")
require("test_shops")
require("test_item_receiver")

require("runner").report()