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

---Deep copy a table (recursive)
---@param original table Table to copy
---@param copies table|nil Internal table to track circular references
---@return table copy Deep copy of the table
function TableHelpers.DeepCopy(original, copies)
    copies = copies or {}
    local original_type = type(original)
    local copy
    
    if original_type == 'table' then
        if copies[original] then
            copy = copies[original]
        else
            copy = {}
            copies[original] = copy
            for k, v in next, original, nil do
                copy[TableHelpers.DeepCopy(k, copies)] = TableHelpers.DeepCopy(v, copies)
            end
            setmetatable(copy, TableHelpers.DeepCopy(getmetatable(original), copies))
        end
    else
        copy = original
    end
    
    return copy
end

---Merge two tables (shallow)
---@param t1 table First table
---@param t2 table Second table (values override t1)
---@return table merged Merged table
function TableHelpers.Merge(t1, t2)
    local result = {}
    for k, v in pairs(t1) do
        result[k] = v
    end
    for k, v in pairs(t2) do
        result[k] = v
    end
    return result
end

---Get table size (works with non-array tables)
---@param tbl table Table to measure
---@return number size Number of elements
function TableHelpers.Size(tbl)
    local count = 0
    for _ in pairs(tbl) do
        count = count + 1
    end
    return count
end

---Check if table is empty
---@param tbl table Table to check
---@return boolean empty True if table has no elements
function TableHelpers.IsEmpty(tbl)
    return next(tbl) == nil
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
            elseif type(k) == "boolean" then
                k = tostring(k)
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
            elseif type(v) == "boolean" then
                v = tostring(v)
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

function TableHelpers.GetRandomElement(table)
    return table[math.random(#table)]
end

return TableHelpers