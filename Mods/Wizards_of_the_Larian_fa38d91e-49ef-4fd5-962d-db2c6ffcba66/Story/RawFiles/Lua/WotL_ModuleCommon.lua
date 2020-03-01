-- Third degree function to calculate range
-- Fixed points are (5,5), (13,8), (25,25)
-- y = 0.003731685*x^3 - 0.1083791*x^2 + 1.359318*x + 0.4464286
function WotL_NormalizeRange(x)
    local a = 0.003731685
    local b = - 0.1083791
    local c = 1.359318
    local d = 0.4464286
    return a*x^3 + b*x^2 + c*x + d
end

-- Returns the root parent of the stat
function WotL_GetRootParent(stat)
    local parent = Ext.StatGetAttribute(stat, "Using")
    if parent ~= nil then
        return WotL_GetRootParent(parent)
    end
    return stat
end

local ENUM_WotL_PrintTable = WotL_Set {
    -- "Armor",
    -- "Character",
    -- "Object",
    -- "Potion",
    -- "Shield",
    -- "Skill",
    -- "Status",
    -- "Weapon",
}

-- Prints a text if the type is set
function WotL_ModulePrint(text, type)
    if ENUM_WotL_PrintTable[type] then
        Ext.Print(text)
    end
end

-- Prints a table if the type is set
function WotL_ModuleTPrint(table, type)
    if ENUM_WotL_PrintTable[type] then
        WotL_TPrint(table)
    end
end
