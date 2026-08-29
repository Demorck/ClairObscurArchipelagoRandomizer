---@class Logger
local Logger = {}


local log_dir = "../../Content/Paks/LogicMods/ClairObscurRandomizer_data/Logs"
local max_logs = 10
local logFile = nil
local queue = {}
local writing = false

CONCURRENT_LOG_HITS = 0
local depth = 0


local os_date, io_open, table_concat = os.date, io.open, table.concat
os.execute("mkdir \"" .. log_dir .. "\"") -- Create the log directory if it doesn't exist

local function sanitize(value, fallback)
    if value == nil or value == "" then return fallback end
    return (tostring(value):gsub("[^%w%-]", "_"))
end


--- Create the name of the file
---@return string 
local function makeLogName()
    return log_dir .. "/" .. os_date("%Y-%m-%d_%H-%M-%S") .. ".txt"
end

--- List log files
---@return table
local function listLogs()
    local files = {}
    local p = io.popen('dir "' .. log_dir .. '" /b /o-d') -- Windows command to list files in reverse order
    if p then
        for file in p:lines() do
            if file:match("%.txt$") then
                table.insert(files, file)
            end
        end
        p:close()
    end
    return files
end

--- Rotate logs by keeping only the last 10 files
local function rotateLogs(currentName)
    local files = listLogs()
    for i = max_logs + 1, #files do
        if files[i] ~= currentName then
            os.remove(log_dir .. "/" .. files[i])
        end
    end
end

local function flush()
    if logFile == nil or writing then return end

    writing = true
    while #queue > 0 do
        local batch = queue
        queue = {}
        local file = io_open(logFile, "a")
        if not file then
            for i = #batch, 1, -1 do table.insert(queue, 1, batch[i]) end
            Debug.print("LOGGER: impossible d'ouvrir " .. logFile)
            break
        end

        file:write(table_concat(batch))
        file:close()
    end
    writing = false
end


-- Write a line to the log
local function writeLine(line)

    depth = depth + 1
    if depth > 1 then CONCURRENT_LOG_HITS = CONCURRENT_LOG_HITS + 1 end
    queue[#queue + 1] = os_date("[%d-%m-%Y %H:%M:%S] ") .. line .. "\n"
    if logFile == nil then
        Debug.print("LOGGER: " .. line)
        if #queue > 2000 then table.remove(queue, 1) end
        -- return
    else
        flush()
    end

    depth = depth - 1
end

-- Public API
--- Logs an informational message
---@param msg any
function Logger:info(msg)
    writeLine("[INFO] " .. tostring(msg))
end

function Logger:warn(msg)
    writeLine("[WARN] " .. tostring(msg))
end

function Logger:error(msg)
    writeLine("[ERROR] " .. tostring(msg))
end

function Logger:debug(msg)
    writeLine("[DEBUG] " .. tostring(msg))
end

function Logger:startSession()
    logFile = nil
    queue = { ("\n===== Session %s =====\n"):format(os_date("%Y-%m-%d %H:%M:%S")) }
end

function Logger:bindSeed(slot, seed)
    if logFile ~= nil then return end

    local name =  sanitize(seed, "no-seed") .. "_" .. sanitize(slot, "no-slot") .. ".txt"
    logFile = log_dir .. "/" .. name

    rotateLogs(name)

    flush()
end

function Logger:safeCall(fn, method_name, ...)
    local ok, result = xpcall(fn, debug.traceback, ...)
    if not ok then
        self:error("Lua crash: " .. tostring(result))
    end
    return result
end

function Logger:callMethod(obj, method_name, ...)
    local args = {...} 
    local fun = obj[method_name]
    if type(fun) ~= "function" and type(fun) ~= "userdata" then
        self:error("callMethod failed, " .. tostring(method_name) .. " is not a function")
        return
    end
    -- self:info(method_name .. " called with " .. tostring(#args) .. " arguments")
    return self:safeCall(function()
        return fun(obj, table.unpack(args)) 
    end)
end

--- Wrap a table with logging
---@param t table
---@param name string
---@return table
function Logger:wrapTable(t, name)
    name = name or "AnonymousTable"
    for k, v in pairs(t) do
        if type(v) == "function" then
            local original = v
            t[k] = function(...)
                return Logger:safeCall(function(...)
                    return original(...)
                end, ...)
            end
            Logger:info("Wrapped function " .. name .. "." .. k)
        elseif type(v) == "table" then
            Logger:wrapTable(v, name .. "." .. tostring(k))
        end
    end
    return t
end


function Logger:initialize()
    logFile = makeLogName()
    rotateLogs()
    Logger:info("Logger initialized: " .. logFile)
    Logger:info("Client mod version: " .. CONSTANTS.VERSION)
end

return Logger
