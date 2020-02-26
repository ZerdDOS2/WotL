local WotL_Mod_GUID = "Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66"

-- Lib
Ext.Require(WotL_Mod_GUID,"WotL_Helpers.lua")

-- Listeners (Core overrides)
Ext.Require(WotL_Mod_GUID,"WotL_CustomHitChance.lua")
-- Ext.Require(WotL_Mod_GUID,"WotL_StatusEnterChance.lua")

-- Module Load Functions
-- Common
Ext.Require(WotL_Mod_GUID,"WotL_ModuleCommon.lua")
-- Character
Ext.Require(WotL_Mod_GUID,"WotL_ModuleCharacterEnum.lua")
Ext.Require(WotL_Mod_GUID,"WotL_ModuleCharacter.lua")
-- Object
Ext.Require(WotL_Mod_GUID,"WotL_ModuleObject.lua")
-- Potions
Ext.Require(WotL_Mod_GUID,"WotL_ModulePotionEnum.lua")
Ext.Require(WotL_Mod_GUID,"WotL_ModulePotion.lua")
-- Skills
Ext.Require(WotL_Mod_GUID,"WotL_ModuleSkillEnum.lua")
Ext.Require(WotL_Mod_GUID,"WotL_ModuleSkill.lua")
-- Status
Ext.Require(WotL_Mod_GUID,"WotL_ModuleStatus.lua")
-- Weapons
Ext.Require(WotL_Mod_GUID,"WotL_ModuleWeaponEnum.lua")
Ext.Require(WotL_Mod_GUID,"WotL_ModuleWeapon.lua")

-- In-game scripts
Ext.Require(WotL_Mod_GUID,"WotL_Abilities.lua")
Ext.Require(WotL_Mod_GUID,"WotL_ArmorSpeciality.lua")
Ext.Require(WotL_Mod_GUID,"WotL_Attributes.lua")
Ext.Require(WotL_Mod_GUID,"WotL_Backstab.lua")
Ext.Require(WotL_Mod_GUID,"WotL_DamageManager.lua")
Ext.Require(WotL_Mod_GUID,"WotL_Resistances.lua")

local WotL_GameSessionLoad = function ()
    -- Ext.StatusGetEnterChance = WotL_CustomStatusGetEnterChance
    Ext.GetHitChance = WotL_CustomGetHitChance
    Ext.EnableStatOverride("HitChance")
end

local WotL_ModuleLoad = function ()
    Ext.Print("===================================================================")
    Ext.Print("          [WotL:Bootstrap.lua] Module Load Start")
    Ext.Print("===================================================================")

    WotL_ModuleCharacter()
    WotL_ModuleObject()
    WotL_ModulePotion()
    WotL_ModuleSkill()
    WotL_ModuleStatus()
    WotL_ModuleWeapon()

    Ext.Print("===================================================================")
    Ext.Print("          [WotL:Bootstrap.lua] Module Load Finished")
    Ext.Print("===================================================================")
end

Ext.RegisterListener("SessionLoading", WotL_GameSessionLoad)
Ext.RegisterListener("ModuleLoading", WotL_ModuleLoad)
