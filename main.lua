-- Tic-Tac-Toe Game in Lua with LÖVE2D (Modular Version)
-- Made by jaans21
-- Features responsive design that adapts to different screen sizes

-- Import all modules
local gameState = require("game_state")
local theme = require("theme")
local audio = require("audio")
local particles = require("particles")
local menu = require("menu")
local board = require("board")
local ai = require("ai")
local input = require("input")
local graphics = require("graphics")
local transitions = require("transitions")

function love.load()
    love.window.setTitle("Tic-Tac-Toe by jaans21")
    
    -- Get current window size (set by conf.lua)
    gameState.windowWidth, gameState.windowHeight = love.graphics.getDimensions()
    
    -- Performance optimizations for smoother resize
    love.graphics.setDefaultFilter("nearest", "nearest")  -- Faster filtering
    love.window.setVSync(1)  -- Enable VSync by default
    
    -- Store original window size
    gameState.originalWindowWidth = gameState.windowWidth
    gameState.originalWindowHeight = gameState.windowHeight
    
    -- Initialize all modules
    theme.init()
    audio.init()
    particles.init(gameState)
    graphics.init()
    
    -- Setup module dependencies
    menu.setup(gameState, theme, audio)
    board.setup(gameState, transitions)
    ai.setup(gameState, board)
    transitions.setup(gameState, particles)
    input.setup(gameState, menu, board, audio, particles, transitions, theme)
    graphics.setup(gameState, theme, menu, particles, transitions)
    
    -- Store audio reference in graphics for button state checks
    graphics.audio = audio
    
    -- Initialize game state
    gameState.initializeBoard()
end

