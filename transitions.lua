-- Screen Transitions Module
-- Made by jaans21

local config = require("settings")
local transitions = {}

-- Screen transition system
transitions.transition = {
    active = false,
    type = "fade",     -- fade, slide, zoom
    direction = "out", -- out, in
    progress = 0,      -- 0 to 1
    duration = config.game.transitionDuration,    -- Duration of transition in seconds
    fromState = "",    -- Previous game state
    toState = "",      -- Target game state
    callback = nil     -- Function to call when transition completes
}

function transitions.setup(gameState, particles)
    transitions.gameState = gameState
    transitions.particles = particles
end

function transitions.startTransition(fromState, toState, transitionType, callback)
    transitions.transition.active = true
    transitions.transition.type = transitionType or "fade"
    transitions.transition.direction = "out"
    transitions.transition.progress = 0
    transitions.transition.fromState = fromState
    transitions.transition.toState = toState
    transitions.transition.callback = callback
end

function transitions.changeGameState(newState, transitionType, callback)
    -- Don't start a new transition if one is already active
    if transitions.transition.active then
        return
    end
    
    -- Special case: if we're already in the target state, just call the callback
    if transitions.gameState.current == newState then
        if callback then callback() end
        return
    end
    
    -- Reset button animations when changing state to prevent stuck hover states
    if transitions.particles and transitions.particles.resetButtonAnimations then
        transitions.particles.resetButtonAnimations()
    end
    
    -- Start the transition
    transitions.startTransition(transitions.gameState.current, newState, transitionType, callback)
end

function transitions.update(dt)
    if transitions.transition.active then
        local speed = 1 / transitions.transition.duration
        transitions.transition.progress = transitions.transition.progress + speed * dt
        
        if transitions.transition.progress >= 1 then
            if transitions.transition.direction == "out" then
                -- Transition out complete, change state and start transition in
                transitions.gameState.current = transitions.transition.toState
                transitions.transition.direction = "in"
                transitions.transition.progress = 0
                
                -- Call callback if provided (e.g., for initializing new state)
                if transitions.transition.callback then
                    transitions.transition.callback()
                end
            else
                -- Transition in complete
                transitions.transition.active = false
                transitions.transition.progress = 0
            end
        end
    end
end

function transitions.easeInOutQuad(t)
    -- Smooth easing function for better transitions
    if t < 0.5 then
        return 2 * t * t
    else
        return -1 + (4 - 2 * t) * t
    end
end

function transitions.draw()
    if transitions.transition.active then
        local alpha = 0
        
        if transitions.transition.direction == "out" then
            alpha = transitions.easeInOutQuad(transitions.transition.progress)
        else
            alpha = 1 - transitions.easeInOutQuad(transitions.transition.progress)
        end
        
        if transitions.transition.type == "fade" then
            love.graphics.setColor(0, 0, 0, alpha)
            love.graphics.rectangle("fill", 0, 0, transitions.gameState.windowWidth, transitions.gameState.windowHeight)
            
        elseif transitions.transition.type == "slide" then
            local offset = 0
            if transitions.transition.direction == "out" then
                offset = transitions.gameState.windowWidth * transitions.easeInOutQuad(transitions.transition.progress)
            else
                offset = transitions.gameState.windowWidth * (1 - transitions.easeInOutQuad(transitions.transition.progress))
            end
            
            love.graphics.push()
            love.graphics.translate(-offset, 0)
            -- Draw current state content here if needed
            love.graphics.pop()
            
            love.graphics.setColor(0, 0, 0, 0.3)
            love.graphics.rectangle("fill", 0, 0, transitions.gameState.windowWidth, transitions.gameState.windowHeight)
            
        elseif transitions.transition.type == "zoom" then
            local scale = 1
            if transitions.transition.direction == "out" then
                scale = 1 - transitions.easeInOutQuad(transitions.transition.progress) * 0.8
            else
                scale = 0.2 + transitions.easeInOutQuad(transitions.transition.progress) * 0.8
            end
            
            love.graphics.push()
            love.graphics.translate(transitions.gameState.windowWidth / 2, transitions.gameState.windowHeight / 2)
            love.graphics.scale(scale, scale)
            love.graphics.translate(-transitions.gameState.windowWidth / 2, -transitions.gameState.windowHeight / 2)
            -- Draw current state content here if needed
            love.graphics.pop()
            
            love.graphics.setColor(0, 0, 0, alpha * 0.5)
            love.graphics.rectangle("fill", 0, 0, transitions.gameState.windowWidth, transitions.gameState.windowHeight)
        end
        
        love.graphics.setColor(1, 1, 1, 1)  -- Reset color
    end
end

return transitions
