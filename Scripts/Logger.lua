local Logger = {}


local log_dir = "../../Content/Paks/LogicMods/ClairObscurRandomizer_data/Logs"
local max_logs = 10
local logFile = ""

os.execute("mkdir \"" .. log_dir .. "\"") -- Create the log directory if it doesn't exist

--- Create the name of the file
---@return string 
local function makeLogName()
    return log_dir .. "/" .. os.date("%Y-%m-%d_%H-%M-%S") .. ".txt"
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
local function rotateLogs()
    local files = listLogs()
    if #files > max_logs then
        for i = max_logs + 1, #files do
            os.remove(log_dir .. "/" .. files[i])
        end
    end
end

-- Write a line to the log
local function writeLine(line)
    if logFile == "" then
        Debug.print("LOGGER: " .. line)
        return
    end


    local file = io.open(logFile, "a")
    if file then
        file:write(os.date("[%d-%m-%Y %H:%M:%S] ") .. line .. "\n")
        file:close()
    end
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

function Logger:safeCall(fn, ...)
    local ok, result = xpcall(fn, debug.traceback, ...)
    if not ok then
        Logger:error("Lua crash: " .. tostring(result))
    else
        Logger:info("OK ? " .. tostring(ok))
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
    self:info("Function " .. method_name .. " found")
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
    Logger:info("Logger initialisé: " .. logFile)
end

return Logger