function love.update(dt)
    -- Handle resize state management
    if gameState.isResizing then
        gameState.resizeFrameCounter = gameState.resizeFrameCounter + 1
        
        if gameState.resizeFrameCounter >= gameState.resizeFramesNeeded then
            -- Resume after waiting enough frames
            gameState.isResizing = false
            gameState.suspendAnimations = false
            
            -- Re-enable VSync after resize
            love.window.setVSync(1)
            
            -- Recalculate layout if in game
            if gameState.current == "playing" or gameState.current == "gameOver" then
                gameState.calculateBoardLayout()
            end
            
            -- Reinitialize particles with new window size
            particles.initParticles()
            
            print("Resize processing resumed")
        else
            -- Still waiting for stability, do minimal processing
            return
        end
    end
    
    -- Update theme transition
    theme.update(dt)
    
    -- Update particles
    particles.update(dt)
    
    -- Update transitions
    transitions.update(dt)
    
    -- Theme button hover detection
    local mx, my = love.mouse.getPosition()
    local config = require("settings")
    
    -- Make theme button detection responsive
    local scale = config.getScale(gameState.windowWidth, gameState.windowHeight)
    local themeButtonSize = math.max(30, config.ui.themeButtonSize * scale)
    local themeButtonMargin = math.max(15, config.ui.themeButtonMargin * scale)
    
    local themeButtonX = gameState.windowWidth - themeButtonSize - themeButtonMargin
    local themeButtonY = themeButtonMargin
    
    local isThemeHovered = mx >= themeButtonX and mx <= themeButtonX + themeButtonSize and
                          my >= themeButtonY and my <= themeButtonY + themeButtonSize
    
    local targetHover = isThemeHovered and 1 or 0
    theme.themeButtonHover = theme.themeButtonHover + (targetHover - theme.themeButtonHover) * dt * 10
    
    -- Reset hover states when not in menu
    if gameState.current ~= "menu" then
        audio.lastHoveredButton = nil
    end
    
    -- Reset game over hover states when not in gameOver
    if gameState.current ~= "gameOver" then
        audio.lastHoveredGameOverButton = nil
    end
    
    -- Reset game button hover states when not in playing
    if gameState.current ~= "playing" then
        audio.lastHoveredGameButton = nil
    end

    -- Update button animations
    if gameState.current == "menu" and not gameState.suspendAnimations then
        for i, anim in ipairs(particles.buttonAnimations) do
            local button = menu.menuButtons[i]
            if button and button.x and button.y and button.w and button.h then
                local isHovered = mx >= button.x and mx <= button.x + button.w and
                                my >= button.y and my <= button.y + button.h
                
                -- Play hover sound
                if isHovered and audio.lastHoveredButton ~= i then
                    audio.playSound("buttonHover")
                    audio.lastHoveredButton = i
                elseif not isHovered and audio.lastHoveredButton == i then
                    audio.lastHoveredButton = nil
                end
                
                local targetHover = isHovered and 1 or 0
                local targetGlow = (button.isSelected and button.isSelected()) and 1 or 0
                
                anim.hover = anim.hover + (targetHover - anim.hover) * dt * 8
                anim.glow = anim.glow + (targetGlow - anim.glow) * dt * 6
            end
        end
    end
    
    -- Game state specific updates
    if gameState.current == "playing" then
        -- Update piece animations
        for row = 1, gameState.boardSize do
            for col = 1, gameState.boardSize do
                local anim = gameState.pieceAnimations[row][col]
                if anim.active then
                    anim.time = anim.time + dt
                    if anim.time >= gameState.pieceAnimationDuration then
                        anim.active = false
                        anim.time = gameState.pieceAnimationDuration
                    end
                end
            end
        end
        
        -- Update winning line animation
        if gameState.winningLineAnimation.active then
            gameState.winningLineAnimation.time = gameState.winningLineAnimation.time + dt
            local progress = gameState.winningLineAnimation.time / gameState.winningLineAnimation.duration
            gameState.winningLineAnimation.intensity = math.sin(progress * math.pi * 4) * 0.5 + 0.5
            
            if gameState.winningLineAnimation.time >= gameState.winningLineAnimation.duration then
                gameState.winningLineAnimation.active = false
                gameState.winningLineAnimation.intensity = 0
            end
        end
        
        -- AI thinking and move execution
        if gameState.aiThinkingTime > 0 then
            gameState.aiThinkingTime = gameState.aiThinkingTime - dt
            if gameState.aiThinkingTime <= 0 then
                -- AI makes move
                local aiMove = ai.makeMove()
                if aiMove then
                    board.makeMove(aiMove.row, aiMove.col, audio, particles)
                end
            end
        end
        
        -- Update victory particle system
        if gameState.victoryParticleSystem.active then
            gameState.victoryParticleSystem.elapsed = gameState.victoryParticleSystem.elapsed + dt
            gameState.victoryParticleSystem.spawnTimer = gameState.victoryParticleSystem.spawnTimer + dt
            
            -- Spawn new victory particles
            if gameState.victoryParticleSystem.spawnTimer >= gameState.victoryParticleSystem.spawnRate then
                gameState.victoryParticleSystem.spawnTimer = 0
                local newParticle = particles.createVictoryParticle()
                table.insert(gameState.victoryParticles, newParticle)
            end
            
            -- Update existing victory particles
            for i = #gameState.victoryParticles, 1, -1 do
                local p = gameState.victoryParticles[i]
                
                -- Update position
                p.x = p.x + p.vx * dt
                p.y = p.y + p.vy * dt
                
                -- Apply gravity
                p.vy = p.vy + p.gravity * dt
                
                -- Update rotation
                p.rotation = p.rotation + p.rotationSpeed * dt
                
                -- Update life
                p.life = p.life - dt
                p.alpha = p.life / p.maxLife
                
                -- Bounce off edges
                if p.x < 0 or p.x > gameState.windowWidth then
                    p.vx = -p.vx * p.bounce
                    p.x = math.max(0, math.min(gameState.windowWidth, p.x))
                end
                
                if p.y > gameState.windowHeight then
                    p.vy = -math.abs(p.vy) * p.bounce
                    p.y = gameState.windowHeight
                end
                
                -- Remove dead particles
                if p.life <= 0 then
                    table.remove(gameState.victoryParticles, i)
                end
            end
            
            -- Stop victory particle system after duration
            if gameState.victoryParticleSystem.elapsed >= gameState.victoryParticleSystem.duration then
                gameState.victoryParticleSystem.active = false
            end
        end
    elseif gameState.current == "gameOver" then
    -- Game Over button hover detection
    if gameState.current == "gameOver" and not gameState.suspendAnimations then
        local mx, my = love.mouse.getPosition()
        
        for i, anim in ipairs(particles.gameOverButtonAnimations) do
            local button = menu.gameOverButtons[i]
            if button and button.x and button.y and button.w and button.h then
                local isHovered = mx >= button.x and mx <= button.x + button.w and
                                my >= button.y and my <= button.y + button.h
                
                -- Play hover sound
                if isHovered and audio.lastHoveredGameOverButton ~= i then
                    audio.playSound("buttonHover")
                    audio.lastHoveredGameOverButton = i
                elseif not isHovered and audio.lastHoveredGameOverButton == i then
                    audio.lastHoveredGameOverButton = nil
                end
                
                local targetHover = isHovered and 1 or 0
                
                anim.hover = anim.hover + (targetHover - anim.hover) * dt * 8
                anim.glow = anim.glow + (0 - anim.glow) * dt * 6  -- No glow for Game Over buttons
            end
        end
    end
    
    -- Game button hover detection (during gameplay)
    if gameState.current == "playing" and not gameState.suspendAnimations then
        local mx, my = love.mouse.getPosition()
        
        -- Ensure game button coordinates are set correctly
        if menu.gameButtons[1] then
            menu.gameButtons[1].x = 20
            menu.gameButtons[1].y = gameState.windowHeight - 60
            menu.gameButtons[1].w = 120
            menu.gameButtons[1].h = 40
        end
        
        for i, button in ipairs(menu.gameButtons) do
            -- Ensure animation exists
            if not particles.gameButtonAnimations[i] then
                particles.gameButtonAnimations[i] = {scale = 1, hover = 0, glow = 0}
            end
            
            local anim = particles.gameButtonAnimations[i]
            
            if button then
                local isHovered = mx >= button.x and mx <= button.x + button.w and
                                my >= button.y and my <= button.y + button.h
                
                -- Only print when hovering changes
                if isHovered and audio.lastHoveredGameButton ~= i then
                    print("HOVER START on button", i)
                    audio.playSound("buttonHover")
                    audio.lastHoveredGameButton = i
                elseif not isHovered and audio.lastHoveredGameButton == i then
                    print("HOVER END on button", i)
                    audio.lastHoveredGameButton = nil
                end
                
                local targetHover = isHovered and 1 or 0
                
                anim.hover = anim.hover + (targetHover - anim.hover) * dt * 8
                anim.glow = anim.glow + (0 - anim.glow) * dt * 6  -- No glow for game buttons
            end
        end
    end
    end
end

function love.draw()
    graphics.draw()
end

function love.mousepressed(x, y, button)
    if button == 1 and not transitions.transition.active then  -- Left click, only when not transitioning
        -- Handle theme button click
        if gameState.current == "menu" then
            local themeButtonSize = 40
            local themeButtonX = gameState.windowWidth - themeButtonSize - 20
            local themeButtonY = 20
            
            if x >= themeButtonX and x <= themeButtonX + themeButtonSize and
               y >= themeButtonY and y <= themeButtonY + themeButtonSize then
                theme.toggle()
                audio.playSound("buttonClick")
                return
            end
        end
        
        input.mousepressed(x, y, button)
    end
end

function love.keypressed(key)
    -- Theme toggle shortcut
    if key == "t" then
        theme.toggle()
        audio.playSound("buttonClick")
        return
    end
    
    input.keypressed(key)
end

function love.resize(w, h)
    input.resize(w, h)
end

-- Additional LÖVE callbacks can be added here as needed
