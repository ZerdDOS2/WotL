-- Doubles the object AP cost, up to 6.
local function WotL_ChangeObjectAP(object)
    local AP = Ext.StatGetAttribute(object, "UseAPCost")
    if AP ~= nil and AP ~= 0 then
        local new = math.min(2*AP, 6)
        WotL_ModulePrint("AP: " .. tostring(AP) .. " -> " .. tostring(new), "Object")
        Ext.StatSetAttribute(object, "UseAPCost", new)
    end
end

---------------------------------------- MODULE FUNCTION ----------------------------------------

function WotL_ModuleObject()
    for _, object in pairs(Ext.GetStatEntries("Object")) do
        WotL_ModulePrint("Object: " .. object, "Object")

        WotL_ChangeObjectAP(object)
    end
end
