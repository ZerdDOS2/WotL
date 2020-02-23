ENUM_WotL_ArmorSpecialityDamageTypes = {
    "Air",
    "Chaos",
    "Earth",
    "Fire",
    "Poison",
    "Water",
}

function WotL_ArmorSpeciality(char, handle)
    local armor = NRD_CharacterGetStatInt(char, "CurrentMagicArmor")
    if armor == 0 then
        return
    end

    local speciality = GetVarInteger(char, "WotL_Ability_ArmorSpeciality")
    if speciality == 0 then
        return
    end
    
    for _, type in pairs(ENUM_WotL_ArmorSpecialityDamageTypes) do
        local damage = NRD_HitStatusGetDamage(char, handle, type)
        if damage ~= 0 then
            local reduction = - math.floor(damage * speciality * 0.1)
            NRD_HitStatusAddDamage(char, handle, type, reduction)
        end
    end
end
