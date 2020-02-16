-- Converts a string or number to a boolean
function bool(v)
    if type(v) == "string" then
        if v == "false" or v == "No" then
            return false
        end
        return true

    elseif type(v) == "number" then
        if v == 0 then
            return false
        end
        return true
    end

    return false
end

-- Creates a Set from a list
function Set(list)
    local set = {}
    for _, l in ipairs(list) do
        set[l] = true
    end
    return set
end

-- Prints a table recursively, identing basend on the value passed
function tprint (tbl, indent)
    if not indent then
        indent = 0
    end
    for k, v in pairs(tbl) do
        local formatting = string.rep("  ", indent) .. k .. ": "
        if type(v) == "table" then
            Ext.Print(formatting)
            tprint(v, indent+1)
        elseif type(v) == 'boolean' then
            Ext.Print(formatting .. tostring(v))		
        else
            Ext.Print(formatting .. v)
        end
    end
end

-- Truncates a number x to the specified decimal places n
function truncate(x, n)
    return math.floor(x*10^n)/10^n
end
