ENUM_WotL_SkillPresets = {
    ["Projectile_BouncingShield"] = {
        ["UseWeaponDamage"] = "No",
    }
}

-- Do it like this to add presets from other mods
-- ENUM_WotL_SkillPresets["Projectile_Fireball"] = {
--     ["DamageType"] = "Air",
--     ["TargetRadius"] = 30,
-- }

local WotL_SkillsLookFor = {}
local WotL_SkillsProperties = {}
function WotL_PrepareSkillPresets()
    for skill, list in pairs(ENUM_WotL_SkillPresets) do
        WotL_SkillsLookFor[skill] = true
        for attribute, _ in pairs(list) do
            WotL_SkillsProperties[attribute] = true
        end
    end
end

local WotL_DefaultSkillProperties = {}
function WotL_ChangeSkillPreset(skill)
    if WotL_SkillsLookFor[skill] then
        WotL_DefaultSkillProperties[skill] = {}
        for attribute, _ in pairs(WotL_SkillsProperties) do
            WotL_DefaultSkillProperties[skill][attribute] = Ext.StatGetAttribute(skill, attribute)
        end
    end

    for stat, list in pairs(ENUM_WotL_SkillPresets) do
        local parent = WotL_GetRootParent(skill)
        if parent == stat then
            for attribute, value in pairs(list) do
                local curr = Ext.StatGetAttribute(skill, attribute)
                if curr == WotL_DefaultSkillProperties[parent][attribute] then
                    WotL_ModulePrint("------ PRESET APPLIED ------", "Skill")
                    WotL_ModulePrint(tostring(attribute) .. ": " .. tostring(curr) .. " -> " .. tostring(value), "Skill")
                    Ext.StatSetAttribute(skill, attribute, value)
                end
            end
            break
        end
    end
end