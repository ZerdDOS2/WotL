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

-- Third degree function to calculate range
-- Fixed points are (5,5), (13,8), (25,25)
-- y = 0.003731685*x^3 - 0.1083791*x^2 + 1.359318*x + 0.4464286
function WotL_CalculateRange(x)
    local a = 0.003731685
    local b = - 0.1083791
    local c = 1.359318
    local d = 0.4464286
    return a*x^3 + b*x^2 + c*x + d
end

-- Decreases skill ranges on the range between 5 and 25 using a third degree function
function WotL_ChangeSkillRange(skill, type)
    for attribute, typeList in pairs(ENUM_WotL_SkillRangeAttributes) do
        if typeList[type] then
            local range = Ext.StatGetAttribute(skill, attribute)
            Ext.Print("Old range (" .. attribute .. "): " .. tostring(range))
            if range > 5 and range < 25 then
                local new = math.ceil(truncate(WotL_CalculateRange(range), 1))
                Ext.StatSetAttribute(skill, attribute, new)
                Ext.Print("New range (" .. attribute .. "): " .. tostring(new))
            end
        end
    end
end
