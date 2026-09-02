package.path = "Scripts/?.lua;Tests/?.lua;" .. package.path
require("stubs")

require("test_regions")

require("runner").report()