local WotL_Mod_GUID = "Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66"

-- Lib
Ext.Require(WotL_Mod_GUID, "WotL_LibShared.lua")

-- Listeners (Core overrides)
Ext.Require(WotL_Mod_GUID, "WotL_CustomHitChance.lua")

-- Session Load Functions
Ext.Require(WotL_Mod_GUID, "WotL_SessionSkill.lua")

-- Module Load Functions
-- Common
Ext.Require(WotL_Mod_GUID, "WotL_ModuleCommon.lua")
-- Armor
Ext.Require(WotL_Mod_GUID, "WotL_ModuleArmor.lua")
-- Character
Ext.Require(WotL_Mod_GUID, "WotL_ModuleCharacterEnum.lua")
Ext.Require(WotL_Mod_GUID, "WotL_ModuleCharacter.lua")
-- Object
Ext.Require(WotL_Mod_GUID, "WotL_ModuleObject.lua")
-- Potions
Ext.Require(WotL_Mod_GUID, "WotL_ModulePotionEnum.lua")
Ext.Require(WotL_Mod_GUID, "WotL_ModulePotion.lua")
-- Shields
Ext.Require(WotL_Mod_GUID, "WotL_ModuleShield.lua")
-- Skills
Ext.Require(WotL_Mod_GUID, "WotL_ModuleSkillEnum.lua")
Ext.Require(WotL_Mod_GUID, "WotL_ModuleSkill.lua")
-- Status
Ext.Require(WotL_Mod_GUID, "WotL_ModuleStatus.lua")
-- Weapons
Ext.Require(WotL_Mod_GUID, "WotL_ModuleWeaponEnum.lua")
Ext.Require(WotL_Mod_GUID, "WotL_ModuleWeapon.lua")

local WotL_GameSessionLoad = function()
    Ext.Print("===================================================================")
    Ext.Print("           [WotL:BootstrapShared.lua] Session Load Start")
    Ext.Print("===================================================================")

    WotL_SessionSkill()

    Ext.Print("===================================================================")
    Ext.Print("         [WotL:BootstrapShared.lua] Session Load Finished")
    Ext.Print("===================================================================")
end

local WotL_ModuleLoad = function ()
    Ext.Print("===================================================================")
    Ext.Print("           [WotL:BootstrapShared.lua] Module Load Start")
    Ext.Print("===================================================================")

    WotL_ModuleArmor()
    WotL_ModuleCharacter()
    WotL_ModuleObject()
    WotL_ModulePotion()
    WotL_ModuleShield()
    WotL_ModuleSkill()
    WotL_ModuleStatus()
    WotL_ModuleWeapon()

    Ext.Print("===================================================================")
    Ext.Print("          [WotL:BootstrapShared.lua] Module Load Finished")
    Ext.Print("===================================================================")
end

Ext.RegisterListener("SessionLoading", WotL_GameSessionLoad)
Ext.RegisterListener("ModuleLoading", WotL_ModuleLoad)
Ext.RegisterListener("GetHitChance", WotL_CustomGetHitChance)
