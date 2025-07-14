-- Graphics and Drawing Module
-- Made by jaans21

local config = require("settings")
local graphics = {}

-- Fonts
graphics.font = nil
graphics.titleFont = nil
graphics.buttonFont = nil
graphics.smallFont = nil
graphics.largeFont = nil

function graphics.init()
    -- Load fonts using config
    graphics.font = love.graphics.newFont(config.graphics.fonts.normal)
    graphics.titleFont = love.graphics.newFont(config.graphics.fonts.title)
    graphics.buttonFont = love.graphics.newFont(config.graphics.fonts.button)
    graphics.smallFont = love.graphics.newFont(config.graphics.fonts.small)
    graphics.largeFont = love.graphics.newFont(config.graphics.fonts.large)
end

function graphics.updateFontsForSize()
    if not graphics.gameState then return end
    
    local scale = config.getScale(graphics.gameState.windowWidth, graphics.gameState.windowHeight)
    
    -- Update fonts with responsive sizes
    local titleSize = math.max(24, math.floor(config.graphics.fonts.title * scale))
    local normalSize = math.max(14, math.floor(config.graphics.fonts.normal * scale))
    local buttonSize = math.max(12, math.floor(config.graphics.fonts.button * scale))
    local smallSize = math.max(10, math.floor(config.graphics.fonts.small * scale))
    local largeSize = math.max(18, math.floor(config.graphics.fonts.large * scale))
    
    graphics.titleFont = love.graphics.newFont(titleSize)
    graphics.font = love.graphics.newFont(normalSize)
    graphics.buttonFont = love.graphics.newFont(buttonSize)
    graphics.smallFont = love.graphics.newFont(smallSize)
    graphics.largeFont = love.graphics.newFont(largeSize)
end

function graphics.setup(gameState, theme, menu, particles, transitions)
    graphics.gameState = gameState
    graphics.theme = theme
    graphics.menu = menu
    graphics.particles = particles
    graphics.transitions = transitions
end

function graphics.draw()
    -- ULTRA MINIMAL drawing during resize - absolute minimum operations
    if graphics.gameState.isResizing or graphics.gameState.suspendAnimations then
        love.graphics.clear(0.05, 0.05, 0.1, 1)  -- Just clear with dark blue
        return  -- Exit immediately - NO text, NO calculations, NO graphics calls
    end
    
    love.graphics.setBackgroundColor(graphics.theme.colors.background)
    
    if graphics.gameState.current == "menu" then
        graphics.drawMenu()
    elseif graphics.gameState.current == "playing" then
        graphics.drawGame()
    elseif graphics.gameState.current == "gameOver" then
        graphics.drawGameOver()
    end
    
    -- Draw transition effect
    graphics.transitions.draw()
end

function graphics.drawMenu()
    -- Animated background
    graphics.drawAnimatedBackground()
    
    -- Draw particles
    graphics.particles.draw()
    
    -- Draw victory particles (if any are still active)
    graphics.drawVictoryParticles()
    
    -- Main title with glow effect
    graphics.drawTitleWithGlow()
    
    -- Draw theme toggle button
    graphics.drawThemeButton()
    
    -- Game mode selection
    graphics.drawGameModeSection()
    
    -- Board size selection
    graphics.drawBoardSizeSection()
    
    -- Footer
    graphics.drawFooter()
end

function graphics.drawAnimatedBackground()
    love.graphics.setColor(graphics.theme.colors.menuBackground)
    love.graphics.rectangle("fill", 0, 0, graphics.gameState.windowWidth, graphics.gameState.windowHeight)
end

function graphics.drawTitleWithGlow()
    love.graphics.setFont(graphics.titleFont)
    
    -- Calculate responsive positions
    local scale = config.getScale(graphics.gameState.windowWidth, graphics.gameState.windowHeight)
    local titleY = math.max(20, config.ui.titleY * scale)
    local subtitleY = math.max(60, config.ui.subtitleY * scale)
    
    -- Skip glow effect if animations are suspended
    if not graphics.gameState.suspendAnimations then
        -- Title shadow/glow using config shadow offset
        for i = 1, 3 do
            love.graphics.setColor(graphics.theme.colors.accent[1], graphics.theme.colors.accent[2], graphics.theme.colors.accent[3], 0.3 - i * 0.1)
            love.graphics.printf("TIC-TAC-TOE", -i, titleY - i, graphics.gameState.windowWidth, "center")
            love.graphics.printf("TIC-TAC-TOE", i, titleY + i, graphics.gameState.windowWidth, "center")
        end
    end
    
    -- Main title (always draw)
    love.graphics.setColor(graphics.theme.colors.text)
    love.graphics.printf("TIC-TAC-TOE", 0, titleY, graphics.gameState.windowWidth, "center")
    
    -- Subtitle with accent
    love.graphics.setFont(graphics.font)
    love.graphics.setColor(graphics.theme.colors.accent)
    love.graphics.printf("Made by jaans21", 0, subtitleY, graphics.gameState.windowWidth, "center")
