-- function WotL_MapPotionResistance(potion)
--     for stat, statuses in pairs(ENUM_WotL_ResistanceStatuses) do
--         local resistance = Ext.StatGetAttribute(potion, stat)
--         if resistance ~= 0 then
--             local status
--             if resistance >= 150 then
--                 status = statuses[4]
--             elseif resistance >= 75 then
--                 status = statuses[3]
--             elseif resistance >= 25 then
--                 status = statuses[2]
--             elseif resistance <= -25 then
--                 status = statuses[1]
--             end
--             Ext.StatSetAttribute(potion, stat, 0)
--             if status ~= nil then
--                 if WotL_PotionResistanceTable[potion] ~= nil then
--                     table.insert(WotL_PotionResistanceTable[potion], status)
--                 else
--                     WotL_PotionResistanceTable[potion] = {status}
--                 end
--             end
--         end
--     end
-- end

function WotL_ChangePotionResistance(potion)
    local physical = Ext.StatGetAttribute(potion, "PhysicalResistance")
    if physical ~= 0 then
        local earth = Ext.StatGetAttribute(potion, "PhysicalResistance")
        WotL_ModulePrint("Physical Resistance: " .. tostring(physical), "Potion")
        WotL_ModulePrint("Earth Resistance: " .. tostring(earth), "Potion")
        local final = math.max(earth, physical)
        if earth < 0 and physical < 0 then
            final = math.min(earth, physical)
        end
        Ext.StatSetAttribute(potion, "EarthResistance", final)
        Ext.StatSetAttribute(potion, "PhysicalResistance", 0)
        WotL_ModulePrint("Final Resistance: " .. tostring(final), "Potion")
    end
end