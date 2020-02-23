ENUM_WotL_SkillRangeAttributes = {
    AreaRadius = Set {
        "Quake", "Projectile", "ProjectileStrike", "Rain", "Shout", "Storm", "Target", "Teleportation",
    },
    Range = Set {
        "Cone", "Zone",
    },
    TargetRadius = Set {
        "Dome", "Jump", "MultiStrike", "Projectile", "ProjectileStrike", "Rain", "Rush",
        "Storm", "Summon", "Target", "Teleportation", "Tornado", "Wall",
    },
}

-- Decreases the skill range, only if it's between 5 and 25 m
function WotL_ChangeSkillRange(skill, type)
    for attribute, typeList in pairs(ENUM_WotL_SkillRangeAttributes) do
        if typeList[type] then
            local range = Ext.StatGetAttribute(skill, attribute)
            if range > 5 and range < 25 then
                local new = math.ceil(truncate(WotL_NormalizeRange(range), 1))
                WotL_ModulePrint("Old range (" .. attribute .. "): " .. tostring(range), "Skill")
                WotL_ModulePrint("New range (" .. attribute .. "): " .. tostring(new), "Skill")
                Ext.StatSetAttribute(skill, attribute, new)
            end
        end
    end
end
