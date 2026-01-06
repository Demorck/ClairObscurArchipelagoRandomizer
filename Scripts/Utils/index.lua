---@class Utils
---@field TableHelper TableHelpers
---@field StringHelper StringHelpers
---@field json any
local Utils        = {}

Utils.TableHelper  = require "Utils.TableHelpers"
Utils.StringHelper = require "Utils.StringHelpers"
Utils.json         = require "Utils.json"

return Utils