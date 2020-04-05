local WotL_Mod_GUID = "Wizards_of_the_Larian_fa38d91e-49ef-4fd5-962d-db2c6ffcba66"
local WotL_ListenersPath = "Listeners/"

-- Module Load
Ext.Require(WotL_Mod_GUID, WotL_ListenersPath .. "Module/WotL_BaseModule.lua")

Ext.Require(WotL_Mod_GUID, WotL_ListenersPath .. "WotL_Hit.lua")
Ext.Require(WotL_Mod_GUID, WotL_ListenersPath .. "WotL_Skill.lua")
Ext.Require(WotL_Mod_GUID, WotL_ListenersPath .. "WotL_Status.lua")
