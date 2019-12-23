ENUM_WotL_ArmorSpecialityDamageTypes = {
    "Air",
    "Chaos",
    "Earth",
    "Fire",
    "Poison",
    "Water",
}

-- This is currently bugged
-- The damage reducted is being dealt directly to the target's HP ??
-- Extra confusion: If the ClearDamage is commented out, some healing appears ??
function WotL_ArmorSpeciality(char, handle)
    print("State 1")
    local armor = NRD_CharacterGetStatInt(char, "CurrentMagicArmor")
    if armor == 0 then
        print("State 2")
        return
    end
    print("Armor:", armor)
    local speciality = GetVarInteger(char, "WotL_Ability_ArmorSpeciality")
    if speciality == 0 then
        print("State 3")
        return
    end
    print("Speciality:", speciality)
    for key, type in pairs(ENUM_WotL_ArmorSpecialityDamageTypes) do
        print(type)
        local damage = NRD_HitStatusGetDamage(char, handle, type)
        if damage ~= 0 then
            print("Damage before:", damage)
            local reduction = math.floor(damage * speciality * 0.1)
            print("Damage reduction:", reduction)
            damage = damage - reduction
            print("Final damage:", damage)
            NRD_HitStatusClearDamage(char, handle, type)
            NRD_HitStatusAddDamage(char, handle, type, damage)
        end
    end
end
