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
        if v == 0 then
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

-- Rolls a random chance of source hitting target
-- Returns true for a hit and false for a miss
function WotL_RollHitChance(target, source)
    local dodge = NRD_CharacterGetComputedStat(target, "Dodge", 1)
    -- Ext.Print("Dodge:" .. tostring(dodge))
    local accuracy = NRD_CharacterGetComputedStat(source, "Accuracy", 1)
    -- Ext.Print("Accuracy:" .. tostring(accuracy))
    local cthb = NRD_CharacterGetComputedStat(source, "ChanceToHitBoost", 1)

    local hitChance = accuracy + cthb - dodge
    hitChance = math.max(hitChance, 5)
    hitChance = math.min(hitChance, 95)

    local roll = math.random(1, 100)
    if roll > hitChance then
        return false
    end
    return true
end
