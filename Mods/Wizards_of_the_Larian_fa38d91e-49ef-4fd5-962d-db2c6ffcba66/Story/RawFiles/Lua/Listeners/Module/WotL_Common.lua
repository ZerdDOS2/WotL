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
