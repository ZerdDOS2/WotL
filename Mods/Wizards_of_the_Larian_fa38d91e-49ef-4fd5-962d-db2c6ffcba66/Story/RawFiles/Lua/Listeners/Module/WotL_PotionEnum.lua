-- Preset potion entries. Applied after every other
-- default change on the module load.

-- Do it like this to add presets from other mods
-- ENUM_WotL_PotionPresets["Stats_Slowed"] = {
--     ["MovementSpeedBoost"] = -30,
--     ["DodgeBoost"] = -100,
-- }

ENUM_WotL_PotionPresets = {
    ["Stats_WotL_LW_Base"] = {
        ["APStart"] = 2,
        ["APRecovery"] = 2,
        ["APMaximum"] = 2,
    },
    ["Stats_WotL_GenerousHost_Debuff"] = {
        ["APStart"] = -2,
        ["APRecovery"] = -2,
        ["APMaximum"] = -2,
    },
    ["Stats_WotL_WhatARush"] = {
        ["APStart"] = 2,
        ["APRecovery"] = 2,
        ["APMaximum"] = 2,
    },
    ["Stats_WotL_Adrenaline"] = {
        ["ActionPoints"] = 4,
        ["APRecovery"] = -4,
        ["APMaximum"] = 0,
    },
    -- Reducing Dodge
    ["Stats_Crippled"] = {
        ["DodgeBoost"] = -15,
    },
    ["Stats_Entangled"] = {
        ["DodgeBoost"] = -30,
    },
    ["Stats_Cursed"] = {
        ["DodgeBoost"] = -20,
    },
    ["Stats_Slowed"] = {
        ["DodgeBoost"] = 0,
    },
    ["Stats_Chilled"] = {
        ["DodgeBoost"] = -15,
    },
    ["Stats_Drunk"] = {
        ["DodgeBoost"] = 20,
    },
    ["Stats_Oiled"] = {
        ["DodgeBoost"] = 0,
    },
    ["Stats_Shocked"] = {
        ["DodgeBoost"] = -15,
    },
    ["Stats_Marked"] = {
        ["DodgeBoost"] = -50,
    },
    ["Stats_Evading"] = {
        ["DodgeBoost"] = 50,
    },
    ["Stats_Infusion_Warp"] = {
        ["DodgeBoost"] = 20,
    },
    ["Stats_Web"] = {
        ["DodgeBoost"] = -30,
    },
    ["CON_Potion_NimbleTumble"] = {
        ["DodgeBoost"] = 30,
    },
}
