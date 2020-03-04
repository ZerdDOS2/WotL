ENUM_WotL_AttributesNames = {
    Strength = "Power",
    Finesse = "Evasion",
    Intelligence = "Precision",
    Constitution = "Constitution",
    Memory =  "Memory",
    Wits =  "Wits",
}

function WotL_SetAttributeStatus(char)
    if not WotL_Bool(ObjectGetFlag(char, "WotL_CharacterInitialized")) or WotL_Bool(CharacterIsDead(char)) then
        return
    end
    for vanilla, attribute in pairs(ENUM_WotL_AttributesNames) do
        local value = CharacterGetAttribute(char, vanilla)
        local status = "WotL_" .. attribute .. "_" .. tostring(value)
        if not WotL_Bool(HasActiveStatus(char, status)) then
            local variable = "WotL_Attribute_" .. attribute
            SetVarInteger(char, variable, value)
            ApplyStatus(char, status, -1.0, 1)
        end
    end
end

function WotL_AddAttributeStatusesToBlacklist()
    for vanilla, attribute in pairs(ENUM_WotL_AttributesNames) do
        for i=0,60,1 do
            local status = "WotL_" .. attribute .. "_" .. tostring(i)
            local db = Osi.DB_WotL_BlacklistVariableStatuses:Get(status)
            if next(db) == nil then
                Osi.DB_WotL_BlacklistVariableStatuses(status)
            end
        end
    end
end
