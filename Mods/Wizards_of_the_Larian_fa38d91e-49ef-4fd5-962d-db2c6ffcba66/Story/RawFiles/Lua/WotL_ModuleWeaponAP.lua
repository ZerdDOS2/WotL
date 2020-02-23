-- Doubles the weapon AP cost, up to 6
function WotL_ChangeWeaponAP(weapon)
    local AP = Ext.StatGetAttribute(weapon, "AttackAPCost")
    if AP ~= nil and AP ~= 0 then
        local new = math.min(2*AP, 6)
        WotL_ModulePrint("Old AP: " .. tostring(AP), "Weapon")
        WotL_ModulePrint("New AP: " .. tostring(new), "Weapon")
        Ext.StatSetAttribute(weapon, "AttackAPCost", new)
    end
end
