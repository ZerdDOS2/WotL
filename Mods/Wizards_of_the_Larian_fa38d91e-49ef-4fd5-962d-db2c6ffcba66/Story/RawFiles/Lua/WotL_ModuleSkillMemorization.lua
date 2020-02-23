-- TODO: Change the book usage requirements alongside the skills. Might have to save the skills
-- here with their new requirements somewhere for later usage

-- Doubles the Memorization Requirements of Mobility, with a maximum of 5
-- ENUM_WotL_MobilitySkillTypes is declared on WotL_ModuleSkillAP.lua
function WotL_ChangeSkillMemorizationRequirements(skill, type)
    local memRequirements = Ext.StatGetAttribute(skill, "MemorizationRequirements")
    if ENUM_WotL_MobilitySkillTypes[type] then
        for _, r in pairs(memRequirements) do
            if not r["Not"] then
                r["Param"] = math.min(2*r["Param"], 5)
            end
        end
        WotL_ModuleTPrint(memRequirements, "Skill")
        Ext.StatSetAttribute(skill, "MemorizationRequirements", memRequirements)
    end
end