end

function graphics.drawGameModeSection()
    -- Section title
    love.graphics.setFont(graphics.largeFont)
    love.graphics.setColor(graphics.theme.colors.text)
    
    -- Calculate responsive positions
    local scale = config.getScale(graphics.gameState.windowWidth, graphics.gameState.windowHeight)
    local gameModeY = math.max(120, config.ui.gameModeY * scale)
    local gameModeButtonsY = math.max(150, config.ui.gameModeButtonsY * scale)
    
    love.graphics.printf("Game Mode", 0, gameModeY, graphics.gameState.windowWidth, "center")
    
    -- Mode buttons using responsive card width
    local cardWidth = math.max(120, config.ui.cardWidth * scale)
    local spacing = math.max(10, 20 * scale)
    local startX = graphics.gameState.windowWidth/2 - cardWidth - spacing/2
    
    graphics.drawModernButton(graphics.menu.menuButtons[2], startX, gameModeButtonsY, 2)
    graphics.drawModernButton(graphics.menu.menuButtons[3], startX + cardWidth + spacing, gameModeButtonsY, 3)
end

function graphics.drawBoardSizeSection()
    -- Section title
    love.graphics.setFont(graphics.largeFont)
    love.graphics.setColor(graphics.theme.colors.text)
    
    -- Calculate responsive positions
    local scale = config.getScale(graphics.gameState.windowWidth, graphics.gameState.windowHeight)
    local boardSizeY = math.max(200, config.ui.boardSizeY * scale)
    local boardSizeButtonsY1 = math.max(230, config.ui.boardSizeButtonsY1 * scale)
    local boardSizeButtonsY2 = math.max(290, config.ui.boardSizeButtonsY2 * scale)
    
    love.graphics.printf("Board Size", 0, boardSizeY, graphics.gameState.windowWidth, "center")
    
    -- Size buttons in grid using responsive card width
    local cardWidth = math.max(120, config.ui.cardWidth * scale)
    local cardHeight = math.max(40, config.ui.cardHeight * scale)
    local spacing = math.max(10, 20 * scale)
    local startX = graphics.gameState.windowWidth/2 - cardWidth - spacing/2
    
    graphics.drawModernButton(graphics.menu.menuButtons[4], startX, boardSizeButtonsY1, 4)
    graphics.drawModernButton(graphics.menu.menuButtons[5], startX + cardWidth + spacing, boardSizeButtonsY1, 5)
    graphics.drawModernButton(graphics.menu.menuButtons[6], startX, boardSizeButtonsY2, 6)
    graphics.drawModernButton(graphics.menu.menuButtons[7], startX + cardWidth + spacing, boardSizeButtonsY2, 7)
    
    -- Start Game button (centered)
    local padding = math.max(15, config.ui.padding * scale)
    local startGameY = boardSizeButtonsY2 + cardHeight + padding
    local startGameX = graphics.gameState.windowWidth/2 - cardWidth/2
    graphics.drawModernButton(graphics.menu.menuButtons[1], startGameX, startGameY, 1)
    
    -- Custom size input (only show if custom is selected)
    if graphics.gameState.isCustomSizeMode then
        graphics.drawCustomSizeInput()
    end
    
    -- Audio controls section
    love.graphics.setFont(graphics.largeFont)
    love.graphics.setColor(graphics.theme.colors.text)
    
    local audioSectionY = startGameY + cardHeight + padding * 2
    if graphics.gameState.isCustomSizeMode then
        audioSectionY = audioSectionY + 60  -- Add space for custom input
    end
    
    love.graphics.printf("Settings", 0, audioSectionY, graphics.gameState.windowWidth, "center")
    
    -- First row: Sound and Music buttons
    local sectionSpacing = math.max(30, config.ui.sectionSpacing * scale)
    local buttonSpacing = math.max(10, config.ui.buttonSpacing * scale)
    local audioButtonY = audioSectionY + sectionSpacing
    local soundButtonX = graphics.gameState.windowWidth/2 - cardWidth - buttonSpacing/2
    local musicButtonX = graphics.gameState.windowWidth/2 + buttonSpacing/2
    
    graphics.drawModernButton(graphics.menu.menuButtons[8], soundButtonX, audioButtonY, 8)
    graphics.drawModernButton(graphics.menu.menuButtons[9], musicButtonX, audioButtonY, 9)
    
    -- Second row: AI Level and AI Speed buttons
    local secondRowY = audioButtonY + cardHeight + buttonSpacing
    graphics.drawModernButton(graphics.menu.menuButtons[12], soundButtonX, secondRowY, 12)
    graphics.drawModernButton(graphics.menu.menuButtons[11], musicButtonX, secondRowY, 11)
    
    -- Third row: Fullscreen button (centered)
    local thirdRowY = secondRowY + cardHeight + buttonSpacing
    local fullscreenButtonX = graphics.gameState.windowWidth/2 - cardWidth/2
    graphics.drawModernButton(graphics.menu.menuButtons[10], fullscreenButtonX, thirdRowY, 10)
