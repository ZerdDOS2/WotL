-- Replaces the default value for physical and magic armor of characters,
-- combining them into magic armor, following the formula:
-- final^2 = phys^2 + mag^2
local function WotL_ChangeCharacterArmor(character)
    local armor = Ext.StatGetAttribute(character, "Armor")
    if armor ~= 0 then
        local magic = Ext.StatGetAttribute(character, "MagicArmor")
        WotL_ModulePrint("Physical Armor: " .. tostring(armor), "Character")
        WotL_ModulePrint("Magic Armor: " .. tostring(magic), "Character")
        local final = math.ceil(math.sqrt(armor^2 + magic^2))
        WotL_ModulePrint("Final Armor: " .. final, "Character")
        Ext.StatSetAttribute(character, "MagicArmor", final)
        Ext.StatSetAttribute(character, "Armor", 0)
    end
end

-- Changes the default value for movement of characters by a factor of 0.5.
-- The default value for player characters changes from 5 m to 2 m.
local function WotL_ChangeCharacterMovement(character)
    local movement = Ext.StatGetAttribute(character, "Movement")
    if movement ~= 0 then
        local new = math.ceil(movement * 0.4)
        WotL_ModulePrint("Movement: " .. tostring(movement) .. " -> " .. tostring(new), "Character")
        Ext.StatSetAttribute(character, "Movement", new)
    end
end

-- Includes the talents listed on the ENUM_WotL_InnateTalents table on the
-- default talents on characters stats.
local function WotL_ChangeInnateTalents(character)
    local talents = Ext.StatGetAttribute(character, "Talents")
    if talents ~= nil and talents ~= "" then
        WotL_ModulePrint("Talents: " .. talents, "Character")
    end
    local final

    for _, talent in pairs (ENUM_WotL_InnateTalents) do
        if string.find(talents, talent) == nil then
            if final ~= nil and final ~= "" then
                final = final .. ";" .. talent
            else
                final = talent
            end
        end
    end
    
    if final ~= nil and final ~= "" then
        if talents ~= nil and talents ~= "" then
            final = talents .. ";" .. final
        end
        Ext.StatSetAttribute(character, "Talents", final)
        WotL_ModulePrint("Final: " .. final, "Character")
    end
end

---------------------------------------- MODULE FUNCTION ----------------------------------------

function WotL_ModuleCharacter()
    for _, character in pairs(Ext.GetStatEntries("Character")) do
        WotL_ModulePrint("Character: " .. character, "Character")

        WotL_ChangeCharacterArmor(character)
        WotL_ChangeCharacterMovement(character)
        -- TODO: Currently refunds talents given upon preset change on CC
        -- WotL_ChangeInnateTalents(character)
    end
end
