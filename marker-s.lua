local config = getConfig()
local colliders = {}

local function setupMarkersCollisions()
    table.foreach(config.markers, function(index, marker)
        local mx, my =
            marker.position.x,
            marker.position.y

        local collider = createColCircle(mx, my, config.colliderSize)

        setElementInterior(collider, marker.interior)
        setElementDimension(collider, marker.dimension)

        colliders[collider] = index
    end)
end

local function onColshapeInteract(elm, samedim)
    local index = colliders[source]
    local marker = type(index) == "number" and config.markers[index]
    local _, __, ez = getElementPosition(elm)
    local sameint = marker and getElementInterior(elm) == marker.interior

    if  not marker or
        not samedim or
        not sameint or
        math.abs(ez - marker.position.z) > 1
    then
        return
    end

    local enter = eventName == "onColShapeHit"
    local event = enter and "onCustomMarkerHit" or "onCustomMarkerLeave"

    triggerEvent(event, elm, marker, source)
    triggerClientEvent(elm, event, elm, marker, source)
end

addEvent("onCustomMarkerHit")
addEvent("onCustomMarkerLeave")

addEventHandler("onResourceStart", root, setupMarkersCollisions)
addEventHandler("onColShapeHit", root, onColshapeInteract)
addEventHandler("onColShapeLeave", root, onColshapeInteract)