end

function graphics.drawFooter()
    love.graphics.setFont(graphics.font)
    love.graphics.setColor(graphics.theme.colors.textSecondary)
    local footerY = graphics.gameState.isCustomSizeMode and graphics.gameState.windowHeight - config.ui.footerMarginBottom or graphics.gameState.windowHeight - 50
    love.graphics.printf("Select your preferences and start playing! Adjust AI speed and difficulty. Click moon/sun to toggle theme.", 0, footerY, graphics.gameState.windowWidth, "center")
end

function graphics.drawCard(x, y, w, h)
    -- Card shadow using config shadow offset
    love.graphics.setColor(graphics.theme.colors.shadow)
    love.graphics.rectangle("fill", x + config.graphics.shadowOffset, y + config.graphics.shadowOffset, w, h)
    
    -- Card background
    love.graphics.setColor(graphics.theme.colors.cardBackground)
    love.graphics.rectangle("fill", x, y, w, h)
    
    -- Card border
    love.graphics.setColor(graphics.theme.colors.cardBorder)
    love.graphics.setLineWidth(config.graphics.lineWidths.thin)
    love.graphics.rectangle("line", x, y, w, h)
end

function graphics.drawModernButton(button, x, y, index)
    if not button then return end
    
    local anim = graphics.particles.buttonAnimations[index] or {scale = 1, hover = 0, glow = 0}
    
    -- Calculate responsive dimensions
    local scale = config.getScale(graphics.gameState.windowWidth, graphics.gameState.windowHeight)
    local w = math.max(100, config.ui.cardWidth * scale)
    local h = math.max(35, config.ui.cardHeight * scale)
    
    -- Get button text (could be a function)
    local buttonText = button.text
    if type(buttonText) == "function" then
        buttonText = buttonText()
    end
    
    -- Check button types
    local isAudioButton = (index == 8 or index == 9)
    local isDisplayButton = (index == 10)
    local isAISpeedButton = (index == 11)
    local isAIDifficultyButton = (index == 12)
    local isSelected = button.isSelected and button.isSelected() or false
    
    local isAudioOn = false
    if index == 8 then
        isAudioOn = graphics.audio and graphics.audio.soundEnabled
    elseif index == 9 then
        isAudioOn = graphics.audio and graphics.audio.musicEnabled
    end
    
    -- Button shadow using config shadow offset
    love.graphics.setColor(graphics.theme.colors.shadow)
    love.graphics.rectangle("fill", x + config.graphics.shadowOffset, y + config.graphics.shadowOffset, w, h)
    
    -- Button background - special colors for different button types
    if isAudioButton then
        local hoverFactor = anim.hover
        if isAudioOn then
            love.graphics.setColor(
                graphics.theme.colors.audioButtonOn[1] + (graphics.theme.colors.audioButtonHoverOn[1] - graphics.theme.colors.audioButtonOn[1]) * hoverFactor,
                graphics.theme.colors.audioButtonOn[2] + (graphics.theme.colors.audioButtonHoverOn[2] - graphics.theme.colors.audioButtonOn[2]) * hoverFactor,
                graphics.theme.colors.audioButtonOn[3] + (graphics.theme.colors.audioButtonHoverOn[3] - graphics.theme.colors.audioButtonOn[3]) * hoverFactor
            )
        else
            love.graphics.setColor(
                graphics.theme.colors.audioButtonOff[1] + (graphics.theme.colors.audioButtonHoverOff[1] - graphics.theme.colors.audioButtonOff[1]) * hoverFactor,
                graphics.theme.colors.audioButtonOff[2] + (graphics.theme.colors.audioButtonHoverOff[2] - graphics.theme.colors.audioButtonOff[2]) * hoverFactor,
                graphics.theme.colors.audioButtonOff[3] + (graphics.theme.colors.audioButtonHoverOff[3] - graphics.theme.colors.audioButtonOff[3]) * hoverFactor
            )
        end
    elseif isAISpeedButton then
        local hoverFactor = anim.hover
        local speedColors = {
            Fast = {0.9, 0.3, 0.3},     -- Red for fast
            Normal = {0.3, 0.7, 0.9},   -- Blue for normal  
            Slow = {0.3, 0.9, 0.3}      -- Green for slow
        }
        local baseColor = speedColors[graphics.gameState.aiSpeed]
        love.graphics.setColor(
            baseColor[1] * (0.8 + hoverFactor * 0.2),
            baseColor[2] * (0.8 + hoverFactor * 0.2),
            baseColor[3] * (0.8 + hoverFactor * 0.2)
        )
    elseif isAIDifficultyButton then
        local hoverFactor = anim.hover
        local difficultyColors = {
            Easy = {0.3, 0.9, 0.3},     -- Green for easy
            Medium = {0.9, 0.7, 0.3},   -- Orange for medium  
            Hard = {0.9, 0.3, 0.3}      -- Red for hard
        }
        local baseColor = difficultyColors[graphics.gameState.aiDifficulty]
        love.graphics.setColor(
            baseColor[1] * (0.8 + hoverFactor * 0.2),
            baseColor[2] * (0.8 + hoverFactor * 0.2),
            baseColor[3] * (0.8 + hoverFactor * 0.2)
        )
    elseif isSelected then
        love.graphics.setColor(graphics.theme.colors.buttonSelected[1], graphics.theme.colors.buttonSelected[2], graphics.theme.colors.buttonSelected[3], 0.9)
    else
        local hoverFactor = anim.hover
        love.graphics.setColor(
            graphics.theme.colors.buttonNormal[1] + (graphics.theme.colors.buttonHover[1] - graphics.theme.colors.buttonNormal[1]) * hoverFactor,
            graphics.theme.colors.buttonNormal[2] + (graphics.theme.colors.buttonHover[2] - graphics.theme.colors.buttonNormal[2]) * hoverFactor,
            graphics.theme.colors.buttonNormal[3] + (graphics.theme.colors.buttonHover[3] - graphics.theme.colors.buttonNormal[3]) * hoverFactor
        )
    end
    
    love.graphics.rectangle("fill", x, y, w, h)
    
    -- Button border
    if isSelected then
        love.graphics.setLineWidth(config.graphics.lineWidths.normal)
        love.graphics.setColor(graphics.theme.colors.accent[1], graphics.theme.colors.accent[2], graphics.theme.colors.accent[3], anim.glow)
    elseif isAudioButton then
        love.graphics.setLineWidth(config.graphics.lineWidths.normal)
        if isAudioOn then
            love.graphics.setColor(graphics.theme.colors.audioButtonHoverOn)
        else
            love.graphics.setColor(graphics.theme.colors.audioButtonHoverOff)
        end
    elseif isAISpeedButton then
        love.graphics.setLineWidth(config.graphics.lineWidths.normal)
        local speedColors = {
            Fast = {1, 0.4, 0.4},     -- Bright red border for fast
            Normal = {0.4, 0.8, 1},   -- Bright blue border for normal  
            Slow = {0.4, 1, 0.4}      -- Bright green border for slow
        }
        local borderColor = speedColors[graphics.gameState.aiSpeed]
        love.graphics.setColor(borderColor[1], borderColor[2], borderColor[3], 0.9)
    elseif isAIDifficultyButton then
        love.graphics.setLineWidth(config.graphics.lineWidths.normal)
        local difficultyColors = {
            Easy = {0.4, 1, 0.4},     -- Bright green border for easy
            Medium = {1, 0.8, 0.4},   -- Bright orange border for medium  
            Hard = {1, 0.4, 0.4}      -- Bright red border for hard
        }
        local borderColor = difficultyColors[graphics.gameState.aiDifficulty]
        love.graphics.setColor(borderColor[1], borderColor[2], borderColor[3], 0.9)
    elseif isDisplayButton then
        love.graphics.setLineWidth(config.graphics.lineWidths.normal)
        love.graphics.setColor(graphics.theme.colors.accent[1], graphics.theme.colors.accent[2], graphics.theme.colors.accent[3], 0.8)
    else
        love.graphics.setLineWidth(config.graphics.lineWidths.thin)
        love.graphics.setColor(graphics.theme.colors.cardBorder)
    end
    love.graphics.rectangle("line", x, y, w, h)
    
    -- Selection indicator
    if isSelected then
        love.graphics.setColor(graphics.theme.colors.accent)
        love.graphics.circle("fill", x + w - 15, y + 15, 6)
        love.graphics.setColor(graphics.theme.colors.text)
        love.graphics.circle("fill", x + w - 15, y + 15, 3)
    end
    
    -- Button text
    love.graphics.setFont(graphics.buttonFont)
    love.graphics.setColor(graphics.theme.colors.text)
    love.graphics.printf(buttonText, x, y + h/2 - 10, w, "center")
    
    -- Store button position for click detection
    button.x = x
    button.y = y
    button.w = w
    button.h = h
