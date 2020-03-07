ENUM_WotL_AbilitiesNames = {
    TwoHanded = "Lifesteal",
    -- SingleHanded = "",
    Ranged = "LongRange",
    DualWielding = "Speed",
    PainReflection = "Focus",
    Perseverance = "ArmorSpeciality",
    Leadership = "Leadership",
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

function WotL_SetAbilityStatus(char)
    if WotL_Bool(CharacterIsDead(char)) then
        return
    end
    for vanilla, ability in pairs(ENUM_WotL_AbilitiesNames) do
        local value = CharacterGetAbility(char, vanilla)
        local status = "WotL_" .. ability .. "_" .. tostring(value)
        if not WotL_Bool(HasActiveStatus(char, status)) then
            local variable = "WotL_Ability_" .. ability
            SetVarInteger(char, variable, value)
            ApplyStatus(char, status, -1.0, 1)
        end
    end
end

function WotL_AddAbilityStatusesToBlacklist()
    for vanilla, ability in pairs(ENUM_WotL_AbilitiesNames) do
        for i=0,5,1 do
            local status = "WotL_" .. ability .. "_" .. tostring(i)
            local db = Osi.DB_WotL_BlacklistVariableStatuses:Get(status)
            if next(db) == nil then
                Osi.DB_WotL_BlacklistVariableStatuses(status)
            end
        end
    end
end
