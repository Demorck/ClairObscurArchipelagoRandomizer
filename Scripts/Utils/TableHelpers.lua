---Table utility functions
---@class TableHelpers
local TableHelpers = {}

---Check if table contains a value
---@param tbl table Table to search
---@param value any Value to find
---@return boolean found True if value is in table
function TableHelpers.Contains(tbl, value)
    for i = 1, #tbl do
        if tbl[i] == value then
            return true
        end
    end
    return false
end

---Remove first occurrence of value from table
---@param tbl table Table to modify
---@param value any Value to remove
---@return boolean removed True if value was found and removed
function TableHelpers.Remove(tbl, value)
    for i = 1, #tbl do
        if tbl[i] == value then
            table.remove(tbl, i)
            return true
        end
    end
    return false
end

---Deep dump table to string for debugging
---@param o any Value to dump
---@param depth number|nil Current depth (for recursion)
---@return string dumped String representation
function TableHelpers.Dump(o, depth)
    depth = depth or 0
    local indent = string.rep('  ', depth * 4)

    if type(o) == 'table' then
        local s = '{\n'
        for k, v in pairs(o) do
            if type(k) == "userdata" then k = k:get() end
            
            if type(k) == 'string' then 
                k = '"' .. k .. '"'
            elseif type(k) == "number" then 
                k = k
            elseif string.find(tostring(k), "FName") then 
                k = k:ToString()
            else 
                k = type(k)
            end

            if string.find(tostring(v), "FName") then 
                v = v:ToString()
            elseif type(v) == "userdata" then 
                v = v:get()
                if string.find(tostring(v), "FName") then 
                    v = v:ToString() 
                end
            end
            
            if type(v) == 'string' then 
                v = '"' .. v .. '"'
            elseif type(v) == "number" then 
                v = v
            else 
                v = type(v) 
            end
            
            s = s .. indent .. '[' .. k .. '] = ' .. TableHelpers.Dump(v, depth + 1) .. ',\n'
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

return TableHelpers