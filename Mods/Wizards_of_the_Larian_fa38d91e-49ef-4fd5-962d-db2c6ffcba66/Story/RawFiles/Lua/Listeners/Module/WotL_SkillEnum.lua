-- Mobility skills have increased AP cost and memorization requirements.
ENUM_WotL_MobilitySkillTypes = WotL_Set {
    "Jump",
    "Teleportation"
}

-- Changes the damage type from the outer key to the inner key,
-- applying the scaling factor defined.
ENUM_WotL_ArmorDamageSourceTypes = {
    ["SourceMaximumPhysicalArmor"] = {
        ["SourceMaximumMagicArmor"] = 1.0,
    },
    ["SourceCurrentPhysicalArmor"] = {
        ["SourceCurrentMagicArmor"] = 1.0,
    },
    ["SourceShieldPhysicalArmor"] = {
        ["SourceMaximumMagicArmor"] = 0.5,
    },
    ["TargetMaximumPhysicalArmor"] = {
        ["TargetMaximumMagicArmor"] = 1.0,
    },
    ["TargetCurrentPhysicalArmor"] = {
        ["TargetCurrentMagicArmor"] = 1.0,
    },
}

-- Applies the WotL_NormalizeRange function to the properties declared, only for the
-- skills associated with those properties.
ENUM_WotL_SkillRangeAttributes = {
    AreaRadius = WotL_Set {
        "Quake", "Projectile", "ProjectileStrike", "Rain", "Shout", "Storm", "Target", "Teleportation",
    },
    Range = WotL_Set {
        "Cone", "Zone",
    },
    TargetRadius = WotL_Set {
        "Dome", "Jump", "MultiStrike", "Projectile", "ProjectileStrike", "Rain", "Rush",
        "Storm", "Summon", "Target", "Teleportation", "Tornado", "Wall",
    },
}

-- Preset skill entries. Applied after every other
-- default change on the module load.

-- Do it like this to add presets from other mods
-- ENUM_WotL_SkillPresets["Projectile_Fireball"] = {
--     ["DamageType"] = "Air",
--     ["TargetRadius"] = 30,
-- }

ENUM_WotL_SkillPresets = {
    ["Projectile_StaffOfMagus"] = {
        ["Damage Multiplier"] = 125,
        ["ActionPoints"] = 6,
    },
    ["Shout_MedusaHead"] = {
        ["ActionPoints"] = 2,
    },
}
