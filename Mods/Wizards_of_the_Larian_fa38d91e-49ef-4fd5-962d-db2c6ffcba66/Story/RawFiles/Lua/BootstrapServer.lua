local WotL_Mod_GUID = "Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66"

-- Shared Bootstrap
Ext.Require(WotL_Mod_GUID, "WotL_BootstrapShared.lua")

-- In-game scripts
Ext.Require(WotL_Mod_GUID, "WotL_AbilitiesEffects.lua")
Ext.Require(WotL_Mod_GUID, "WotL_AbilitiesStatus.lua")
Ext.Require(WotL_Mod_GUID, "WotL_Attributes.lua")
Ext.Require(WotL_Mod_GUID, "WotL_Backstab.lua")
Ext.Require(WotL_Mod_GUID, "WotL_DamageManager.lua")
Ext.Require(WotL_Mod_GUID, "WotL_MissingSkills.lua")
Ext.Require(WotL_Mod_GUID, "WotL_MissingStatuses.lua")
Ext.Require(WotL_Mod_GUID, "WotL_StatusReplacer.lua")
Ext.Require(WotL_Mod_GUID, "WotL_StatusRequestDelete.lua")
Ext.Require(WotL_Mod_GUID, "WotL_Talents.lua")
