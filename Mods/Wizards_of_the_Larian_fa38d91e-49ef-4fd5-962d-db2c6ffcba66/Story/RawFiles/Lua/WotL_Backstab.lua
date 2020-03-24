WotL_BackstabMultiplier = 1.5
local function Backstab(target, source, handle)
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
    
    if isCritical then
        -- Applies a status just for the text
        ApplyStatus(target, "WotL_BackstabCritical", 0.0, 1, source)
    end
end
Ext.NewCall(Backstab, "WotL_Backstab", "(CHARACTERGUID)_Target, (CHARACTERGUID)_Source, (INTEGER64)_Handle")
