local config = getConfig()
local descriptors = getMarkersDescriptors()
local markers = getMarkersElements()

local function onColshapeInteract(elm, samedim)
    local descriptor = descriptors[source]
    local marker = markers[source]
    local _, __, ez = getElementPosition(elm)

    if not descriptor or
        not marker or
        math.abs(ez - descriptor.position.z) > 1
    then
        return
    end

    local sameint = getElementInterior(elm) == descriptor.interior

    local enter = eventName == "onColShapeHit"
    local event = enter and "onCustomMarkerHit" or "onCustomMarkerLeave"

    triggerEvent(event, marker, elm, samedim, sameint, descriptor, source)

    if isElement(elm) then
        triggerClientEvent(event, marker, elm, samedim, sameint, descriptor, source)
    end
end

function createCustomMarker(
    x, y, z,
    icon,
    dimension,
    interior,
    iconColor,
    baseColor
)
    dimension = dimension or 0
    interior = interior or 0
    iconColor = iconColor or config.colors.icon
    baseColor = baseColor or config.colors.base

    assert(type(x) == "number", strf("Bad argument 1 to 'createCustomMarker' (number expected got %s)", type(x)))
    assert(type(y) == "number", strf("Bad argument 2 to 'createCustomMarker' (number expected got %s)", type(y)))
    assert(type(z) == "number", strf("Bad argument 3 to 'createCustomMarker' (number expected got %s)", type(z)))
    assert(doesIconExists(config.icons, icon), "Bad argument 4 to 'createCustomMarker' (valid icon expected)")
    assert(type(dimension) == "number", strf("Bad argument 5 to 'createCustomMarker' (number expected got %s)", type(dimension)))
    assert(type(interior) == "number", strf("Bad argument 6 to 'createCustomMarker' (number expected got %s)", type(interior)))
    assert(type(iconColor) == "number", strf("Bad argument 7 to 'createCustomMarker' (number expected got %s)", type(iconColor)))
    assert(type(baseColor) == "number", strf("Bad argument 8 to 'createCustomMarker' (number expected got %s)", type(baseColor)))

    local element = createElement("custom-marker")
    local collider = createColCircle(x, y, config.colliderSize)
    local descriptor = {
        icon = icon,
        position = { x = x, y = y, z = z },
        dimension = dimension,
        interior = interior,
        iconColor = iconColor,
        baseColor = baseColor
    }

    setElementInterior(collider, interior)
    setElementDimension(collider, dimension)

    triggerEvent("onCustomMarkerCreated", resourceRoot, collider, element, descriptor)
    triggerClientEvent("onCustomMarkerCreated", resourceRoot, collider, element, descriptor)

    return element
end

addEvent("custommarker:doCustomMarkerCreate", true)

addEventHandler("custommarker:doCustomMarkerCreate", root, createCustomMarker)
addEventHandler("onColShapeHit", root, onColshapeInteract)
addEventHandler("onColShapeLeave", root, onColshapeInteract)
