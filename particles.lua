-- Particle Effects Module
-- Made by jaans21

local config = require("settings")
local particles = {}

-- Animation and effects state
particles.menuTime = 0
particles.buttonAnimations = {}
particles.particleList = {}
particles.particleUpdateTimer = 0

function particles.init(gameState)
    particles.gameState = gameState
    
    -- Initialize button animations
    particles.buttonAnimations = {}
    for i = 1, 11 do  -- 11 buttons total (added AI difficulty button)
        particles.buttonAnimations[i] = {scale = 1, hover = 0, glow = 0}
    end
    
    -- Initialize Game Over button animations
    particles.gameOverButtonAnimations = {}
    for i = 1, 2 do  -- 2 Game Over buttons (Play Again, Main Menu)
        particles.gameOverButtonAnimations[i] = {scale = 1, hover = 0, glow = 0}
    end
    
    -- Initialize Game button animations (buttons during gameplay)
    particles.gameButtonAnimations = {}
    for i = 1, 1 do  -- 1 Game button (Menu)
        particles.gameButtonAnimations[i] = {scale = 1, hover = 0, glow = 0}
    end
    
    -- Initialize particles
    particles.initParticles()
end

function particles.createVictoryParticle()
    -- Create a celebratory particle
    local particle = {
        x = math.random(0, love.graphics.getWidth()),
        y = love.graphics.getHeight() + 10,  -- Start from bottom
        vx = math.random(-50, 50),  -- Horizontal velocity
        vy = math.random(-200, -100),  -- Upward velocity
        size = math.random(3, 8),  -- Larger particles
        life = math.random(2, 4),  -- Longer life
        maxLife = 0,
        alpha = 1,
        color = {},
        type = math.random(1, 3),  -- Different particle types
        rotation = 0,
        rotationSpeed = math.random(-5, 5),
        gravity = math.random(50, 100),  -- Gravity effect
        bounce = math.random(2, 4) / 10  -- Bounce factor
    }
    
    particle.maxLife = particle.life
    
    -- Different colors for victory particles
    if particle.type == 1 then
        particle.color = {1, 0.8, 0}  -- Gold
    elseif particle.type == 2 then
        particle.color = {0.8, 0.2, 0.8}  -- Purple
    else
        particle.color = {0.2, 0.8, 1}  -- Blue
    end
    
    return particle
end

function particles.createConfettiExplosion()
    -- Create multiple confetti particles at once
    local particleCount = math.random(15, 25)
    -- Use gameState window dimensions if available, otherwise fallback to love.graphics
    local centerX = (particles.gameState and particles.gameState.windowWidth or love.graphics.getWidth()) / 2
    local centerY = (particles.gameState and particles.gameState.windowHeight or love.graphics.getHeight()) / 2
    
    for i = 1, particleCount do
        local angle = (i / particleCount) * math.pi * 2 + math.random() * 0.5
        local speed = math.random(100, 300)
        
        local particle = {
            x = centerX + math.random(-50, 50),
            y = centerY + math.random(-50, 50),
            vx = math.cos(angle) * speed,
            vy = math.sin(angle) * speed,
            size = math.random(4, 10),
            life = math.random(3, 6),
            maxLife = 0,
            alpha = 1,
            color = {},
            type = math.random(1, 5),  -- More variety
            rotation = math.random() * math.pi * 2,
            rotationSpeed = math.random(-10, 10),
            gravity = math.random(80, 120),
            bounce = math.random(3, 6) / 10
        }
        
        particle.maxLife = particle.life
        
        -- Rainbow colors for confetti
        if particle.type == 1 then
            particle.color = {1, 0.2, 0.2}  -- Red
        elseif particle.type == 2 then
            particle.color = {1, 0.8, 0.2}  -- Orange
        elseif particle.type == 3 then
            particle.color = {0.2, 1, 0.2}  -- Green
        elseif particle.type == 4 then
            particle.color = {0.2, 0.2, 1}  -- Blue
        else
            particle.color = {0.8, 0.2, 1}  -- Purple
        end
        
        table.insert(particles.particleList, particle)
    end
