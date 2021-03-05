local EASING_FUNCTIONS = {
    "Linear", "InQuad", "OutQuad", "InOutQuad",
    "OutInQuad", "InElastic", "OutElastic", "InOutElastic",
    "OutInElastic", "InBack", "OutBack", "InOutBack",
    "OutInBack", "InBounce", "OutBounce", "InOutBounce",
    "OutInBounce", "SineCurve", "CosineCurve"
}

function getConfig()
    return {
        viewDistance = viewDistance or 50,
        colliderSize = colliderSize or 2,
        markers = markers or {},
        icons = icons or {},
        colors = colors or {
            icon = tocolor(255, 255, 255),
            base = tocolor(255, 255, 255)
        },
        sizes = sizes or {
            icon = 1,
            base = 1.3
        },
        animation = animation or {
            duration = 1000,
            easing = "InOutQuad",
            pulseMultiplier = 0.3
        }
    }
end

function strf(str, ...)
    assert(type(str) == "string", string.format("Bad argument 1 to 'strf' (string expected got %s)", type(str)))

    return string.format(str, ...)
end

function table.each(tbl, fun)
    assert(type(tbl) == "table", strf("Bad argument 1 to 'table.each' (table expected got %s)", type(tbl)))
    assert(type(fun) == "function", strf("Bad argument 2 to 'table.each' (function expected got %s)", type(fun)))

    for key, value in pairs(tbl) do
        fun(value, key)
    end

    return true
end

function table.filter(tbl, fun)
    assert(type(tbl) == "table", strf("Bad argument 1 to 'table.filter' (table expected got %s)", type(tbl)))
    assert(type(fun) == "function", strf("Bad argument 2 to 'table.filter' (function expected got %s)", type(fun)))

    local result = {}

    for key, value in pairs(tbl) do
        if (fun(value, key)) then
            result[key] = value
        end
    end

    return result
end

function table.includes(tbl, value)
    assert(type(tbl) == "table", strf("Bad argument 1 to 'table.includes' (table expected got %s)", type(tbl)))

    for _, v in pairs(tbl) do
        if (v == value) then
            return true
        end
    end

    return false
end

function getVisibleMarkers(player, all_markers, maxViewDistance)
    local px, py, pz = getElementPosition(player)
    local pdimension = getElementDimension(player)
    local pinterior = getElementInterior(player)

    return table.filter(all_markers, function(marker)
        local mx, my, mz =
            marker.position.x,
            marker.position.y,
            marker.position.z

        local distance = getDistanceBetweenPoints3D(
            px, py, pz,
            mx, my, mz 
        )

        local samedim = pdimension == marker.dimension
        local sameint = pinterior == marker.interior

        return
            distance < maxViewDistance and
            samedim and
            sameint
    end)
end

function createAnimation(duration, easing, multiplier)
    assert(type(duration) == "number", strf("Bad argument 1 to 'createAnimation' (number expected got %s)", type(duration)))
    assert(table.includes(EASING_FUNCTIONS, easing), "Bad argument 2 to 'createAnimation' (valid animation expected)")

    local state = 0
    local startTime = getTickCount()
    
    return function()
        local tick = getTickCount()
        local passed = tick - startTime

        local value = interpolateBetween(
            state > 0 and 0 or 1, 0, 0,
            state > 0 and 1 or 0, 0, 0,
            passed / duration,
            easing
        )

        if passed > duration then
            state = state > 0 and 0 or 1
            startTime = tick
        end

        return value * multiplier
    end
end