end

function graphics.drawCustomSizeInput()
    local inputPos = config.getCustomInputPosition(graphics.gameState.windowWidth, graphics.gameState.windowHeight)
    local inputX = inputPos.x
    local inputY = inputPos.y
    local inputW = inputPos.w
    local inputH = inputPos.h
    
    -- Custom size label
    love.graphics.setFont(graphics.buttonFont)
    love.graphics.setColor(graphics.theme.colors.text)
    love.graphics.printf("Custom Size:", inputX, inputY - 25, inputW, "center")
    
    -- Input field background
    if graphics.gameState.customInputActive then
        love.graphics.setColor(graphics.theme.colors.buttonSelected)
    else
        love.graphics.setColor(graphics.theme.colors.buttonNormal)
    end
    love.graphics.rectangle("fill", inputX, inputY, inputW, inputH)
    
    -- Input field border
    if graphics.gameState.customInputActive then
        love.graphics.setLineWidth(config.graphics.lineWidths.normal)
        love.graphics.setColor(graphics.theme.colors.buttonSelectedHover)
    else
        love.graphics.setLineWidth(config.graphics.lineWidths.thin)
        love.graphics.setColor(graphics.theme.colors.text)
    end
    love.graphics.rectangle("line", inputX, inputY, inputW, inputH)
    
    -- Input text - show current custom size
    love.graphics.setColor(graphics.theme.colors.text)
    local displayText
    if graphics.gameState.customInputActive then
        local inputText = graphics.gameState.customInputText
        if inputText == "" then
            displayText = graphics.gameState.customBoardSize .. "×" .. graphics.gameState.customBoardSize .. "_"
        else
            displayText = inputText .. "×" .. inputText .. "_"
        end
    else
        displayText = graphics.gameState.customBoardSize .. "×" .. graphics.gameState.customBoardSize
    end
    love.graphics.printf(displayText, inputX, inputY + 10, inputW, "center")
    
    -- Size range hint
    love.graphics.setFont(graphics.smallFont)
    love.graphics.setColor(0.7, 0.7, 0.7)
    love.graphics.printf("(" .. config.game.minBoardSize .. "-" .. config.game.maxBoardSize .. ")", inputX, inputY + 45, inputW, "center")
