-- Game State Management Module
-- Made by jaans21

local config = require("settings")
local gameState = {}

-- Game states
gameState.current = "menu"  -- menu, playing, gameOver
gameState.gameMode = "human"  -- human, ai
gameState.boardSize = config.game.defaultBoardSize       -- Board size (3x3, 4x4, 5x5, etc.)
gameState.currentPlayer = 1   -- 1 for X, 2 for O
gameState.board = {}
gameState.winner = 0
gameState.gameOver = false

-- Interface variables
gameState.windowWidth = config.window.width
gameState.windowHeight = config.window.height
gameState.originalWindowWidth = config.window.width
gameState.originalWindowHeight = config.window.height
gameState.isFullscreen = config.window.fullscreen
gameState.cellSize = 0
gameState.boardOffsetX = 0
gameState.boardOffsetY = 0

-- Menu settings
gameState.selectedBoardSize = config.game.defaultBoardSize
gameState.customBoardSize = 6  -- Default custom size
gameState.isCustomSizeMode = false
gameState.customInputActive = false
gameState.customInputText = ""  -- Start with empty input
gameState.aiThinkingTime = 0

-- AI Speed settings
gameState.aiSpeed = config.game.defaultAiSpeed  -- "Fast", "Normal", "Slow"
gameState.aiThinkingDelays = config.game.aiThinkingTimes

-- AI Difficulty settings
gameState.aiDifficulty = config.game.defaultAiDifficulty  -- "Easy", "Medium", "Hard"

-- Performance optimizations
gameState.isResizing = false
gameState.resizeFrameCounter = 0
gameState.resizeFramesNeeded = config.game.resizeFramesNeeded  -- Wait frames after resize
gameState.suspendAnimations = false

-- Piece animation system
gameState.pieceAnimations = {}  -- Table to store animation data for each piece
gameState.pieceAnimationDuration = config.game.pieceAnimationDuration  -- Duration of the animation in seconds

-- Winning line highlight system
gameState.winningLine = {}  -- Stores the coordinates of the winning line
gameState.winningLineAnimation = {
    active = false,
    time = 0,
    duration = config.game.winningLineAnimationDuration,  -- Duration of the highlight animation
    intensity = 0    -- Current intensity of the highlight (0 to 1)
}

-- Victory particles system
gameState.victoryParticles = {}
gameState.victoryParticleSystem = {
    active = false,
    spawnTimer = 0,
    spawnRate = config.game.victoryParticles.spawnRate,  -- Spawn particles rate
    duration = config.game.victoryParticles.duration,    -- Total duration of victory particle effect
    elapsed = 0        -- Time elapsed since victory
}

function gameState.initializeBoard()
    gameState.board = {}
    gameState.pieceAnimations = {}
    
    for row = 1, gameState.boardSize do
        gameState.board[row] = {}
        gameState.pieceAnimations[row] = {}
        for col = 1, gameState.boardSize do
            gameState.board[row][col] = 0  -- 0 = empty, 1 = X, 2 = O
            gameState.pieceAnimations[row][col] = {
                active = false,
                time = 0
            }
        end
    end
    
    gameState.currentPlayer = 1
    gameState.winner = 0
    gameState.gameOver = false
    gameState.winningLine = {}
    gameState.winningLineAnimation.active = false
    gameState.winningLineAnimation.time = 0
    gameState.winningLineAnimation.intensity = 0
end

function gameState.syncPieceAnimations()
    -- Ensure the piece animations table matches the board size
    if not gameState.pieceAnimations or #gameState.pieceAnimations ~= gameState.boardSize then
        gameState.pieceAnimations = {}
        for row = 1, gameState.boardSize do
            gameState.pieceAnimations[row] = {}
            for col = 1, gameState.boardSize do
                gameState.pieceAnimations[row][col] = {
                    active = false,
                    time = 0
                }
            end
        end
    else
        -- Just ensure each row has the correct number of columns
        for row = 1, gameState.boardSize do
            if not gameState.pieceAnimations[row] or #gameState.pieceAnimations[row] ~= gameState.boardSize then
                gameState.pieceAnimations[row] = {}
                for col = 1, gameState.boardSize do
                    gameState.pieceAnimations[row][col] = {
                        active = false,
                        time = 0
                    }
                end
            end
        end
    end
end

function gameState.calculateBoardLayout()
    local config = require("settings")
    
    -- Adjust board size based on screen size
    local boardPercentage = 0.7
    local verticalPercentage = 0.8
    
    if config.isTinyScreen(gameState.windowWidth, gameState.windowHeight) then
        boardPercentage = 0.85  -- Use more space on tiny screens
        verticalPercentage = 0.75
    elseif config.isSmallScreen(gameState.windowWidth, gameState.windowHeight) then
        boardPercentage = 0.8   -- Use more space on small screens
        verticalPercentage = 0.75
    end
    
    local maxBoardSize = math.min(
        gameState.windowWidth * boardPercentage, 
        gameState.windowHeight * verticalPercentage
    )
    
    -- Ensure minimum cell size for usability
    local minCellSize = config.isTinyScreen(gameState.windowWidth, gameState.windowHeight) and 25 or 30
    gameState.cellSize = math.max(minCellSize, maxBoardSize / gameState.boardSize)
    
    -- Center the board
    local actualBoardSize = gameState.cellSize * gameState.boardSize
    gameState.boardOffsetX = (gameState.windowWidth - actualBoardSize) / 2
    
    -- Adjust vertical offset based on screen size
    local verticalOffset = config.isTinyScreen(gameState.windowWidth, gameState.windowHeight) and 10 or 20
    gameState.boardOffsetY = (gameState.windowHeight - actualBoardSize) / 2 + verticalOffset
end

function gameState.startGame()
    -- Ensure we use the correct board size based on current mode
    if gameState.isCustomSizeMode then
        -- In custom mode, use the custom board size
        gameState.boardSize = gameState.customBoardSize
    else
        -- In normal mode, use the selected board size
        gameState.boardSize = gameState.selectedBoardSize
    end
    
    -- Validate board size is within acceptable range
    if gameState.boardSize < 3 then
        gameState.boardSize = 3
    elseif gameState.boardSize > 15 then
        gameState.boardSize = 15
    end
    
    gameState.initializeBoard()
    gameState.syncPieceAnimations()
    gameState.calculateBoardLayout()
    gameState.current = "playing"
    
    -- Clear victory particles if any
    gameState.victoryParticles = {}
    gameState.victoryParticleSystem.active = false
    gameState.victoryParticleSystem.elapsed = 0
    
    -- Clear winning line animation
    gameState.winningLineAnimation.active = false
    gameState.winningLineAnimation.time = 0
    gameState.winningLineAnimation.intensity = 0
end

return gameState
