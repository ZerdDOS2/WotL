function WotL_ChangeSkillDescription(skill)
    local params = Ext.StatGetAttribute(skill, "StatsDescriptionParams")
    local new, count = string.gsub(params, ":Armor", ":MagicArmor")
    if count > 0 then
        WotL_ModulePrint("Description Parameters: " .. params, "Skill")
        WotL_ModulePrint("New Description Parameters: " .. new, "Skill")
        Ext.StatSetAttribute(skill, "StatsDescriptionParams", new)
    end
end