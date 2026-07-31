---@class Utils
---@field TableHelper TableHelpers
---@field StringHelper StringHelpers
---@field json any
local Utils        = {}

Utils.TableHelper  = require "Utils.TableHelpers"
Utils.StringHelper = require "Utils.StringHelpers"
Utils.json         = require "Utils.json"



local stats = {}

---@param name string
---@param t0 number
function Utils.record(name, t0)
    local s = stats[name]
    if not s then
        s = { n = 0, total = 0 }
        stats[name] = s
    end
    s.n = s.n + 1
    s.total = s.total + (os.clock() - t0)
end



function Utils.DumpStats()
    for name, s in pairs(stats) do
        print(("%-14s %5d appels, %6.0f ms total, %5.2f ms/appel")
            :format(name, s.n, s.total * 1000, s.total * 1000 / s.n))
    end
end


return Utils