end

function graphics.drawGame()
    -- Game information with responsive positioning
    love.graphics.setColor(graphics.theme.colors.text)
    love.graphics.setFont(graphics.font)
    
    local scale = config.getScale(graphics.gameState.windowWidth, graphics.gameState.windowHeight)
    local topMargin = math.max(10, 20 * scale)
    local infoSpacing = math.max(20, 30 * scale)
    
    local modeText = graphics.gameState.gameMode == "human" and "Human vs Human" or "Human vs AI"
    love.graphics.printf(modeText, 0, topMargin, graphics.gameState.windowWidth, "center")
    
    if not graphics.gameState.gameOver then
        if graphics.gameState.aiThinkingTime > 0 then
            love.graphics.setColor(graphics.theme.colors.playerO)
            love.graphics.printf("AI thinking...", 0, topMargin + infoSpacing, graphics.gameState.windowWidth, "center")
        else
            local playerText = graphics.gameState.currentPlayer == 1 and "Turn: X" or "Turn: O"
            love.graphics.printf(playerText, 0, topMargin + infoSpacing, graphics.gameState.windowWidth, "center")
        end
    end
    
    -- Draw board
    graphics.drawBoard()
    
    -- Draw pieces
    graphics.drawPieces()
    
    -- Draw victory particles
    graphics.drawVictoryParticles()
    
    -- Back to menu button using responsive sizing
    local buttonWidth = math.max(80, 120 * scale)
    local buttonHeight = math.max(30, 40 * scale)
    local margin = math.max(10, 20 * scale)
    
    local menuButtonX = margin
    local menuButtonY = graphics.gameState.windowHeight - buttonHeight - margin
    
    -- Update button coordinates before drawing to ensure consistency
    if graphics.menu.gameButtons[1] then
        graphics.menu.gameButtons[1].x = menuButtonX
        graphics.menu.gameButtons[1].y = menuButtonY
        graphics.menu.gameButtons[1].w = buttonWidth
        graphics.menu.gameButtons[1].h = buttonHeight
    end
    
    graphics.drawGameButton(graphics.menu.gameButtons[1], menuButtonX, menuButtonY, 1)
end

function graphics.drawBoard()
    love.graphics.setColor(graphics.theme.colors.grid)
    love.graphics.setLineWidth(config.graphics.lineWidths.thick)
    
    -- Vertical lines
    for i = 1, graphics.gameState.boardSize - 1 do
        local x = graphics.gameState.boardOffsetX + i * graphics.gameState.cellSize
        love.graphics.line(x, graphics.gameState.boardOffsetY, x, graphics.gameState.boardOffsetY + graphics.gameState.boardSize * graphics.gameState.cellSize)
    end
    
    -- Horizontal lines
    for i = 1, graphics.gameState.boardSize - 1 do
        local y = graphics.gameState.boardOffsetY + i * graphics.gameState.cellSize
        love.graphics.line(graphics.gameState.boardOffsetX, y, graphics.gameState.boardOffsetX + graphics.gameState.boardSize * graphics.gameState.cellSize, y)
    end
    
    -- Board border
    love.graphics.rectangle("line", graphics.gameState.boardOffsetX, graphics.gameState.boardOffsetY, graphics.gameState.boardSize * graphics.gameState.cellSize, graphics.gameState.boardSize * graphics.gameState.cellSize)
end

