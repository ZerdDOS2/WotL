-- ENUM_WotL_MissingSkills is started at WotL_SessionSkill.lua -> WotL_RegisterMissingSkill
-- Grenades
ENUM_WotL_MissingSkills["Projectile_Grenade_ArmorPiercing"] = true
ENUM_WotL_MissingSkills["Projectile_Grenade_Nailbomb"] = true
ENUM_WotL_MissingSkills["Projectile_Grenade_Flashbang"] = true
ENUM_WotL_MissingSkills["Projectile_Grenade_Molotov"] = true
ENUM_WotL_MissingSkills["Projectile_Grenade_CursedMolotov"] = true
ENUM_WotL_MissingSkills["Projectile_Grenade_Love"] = true
ENUM_WotL_MissingSkills["Projectile_Grenade_MindMaggot"] = true
ENUM_WotL_MissingSkills["Projectile_Grenade_ChemicalWarfare"] = true
ENUM_WotL_MissingSkills["Projectile_Grenade_Terror"] = true
ENUM_WotL_MissingSkills["Projectile_Grenade_Ice"] = true
ENUM_WotL_MissingSkills["Projectile_Grenade_BlessedIce"] = true
ENUM_WotL_MissingSkills["Projectile_Grenade_Holy"] = true
ENUM_WotL_MissingSkills["Projectile_Grenade_Tremor"] = true
ENUM_WotL_MissingSkills["Projectile_Grenade_Taser"] = true
ENUM_WotL_MissingSkills["Projectile_Grenade_WaterBalloon"] = true
ENUM_WotL_MissingSkills["Projectile_Grenade_WaterBlessedBalloon"] = true
ENUM_WotL_MissingSkills["Projectile_Grenade_SmokeBomb"] = true
ENUM_WotL_MissingSkills["Projectile_Grenade_MustardGas"] = true
ENUM_WotL_MissingSkills["Projectile_Grenade_OilFlask"] = true
ENUM_WotL_MissingSkills["Projectile_Grenade_BlessedOilFlask"] = true
ENUM_WotL_MissingSkills["Projectile_Grenade_PoisonFlask"] = true
ENUM_WotL_MissingSkills["Projectile_Grenade_CursedPoisonFlask"] = true

local function CheckMissingSkill(target, source, handle)
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

    if not WotL_Bool(WotL_RollHitChance(target, source)) then
        NRD_StatusSetInt(target, handle, "Hit", 0)
        NRD_StatusSetInt(target, handle, "Missed", 1)
        -- Clearing the damage removes the miss text and animation
        NRD_HitStatusClearAllDamage(target, handle)

        -- Mocks a fake hit just to have the missing animation
        WotL_MockFakeHit(target, source)
    end
end
Ext.NewCall(CheckMissingSkill, "WotL_CheckMissingSkill", "(CHARACTERGUID)_Target, (CHARACTERGUID)_Source, (INTEGER64)_Handle")
