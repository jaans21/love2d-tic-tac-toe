-- Board Logic Module
-- Made by jaans21

local board = {}

function board.setup(gameState, transitions)
    board.gameState = gameState
    board.transitions = transitions
end

function board.makeMove(row, col, audio, particles)
    -- Check if the cell is empty and game is not over
    if board.gameState.board[row][col] == 0 and not board.gameState.gameOver then
        -- Make the move
        board.gameState.board[row][col] = board.gameState.currentPlayer
        
        -- Start piece animation
        if board.gameState.pieceAnimations[row] and board.gameState.pieceAnimations[row][col] then
            board.gameState.pieceAnimations[row][col].active = true
            board.gameState.pieceAnimations[row][col].time = 0
        end
        
        -- Play move sound
        if audio then
            audio.playSound("gameMove")
        end
        
        -- Check for win
        if board.checkWinForPlayer(board.gameState.currentPlayer) then
            board.gameState.winner = board.gameState.currentPlayer
            board.gameState.gameOver = true
            
            -- Change to gameOver state
            board.transitions.changeGameState("gameOver", "fade")
            
            -- Start winning line animation
            board.gameState.winningLineAnimation.active = true
            board.gameState.winningLineAnimation.time = 0
            
            -- Create victory particles
            if particles then
                board.gameState.victoryParticleSystem.active = true
                board.gameState.victoryParticleSystem.elapsed = 0
                particles.createConfettiExplosion()
            end
            
            -- Play win sound
            if audio then
                audio.playSound("gameWin")
            end
        elseif board.checkTie() then
            board.gameState.winner = 0
            board.gameState.gameOver = true
            
            -- Change to gameOver state
            board.transitions.changeGameState("gameOver", "fade")
            
            -- Play tie sound
            if audio then
                audio.playSound("gameTie")
            end
        else
            -- Switch players
            board.gameState.currentPlayer = board.gameState.currentPlayer == 1 and 2 or 1
            
            -- If AI mode and it's AI's turn, set AI thinking time
            if board.gameState.gameMode == "ai" and board.gameState.currentPlayer == 2 then
                local delays = board.gameState.aiThinkingDelays[board.gameState.aiSpeed]
                board.gameState.aiThinkingTime = delays[math.random(#delays)]
            end
        end
        
        return true
    end
    
    return false
end

function board.checkWin()
    return board.checkWinForPlayer(1) or board.checkWinForPlayer(2)
end

function board.checkWinForPlayer(player)
    local size = board.gameState.boardSize
    local winLength = math.min(size, 5)  -- Win with 5 in a row for larger boards
    
    -- Check rows
    for row = 1, size do
        for startCol = 1, size - winLength + 1 do
            local count = 0
            local winningCells = {}
            
            for col = startCol, startCol + winLength - 1 do
                if board.gameState.board[row][col] == player then
                    count = count + 1
                    table.insert(winningCells, {row, col})
                else
                    break
                end
            end
            
            if count == winLength then
                board.gameState.winningLine = winningCells
                return true
            end
        end
    end
    
    -- Check columns
    for col = 1, size do
        for startRow = 1, size - winLength + 1 do
            local count = 0
            local winningCells = {}
            
            for row = startRow, startRow + winLength - 1 do
                if board.gameState.board[row][col] == player then
                    count = count + 1
                    table.insert(winningCells, {row, col})
                else
                    break
                end
            end
            
            if count == winLength then
                board.gameState.winningLine = winningCells
                return true
            end
        end
    end
    
    -- Check diagonals (top-left to bottom-right)
    for startRow = 1, size - winLength + 1 do
        for startCol = 1, size - winLength + 1 do
            local count = 0
            local winningCells = {}
            
            for i = 0, winLength - 1 do
                if board.gameState.board[startRow + i][startCol + i] == player then
                    count = count + 1
                    table.insert(winningCells, {startRow + i, startCol + i})
                else
                    break
                end
            end
            
            if count == winLength then
                board.gameState.winningLine = winningCells
                return true
            end
        end
    end
    
    -- Check diagonals (top-right to bottom-left)
    for startRow = 1, size - winLength + 1 do
        for startCol = winLength, size do
            local count = 0
            local winningCells = {}
            
            for i = 0, winLength - 1 do
                if board.gameState.board[startRow + i][startCol - i] == player then
                    count = count + 1
                    table.insert(winningCells, {startRow + i, startCol - i})
                else
                    break
                end
            end
            
            if count == winLength then
                board.gameState.winningLine = winningCells
                return true
            end
        end
    end
    
    return false
end

function board.checkTie()
    -- Check if the board is full
    for row = 1, board.gameState.boardSize do
        for col = 1, board.gameState.boardSize do
            if board.gameState.board[row][col] == 0 then
                return false  -- Found an empty cell, so no tie yet
            end
        end
    end
    
    return true  -- All cells are filled and no winner
end

return board
