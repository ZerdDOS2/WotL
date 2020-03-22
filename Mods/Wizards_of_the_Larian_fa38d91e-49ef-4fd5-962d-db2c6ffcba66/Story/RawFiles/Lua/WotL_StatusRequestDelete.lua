-- Custom (random) number to identify statuses applied by WotL
WotL_StatusRemovalAtTurnEndCustomNumber = 1.84279

-- If the status remaining LifeTime matches the custom number
-- it means it was set by WotL, thus, should be deleted at
-- turn end
function WotL_RemoveStatusesAtTurnEnd(char, status, handle)
    local duration = NRD_StatusGetReal(char, handle, "CurrentLifeTime")
    local isEqual = math.abs(duration - WotL_StatusRemovalAtTurnEndCustomNumber) < 0.001
    if isEqual then
        RemoveStatus(char, status)
    end
end

function WotL_RemoveStatusesAtTurnStartHandler(combatId)
    local combat = Ext.GetCombat(combatId)
    local order = combat:GetCurrentTurnOrder()
    local char = ""

    if (#order > 1) then
        char = order[2].Character.MyGuid
    else
        order = combat:GetNextTurnOrder()
        char = order[1].Character.MyGuid
    end
    CharacterStatusText(char, "Identified next")
    -- NRD_IterateStatuses(char, "WotL_RemoveStatusesAtTurnStart")
end

ENUM_WotL_HardCCTypeRemovals = WotL_Set {
    "CHARMED",
    "FEAR",
    "INCAPACITATED",
    "KNOCKED_DOWN",
    "POLYMORPHED",
}

ENUM_WotL_HardCCStatusRemovals = {
    ["KNOCKED_DOWN"] = "CRIPPLED",
    ["FROZEN"] = "CHILLED",
    -- ["PETRIFIED"] = ""
    ["STUNNED"] = "SHOCKED",
}

function WotL_RemoveStatusesAtTurnStart(char, status, handle)
    if not WotL_Bool(NRD_StatExists(status)) then
        return
    end

    local type = NRD_StatGetString(status, "StatusType")
    if not ENUM_WotL_HardCCTypeRemovals[type] then
        return
    end
    
    Ext.Print("Status: " .. tostring(status))
    local replacer = ENUM_WotL_HardCCStatusRemovals[status]
    Ext.Print("Replacer: " .. tostring(replacer))

    local source = NRD_StatusGetGuidString(char, handle, "StatusSourceHandle")

    RemoveStatus(char, status)
    ApplyStatus(char, replacer, 6.0, 0, source)
end