function graphics.drawPieces()
    -- Make line width responsive - slightly thicker on smaller screens for better visibility
    local baseLineWidth = config.graphics.lineWidths.piece
    if config.isSmallScreen(graphics.gameState.windowWidth, graphics.gameState.windowHeight) then
        baseLineWidth = baseLineWidth + 1
    end
    love.graphics.setLineWidth(baseLineWidth)
    
    for i = 1, graphics.gameState.boardSize do
        for j = 1, graphics.gameState.boardSize do
            local x = graphics.gameState.boardOffsetX + (j - 1) * graphics.gameState.cellSize
            local y = graphics.gameState.boardOffsetY + (i - 1) * graphics.gameState.cellSize
            local centerX = x + graphics.gameState.cellSize / 2
            local centerY = y + graphics.gameState.cellSize / 2
            local margin = graphics.gameState.cellSize * config.graphics.cellMarginPercent
            
            -- Check if this cell is part of the winning line
            local isWinningCell = false
            if graphics.gameState.winningLineAnimation.active then
                for _, cell in ipairs(graphics.gameState.winningLine) do
                    if cell[1] == i and cell[2] == j then
                        isWinningCell = true
                        break
                    end
                end
            end
            
            -- Draw winning cell highlight background
            if isWinningCell and graphics.gameState.winningLineAnimation.intensity > 0 then
                local highlightAlpha = graphics.gameState.winningLineAnimation.intensity * 0.6  -- Max 60% alpha
                love.graphics.setColor(1, 1, 0, highlightAlpha)  -- Yellow highlight
                love.graphics.rectangle("fill", x + 2, y + 2, graphics.gameState.cellSize - 4, graphics.gameState.cellSize - 4)
                
                -- Add a pulsing border
                love.graphics.setColor(1, 1, 0, graphics.gameState.winningLineAnimation.intensity * 0.8)
                love.graphics.setLineWidth(config.graphics.lineWidths.thick)
                love.graphics.rectangle("line", x + 2, y + 2, graphics.gameState.cellSize - 4, graphics.gameState.cellSize - 4)
            end
            
            if graphics.gameState.board[i][j] ~= 0 then
                -- Get animation progress
                local animData = graphics.gameState.pieceAnimations[i][j]
                local scale = 1
                if animData.active then
                    -- Simple scale animation from 0 to 1
                    local progress = math.min(1, animData.time / config.game.pieceAnimationDuration)
                    scale = math.sin(progress * math.pi) -- Smooth scale up
                end
                
                -- Only draw if scale > 0
                if scale > 0 then
                    love.graphics.push()
                    love.graphics.translate(centerX, centerY)
                    love.graphics.scale(scale, scale)
                    love.graphics.translate(-centerX, -centerY)
                    
                    -- Set piece color with potential highlight effect
                    local baseColor = graphics.gameState.board[i][j] == 1 and graphics.theme.colors.playerX or graphics.theme.colors.playerO
                    if isWinningCell and graphics.gameState.winningLineAnimation.intensity > 0 then
                        -- Brighten the winning pieces
                        local brightness = 1 + graphics.gameState.winningLineAnimation.intensity * 0.3
                        love.graphics.setColor(
                            math.min(1, baseColor[1] * brightness),
                            math.min(1, baseColor[2] * brightness),
                            math.min(1, baseColor[3] * brightness)
                        )
                    else
                        love.graphics.setColor(baseColor)
                    end
                    
                    love.graphics.setLineWidth(config.graphics.lineWidths.piece)
                    if graphics.gameState.board[i][j] == 1 then
                        -- Draw X
                        love.graphics.line(x + margin, y + margin, x + graphics.gameState.cellSize - margin, y + graphics.gameState.cellSize - margin)
                        love.graphics.line(x + margin, y + graphics.gameState.cellSize - margin, x + graphics.gameState.cellSize - margin, y + margin)
                    elseif graphics.gameState.board[i][j] == 2 then
                        -- Draw O
                        love.graphics.circle("line", centerX, centerY, graphics.gameState.cellSize / 2 - margin)
                    end
                    
                    love.graphics.pop()
                end
            end
        end
    end
end

