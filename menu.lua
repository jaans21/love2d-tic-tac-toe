-- Menu System Module
-- Made by jaans21

local config = require("settings")
local menu = {}

-- Menu layout
menu.menuCards = {}
menu.cardWidth = config.ui.cardWidth
menu.cardHeight = config.ui.cardHeight
menu.menuButtons = {}
menu.gameOverButtons = {}
menu.gameButtons = {}  -- Nueva array para botones durante el juego

function menu.setup(gameState, theme, audio)
    menu.gameState = gameState
    menu.theme = theme
    menu.audio = audio
    
    menu.menuButtons = {
        {
            text = "Start Game", 
            action = function() 
                menu.gameState.startGame()
                menu.audio.playSound("buttonClick")
            end,
            x = 0, y = 0, w = menu.cardWidth, h = menu.cardHeight
        },
        {
            text = "Human vs Human", 
            action = function() 
                menu.gameState.gameMode = "human"
                menu.updateGameModeButtons()
                menu.audio.playSound("buttonClick")
            end,
            x = 0, y = 0, w = menu.cardWidth, h = menu.cardHeight,
            isSelected = function() return menu.gameState.gameMode == "human" end
        },
        {
            text = "Human vs AI", 
            action = function() 
                menu.gameState.gameMode = "ai"
                menu.updateGameModeButtons()
                menu.audio.playSound("buttonClick")
            end,
            x = 0, y = 0, w = menu.cardWidth, h = menu.cardHeight,
            isSelected = function() return menu.gameState.gameMode == "ai" end
        },
        {
            text = "3x3", 
            action = function() 
                menu.gameState.selectedBoardSize = 3
                menu.gameState.boardSize = 3
                menu.gameState.isCustomSizeMode = false
                menu.updateBoardSizeButtons()
                menu.audio.playSound("buttonClick")
            end,
            x = 0, y = 0, w = menu.cardWidth, h = menu.cardHeight,
            isSelected = function() return menu.gameState.selectedBoardSize == 3 and not menu.gameState.isCustomSizeMode end
        },
        {
            text = "4x4", 
            action = function() 
                menu.gameState.selectedBoardSize = 4
                menu.gameState.boardSize = 4
                menu.gameState.isCustomSizeMode = false
                menu.updateBoardSizeButtons()
                menu.audio.playSound("buttonClick")
            end,
            x = 0, y = 0, w = menu.cardWidth, h = menu.cardHeight,
            isSelected = function() return menu.gameState.selectedBoardSize == 4 and not menu.gameState.isCustomSizeMode end
        },
        {
            text = "5x5", 
            action = function() 
                menu.gameState.selectedBoardSize = 5
                menu.gameState.boardSize = 5
                menu.gameState.isCustomSizeMode = false
                menu.updateBoardSizeButtons()
                menu.audio.playSound("buttonClick")
            end,
            x = 0, y = 0, w = menu.cardWidth, h = menu.cardHeight,
            isSelected = function() return menu.gameState.selectedBoardSize == 5 and not menu.gameState.isCustomSizeMode end
        },
        {
            text = "Custom", 
            action = function() 
                menu.gameState.isCustomSizeMode = true
                menu.gameState.boardSize = menu.gameState.customBoardSize
                menu.updateBoardSizeButtons()
                menu.audio.playSound("buttonClick")
            end,
            x = 0, y = 0, w = menu.cardWidth, h = menu.cardHeight,
            isSelected = function() return menu.gameState.isCustomSizeMode end
        },
        {
            text = function() return menu.audio.soundEnabled and "Sound: ON" or "Sound: OFF" end,
            action = function() 
                menu.audio.toggleSound()
                menu.updateSoundButton()
                menu.audio.playSound("buttonClick")
            end,
            x = 0, y = 0, w = menu.cardWidth, h = menu.cardHeight,
            isAudioButton = true
        },
        {
            text = function() return menu.audio.musicEnabled and "Music: ON" or "Music: OFF" end,
            action = function() 
                menu.audio.toggleMusic()
                menu.updateMusicButton()
                menu.audio.playSound("buttonClick")
            end,
            x = 0, y = 0, w = menu.cardWidth, h = menu.cardHeight,
            isAudioButton = true
        },
        {
            text = function() return menu.gameState.isFullscreen and "Windowed" or "Fullscreen" end,
            action = function() 
                menu.toggleFullscreen()
                menu.updateFullscreenButton()
                menu.audio.playSound("buttonClick")
            end,
            x = 0, y = 0, w = menu.cardWidth, h = menu.cardHeight
        },
        {
            text = function() return "AI Speed: " .. menu.gameState.aiSpeed end,
            action = function() 
                menu.toggleAISpeed()
                menu.updateAISpeedButton()
                menu.audio.playSound("buttonClick")
            end,
            x = 0, y = 0, w = menu.cardWidth, h = menu.cardHeight
        },
        {
            text = function() return "AI Level: " .. menu.gameState.aiDifficulty end,
            action = function() 
                menu.toggleAIDifficulty()
                menu.updateAIDifficultyButton()
                menu.audio.playSound("buttonClick")
            end,
            x = 0, y = 0, w = menu.cardWidth, h = menu.cardHeight
        }
    }
    
    -- Initialize Game Over buttons
    menu.gameOverButtons = {
        {
            text = "Play Again",
            action = function()
                menu.gameState.startGame()
                menu.audio.playSound("buttonClick")
            end,
            x = 0, y = 0, w = 200, h = 50
        },
        {
            text = "Main Menu",
            action = function()
                local transitions = require("transitions")
                local particles = require("particles")
                transitions.changeGameState("menu", "fade")
                particles.clearVictoryParticles()
                menu.audio.playSound("buttonClick")
            end,
            x = 0, y = 0, w = 200, h = 50
        }
    }
    
    -- Initialize Game buttons (buttons that appear during gameplay)
    menu.gameButtons = {
        {
            text = "Menu",
            action = function()
                local transitions = require("transitions")
                local particles = require("particles")
                transitions.changeGameState("menu", "fade")
                particles.clearVictoryParticles()
                menu.audio.playSound("buttonClick")
            end,
            x = 0, y = 0, w = config.ui.buttonMinWidth, h = config.ui.buttonHeight
        }
    }
