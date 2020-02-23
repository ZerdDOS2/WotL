function WotL_ChangePotionMovement(potion)
    local movement = Ext.StatGetAttribute(potion, "Movement")
    if movement ~= 0 then
        local new = math.ceil(movement * 0.3)
        WotL_ModulePrint("Old Movement: " .. tostring(movement), "Potion")
        WotL_ModulePrint("New Movement: " .. tostring(new), "Potion")
        Ext.StatSetAttribute(potion, "Movement", new)
    end
end