function graphics.drawGameOver()
    graphics.drawGame()
    
    -- Overlay
    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle("fill", 0, 0, graphics.gameState.windowWidth, graphics.gameState.windowHeight)
    
    -- Game over message with responsive positioning
    love.graphics.setColor(graphics.theme.colors.text)
    love.graphics.setFont(graphics.titleFont)
    
    local scale = config.getScale(graphics.gameState.windowWidth, graphics.gameState.windowHeight)
    local messageOffset = math.max(60, 100 * scale)
    
    local message = ""
    if graphics.gameState.winner == 1 then
        message = "X Wins!"
        love.graphics.setColor(graphics.theme.colors.playerX)
    elseif graphics.gameState.winner == 2 then
        message = "O Wins!"
        love.graphics.setColor(graphics.theme.colors.playerO)
    else
        message = "It's a Tie!"
        love.graphics.setColor(graphics.theme.colors.tie)
    end
    
    love.graphics.printf(message, 0, graphics.gameState.windowHeight/2 - messageOffset, graphics.gameState.windowWidth, "center")
    
    -- Buttons with responsive sizing
    local buttonWidth = math.max(120, 200 * scale)
    local buttonHeight = math.max(40, 50 * scale)
    local buttonSpacing = math.max(40, 70 * scale)
    
    local buttonX = graphics.gameState.windowWidth/2 - buttonWidth/2
    local playAgainY = graphics.gameState.windowHeight/2 - 10
    local mainMenuY = playAgainY + buttonHeight + math.max(10, 20 * scale)
    
    -- Update button coordinates for proper mouse detection
    if graphics.menu.gameOverButtons[1] then
        graphics.menu.gameOverButtons[1].x = buttonX
        graphics.menu.gameOverButtons[1].y = playAgainY
        graphics.menu.gameOverButtons[1].w = buttonWidth
        graphics.menu.gameOverButtons[1].h = buttonHeight
    end
    
    if graphics.menu.gameOverButtons[2] then
        graphics.menu.gameOverButtons[2].x = buttonX
        graphics.menu.gameOverButtons[2].y = mainMenuY
        graphics.menu.gameOverButtons[2].w = buttonWidth
        graphics.menu.gameOverButtons[2].h = buttonHeight
    end
    
    -- Draw Game Over buttons
    graphics.drawGameOverButton(graphics.menu.gameOverButtons[1], buttonX, playAgainY, 1)
    graphics.drawGameOverButton(graphics.menu.gameOverButtons[2], buttonX, mainMenuY, 2)
end

function graphics.drawVictoryParticles()
    -- Draw victory particles
    if not graphics.gameState.victoryParticleSystem.active and #graphics.gameState.victoryParticles == 0 then
        return
    end
    
    for _, p in ipairs(graphics.gameState.victoryParticles) do
        love.graphics.push()
        love.graphics.translate(p.x, p.y)
        love.graphics.rotate(p.rotation)
        
        -- Set color with alpha
        love.graphics.setColor(p.color[1], p.color[2], p.color[3], p.alpha)
        
        if p.type == 1 then
            -- Circle particles
            love.graphics.circle("fill", 0, 0, p.size)
        elseif p.type == 2 then
            -- Star particles
            local points = 5
            local outerRadius = p.size
            local innerRadius = p.size * 0.5
            local angleStep = math.pi * 2 / points
            
            local vertices = {}
            for i = 0, points * 2 - 1 do
                local angle = i * angleStep / 2
                local radius = (i % 2 == 0) and outerRadius or innerRadius
                table.insert(vertices, math.cos(angle) * radius)
                table.insert(vertices, math.sin(angle) * radius)
            end
            love.graphics.polygon("fill", vertices)
        elseif p.type == 3 then
            -- Square particles
            love.graphics.rectangle("fill", -p.size/2, -p.size/2, p.size, p.size)
        elseif p.type == 4 then
            -- Confetti (rectangles)
            love.graphics.rectangle("fill", -p.size/4, -p.size/2, p.size/2, p.size)
        end
        
        love.graphics.pop()
    end
end

function graphics.drawThemeButton()
    -- Make theme button responsive
    local scale = config.getScale(graphics.gameState.windowWidth, graphics.gameState.windowHeight)
    local buttonSize = math.max(30, config.ui.themeButtonSize * scale)
    local margin = math.max(15, config.ui.themeButtonMargin * scale)
    
    local x = graphics.gameState.windowWidth - buttonSize - margin
    local y = margin
    
    -- Button background with hover effect
    local hoverFactor = graphics.theme.themeButtonHover
    love.graphics.setColor(
        graphics.theme.colors.buttonNormal[1] + (graphics.theme.colors.buttonHover[1] - graphics.theme.colors.buttonNormal[1]) * hoverFactor,
        graphics.theme.colors.buttonNormal[2] + (graphics.theme.colors.buttonHover[2] - graphics.theme.colors.buttonNormal[2]) * hoverFactor,
        graphics.theme.colors.buttonNormal[3] + (graphics.theme.colors.buttonHover[3] - graphics.theme.colors.buttonNormal[3]) * hoverFactor,
        0.8 + hoverFactor * 0.2
    )
    love.graphics.circle("fill", x + buttonSize/2, y + buttonSize/2, buttonSize/2)
    
    -- Button border
    love.graphics.setColor(graphics.theme.colors.accent[1], graphics.theme.colors.accent[2], graphics.theme.colors.accent[3], 0.6 + hoverFactor * 0.4)
    love.graphics.setLineWidth(config.graphics.lineWidths.normal)
    love.graphics.circle("line", x + buttonSize/2, y + buttonSize/2, buttonSize/2)
    
    -- Draw moon or sun icon
    love.graphics.setColor(graphics.theme.colors.accent[1], graphics.theme.colors.accent[2], graphics.theme.colors.accent[3], 0.9)
    local centerX = x + buttonSize/2
    local centerY = y + buttonSize/2
    
    if graphics.theme.isDarkMode then
        -- Draw moon (crescent shape)
        local moonRadius = 12
        love.graphics.circle("fill", centerX - 2, centerY, moonRadius)
        love.graphics.setColor(graphics.theme.colors.buttonNormal)
        love.graphics.circle("fill", centerX + 3, centerY - 3, moonRadius - 2)
    else
        -- Draw sun
        local sunRadius = 8
        love.graphics.circle("fill", centerX, centerY, sunRadius)
        
        -- Sun rays
        love.graphics.setLineWidth(config.graphics.lineWidths.normal)
        for i = 0, 7 do
            local angle = i * math.pi / 4
            local rayStart = sunRadius + 3
            local rayEnd = sunRadius + 8
            local x1 = centerX + math.cos(angle) * rayStart
            local y1 = centerY + math.sin(angle) * rayStart
            local x2 = centerX + math.cos(angle) * rayEnd
            local y2 = centerY + math.sin(angle) * rayEnd
            love.graphics.line(x1, y1, x2, y2)
        end
    end
