local function BackstabCritical(target, source, handle)
    local hit = WotL_Bool(NRD_StatusGetInt(target, handle, "Hit"))
    local backstab = WotL_Bool(NRD_StatusGetInt(target, handle, "Backstab"))
    local critical = WotL_Bool(NRD_StatusGetInt(target, handle, "CriticalHit"))

    if hit and backstab and critical then
        ApplyStatus(target, "WotL_BackstabCritical", 0.0, 1, source)
    end
end
Ext.NewCall(BackstabCritical, "WotL_BackstabCritical", "(CHARACTERGUID)_Target, (CHARACTERGUID)_Source,(INTEGER64)_Handle")
