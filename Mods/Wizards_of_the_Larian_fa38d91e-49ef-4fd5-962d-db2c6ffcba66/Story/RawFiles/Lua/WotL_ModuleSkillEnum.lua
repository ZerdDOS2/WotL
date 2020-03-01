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
    -- Parse magic armor scaling abilities to include them as missable skills
    ["SourceMaximumMagicArmor"] = {
        ["SourceMaximumMagicArmor"] = 1.0,
    },
    ["SourceCurrentMagicArmor"] = {
        ["SourceCurrentMagicArmor"] = 1.0,
    },
    ["TargetMaximumMagicArmor"] = {
        ["TargetMaximumMagicArmor"] = 1.0,
    },
    ["TargetCurrentMagicArmor"] = {
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
    ["Projectile_OdinNECRO_Mute_Damage"] = {
        ["UseWeaponDamage"] = "No",
    },
    ["Projectile_OdinNECRO_HorrificScream_Damage"] = {
        ["UseWeaponDamage"] = "No",
    },
    ["Projectile_OdinNECRO_WitchesBrew_Damage"] = {
        ["UseWeaponDamage"] = "No",
    },
    ["Projectile_OdinNECRO_BlackShroud_Damage"] = {
        ["UseWeaponDamage"] = "No",
    },
    ["Projectile_OdinNECRO_ArcaneVolley_Damage"] = {
        ["UseWeaponDamage"] = "No",
    },
    ["Projectile_OdinNECRO_OphidianGlare_Damage"] = {
        ["UseWeaponDamage"] = "No",
    },
}
