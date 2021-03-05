local config = getConfig()
local colliders = {}

local function setupMarkersCollisions()
    table.each(config.markers, function(marker, index)
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

    if  not marker or
        not samedim or
        math.abs(ez - marker.position.z) > 1
    then
        return
    end

    local enter = eventName == "onColShapeHit"
    local event = enter and "onCustomMarkerHit" or "onCustomMarkerLeave"

    triggerEvent(event, elm, marker)
    triggerClientEvent(elm, event, elm, marker)
end

addEvent("onCustomerMarkerHit")
addEvent("onCustomerMarkerLeave")

addEventHandler("onResourceStart", root, setupMarkersCollisions)
addEventHandler("onColShapeHit", root, onColshapeInteract)
addEventHandler("onColShapeLeave", root, onColshapeInteract)
