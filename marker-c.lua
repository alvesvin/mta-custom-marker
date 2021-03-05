local visibleMarkers = {} -- Markers dentro do campo de visão escolhido nas configurações

local config = getConfig()
local textures = {}

local getAnimationOffset = createAnimation(
    config.animation.duration,
    config.animation.easing,
    config.animation.pulseMultiplier
)

local function preloadTextures()
    table.each(config.icons, function(v, k)
        local name = k
        local path = v

        if type(k) == "number" then
            name = v
            path = strf("assets/icons/%s.png", v)
        end

        textures[name] = dxCreateTexture(path, "dxt5", false, "clamp")
    end)
end

local function drawMarker(marker)
    local mx, my, mz = 
        marker.position.x,
        marker.position.y,
        marker.position.z
    
    local groundPosition = getGroundPosition(
        mx, my, mz
    )

    -- Icone
    
    dxDrawMaterialLine3D(
        mx, my, mz + config.sizes.icon + getAnimationOffset(),
        mx, my, mz + getAnimationOffset(),
        textures[marker.icon],
        config.sizes.icon,
        marker.iconColor or config.colors.icon
    )

    -- Base

    local baseSize = config.sizes.base + getAnimationOffset()

    dxDrawMaterialLine3D(
        mx, my - baseSize / 2, groundPosition,
        mx, my + baseSize / 2, groundPosition,
        textures["base"],
        baseSize,
        marker.baseColor or config.colors.base,
        false,
        mx, my, groundPosition + 1
    )
end

addEvent("onCustomMarkerHit", true)
addEvent("onCustomMarkerLeave", true)

addEventHandler("onClientResourceStart", root, preloadTextures)

addEventHandler("onClientPedStep", localPlayer, function()
    visibleMarkers = getVisibleMarkers(localPlayer, config.markers, config.viewDistance)
end)

addEventHandler("onClientRender", root, function()
    table.each(visibleMarkers, drawMarker)
end)

setDevelopmentMode(true)

