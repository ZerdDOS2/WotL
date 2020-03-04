ENUM_WotL_ArmorSpecialityDamageTypes = {
    "Air",
    "Chaos",
    "Earth",
    "Fire",
    "Poison",
    "Water",
}

function WotL_ArmorSpeciality(target, handle)
    local armor = NRD_CharacterGetStatInt(target, "CurrentMagicArmor")
    if armor == 0 or armor == nil then
        return
    end

    local speciality = GetVarInteger(target, "WotL_Ability_ArmorSpeciality")
    if speciality == 0 or speciality == nil then
        return
    end
    
    for _, type in pairs(ENUM_WotL_ArmorSpecialityDamageTypes) do
        local damage = NRD_HitStatusGetDamage(target, handle, type)
        if damage ~= 0 then
            local reduction = - math.floor(damage * speciality * 0.1)
            NRD_HitStatusAddDamage(target, handle, type, reduction)
        end
    end
end
