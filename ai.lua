-- AI Logic Module
-- Made by jaans21

local ai = {}

function ai.setup(gameState, board)
    ai.gameState = gameState
    ai.board = board
end

function ai.makeMove()
    -- Just find and return the best move, don't execute it
    return ai.findBestMove()
end

function ai.findBestMove()
    if ai.gameState.aiDifficulty == "Easy" then
        return ai.findEasyMove()
    elseif ai.gameState.aiDifficulty == "Medium" then
        return ai.findMediumMove()
    else -- Hard
        -- For larger boards, use heuristic approach for performance
        if ai.gameState.boardSize > 4 then
            return ai.findBestMoveHeuristic()
        else
            return ai.findBestMoveMinimax()
        end
    end
end

function ai.findEasyMove()
    -- Easy AI: 70% random moves, 30% try to win or block
    if math.random() < 0.7 then
        -- Random move
        local emptyCells = {}
        for row = 1, ai.gameState.boardSize do
            for col = 1, ai.gameState.boardSize do
                if ai.gameState.board[row][col] == 0 then
                    table.insert(emptyCells, {row = row, col = col})
                end
            end
        end
        
        if #emptyCells > 0 then
            return emptyCells[math.random(#emptyCells)]
        end
    else
        -- Try to win first, then block
        local winMove = ai.findWinningMove(2)  -- AI is player 2
        if winMove then
            return winMove
        end
        
        local blockMove = ai.findWinningMove(1)  -- Block human player 1
        if blockMove then
            return blockMove
        end
        
        -- Fallback to random
        return ai.findEasyMove()
    end
end

function ai.findMediumMove()
    -- Medium AI: Try to win, then block, then strategic moves
    
    -- 1. Try to win
    local winMove = ai.findWinningMove(2)  -- AI is player 2
    if winMove then
        return winMove
    end
    
    -- 2. Block opponent from winning
    local blockMove = ai.findWinningMove(1)  -- Block human player 1
    if blockMove then
        return blockMove
    end
    
    -- 3. Strategic moves (center, corners, etc.)
    local size = ai.gameState.boardSize
    
    -- Try center first (for odd-sized boards)
    if size % 2 == 1 then
        local center = math.ceil(size / 2)
        if ai.gameState.board[center][center] == 0 then
            return {row = center, col = center}
        end
    end
    
    -- Try corners
    local corners = {
        {1, 1}, {1, size}, {size, 1}, {size, size}
    }
    
    for _, corner in ipairs(corners) do
        if ai.gameState.board[corner[1]][corner[2]] == 0 then
            return {row = corner[1], col = corner[2]}
        end
    end
    
    -- Fallback to any empty cell
    for row = 1, size do
        for col = 1, size do
            if ai.gameState.board[row][col] == 0 then
                return {row = row, col = col}
            end
        end
    end
    
    return nil
end

function ai.findWinningMove(player)
    local size = ai.gameState.boardSize
    
    -- Try each empty cell to see if it creates a win
    for row = 1, size do
        for col = 1, size do
            if ai.gameState.board[row][col] == 0 then
                -- Temporarily place the piece
                ai.gameState.board[row][col] = player
                
                -- Check if this creates a win
                if ai.board.checkWinForPlayer(player) then
                    -- Remove the temporary piece
                    ai.gameState.board[row][col] = 0
                    return {row = row, col = col}
                end
                
                -- Remove the temporary piece
                ai.gameState.board[row][col] = 0
            end
        end
    end
    
    return nil
end

function ai.findBestMoveHeuristic()
    -- Heuristic-based AI for larger boards (better performance)
    local size = ai.gameState.boardSize
    local bestScore = -math.huge
    local bestMove = nil
    
    for row = 1, size do
        for col = 1, size do
            if ai.gameState.board[row][col] == 0 then
                -- Calculate heuristic score for this position
                local score = ai.evaluatePosition(row, col, 2)  -- AI is player 2
                
                -- Add some randomness to make it less predictable
                score = score + math.random(-5, 5)
                
                if score > bestScore then
                    bestScore = score
                    bestMove = {row = row, col = col}
                end
            end
        end
    end
    
    return bestMove
end

function ai.evaluatePosition(row, col, player)
    local score = 0
    local opponent = player == 1 and 2 or 1
    
    -- Temporarily place the piece
    ai.gameState.board[row][col] = player
    
    -- Check if this move wins the game
    if ai.board.checkWinForPlayer(player) then
        score = score + 1000
    end
    
    -- Check if this move blocks opponent from winning
    ai.gameState.board[row][col] = opponent
    if ai.board.checkWinForPlayer(opponent) then
        score = score + 500
    end
    
    -- Restore the cell
    ai.gameState.board[row][col] = 0
    
    -- Add positional bonuses
    local center = math.ceil(ai.gameState.boardSize / 2)
    local distanceFromCenter = math.abs(row - center) + math.abs(col - center)
    score = score + (10 - distanceFromCenter)  -- Prefer center positions
    
    return score
end

function ai.findBestMoveMinimax()
    -- Minimax algorithm for smaller boards (3x3, 4x4)
    local bestScore = -math.huge
    local bestMove = nil
    local maxDepth = ai.getMaxDepth()
    
    for row = 1, ai.gameState.boardSize do
        for col = 1, ai.gameState.boardSize do
            if ai.gameState.board[row][col] == 0 then
                ai.gameState.board[row][col] = 2  -- AI is player 2
                local score = ai.minimax(ai.gameState.board, maxDepth - 1, false)
                ai.gameState.board[row][col] = 0
                
                if score > bestScore then
                    bestScore = score
                    bestMove = {row = row, col = col}
                end
            end
        end
    end
    
    return bestMove
end

function ai.minimax(board, depth, isMaximizing)
    -- Check for terminal states
    if ai.board.checkWinForPlayer(2) then  -- AI wins
        return 10 + depth  -- Prefer quicker wins
    elseif ai.board.checkWinForPlayer(1) then  -- Human wins
        return -10 - depth  -- Prefer to delay losses
    elseif ai.board.checkTie() or depth == 0 then
        return ai.evaluateBoard()
    end
    
    if isMaximizing then
        local bestScore = -math.huge
        for row = 1, ai.gameState.boardSize do
            for col = 1, ai.gameState.boardSize do
                if ai.gameState.board[row][col] == 0 then
                    ai.gameState.board[row][col] = 2
                    local score = ai.minimax(board, depth - 1, false)
                    ai.gameState.board[row][col] = 0
                    bestScore = math.max(score, bestScore)
                end
            end
        end
        return bestScore
    else
        local bestScore = math.huge
        for row = 1, ai.gameState.boardSize do
            for col = 1, ai.gameState.boardSize do
                if ai.gameState.board[row][col] == 0 then
                    ai.gameState.board[row][col] = 1
                    local score = ai.minimax(board, depth + 1, true)
                    ai.gameState.board[row][col] = 0
                    bestScore = math.min(score, bestScore)
                end
            end
        end
        return bestScore
    end
end

function ai.getMaxDepth()
    -- Adjust search depth based on board size for performance
    if ai.gameState.boardSize == 3 then
        return 9  -- Can search the entire game tree
    elseif ai.gameState.boardSize == 4 then
        return 6  -- Reasonable depth for 4x4
    else
        return 4  -- Limited depth for larger boards
    end
end

function ai.evaluateBoard()
    -- Simple board evaluation heuristic
    local score = 0
    
    -- Add small bonuses for having pieces in good positions
    local center = math.ceil(ai.gameState.boardSize / 2)
    
    for row = 1, ai.gameState.boardSize do
        for col = 1, ai.gameState.boardSize do
            if ai.gameState.board[row][col] == 2 then  -- AI piece
                local distanceFromCenter = math.abs(row - center) + math.abs(col - center)
                score = score + (3 - distanceFromCenter)
            elseif ai.gameState.board[row][col] == 1 then  -- Human piece
                local distanceFromCenter = math.abs(row - center) + math.abs(col - center)
                score = score - (3 - distanceFromCenter)
            end
        end
    end
    
    return score
end

return ai
