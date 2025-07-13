-- Configuration Module
-- Centralized configuration for Tic-Tac-Toe game
-- Made by jaans21

local config = {}

-- UI Configuration
config.ui = {
    -- Button dimensions
    buttonMinWidth = 120,
    buttonHeight = 40,
    cardWidth = 180,
    cardHeight = 60,
    
    -- Spacing and padding
    padding = 20,
    sectionSpacing = 40,
    buttonSpacing = 15,
    
    -- Animation settings
    animationSpeed = 8,
    hoverSpeed = 10,
    glowSpeed = 6,
    scaleEffect = 0.05, -- Subtle scale effect on hover
    
    -- Layout positions (relative to window)
    customInputY = 580,  -- Increased spacing from Start Game button
    customInputWidth = 160,
    customInputHeight = 40,
    
    -- Theme button
    themeButtonSize = 40,
    themeButtonMargin = 20,
    
    -- Menu layout
    titleY = 40,
    subtitleY = 110,
    gameModeY = 160,
    gameModeButtonsY = 200,
    boardSizeY = 280,
    boardSizeButtonsY1 = 320,
    boardSizeButtonsY2 = 390,
    
    -- Footer
    footerMarginBottom = 30,
    
    -- Responsive settings
    minWindowWidth = 800,
    minWindowHeight = 600,
    maxWindowWidth = 1920,
    maxWindowHeight = 1080
}

-- Game Configuration
config.game = {
    -- Board settings
    minBoardSize = 3,
    maxBoardSize = 15,
    defaultBoardSize = 3,
    
    -- Animation durations
    pieceAnimationDuration = 0.3,
    winningLineAnimationDuration = 2.0,
    transitionDuration = 0.4,
    
    -- AI settings
    defaultAiSpeed = "Normal",
    defaultAiDifficulty = "Medium",
    aiThinkingTimes = {
        Fast = {0.05, 0.1, 0.15, 0.2, 0.25},     -- Very fast AI
        Normal = {0.3, 0.5, 0.7, 1.0, 1.2},      -- Normal thinking speed
        Slow = {1.0, 1.5, 2.0, 2.5, 3.0}         -- Slow, thoughtful AI
    },
    
    -- Victory particles
    victoryParticles = {
        spawnRate = 0.05,
        duration = 3.0,
        maxParticles = 100,
        types = 4, -- circle, star, square, confetti
        colors = {
            {1, 0.2, 0.2}, -- Red
            {0.2, 1, 0.2}, -- Green
            {0.2, 0.2, 1}, -- Blue
            {1, 1, 0.2},   -- Yellow
            {1, 0.2, 1},   -- Magenta
            {0.2, 1, 1}    -- Cyan
        }
    },
    
    -- Performance settings
    maxParticleAge = 5.0,
    resizeFramesNeeded = 3, -- Frames to wait after resize
    
    -- Input settings
    doubleClickTime = 0.3,
    customInputMaxLength = 2
}

-- Audio Configuration
config.audio = {
    -- Default states
    soundEnabled = true,
    musicEnabled = true,
    
    -- Volume levels (0.0 - 1.0)
    masterVolume = 0.7,
    soundVolume = 0.8,
    musicVolume = 0.5,
    
    -- Audio files (if you have them)
    sounds = {
        buttonHover = nil, -- "sounds/hover.wav"
        buttonClick = nil, -- "sounds/click.wav"
        piecePlace = nil,  -- "sounds/place.wav"
        victory = nil,     -- "sounds/victory.wav"
        tie = nil          -- "sounds/tie.wav"
    },
    
    music = {
        menu = nil,        -- "music/menu.ogg"
        game = nil         -- "music/game.ogg"
    }
}

-- Graphics Configuration
config.graphics = {
    -- Font sizes
    fonts = {
        small = 14,
        normal = 20,
        button = 18,
        large = 32,
        title = 56
    },
    
    -- Line widths
    lineWidths = {
        thin = 1,
        normal = 2,
        thick = 3,
        piece = 4
    },
    
    -- Shadow offsets
    shadowOffset = 3,
    
    -- Particle settings
    particleLifetime = 3.0,
    particleGravity = 200,
    particleBounce = 0.6,
    
    -- Board rendering
    cellMarginPercent = 0.15, -- 15% margin inside each cell
    
    -- Performance settings
    maxFPS = 60,
    vsync = true
}

