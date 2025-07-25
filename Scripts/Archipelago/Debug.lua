local debug = {}
local ENABLED = true

local function Dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. Dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

--- Prints a debug message if debug is enabled.
---@param str string The message to print.
---@param from string | nil The prefix to print to know where the print comes from
---@param fun function | nil The function to use if different from print
function debug.print(str, from, fun)
    if ENABLED then
        local converted_str = str
        if type(str) == "table" then
            converted_str = Dump(str)
        end

        if from == nil then
            from = ""
        end
        
        if fun == nil then
            print("[Clair Obscur Randomizer] DEBUG " .. from .. " : " .. converted_str)
        else
            fun("[Clair Obscur Randomizer] DEBUG " .. from .. " : " .. converted_str)
        end
    end
end


--- Dummy callback that does nothing.
---@private
local function passthrough(...) end


--- Logs a single argument.
---@private
---@param arg any
local function one_arg(arg) debug.print(arg) end


--- Logs two arguments.
---@private
---@param a any
---@param b any
local function two_arg(a, b) 
    debug.print(a)
    debug.print(b)
end

--- Logs three arguments.
---@private
---@param a any
---@param b any
---@param c any
local function three_arg(a, b, c) 
    debug.print(a) 
    debug.print(b) 
    debug.print(c)
end

--- Default debug callbacks for AP events.
---@type table<string, fun(...)>
debug.callbacks = {
    on_socket_connected = passthrough,
    on_socket_error = one_arg,
    on_socket_disconnected = passthrough,
    on_room_info = passthrough,
    on_slot_connected = one_arg,
    on_slot_refused = one_arg,
    on_items_received = one_arg,
    on_location_info = one_arg,
    on_location_checked = one_arg,
    on_data_package_changed = one_arg,
    on_print = one_arg,
    on_print_json = two_arg,
    on_bounced = one_arg,
    on_retrieved = three_arg,
    on_set_reply = one_arg
}

return debug