end

function menu.updateGameModeButtons()
    -- Force update of button selection states
end

function menu.updateBoardSizeButtons()
    -- Force update of button selection states
end

function menu.updateSoundButton()
    -- Force update of button text
end

function menu.updateMusicButton()
    -- Force update of button text
end

function menu.updateFullscreenButton()
    -- Force update of button text
end

function menu.toggleAISpeed()
    if menu.gameState.aiSpeed == "Fast" then
        menu.gameState.aiSpeed = "Normal"
    elseif menu.gameState.aiSpeed == "Normal" then
        menu.gameState.aiSpeed = "Slow"
    else
        menu.gameState.aiSpeed = "Fast"
    end
end

function menu.updateAISpeedButton()
    -- Force update of button text
end

function menu.toggleAIDifficulty()
    if menu.gameState.aiDifficulty == "Easy" then
        menu.gameState.aiDifficulty = "Medium"
    elseif menu.gameState.aiDifficulty == "Medium" then
        menu.gameState.aiDifficulty = "Hard"
    else
        menu.gameState.aiDifficulty = "Easy"
    end
end

function menu.updateAIDifficultyButton()
    -- Force update of button text
end

function menu.toggleFullscreen()
    menu.gameState.isFullscreen = not menu.gameState.isFullscreen
    if menu.gameState.isFullscreen then
        love.window.setFullscreen(true)
    else
        love.window.setFullscreen(false)
        love.window.setMode(menu.gameState.originalWindowWidth, menu.gameState.originalWindowHeight, {resizable = true})
    end
    
    -- Update window dimensions
    menu.gameState.windowWidth, menu.gameState.windowHeight = love.graphics.getDimensions()
    
    -- Mark as resizing to prevent animation during fullscreen transition
    menu.gameState.isResizing = true
    menu.gameState.resizeFrameCounter = 0
    menu.gameState.suspendAnimations = true
end

function menu.handleClick(x, y)
    -- Handle custom board size input
    if menu.gameState.isCustomSizeMode then
        local inputPos = config.getCustomInputPosition(menu.gameState.windowWidth, menu.gameState.windowHeight)
        local inputX = inputPos.x
        local inputY = inputPos.y
        local inputW = inputPos.w
        local inputH = inputPos.h
        
        if x >= inputX and x <= inputX + inputW and y >= inputY and y <= inputY + inputH then
            menu.gameState.customInputActive = true
            return true
        else
            menu.gameState.customInputActive = false
        end
    end
    
    -- Check button clicks
    for i, button in ipairs(menu.menuButtons) do
        if x >= button.x and x <= button.x + button.w and 
           y >= button.y and y <= button.y + button.h then
            button.action()
            return true
        end
    end
    
    return false
end

function menu.updateGameButtonPositions(windowWidth, windowHeight)
    -- Update positions for game buttons based on current window size
    if menu.gameButtons[1] then
        menu.gameButtons[1].x = config.ui.padding
        menu.gameButtons[1].y = windowHeight - config.ui.padding - config.ui.buttonHeight
        menu.gameButtons[1].w = config.ui.buttonMinWidth
        menu.gameButtons[1].h = config.ui.buttonHeight
    end
end

function menu.handleGameClick(x, y)
    -- Check button clicks for Game buttons (during gameplay)
    for i, button in ipairs(menu.gameButtons) do
        if x >= button.x and x <= button.x + button.w and 
           y >= button.y and y <= button.y + button.h then
            button.action()
            return true
        end
    end
    
    return false
end

function menu.handleGameOverClick(x, y)
    -- Check button clicks for Game Over buttons
    for i, button in ipairs(menu.gameOverButtons) do
        if x >= button.x and x <= button.x + button.w and 
           y >= button.y and y <= button.y + button.h then
            button.action()
            return true
        end
    end
    
    return false
end

return menu
