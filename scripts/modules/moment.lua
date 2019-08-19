local module = {}

function module.get_seconds(time)
    if time > 3600 then return '' end
    while time >= 60 do time = time - 60 end
    if time >= 1 then return math.floor(time / 1).." с." end
    return ""
end

function module.get_minutes(time)
    if time > 86400 then return '' end
    while time >= 3600 do time = time - 3600 end
    if time >= 60 then return math.floor(time / 60).." м. " end
    return ""
end

function module.get_hours(time)
    if time > 86400 * 30 then return '' end
    while time >= 86400 do time = time - 86400 end
    if time >= 3600 then return math.floor(time / 3600).." ч. " end
    return ""
end

function module.get_days(time)
    if time > 86400 * 30 * 12 then return '' end
    while time >= 86400 * 30 do time = time - 86400 * 30 end
    if time >= 86400 then return math.floor(time / 86400).." д. " end
    return ""
end

function module.get_month(time)
    if time > 3600 * 30 * 12 * 100 then return '' end
    while time >= 86400 * 30 * 12 do time = time - 86400 * 30 * 12 end
    if time >= 86400 * 30 then return math.floor(time / 86400 * 30).." мес. " end
    return ""
end

function module.get_years(time)
    if time >= 86400 * 30 * 12 then return math.floor(time / 86400 * 30 * 12).." л. " end
    return ""
end

function module.get_time(time)
    if time == 1e999 then return '∞' end
    return ''
        .. module.get_years(time)
        .. module.get_month(time)
        .. module.get_days(time)
        .. module.get_hours(time)
        .. module.get_minutes(time)
        .. module.get_seconds(time)
end

return module
