ENUM_WotL_MissingSkills = WotL_Set {
    -- Grenades
    "Projectile_Grenade_ArmorPiercing",
    "Projectile_Grenade_Nailbomb",
    "Projectile_Grenade_Flashbang",
    "Projectile_Grenade_Molotov",
    "Projectile_Grenade_CursedMolotov",
    "Projectile_Grenade_Love",
    "Projectile_Grenade_MindMaggot",
    "Projectile_Grenade_ChemicalWarfare",
    "Projectile_Grenade_Terror",
    "Projectile_Grenade_Ice",
    "Projectile_Grenade_BlessedIce",
    "Projectile_Grenade_Holy",
    "Projectile_Grenade_Tremor",
    "Projectile_Grenade_Taser",
    "Projectile_Grenade_WaterBalloon",
    "Projectile_Grenade_WaterBlessedBalloon",
    "Projectile_Grenade_SmokeBomb",
    "Projectile_Grenade_MustardGas",
    "Projectile_Grenade_OilFlask",
    "Projectile_Grenade_BlessedOilFlask",
    "Projectile_Grenade_PoisonFlask",
    "Projectile_Grenade_CursedPoisonFlask",
}

function WotL_CheckMissingSkill(target, handle)
    local skill = NRD_StatusGetString(target, handle, "SkillId")
    -- TODO: SkillId sometimes come with a value appended to it to indicate the level scaling
    -- so it doesn't match the exact string on the table. The solution implemented is
    -- significantly worst performance wise, so it'd be best to have a different solution.
    -- if skill == nil or skill == "" or not ENUM_WotL_MissingSkills[skill] then
    --     return
    -- end

    -- O(n*m) solution :/
    local isMissable = false
    for missable, _ in pairs(ENUM_WotL_MissingSkills) do
        if string.find(skill, missable) ~= nil then
            isMissable = true
        end
    end
    if not isMissable then
        return
    end
    --

    local source = NRD_StatusGetGuidString(target, handle, "StatusSourceHandle")
    if source == nil or source == "" then
        return
    end

    local dodge = NRD_CharacterGetComputedStat(target, "Dodge", 1)
    local accuracy = NRD_CharacterGetComputedStat(source, "Accuracy", 1)

    local hitChance = accuracy - dodge
    hitChance = math.max(hitChance, 5)
    hitChance = math.min(hitChance, 95)

    local roll = math.random(1, 100)
    if roll >= hitChance then
        NRD_StatusSetInt(target, handle, "Hit", 0)
        NRD_StatusSetInt(target, handle, "Missed", 1)
    end
end