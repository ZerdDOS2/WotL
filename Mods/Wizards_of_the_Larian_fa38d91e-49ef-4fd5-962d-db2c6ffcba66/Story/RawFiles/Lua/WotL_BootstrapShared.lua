-- Lib
Ext.Require("WotL_Lib.lua")

-- Listeners
Ext.Require("Listeners/WotL_Listeners.lua")

-- In-game scripts
if Ext.IsServer() then
    Ext.Require("Server/WotL_AbilitiesEffects.lua")
    Ext.Require("Server/WotL_AbilitiesStatus.lua")
    Ext.Require("Server/WotL_Attributes.lua")
    Ext.Require("Server/WotL_Backstab.lua")
    Ext.Require("Server/WotL_Lib.lua")
    Ext.Require("Server/WotL_MissingStatuses.lua")
    Ext.Require("Server/WotL_StatusReplacer.lua")
    Ext.Require("Server/WotL_StatusRequestDelete.lua")
    Ext.Require("Server/WotL_Talents.lua")
end
