-- Decreases the weapon range, only if it's between 5 and 25 m
function WotL_ChangeWeaponRange(weapon)
    local range = Ext.StatGetAttribute(weapon, "WeaponRange")
    if range > 500 then
        local new = 100 * math.ceil(truncate(WotL_NormalizeRange(range/100), 1))
        WotL_ModulePrint("Old range: " .. tostring(range), "Weapon")
        WotL_ModulePrint("New range: " .. tostring(new), "Weapon")
        Ext.StatSetAttribute(weapon, "WeaponRange", new)
    end
end