end

function particles.initParticles()
    particles.particleList = {}
    
    -- Create some initial ambient particles
    for i = 1, 20 do
        local particle = {
            x = math.random(0, love.graphics.getWidth()),
            y = math.random(0, love.graphics.getHeight()),
            vx = math.random(-10, 10),
            vy = math.random(-10, 10),
            size = math.random(1, 3),
            life = math.random(5, 10),
            maxLife = 0,
            alpha = 0.3,
            color = {0.5, 0.7, 1},
            type = 1,
            rotation = 0,
            rotationSpeed = math.random(-1, 1),
            gravity = 0,
            bounce = 0
        }
        particle.maxLife = particle.life
        table.insert(particles.particleList, particle)
    end
end

function particles.update(dt)
    particles.menuTime = particles.menuTime + dt
    particles.particleUpdateTimer = particles.particleUpdateTimer + dt
    
    -- Update particles
    for i = #particles.particleList, 1, -1 do
        local p = particles.particleList[i]
        
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
        if p.x < 0 or p.x > love.graphics.getWidth() then
            p.vx = -p.vx * p.bounce
            p.x = math.max(0, math.min(love.graphics.getWidth(), p.x))
        end
        
        if p.y > love.graphics.getHeight() then
            p.vy = -math.abs(p.vy) * p.bounce
            p.y = love.graphics.getHeight()
        end
        
        -- Remove dead particles
        if p.life <= 0 then
            table.remove(particles.particleList, i)
        end
    end
    
    -- Add new ambient particles occasionally
    if particles.particleUpdateTimer > 0.5 then
        particles.particleUpdateTimer = 0
        
        -- Only add if we don't have too many
        if #particles.particleList < 30 then
            local particle = {
                x = math.random(0, love.graphics.getWidth()),
                y = -10,
                vx = math.random(-20, 20),
                vy = math.random(10, 30),
                size = math.random(1, 2),
                life = math.random(8, 15),
                maxLife = 0,
                alpha = 0.2,
                color = {0.6, 0.8, 1},
                type = 1,
                rotation = 0,
                rotationSpeed = math.random(-0.5, 0.5),
                gravity = 5,
                bounce = 0
            }
            particle.maxLife = particle.life
            table.insert(particles.particleList, particle)
        end
    end
end

function particles.draw()
    love.graphics.push()
    
    for _, p in ipairs(particles.particleList) do
        love.graphics.push()
        love.graphics.translate(p.x, p.y)
        love.graphics.rotate(p.rotation)
        
        local r, g, b = p.color[1], p.color[2], p.color[3]
        love.graphics.setColor(r, g, b, p.alpha)
        
        if p.type == 1 then
            love.graphics.circle("fill", 0, 0, p.size)
        elseif p.type == 2 then
            love.graphics.rectangle("fill", -p.size/2, -p.size/2, p.size, p.size)
        else
            -- Star shape
            local points = {}
            for i = 0, 4 do
                local angle = i * math.pi * 0.4
                table.insert(points, math.cos(angle) * p.size)
                table.insert(points, math.sin(angle) * p.size)
            end
            love.graphics.polygon("fill", points)
        end
        
        love.graphics.pop()
    end
    
    love.graphics.pop()
end

function particles.clearVictoryParticles()
    particles.particleList = {}
    particles.initParticles()
end

function particles.resetButtonAnimations()
    -- Reset all button animations to their default state
    for i, anim in ipairs(particles.buttonAnimations) do
        anim.hover = 0
        anim.glow = 0
        anim.scale = 1
    end
    
    -- Reset Game Over button animations
    if particles.gameOverButtonAnimations then
        for i, anim in ipairs(particles.gameOverButtonAnimations) do
            anim.hover = 0
            anim.glow = 0
            anim.scale = 1
        end
    end
    
    -- Reset Game button animations
    if particles.gameButtonAnimations then
        for i, anim in ipairs(particles.gameButtonAnimations) do
            anim.hover = 0
            anim.glow = 0
            anim.scale = 1
        end
    end
end

return particles
