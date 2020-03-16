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
