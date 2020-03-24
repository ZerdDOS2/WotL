-- All damage types in the game
ENUM_WotL_AllDamageTypes = {
    "Air",
    "Chaos",
    "Corrosive",
    "Earth",
    "Fire",
    "Magic",
    "Physical",
    "Piercing",
    "Poison",
    "Shadow",
    "Water",
}

-- Converts a string or number to a boolean
function WotL_Bool(v)
    if type(v) == "boolean" then
        return v
    end
    if type(v) == "string" then
        if v == "false" or v == "No" then
            return false
        end
        return true

    elseif type(v) == "number" then
        if v == 0 or v ~= v then
            return false
        end
        return true
    end

    return false
end

-- Creates a Set from a list
function WotL_Set(list)
    local set = {}
    for _, l in ipairs(list) do
        set[l] = true
    end
    return set
end

-- Prints a table recursively, identing basend on the value passed
function WotL_TPrint(tbl, indent)
    if not indent then
        indent = 0
    end
    for k, v in pairs(tbl) do
        local formatting = string.rep("  ", indent) .. k .. ": "
        if type(v) == "table" then
            Ext.Print(formatting)
            WotL_TPrint(v, indent+1)
        else
            Ext.Print(formatting .. tostring(v))
        end
    end
end

-- Truncates a number x to the specified decimal places n
function WotL_Truncate(x, n)
    return math.floor(x*10^n)/10^n
end

-- Inserts a value for a key that might not exist
function WotL_TableInsertTable(name, key, value)
    if name[key] == nil then
        name[key] = {}
    end
    table.insert(name[key], value)
end

-- Removes a table entry based on the key
function WotL_TableRemove(name, key)
    name[key] = nil
end
