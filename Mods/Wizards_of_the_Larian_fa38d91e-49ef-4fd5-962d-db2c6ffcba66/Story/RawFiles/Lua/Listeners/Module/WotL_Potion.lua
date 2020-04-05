-- Doubles the potion AP boost and provides a maximum if there is none
local function WotL_ChangePotionAPBoost(potion)
    local givesAP = 0

    local APStart = Ext.StatGetAttribute(potion, "APStart")
    if (APStart ~= nil and APStart ~= 0) then
        local new = 2*APStart
        WotL_ModulePrint("APStart: " .. tostring(APStart) .. " -> " .. tostring(new), "Potion")
        givesAP = math.max(givesAP, new)
        Ext.StatSetAttribute(potion, "APStart", new)
    end

    local APRecovery = Ext.StatGetAttribute(potion, "APRecovery")
    if (APRecovery ~= nil and APRecovery ~= 0) then
        local new = 2*APRecovery
        WotL_ModulePrint("APRecovery: " .. tostring(APRecovery) .. " -> " .. tostring(new), "Potion")
        givesAP = math.max(givesAP, new)
        Ext.StatSetAttribute(potion, "APRecovery", new)
    end

    local ActionPoints = Ext.StatGetAttribute(potion, "ActionPoints")
    if (ActionPoints ~= nil and ActionPoints ~= 0) then
        local new = 2*ActionPoints
        WotL_ModulePrint("ActionPoints: " .. tostring(ActionPoints) .. " -> " .. tostring(new), "Potion")
        givesAP = math.max(givesAP, new)
        Ext.StatSetAttribute(potion, "ActionPoints", new)
    end

    local APMaximum = Ext.StatGetAttribute(potion, "APMaximum")
    if (ActionPoints ~= nil and ActionPoints ~= 0) or (givesAP > 0) then
        local new = math.max(givesAP, 2*APMaximum)
        WotL_ModulePrint("APMaximum: " .. tostring(APMaximum) .. " -> " .. tostring(new), "Potion")
        Ext.StatSetAttribute(potion, "APMaximum", new)
    end
end

-- Doubles the potion AP cost, up to 6.
local function WotL_ChangePotionAPCost(potion)
    local AP = Ext.StatGetAttribute(potion, "UseAPCost")
    if AP ~= nil and AP ~= 0 then
        local new = math.min(2*AP, 6)
        WotL_ModulePrint("AP: " .. tostring(AP) .. " -> " .. tostring(new), "Potion")
        Ext.StatSetAttribute(potion, "UseAPCost", new)
    end
end

-- Changes the physical armor bonus from potions to magic armor.
-- Picks the maximum between them, but if physical armor is negative
-- and magic armor isn't positive, picks the minimum between them.
local function WotL_ChangePotionArmor(potion)
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
        if magic <= 0 and armor < 0 then
            final = math.min(magic, armor)
        end
        WotL_ModulePrint("Final Armor Boost: " .. tostring(final), "Potion")
        Ext.StatSetAttribute(potion, "MagicArmorBoost", final)
        Ext.StatSetAttribute(potion, "ArmorBoost", 0)
    end
end

-- Changes the value for movement bonuses by a factor of WotL_BaseMovementMultiplier.
local function WotL_ChangePotionMovement(potion)
    local movement = Ext.StatGetAttribute(potion, "Movement")
    if movement ~= 0 then
        local new = Ext.Round(movement * Ext.ExtraData.WotL_BaseMovementMultiplier)
        WotL_ModulePrint("Movement: " .. tostring(movement) .. " -> " .. tostring(new), "Potion")
        Ext.StatSetAttribute(potion, "Movement", new)
    end
end

-------------------------------------------- PRESETS --------------------------------------------

local WotL_PotionsLookFor = {}
local WotL_PotionsProperties = {}
-- Saves the stats and properties that will suffer preset changes.
local function WotL_PreparePotionPresets()
    for potion, list in pairs(ENUM_WotL_PotionPresets) do
        WotL_PotionsLookFor[potion] = true
        for attribute, _ in pairs(list) do
            WotL_PotionsProperties[attribute] = true
        end
    end
end

local WotL_DefaultPotionProperties = {}
-- Applies the preset changes, based on the stats and properties saved of the root parent.
-- If the root parent matches the defined stat, the current stat suffer the preset change
-- if the property value matches the default value for the root parent stat.
local function WotL_ChangePotionPreset(potion)
    if WotL_PotionsLookFor[potion] then
        WotL_DefaultPotionProperties[potion] = {}
        for attribute, _ in pairs(WotL_PotionsProperties) do
            WotL_DefaultPotionProperties[potion][attribute] = Ext.StatGetAttribute(potion, attribute)
        end
    end

    for stat, list in pairs(ENUM_WotL_PotionPresets) do
        local parent = WotL_GetRootParent(potion)
        if parent == stat then
            for attribute, value in pairs(list) do
                local curr = Ext.StatGetAttribute(potion, attribute)
                if curr == WotL_DefaultPotionProperties[parent][attribute] then
                    WotL_ModulePrint("------ PRESET APPLIED ------", "Potion")
                    WotL_ModulePrint(tostring(attribute) .. ": " .. tostring(curr) .. " -> " .. tostring(value), "Potion")
                    Ext.StatSetAttribute(potion, attribute, value)
                end
            end
            break
        end
    end
end

---------------------------------------- MODULE FUNCTION ----------------------------------------

function WotL_ModulePotion()
    WotL_PreparePotionPresets()
    for _, potion in pairs(Ext.GetStatEntries("Potion")) do
        WotL_ModulePrint("Potion: " .. potion, "Potion")

        WotL_ChangePotionAPBoost(potion)
        WotL_ChangePotionAPCost(potion)
        WotL_ChangePotionArmor(potion)
        WotL_ChangePotionMovement(potion)
        WotL_ChangePotionPreset(potion)
    end
end
