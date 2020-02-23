ENUM_WotL_MobilitySkillTypes = Set {
    "Jump",
    "Teleportation"
}

-- Doubles the skill AP cost, up to 6
-- Also increases the minimum AP cost for Mobility skills to 4
function WotL_ChangeSkillAP(skill, type)
    local AP = Ext.StatGetAttribute(skill, "ActionPoints")
    if AP ~= nil and AP ~= 0 then
        local new = math.min(2*AP, 6)
        if ENUM_WotL_MobilitySkillTypes[type] then
            new = math.max(new, 4)
        end
        WotL_ModulePrint("Old AP: " .. tostring(AP), "Skill")
        WotL_ModulePrint("New AP: " .. tostring(new), "Skill")
        Ext.StatSetAttribute(skill, "ActionPoints", new)
    end
end