-- Theme Configuration
config.themes = {
    -- Theme transition settings
    transitionSpeed = 5,
    
    -- Available themes
    available = {"dark", "light"},
    default = "dark",
    
    -- Color schemes will be loaded from theme.lua
    -- This just defines the structure and defaults
    colorStructure = {
        "background",
        "menuBackground", 
        "text",
        "textSecondary",
        "accent",
        "buttonNormal",
        "buttonHover",
        "buttonSelected",
        "buttonSelectedHover",
        "cardBackground",
        "cardBorder",
        "shadow",
        "grid",
        "playerX",
        "playerO",
        "tie",
        "audioButtonOn",
        "audioButtonOff",
        "audioButtonHoverOn",
        "audioButtonHoverOff"
    }
}

-- Input Configuration
config.input = {
    -- Keyboard shortcuts
    shortcuts = {
        toggleTheme = "t",
        toggleFullscreen = "f11",
        toggleSound = "s",
        toggleMusic = "m",
        quit = "escape",
        newGame = "space",
        restart = "r"
    },
    
    -- Mouse settings
    doubleClickThreshold = 0.3,
    hoverDelay = 0.1,
    
    -- Touch settings (for mobile if supported)
    touchEnabled = false,
    touchThreshold = 10
}

-- Debug Configuration
config.debug = {
    enabled = false,
    showFPS = false,
    showCoordinates = false,
    showButtonBounds = false,
    logLevel = "info", -- "debug", "info", "warn", "error"
    
    -- Debug colors
    colors = {
        boundingBox = {1, 0, 0, 0.3}, -- Red with alpha
        hotspot = {0, 1, 0, 0.5},     -- Green with alpha
        center = {0, 0, 1, 0.8}       -- Blue with alpha
    }
}

-- Window Configuration
config.window = {
    -- Default window settings
    title = "Tic-Tac-Toe by jaans21",
    width = 1024,
    height = 768,
    minWidth = 800,
    minHeight = 600,
    
    -- Window behavior
    resizable = true,
    centered = true,
    fullscreen = false,
    borderless = false,
    
    -- Display settings
    vsync = true,
    msaa = 0, -- Anti-aliasing samples (0, 2, 4, 8, 16)
    display = 1 -- Which monitor to use
}

-- Utility functions for config
function config.getResponsiveButtonWidth(windowWidth)
    return math.max(config.ui.buttonMinWidth, windowWidth * 0.15)
end

function config.getResponsiveCardWidth(windowWidth)
    return math.max(config.ui.cardWidth, windowWidth * 0.12)
end

function config.getResponsiveFontSize(baseFontSize, windowWidth)
    local scale = math.max(0.7, math.min(1.3, windowWidth / 1024))
    return math.floor(baseFontSize * scale)
end

function config.getCustomInputPosition(windowWidth, windowHeight)
    return {
        x = windowWidth / 2 - config.ui.customInputWidth / 2,
        y = config.ui.customInputY,
        w = config.ui.customInputWidth,
        h = config.ui.customInputHeight
    }
end

function config.calculateAudioSectionY(isCustomMode)
    return isCustomMode and (config.ui.customInputY + 100) or 550
end

function config.validateBoardSize(size)
    if type(size) ~= "number" then
        return false
    end
    return size >= config.game.minBoardSize and size <= config.game.maxBoardSize
end

function config.clampVolume(volume)
    return math.max(0, math.min(1, volume or 0))
end

-- Environment detection
function config.detectEnvironment()
    local info = {}
    info.os = love.system.getOS()
    info.version = love.getVersion()
    info.renderer = love.graphics.getRendererInfo()
    return info
end

-- Performance profiles
config.performance = {
    profiles = {
        potato = {
            maxParticles = 20,
            particleLifetime = 1.5,
            animationSpeed = 4,
            shadowsEnabled = false,
            glowEffectsEnabled = false
        },
        normal = {
            maxParticles = 50,
            particleLifetime = 3.0,
            animationSpeed = 8,
            shadowsEnabled = true,
            glowEffectsEnabled = true
        },
        high = {
            maxParticles = 100,
            particleLifetime = 5.0,
            animationSpeed = 12,
            shadowsEnabled = true,
            glowEffectsEnabled = true
        }
    },
    current = "normal"
}

function config.setPerformanceProfile(profile)
    if config.performance.profiles[profile] then
        config.performance.current = profile
        local settings = config.performance.profiles[profile]
        
        -- Apply settings
        config.game.victoryParticles.maxParticles = settings.maxParticles
        config.graphics.particleLifetime = settings.particleLifetime
        config.ui.animationSpeed = settings.animationSpeed
        
        return true
    end
    return false
end

function config.autoDetectPerformance()
    -- Simple performance detection based on renderer
    local renderer = love.graphics.getRendererInfo()
    
    if string.find(string.lower(renderer), "intel") then
        config.setPerformanceProfile("potato")
    elseif string.find(string.lower(renderer), "integrated") then
        config.setPerformanceProfile("normal")
    else
        config.setPerformanceProfile("high")
    end
end

return config
