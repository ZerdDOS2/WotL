-- Doubles the weapon AP cost, up to 6.
local function WotL_ChangeWeaponAP(weapon)
    local AP = Ext.StatGetAttribute(weapon, "AttackAPCost")
    if AP ~= nil and AP ~= 0 then
        local new = math.min(2*AP, 6)
        WotL_ModulePrint("AP: " .. tostring(AP) .. " -> " .. tostring(new), "Weapon")
        Ext.StatSetAttribute(weapon, "AttackAPCost", new)
    end
end

-- Decreases the weapon range, only if it's between 5 and 25 m.
local function WotL_ChangeWeaponRange(weapon)
    local range = Ext.StatGetAttribute(weapon, "WeaponRange")
    if range > 500 then
        local new = 100 * math.ceil(WotL_Truncate(WotL_NormalizeRange(range/100), 1))
        WotL_ModulePrint("Range: " .. tostring(range) .. " -> " .. tostring(new), "Weapon")
        Ext.StatSetAttribute(weapon, "WeaponRange", new)
    end
end

-- Removes the weapon requirements and, thus, scaling.
local function WotL_RemoveWeaponRequirements(weapon)
    Ext.StatSetAttribute(weapon, "Requirements", {})
end

-------------------------------------------- PRESETS --------------------------------------------

local WotL_WeaponsLookFor = {}
local WotL_WeaponProperties = {}
-- Saves the stats and properties that will suffer preset changes.
local function WotL_PrepareWeaponPresets()
    for weapon, list in pairs(ENUM_WotL_WeaponPresets) do
        WotL_WeaponsLookFor[weapon] = true
        for attribute, _ in pairs(list) do
            WotL_WeaponProperties[attribute] = true
        end
    end
end

local WotL_DefaultWeaponProperties = {}
-- Applies the preset changes, based on the stats and properties saved of the root parent.
-- If the root parent matches the defined stat, the current stat suffer the preset change
-- if the property value matches the default value for the root parent stat.
local function WotL_ChangeWeaponPreset(weapon)
    if WotL_WeaponsLookFor[weapon] then
        WotL_DefaultWeaponProperties[weapon] = {}
        for attribute, _ in pairs(WotL_WeaponProperties) do
            WotL_DefaultWeaponProperties[weapon][attribute] = Ext.StatGetAttribute(weapon, attribute)
        end
    end

    for stat, list in pairs(ENUM_WotL_WeaponPresets) do
        local parent = WotL_GetRootParent(weapon)
        if parent == stat then
            for attribute, value in pairs(list) do
                local curr = Ext.StatGetAttribute(weapon, attribute)
                if curr == WotL_DefaultWeaponProperties[parent][attribute] then
                    WotL_ModulePrint("------ PRESET APPLIED ------", "Weapon")
                    WotL_ModulePrint(tostring(attribute) .. ": " .. tostring(curr) .. " -> " .. tostring(value), "Weapon")
                    Ext.StatSetAttribute(weapon, attribute, value)
                end
            end
            break
        end
    end
end

---------------------------------------- MODULE FUNCTION ----------------------------------------

function WotL_ModuleWeapon()
    WotL_PrepareWeaponPresets()
    for _, weapon in pairs(Ext.GetStatEntries("Weapon")) do
        WotL_ModulePrint("Weapon: " .. weapon, "Weapon")
        
        WotL_ChangeWeaponAP(weapon)
        WotL_ChangeWeaponRange(weapon)
        WotL_RemoveWeaponRequirements(weapon)
        WotL_ChangeWeaponPreset(weapon)
    end
end
