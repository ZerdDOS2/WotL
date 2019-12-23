ENUM_WotL_AttributesNames = {
    Strength = "Power",
    Finesse = "Evasion",
    Intelligence = "Precision",
    Constitution = "Constitution",
    Memory =  "Memory",
    Wits =  "Wits",
}

function WotL_SetAttributeStatus(char)
    WotL_AddAttributeStatusesToBlacklist()
    if not bool(ObjectGetFlag(char, "WotL_CharacterInitialized")) or bool(CharacterIsDead(char)) then
        return
    end
    for vanilla, attribute in pairs(ENUM_WotL_AttributesNames) do
        local value = CharacterGetAttribute(char, vanilla)
        local status = "WotL_" .. attribute .. "_" .. tostring(value)
        if not bool(HasActiveStatus(char, status)) then
            local variable = "WotL_Attribute_" .. attribute
            SetVarInteger(char, variable, value)

            -- Remove Status from blacklist (NOT DB_WotL_BlacklistVariableStatuses(_Status);)
            -- Add it back again (DB_WotL_BlacklistVariableStatuses(_Status);)
            ApplyStatus(char, status, -1.0, 1)
        end
    end
end

function WotL_AddAttributeStatusesToBlacklist()
    for vanilla, attribute in pairs(ENUM_WotL_AttributesNames) do
        for i=0,60,1 do
            local status = "WotL_" .. attribute .. "_" .. tostring(i)
            Osi.DB_WotL_BlacklistVariableStatuses(status)
        end
    end
end
