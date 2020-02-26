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

-- Changes the value for movement bonuses by a factor of 0.3 (same as characters).
local function WotL_ChangePotionMovement(potion)
    local movement = Ext.StatGetAttribute(potion, "Movement")
    if movement ~= 0 then
        local new = math.ceil(movement * 0.3)
        WotL_ModulePrint("Movement: " .. tostring(movement) .. " -> " .. tostring(new), "Potion")
        Ext.StatSetAttribute(potion, "Movement", new)
    end
end

-- Changes physical resistances to earth resistances.
-- Picks the maximum between them, but if physical resistance is negative
-- and earth resistance isn't positive, picks the minimum between them.
local function WotL_ChangePotionResistance(potion)
    local physical = Ext.StatGetAttribute(potion, "PhysicalResistance")
    if physical ~= 0 then
        local earth = Ext.StatGetAttribute(potion, "PhysicalResistance")
        WotL_ModulePrint("Physical Resistance: " .. tostring(physical), "Potion")
        WotL_ModulePrint("Earth Resistance: " .. tostring(earth), "Potion")
        local final = math.max(earth, physical)
        if earth <= 0 and physical < 0 then
            final = math.min(earth, physical)
        end
        WotL_ModulePrint("Final Resistance: " .. tostring(final), "Potion")
        Ext.StatSetAttribute(potion, "EarthResistance", final)
        Ext.StatSetAttribute(potion, "PhysicalResistance", 0)
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

        WotL_ChangePotionArmor(potion)
        WotL_ChangePotionMovement(potion)
        WotL_ChangePotionResistance(potion)
        WotL_ChangePotionPreset(potion)
    end
end
