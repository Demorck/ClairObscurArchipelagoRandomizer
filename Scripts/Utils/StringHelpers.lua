---String utility functions
---@class StringHelpers
local StringHelpers = {}

---Trim whitespace from both ends of string
---@param s string String to trim
---@return string trimmed Trimmed string
function StringHelpers.Trim(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

---Split string by delimiter
---@param str string String to split
---@param delimiter string Delimiter pattern
---@return string[] parts Array of split parts
function StringHelpers.Split(str, delimiter)
    local result = {}
    local pattern = string.format("([^%s]+)", delimiter)
    for match in string.gmatch(str, pattern) do
        table.insert(result, match)
    end
    return result
end

---Check if string starts with prefix
---@param str string String to check
---@param prefix string Prefix to look for
---@return boolean startsWith True if string starts with prefix
function StringHelpers.StartsWith(str, prefix)
    return str:sub(1, #prefix) == prefix
end

---Check if string ends with suffix
---@param str string String to check
---@param suffix string Suffix to look for
---@return boolean endsWith True if string ends with suffix
function StringHelpers.EndsWith(str, suffix)
    return suffix == "" or str:sub(-#suffix) == suffix
end

return StringHelpers