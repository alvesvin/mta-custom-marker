local visibleMarkers = {}
local all_markers = getMarkersDescriptors()

local config = getConfig()
local textures = {}

local getAnimatedValue = createAnimation(
    config.animation.duration,
    config.animation.easing,
    config.animation.pulseMultiplier
)

local function preloadTextures()
    table.foreach(config.icons, function(k, v)
        local name = k
        local path = v

        if type(k) == "number" then
            name = v
            path = strf("assets/icons/%s.png", v)
        end

        textures[name] = dxCreateTexture(path, "dxt5", false, "clamp")
    end)
end

local function loadConfigMarkers()
    table.foreach(config.markers, function(_, descriptor)
        createCustomMarker(
            descriptor.position.x,
            descriptor.position.y,
            descriptor.position.z,
            descriptor.icon,
            descriptor.dimension,
            descriptor.interior,
            descriptor.iconColor,
            descriptor.baseColor
        )
    end)
end

local function onResourceStart()
    preloadTextures()
    loadConfigMarkers()
end

local function drawMarkers()
    local animatedValue = getAnimatedValue()
    
    table.foreach(visibleMarkers, function(_, marker)
        local mx, my, mz = 
            marker.position.x,
            marker.position.y,
            marker.position.z
        
        local groundPosition = 0.03 + getGroundPosition(
            mx, my, mz
        )

        dxDrawMaterialLine3D(
            mx, my, mz + config.sizes.icon + animatedValue,
            mx, my, mz + animatedValue,
            textures[marker.icon],
            config.sizes.icon,
            marker.iconColor or config.colors.icon
        )

        local baseSize = config.sizes.base + animatedValue

        dxDrawMaterialLine3D(
            mx, my - baseSize / 2, groundPosition,
            mx, my + baseSize / 2, groundPosition,
            textures["base"],
            baseSize,
            marker.baseColor or config.colors.base,
            false,
            mx, my, groundPosition + 1
        )
    end)
end

local function calculateVisibleMarkers()
    local checked = getTickCount()
    local period = 300

    return function()
        local tick = getTickCount()
        local passed = tick - checked

        if passed >= period then
            visibleMarkers = getVisibleMarkers(localPlayer, all_markers, config.viewDistance)
            checked = tick
        end
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
    triggerServerEvent(
        "custommarker:doCustomMarkerCreate",
        resourceRoot,
        x, y, z,
        icon,
        dimension,
        interior,
        iconColor,
        baseColor
    )
end

addEventHandler("onClientResourceStart", resourceRoot, onResourceStart)
addEventHandler("onClientPreRender", root, calculateVisibleMarkers())
addEventHandler("onClientRender", root, drawMarkers)
