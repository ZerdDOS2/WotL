ENUM_WotL_MobilitySkillTypes = Set {
    "Jump",
    "Teleportation"
}

-- Doubles all skills AP cost, up to 6
-- Also increases the minimum AP cost for Mobility skills to 4
function WotL_ChangeSkillAP(skill, type)
    local AP = Ext.StatGetAttribute(skill, "ActionPoints")
    Ext.Print("Old AP: " .. tostring(AP))
    if AP ~= nil and AP ~= 0 then
        local new = math.min(2*AP, 6)
        if ENUM_WotL_MobilitySkillTypes[type] then
            new = math.max(new, 4)
        end
        Ext.StatSetAttribute(skill, "ActionPoints", new)
        Ext.Print("New AP: " .. tostring(new))
    end
end
