local WotL_ModulePath = "Listeners/Module/"

-- Common
Ext.Require(WotL_ModulePath .. "WotL_Common.lua")
-- Armor
Ext.Require(WotL_ModulePath .. "WotL_Armor.lua")
-- Character
Ext.Require(WotL_ModulePath .. "WotL_CharacterEnum.lua")
Ext.Require(WotL_ModulePath .. "WotL_Character.lua")
-- Object
Ext.Require(WotL_ModulePath .. "WotL_Object.lua")
-- Potions
Ext.Require(WotL_ModulePath .. "WotL_PotionEnum.lua")
Ext.Require(WotL_ModulePath .. "WotL_Potion.lua")
-- Shields
Ext.Require(WotL_ModulePath .. "WotL_Shield.lua")
-- Skills
Ext.Require(WotL_ModulePath .. "WotL_SkillEnum.lua")
Ext.Require(WotL_ModulePath .. "WotL_Skill.lua")
-- Status
Ext.Require(WotL_ModulePath .. "WotL_Status.lua")
-- Weapons
Ext.Require(WotL_ModulePath .. "WotL_WeaponEnum.lua")
Ext.Require(WotL_ModulePath .. "WotL_Weapon.lua")

local function WotL_ModuleLoad()
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

Ext.RegisterListener("ModuleLoading", WotL_ModuleLoad)
