-- Tests/stubs.lua
---Stands in for the globals UE4SS injects, so pure modules can be required outside the game
local function noop() end

-- Deleting some functions
Logger = { info = noop, warn = noop, error = noop, debug = noop }
Debug = { print = noop }

JSON = require("Utils.json")
Utils = require("Utils.index")

Dump = Utils.TableHelper.Dump
Contains = Utils.TableHelper.Contains
Trim = Utils.StringHelper.Trim
Remove = Utils.TableHelper.Remove