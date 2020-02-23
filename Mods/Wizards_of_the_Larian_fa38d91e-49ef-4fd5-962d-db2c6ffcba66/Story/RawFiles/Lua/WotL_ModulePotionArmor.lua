function WotL_ChangePotionArmor(potion)
    local armor = Ext.StatGetAttribute(potion, "Armor")
    if armor ~= 0 then
        local magic = Ext.StatGetAttribute(potion, "MagicArmor")
        WotL_ModulePrint("Physical Armor: " .. tostring(armor), "Potion")
        WotL_ModulePrint("Magic Armor: " .. tostring(magic), "Potion")
        local final = math.max(armor, magic)
        if magic <= 0 and armor < 0 then
            final = math.min(magic, armor)
        end
        WotL_ModulePrint("Final Armor: " .. tostring(final), "Potion")
        Ext.StatSetAttribute(potion, "MagicArmor", final)
        Ext.StatSetAttribute(potion, "Armor", 0)
    end

    local armor = Ext.StatGetAttribute(potion, "ArmorBoost")
    if armor ~= 0 then
        local magic = Ext.StatGetAttribute(potion, "MagicArmorBoost")
        WotL_ModulePrint("Physical Armor Boost: " .. tostring(armor), "Potion")
        WotL_ModulePrint("Magic Armor Boost: " .. tostring(magic), "Potion")
        local final = math.max(armor, magic)
        if magic < 0 and armor < 0 then
            final = math.min(magic, armor)
        end
        WotL_ModulePrint("Final Armor Boost: " .. tostring(final), "Potion")
        Ext.StatSetAttribute(potion, "MagicArmorBoost", final)
        Ext.StatSetAttribute(potion, "ArmorBoost", 0)
    end
end