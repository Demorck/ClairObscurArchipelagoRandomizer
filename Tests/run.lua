package.path = "Scripts/?.lua;Tests/?.lua;" .. package.path
require("stubs")

require("test_regions")
require("test_runtime_state")

require("runner").report()