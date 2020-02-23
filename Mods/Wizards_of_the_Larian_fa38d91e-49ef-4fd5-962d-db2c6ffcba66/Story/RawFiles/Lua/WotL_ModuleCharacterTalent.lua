ENUM_WotL_InnateTalents = {
    "QuickStep",
    "ViolentMagic",
    "AttackOfOpportunity",
}

function WotL_ChangeInnateTalents(character)
    local talents = Ext.StatGetAttribute(character, "Talents")
    if talents ~= nil and talents ~= "" then
        WotL_ModulePrint("Talents: " .. talents, "Character")
    end
    local final

    for _, talent in pairs (ENUM_WotL_InnateTalents) do
        if string.find(talents, talent) == nil then
            if final ~= nil and final ~= "" then
                final = final .. ";" .. talent
            else
                final = talent
            end
        end
    end
    
    if final ~= nil and final ~= "" then
        if talents ~= nil and talents ~= "" then
            final = talents .. ";" .. final
        end
        Ext.StatSetAttribute(character, "Talents", final)
        WotL_ModulePrint("Final: " .. final, "Character")
    end
end