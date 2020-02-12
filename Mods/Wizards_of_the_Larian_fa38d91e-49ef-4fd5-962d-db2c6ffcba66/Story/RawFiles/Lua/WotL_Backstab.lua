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
    local weapon = CharacterGetEquippedItem(source, "Weapon")
    local criticalDamage = NRD_ItemGetPermanentBoostInt(weapon, "CriticalDamage")
    if criticalDamage == 0 then
        local weaponStatsID = NRD_ItemGetStatsId(weapon)
        criticalDamage = NRD_StatGetInt(weaponStatsID, "CriticalDamage")
    end
    NRD_DebugLog("Critical Damage: " .. tostring(criticalDamage))

    local criticalChance = NRD_CharacterGetComputedStat(source, "CriticalChance", 0)
    local isCritical = false
    if criticalChance >= math.random(100) then
        isCritical = true
    end

    for key, type in pairs(ENUM_WotL_AllDamageTypes) do
        local damage = NRD_HitStatusGetDamage(target, handle, type)
        if damage ~= 0 then
            NRD_DebugLog("Damage Type: " .. type)
            NRD_DebugLog("Damage: " .. tostring(damage))
            local finalDamage = damage * WotL_BackstabMultiplier
            if isCritical ~= true then
                finalDamage = finalDamage * 100 / criticalDamage
            end
            NRD_DebugLog("Final Damage: " .. tostring(finalDamage))
            local delta = finalDamage - damage
            NRD_DebugLog("Delta: " .. tostring(delta))
            NRD_HitStatusAddDamage(target, handle, type, delta)
        end
    end
end
