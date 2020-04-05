-- Replaces physical armor for magic armor on armor equipments.
-- Mostly used for boosts, since the base armors were changed using stats overwrites.
local function WotL_ChangeArmor(armor)
    local phys = Ext.StatGetAttribute(armor, "Armor Defense Value")
    if phys ~= nil and phys ~= 0 then
        local mag = Ext.StatGetAttribute(armor, "Magic Armor Value")
        WotL_ModulePrint("Physical: " .. tostring(phys) .. " | Magic: " .. tostring(mag), "Armor")
        if phys > mag then
            Ext.StatSetAttribute(armor, "Magic Armor Value", phys)
        end
        Ext.StatSetAttribute(armor, "Armor Defense Value", 0)
    end
end

---------------------------------------- MODULE FUNCTION ----------------------------------------

function WotL_ModuleArmor()
    for _, armor in pairs(Ext.GetStatEntries("Armor")) do
        WotL_ModulePrint("Armor: " .. armor, "Armor")

        WotL_ChangeArmor(armor)
    end
end
