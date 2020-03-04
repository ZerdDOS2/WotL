-- Some missing skills come from the WotL_ModuleSkill.lua -> WotL_ChangeSkillDamage
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

function WotL_CheckMissingSkill(target, source, handle)
    local skill = NRD_StatusGetString(target, handle, "SkillId")
    if skill == nil or skill == "" then
        return
    end

    -- SkillId sometimes come with a value appended to it to indicate the level scaling
    -- so it doesn't match the exact string on the table. The solution is to use a
    -- regex to remove that last "_-1" (or any number) if it exists, before trying to
    -- match the WotL_Set.
    skill = string.gsub(skill, "_%-?%d+$", "")
    local spCost = NRD_StatGetInt(skill, "Magic Cost")
    local sType = NRD_StatGetString(skill, "SkillType")

    -- Target skills with SP cost have the "RollForDamage" property set to 0.
    if not ENUM_WotL_MissingSkills[skill] and (sType ~= "Target" or spCost == 0) then
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
