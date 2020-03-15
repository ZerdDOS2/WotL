ENUM_WotL_MissingSkills = {}

-- Adds a skill to the ENUM_WotL_MissingSkills so they don't get
-- the UseWeaponDamage property but are still allowed to miss, if their
-- damage scale from armor
local function WotL_RegisterMissingSkill(skill)
    local source = Ext.StatGetAttribute(skill, "Damage")
    for type, _ in pairs(ENUM_WotL_ArmorDamageSourceTypes) do
        if source == type then
            ENUM_WotL_MissingSkills[skill] = true
            break
        end
    end
end

---------------------------------------- SESSION FUNCTION ----------------------------------------

function WotL_SessionSkill()
    for _, skill in pairs(Ext.GetStatEntries("SkillData")) do
        WotL_RegisterMissingSkill(skill)
    end
end
