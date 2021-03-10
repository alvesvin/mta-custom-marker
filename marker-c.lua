local visibleMarkers = {}

local config = getConfig()
local textures = {}

local getAnimationOffset = createAnimation(
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

local function drawMarkers()
    table.foreach(visibleMarkers, function(_, marker)
        local mx, my, mz = 
            marker.position.x,
            marker.position.y,
            marker.position.z
        
        local groundPosition = 0.03 + getGroundPosition(
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
    end)
end

local function calculateVisibleMarkers()
    local checked = getTickCount()
    local period = 300

    return function()
        local tick = getTickCount()
        local passed = tick - checked

        if passed >= period then
            visibleMarkers = getVisibleMarkers(localPlayer, config.markers, config.viewDistance)
            checked = tick
        end

    end

end

addEvent("onCustomMarkerHit", true)
addEvent("onCustomMarkerLeave", true)

addEventHandler("onClientResourceStart", resourceRoot, preloadTextures)
addEventHandler("onClientPreRender", root, calculateVisibleMarkers())
addEventHandler("onClientRender", root, drawMarkers)
