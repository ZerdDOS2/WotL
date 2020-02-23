function WotL_ChangeStatusArmor(status)
    local healStat = Ext.StatGetAttribute(status, "HealStat")
    if healStat == "PhysicalArmor" or healStat == "AllArmor" then
        WotL_ModulePrint("Changed HealStat", "Status")
        Ext.StatSetAttribute(status, "HealStat", "MagicArmor")
    end
end
