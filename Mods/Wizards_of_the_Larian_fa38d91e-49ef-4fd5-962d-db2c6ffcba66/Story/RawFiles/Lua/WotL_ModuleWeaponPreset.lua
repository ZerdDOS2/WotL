WotL_WeaponPresets = {
    ["_Daggers"] = {
        ["AttackAPCost"] = 4,
        ["Damage Range"] = 10,
        ["DamageFromBase"] = 56,
        ["CriticalDamage"] = 150,
        ["WeaponRange"] = 150,
    },
    ["_Swords"] = {
        ["AttackAPCost"] = 4,
        ["Damage Range"] = 10,
        ["DamageFromBase"] = 53,
        ["CriticalDamage"] = 150,
        ["WeaponRange"] = 150,
    },
    ["_Clubs"] = {
        ["AttackAPCost"] = 4,
        ["Damage Range"] = 10,
        ["DamageFromBase"] = 35,
        ["CriticalDamage"] = 150,
        ["WeaponRange"] = 150,
    },
    ["_Axes"] = {
        ["AttackAPCost"] = 4,
        ["Damage Range"] = 10,
        ["DamageFromBase"] = 70,
        ["CriticalDamage"] = 150,
        ["WeaponRange"] = 150,
    },
    ["_TwoHandedMaces"] = {
        ["AttackAPCost"] = 4,
        ["Damage Range"] = 20,
        ["DamageFromBase"] = 47,
        ["CriticalDamage"] = 200,
        ["WeaponRange"] = 150,
    },
    ["_TwoHandedAxes"] = {
        ["AttackAPCost"] = 4,
        ["Damage Range"] = 20,
        ["DamageFromBase"] = 95,
        ["CriticalDamage"] = 200,
        ["WeaponRange"] = 150,
    },
    ["_TwoHandedSwords"] = {
        ["AttackAPCost"] = 4,
        ["Damage Range"] = 20,
        ["DamageFromBase"] = 71,
        ["CriticalDamage"] = 200,
        ["WeaponRange"] = 150,
    },
    ["_Spears"] = {
        ["AttackAPCost"] = 4,
        ["Damage Range"] = 20,
        ["DamageFromBase"] = 85,
        ["CriticalDamage"] = 200,
        ["WeaponRange"] = 300,
        -- ["WeaponType"] = "Knife",
        -- ["AnimType"] = "PoleArms",
    },
    ["_Crossbows"] = {
        ["AttackAPCost"] = 4,
        ["Damage Range"] = 20,
        ["DamageFromBase"] = 95,
        ["CriticalDamage"] = 150,
        ["WeaponRange"] = 800,
    },
    ["_Bows"] = {
        ["AttackAPCost"] = 4,
        ["Damage Range"] = 20,
        ["DamageFromBase"] = 85,
        ["CriticalDamage"] = 200,
        ["WeaponRange"] = 800,
    },
    ["_Wands"] = {
        ["AttackAPCost"] = 4,
        ["Damage Range"] = 10,
        ["DamageFromBase"] = 60,
        ["CriticalDamage"] = 150,
        ["WeaponRange"] = 800,
    },
    ["_Staffs"] = {
        ["AttackAPCost"] = 4,
        ["Damage Range"] = 20,
        ["DamageFromBase"] = 80,
        ["CriticalDamage"] = 200,
        ["WeaponRange"] = 150,
    },
}

function WotL_ChangeWeaponPreset(weapon)
    for stat, properties in pairs(WotL_WeaponPresets) do
        if WotL_GetRootParent(weapon) == stat then
            for attribute, value in pairs(properties) do
                if value == WotL_WeaponPresetDefault[weapon][attribute] then
                    Ext.StatSetAttribute(weapon, attribute, value)
                end
            end
            break
        end
    end
end
