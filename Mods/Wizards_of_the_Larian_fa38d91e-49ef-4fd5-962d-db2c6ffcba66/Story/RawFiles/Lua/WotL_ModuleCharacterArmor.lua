function WotL_ChangeCharacterArmor(character)
    local armor = Ext.StatGetAttribute(character, "Armor")
    if armor ~= 0 then
        local magic = Ext.StatGetAttribute(character, "MagicArmor")
        WotL_ModulePrint("Physical Armor: " .. tostring(armor), "Character")
        WotL_ModulePrint("Magic Armor: " .. tostring(magic), "Character")
        local final = math.ceil(math.sqrt(armor^2 + magic^2))
        WotL_ModulePrint("Final Armor: " .. final, "Character")
        Ext.StatSetAttribute(character, "MagicArmor", final)
        Ext.StatSetAttribute(character, "Armor", 0)
    end
end