end

function graphics.drawGameOverButton(button, x, y, index)
    if not button then return end
    
    local anim = graphics.particles.gameOverButtonAnimations[index] or {scale = 1, hover = 0, glow = 0}
    
    -- Use button dimensions if they exist, otherwise use responsive defaults
    local w = button.w or (math.max(120, 200 * config.getScale(graphics.gameState.windowWidth, graphics.gameState.windowHeight)))
    local h = button.h or (math.max(40, 50 * config.getScale(graphics.gameState.windowWidth, graphics.gameState.windowHeight)))
    
    -- Get button text
    local buttonText = button.text
    if type(buttonText) == "function" then
        buttonText = buttonText()
    end
    
    -- Button shadow using config shadow offset
    love.graphics.setColor(graphics.theme.colors.shadow)
    love.graphics.rectangle("fill", x + config.graphics.shadowOffset, y + config.graphics.shadowOffset, w, h)
    
    -- Button background with hover effect
    local hoverFactor = anim.hover
    love.graphics.setColor(
        graphics.theme.colors.buttonNormal[1] + (graphics.theme.colors.buttonHover[1] - graphics.theme.colors.buttonNormal[1]) * hoverFactor,
        graphics.theme.colors.buttonNormal[2] + (graphics.theme.colors.buttonHover[2] - graphics.theme.colors.buttonNormal[2]) * hoverFactor,
        graphics.theme.colors.buttonNormal[3] + (graphics.theme.colors.buttonHover[3] - graphics.theme.colors.buttonNormal[3]) * hoverFactor
    )
    
    love.graphics.rectangle("fill", x, y, w, h)
    
    -- Button border
    love.graphics.setLineWidth(config.graphics.lineWidths.thin)
    love.graphics.setColor(graphics.theme.colors.cardBorder)
    love.graphics.rectangle("line", x, y, w, h)
    
    -- Button text
    love.graphics.setColor(graphics.theme.colors.text)
    love.graphics.setFont(graphics.buttonFont)
    love.graphics.printf(buttonText, x, y + h/2 - graphics.buttonFont:getHeight()/2, w, "center")
    
    -- Update button position for click detection
    button.x = x
    button.y = y
    button.w = w
    button.h = h
end

function graphics.drawGameButton(button, x, y, index)
    if not button then return end
    
    -- Ensure animation exists
    if not graphics.particles.gameButtonAnimations[index] then
        graphics.particles.gameButtonAnimations[index] = {scale = 1, hover = 0, glow = 0}
    end
    
    local anim = graphics.particles.gameButtonAnimations[index]
    local w, h = button.w or config.ui.buttonMinWidth, button.h or config.ui.buttonHeight
    
    -- Get button text
    local buttonText = button.text
    if type(buttonText) == "function" then
        buttonText = buttonText()
    end
    
    -- Button shadow using config shadow offset
    love.graphics.setColor(graphics.theme.colors.shadow)
    love.graphics.rectangle("fill", x + config.graphics.shadowOffset, y + config.graphics.shadowOffset, w, h)
    
    -- Button background with hover effect
    local hoverFactor = anim.hover
    local normalColor = graphics.theme.colors.buttonNormal
    local hoverColor = graphics.theme.colors.buttonHover
    
    love.graphics.setColor(
        normalColor[1] + (hoverColor[1] - normalColor[1]) * hoverFactor,
        normalColor[2] + (hoverColor[2] - normalColor[2]) * hoverFactor,
        normalColor[3] + (hoverColor[3] - normalColor[3]) * hoverFactor
    )
    
    love.graphics.rectangle("fill", x, y, w, h)
    
    -- Button border
    love.graphics.setLineWidth(config.graphics.lineWidths.thin)
    love.graphics.setColor(graphics.theme.colors.cardBorder)
    love.graphics.rectangle("line", x, y, w, h)
    
    -- Button text
    love.graphics.setColor(graphics.theme.colors.text)
    love.graphics.setFont(graphics.buttonFont)
    love.graphics.printf(buttonText, x, y + h/2 - graphics.buttonFont:getHeight()/2, w, "center")
    
    -- Update button position for click detection
    button.x = x
    button.y = y
    button.w = w
    button.h = h
end

return graphics
