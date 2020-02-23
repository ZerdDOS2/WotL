ENUM_WotL_PotionPresets = {
    ["Stats_WotL_Speed_1"] = {
        ["Movement"] = 30,
    },
    ["Stats_WotL_Speed_2"] = {
        ["Movement"] = 60,
    },
    ["Stats_WotL_Speed_3"] = {
        ["Movement"] = 90,
    },
    ["Stats_WotL_Speed_4"] = {
        ["Movement"] = 120,
    },
    ["Stats_WotL_Speed_5"] = {
        ["Movement"] = 150,
    },
}

-- Do it like this to add presets from other mods
-- ENUM_WotL_PotionPresets["Stats_Slowed"] = {
--     ["MovementSpeedBoost"] = -30,
--     ["DodgeBoost"] = -100,
-- }

local WotL_PotionsLookFor = {}
local WotL_PotionsProperties = {}
function WotL_PreparePotionPresets()
    for potion, list in pairs(ENUM_WotL_PotionPresets) do
        WotL_PotionsLookFor[potion] = true
        for attribute, _ in pairs(list) do
            WotL_PotionsProperties[attribute] = true
        end
    end
end

local WotL_DefaultPotionProperties = {}
function WotL_ChangePotionPreset(potion)
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