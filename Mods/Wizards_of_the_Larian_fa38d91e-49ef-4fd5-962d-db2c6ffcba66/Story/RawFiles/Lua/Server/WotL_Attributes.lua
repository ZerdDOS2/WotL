ENUM_WotL_AttributesNames = {
    Strength = "Power",
    Finesse = "Evasion",
    Intelligence = "Precision",
    Constitution = "Constitution",
    Memory =  "Memory",
    Wits =  "Wits",
}

local function SetAttributeStatus(char)
    if WotL_Bool(CharacterIsDead(char)) then
        return
    end
    for vanilla, attribute in pairs(ENUM_WotL_AttributesNames) do
        local value = CharacterGetAttribute(char, vanilla)
        local status = "WotL_" .. attribute .. "_" .. tostring(value)
        if WotL_Bool(NRD_StatExists(status)) and not WotL_Bool(HasActiveStatus(char, status)) then
            ApplyStatus(char, status, -1.0, 1)
        end

        local variable = "WotL_Attribute_" .. attribute
        if GetVarInteger(char, variable) ~= value then
            SetVarInteger(char, variable, value)
        end
    end
end
Ext.NewCall(SetAttributeStatus, "WotL_SetAttributeStatus", "(CHARACTERGUID)_Char")

local function AddAttributeStatusesToBlacklist()
    for vanilla, attribute in pairs(ENUM_WotL_AttributesNames) do
        for i=0,100,1 do
            local status = "WotL_" .. attribute .. "_" .. tostring(i)
            local db = Osi.DB_WotL_BlacklistVariableStatuses:Get(status)
            if WotL_Bool(NRD_StatExists(status)) and next(db) == nil then
                Osi.DB_WotL_BlacklistVariableStatuses(status)
            end
        end
    end
end
Ext.NewCall(AddAttributeStatusesToBlacklist, "WotL_AddAttributeStatusesToBlacklist", "")
