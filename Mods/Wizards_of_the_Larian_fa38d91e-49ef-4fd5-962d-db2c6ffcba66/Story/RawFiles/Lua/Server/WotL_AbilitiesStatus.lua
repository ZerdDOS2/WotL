ENUM_WotL_AbilitiesNames = {
    TwoHanded = "BrutalCritical",
    SingleHanded = "Focus",
    Ranged = "Ranged",
    -- DualWielding = "",
    Perseverance = "BlockMaster",
    Leadership = "Leadership",
    PainReflection = "Retribution",
    AirSpecialist = "Aerotheurge",
    EarthSpecialist = "Geomancer",
    RangerLore = "Huntsman",
    WaterSpecialist = "Hydrosophist",
    Necromancy = "Necromancer",
    Polymorph = "Polymorph",
    FireSpecialist = "Pyrokinetic",
    RogueLore = "Scoundrel",
    Summoning = "Summoning",
    WarriorLore = "Warfare",
}

local function SetAbilityStatus(char)
    if WotL_Bool(CharacterIsDead(char)) then
        return
    end
    for vanilla, ability in pairs(ENUM_WotL_AbilitiesNames) do
        local value = CharacterGetAbility(char, vanilla)
        local status = "WotL_" .. ability .. "_" .. tostring(value)
        if WotL_Bool(NRD_StatExists(status)) and not WotL_Bool(HasActiveStatus(char, status)) then
            ApplyStatus(char, status, -1.0, 1)
        end

        local variable = "WotL_Ability_" .. ability
        if GetVarInteger(char, variable) ~= value then
            SetVarInteger(char, variable, value)
        end
    end
end
Ext.NewCall(SetAbilityStatus, "WotL_SetAbilityStatus", "(CHARACTERGUID)_Char")

local function AddAbilityStatusesToBlacklist()
    for vanilla, ability in pairs(ENUM_WotL_AbilitiesNames) do
        for i=0,20,1 do
            local status = "WotL_" .. ability .. "_" .. tostring(i)
            local db = Osi.DB_WotL_BlacklistVariableStatuses:Get(status)
            if WotL_Bool(NRD_StatExists(status)) and next(db) == nil then
                Osi.DB_WotL_BlacklistVariableStatuses(status)
            end
        end
    end

    -- Leadership corner case. It's not applied on SetAbilityStatus
    -- and it shouldn't trigger SetAllVariables when it's applied
    for i=0,40,1 do
        local status = "WotL_Leadership_Source_" .. tostring(i)
        local db = Osi.DB_WotL_BlacklistVariableStatuses:Get(status)
        if WotL_Bool(NRD_StatExists(status)) and next(db) == nil then
            Osi.DB_WotL_BlacklistVariableStatuses(status)
        end
    end
end
Ext.NewCall(AddAbilityStatusesToBlacklist, "WotL_AddAbilityStatusesToBlacklist", "")
