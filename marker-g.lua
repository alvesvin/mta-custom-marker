local colliderDescriptor = {} -- Mapeia um collider para um marker descriptor
local colliderElement = {} -- Mapeia um collider para um custom-marker element

local function appendMarkerToMap(collider, element, descriptor)
    assert(getElementType(collider) == "colshape", strf("Bad argument 1 to 'appendMarkerTopMap' (colshape expected got %s)", getElementType(collider)))
    assert(getElementType(element) == "custom-marker", strf("Bad argument 2 to 'appendMarkerTopMap' (custom marker element expected got %s)", getElementType(element)))
    assert(type(descriptor) == "table", strf("Bad argument 3 to 'appendMarkerTopMap' (table expected got %s)", type(descriptor)))

    colliderDescriptor[collider] = descriptor
    colliderElement[collider] = element
end

function getMarkersDescriptors()
    return colliderDescriptor
end

function getMarkersElements()
    return colliderElement
end

addEvent("onCustomMarkerCreated", true)
addEvent("onCustomMarkerHit", true)
addEvent("onCustomMarkerLeave", true)

addEventHandler("onCustomMarkerCreated", root, appendMarkerToMap)
