package.path = "Scripts/?.lua;Tests/?.lua;" .. package.path
require("stubs")

require("test_regions")
require("test_runtime_state")
require("test_goals")
require("test_options")

require("runner").report()