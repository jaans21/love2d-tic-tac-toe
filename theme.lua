-- Theme and Color Management Module
-- Made by jaans21

local theme = {}

-- Theme state
theme.isDarkMode = true
theme.themeTransition = 0
theme.themeButtonHover = 0

-- Color themes
local darkTheme = {
    background = {0.08, 0.08, 0.12},
    menuBackground = {0.05, 0.05, 0.08},
    buttonNormal = {0.15, 0.2, 0.3},
    buttonHover = {0.2, 0.3, 0.45},
    buttonActive = {0.25, 0.35, 0.5},
    buttonSelected = {0.1, 0.4, 0.7},
    buttonSelectedHover = {0.2, 0.5, 0.8},
    audioButtonOn = {0.2, 0.7, 0.3},
    audioButtonOff = {0.7, 0.3, 0.3},
    audioButtonHoverOn = {0.3, 0.8, 0.4},
    audioButtonHoverOff = {0.8, 0.4, 0.4},
    text = {0.95, 0.95, 0.98},
    textSecondary = {0.7, 0.7, 0.8},
    textHint = {0.5, 0.5, 0.6},
    grid = {0.3, 0.3, 0.35},
    playerX = {0.9, 0.3, 0.3},
    playerO = {0.3, 0.6, 0.9},
    tie = {0.6, 0.6, 0.6},
    accent = {0.2, 0.8, 0.6},
    cardBackground = {0.12, 0.15, 0.2},
    cardBorder = {0.2, 0.25, 0.3},
    shadow = {0, 0, 0, 0.3}
}

local lightTheme = {
    background = {0.95, 0.95, 0.98},
    menuBackground = {0.98, 0.98, 1.0},
    buttonNormal = {0.85, 0.88, 0.92},
    buttonHover = {0.75, 0.8, 0.85},
    buttonActive = {0.7, 0.75, 0.8},
    buttonSelected = {0.3, 0.6, 0.9},
    buttonSelectedHover = {0.2, 0.5, 0.8},
    audioButtonOn = {0.1, 0.6, 0.2},
    audioButtonOff = {0.6, 0.2, 0.2},
    audioButtonHoverOn = {0.2, 0.7, 0.3},
    audioButtonHoverOff = {0.7, 0.3, 0.3},
    text = {0.1, 0.1, 0.15},
    textSecondary = {0.3, 0.3, 0.4},
    textHint = {0.4, 0.4, 0.5},
    grid = {0.6, 0.6, 0.65},
    playerX = {0.8, 0.2, 0.2},
    playerO = {0.2, 0.5, 0.8},
    tie = {0.4, 0.4, 0.4},
    accent = {0.2, 0.7, 0.5},
    cardBackground = {0.9, 0.92, 0.95},
    cardBorder = {0.7, 0.75, 0.8},
    shadow = {0, 0, 0, 0.15}
}

theme.colors = {}

-- Function to interpolate between two colors
local function lerpColor(a, b, t)
    return {
        a[1] + (b[1] - a[1]) * t,
        a[2] + (b[2] - a[2]) * t,
        a[3] + (b[3] - a[3]) * t,
        (a[4] or 1) + ((b[4] or 1) - (a[4] or 1)) * t
    }
end

-- Function to update colors based on current theme
function theme.updateColors()
    -- themeTransition: 0 = dark theme, 1 = light theme
    for key, _ in pairs(darkTheme) do
        theme.colors[key] = lerpColor(darkTheme[key], lightTheme[key], theme.themeTransition)
    end
end

-- Function to toggle theme
function theme.toggle()
    theme.isDarkMode = not theme.isDarkMode
    -- Don't reset themeTransition here - let the update function handle it smoothly
end

-- Initialize with dark theme
function theme.init()
    for key, value in pairs(darkTheme) do
        theme.colors[key] = {value[1], value[2], value[3], value[4] or 1}
    end
    
    -- Ensure proper initialization
    theme.themeTransition = 0  -- Start with dark theme (0 = dark, 1 = light)
end

-- Update theme transition
function theme.update(dt)
    -- Smooth theme transition
    local targetTransition = theme.isDarkMode and 0 or 1
    if math.abs(theme.themeTransition - targetTransition) > 0.01 then
        theme.themeTransition = theme.themeTransition + (targetTransition - theme.themeTransition) * dt * 5
        theme.updateColors()
    else
        theme.themeTransition = targetTransition
    end
end

return theme
