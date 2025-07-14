-- Input Handling Module
-- Made by jaans21

local config = require("settings")
local input = {}

function input.setup(gameState, menu, board, audio, particles, transitions, theme)
    input.gameState = gameState
    input.menu = menu
    input.board = board
    input.audio = audio
    input.particles = particles
    input.transitions = transitions
    input.theme = theme
end

function input.mousepressed(x, y, button)
    if button == 1 then  -- Left mouse button
        if input.gameState.current == "menu" then
            input.handleMenuClick(x, y)
        elseif input.gameState.current == "playing" then
            input.handleGameClick(x, y)
        elseif input.gameState.current == "gameOver" then
            input.handleGameOverClick(x, y)
        end
    end
end

function input.handleMenuClick(x, y)
    input.menu.handleClick(x, y)
end

function input.handleGameClick(x, y)
    -- Check for menu button click first
    if input.menu.handleGameClick(x, y) then
        return
    end
    
    if input.gameState.gameOver then
        return
    end
    
    -- Calculate which cell was clicked
    local col = math.floor((x - input.gameState.boardOffsetX) / input.gameState.cellSize) + 1
    local row = math.floor((y - input.gameState.boardOffsetY) / input.gameState.cellSize) + 1
    
    -- Check if click is within board bounds
    if row >= 1 and row <= input.gameState.boardSize and col >= 1 and col <= input.gameState.boardSize then
        -- Only allow human moves (player 1) or both players in human vs human mode
        if input.gameState.gameMode == "human" or input.gameState.currentPlayer == 1 then
            input.board.makeMove(row, col, input.audio, input.particles)
        end
    end
end

function input.handleGameOverClick(x, y)
    return input.menu.handleGameOverClick(x, y)
end

function input.keypressed(key)
    -- Use config shortcuts for consistent key mapping
    if key == config.input.shortcuts.quit then
        if input.gameState.current == "playing" or input.gameState.current == "gameOver" then
            input.transitions.changeGameState("menu", "fade")
            input.particles.clearVictoryParticles()
        else
            love.event.quit()
        end
    elseif key == config.input.shortcuts.toggleFullscreen or key == "return" and love.keyboard.isDown("lalt") then
        input.menu.toggleFullscreen()
    elseif key == config.input.shortcuts.restart and input.gameState.current == "gameOver" then
        input.gameState.startGame()
        input.audio.playSound("buttonClick")
    elseif key == config.input.shortcuts.newGame and input.gameState.current == "menu" then
        input.gameState.startGame()
        input.audio.playSound("buttonClick")
    elseif key == config.input.shortcuts.toggleTheme then
        input.theme.toggle()
    elseif key == config.input.shortcuts.toggleSound then
        input.audio.toggleSound()
        input.audio.playSound("buttonClick")
    elseif key == config.input.shortcuts.toggleMusic then
        input.audio.toggleMusic()
        input.audio.playSound("buttonClick")
    end
    
    -- Handle custom board size input
    if input.gameState.current == "menu" and input.gameState.customInputActive then
        if key == "backspace" then
            input.gameState.customInputText = string.sub(input.gameState.customInputText, 1, -2)
        elseif key == "return" or key == "kpenter" then
            local inputText = input.gameState.customInputText
            local size
            
            if inputText == "" then
                -- If no input, use the default custom size
                size = input.gameState.customBoardSize
            else
                size = tonumber(inputText)
            end
            
            if size and size >= 3 and size <= 15 then
                input.gameState.customBoardSize = size
                input.gameState.boardSize = size
                input.gameState.customInputActive = false
                input.audio.playSound("buttonClick")
            end
        elseif string.match(key, "[0-9]") and string.len(input.gameState.customInputText) < 3 then
            input.gameState.customInputText = input.gameState.customInputText .. key
        end
    end
end

function input.resize(w, h)
    input.gameState.windowWidth = w
    input.gameState.windowHeight = h
    
    -- Update fonts for new size
    if graphics and graphics.updateFontsForSize then
        graphics.updateFontsForSize()
    end
    
    -- Recalculate board layout if in game
    if input.gameState.current == "playing" or input.gameState.current == "gameOver" then
        input.gameState.calculateBoardLayout()
    end
    
    -- Mark as resizing to prevent animation glitches
    input.gameState.isResizing = true
    input.gameState.resizeFrameCounter = 0
    input.gameState.suspendAnimations = true
end

return input
