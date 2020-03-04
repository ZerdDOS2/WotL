ENUM_WotL_AllDamageTypes = {
    "Air",
    "Chaos",
    "Corrosive",
    "Earth",
    "Fire",
    "Magic",
    "Physical",
    "Piercing",
    "Poison",
    "Shadow",
    "Water",
}

WotL_BackstabMultiplier = 1.5

function WotL_Backstab(target, source, handle)
    local hit = WotL_Bool(NRD_StatusGetInt(target, handle, "Hit"))
    local backstab = WotL_Bool(NRD_StatusGetInt(target, handle, "AlwaysBackstab"))
    if not hit or not backstab then
        return
    end

    local weapon = CharacterGetEquippedItem(source, "Weapon")
    local criticalDamage = NRD_ItemGetPermanentBoostInt(weapon, "CriticalDamage")
    if criticalDamage == 0 then
        local weaponStatsID = NRD_ItemGetStatsId(weapon)
        criticalDamage = NRD_StatGetInt(weaponStatsID, "CriticalDamage")
    end

    local criticalChance = NRD_CharacterGetComputedStat(source, "CriticalChance", 0)
    local isCritical = false
    if criticalChance >= math.random(100) then
        isCritical = true
    end

    for _, type in pairs(ENUM_WotL_AllDamageTypes) do
        local damage = NRD_HitStatusGetDamage(target, handle, type)
        if damage ~= 0 then
            local finalDamage = damage * WotL_BackstabMultiplier
            if isCritical ~= true then
                finalDamage = finalDamage * 100 / criticalDamage
            end
            local delta = finalDamage - damage
            NRD_HitStatusAddDamage(target, handle, type, delta)
        end
    end
end
