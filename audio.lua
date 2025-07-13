-- Audio System Module
-- Made by jaans21

local audio = {}

-- Audio state
audio.sounds = {}
audio.soundEnabled = true
audio.musicEnabled = true
audio.lastHoveredButton = nil  -- Track which button was last hovered for sound
audio.backgroundMusic = nil
audio.currentMusicVolume = 0.15

function audio.init()
    -- Create simple sound data programmatically
    audio.sounds = {}
    
    -- Button click sound (short beep)
    audio.sounds.buttonClick = audio.createToneSound(800, 0.1, 0.3)  -- 800Hz, 0.1 seconds, 30% volume
    
    -- Button hover sound (softer tone)
    audio.sounds.buttonHover = audio.createToneSound(600, 0.05, 0.1)  -- 600Hz, 0.05 seconds, 10% volume
    
    -- Game move sound (deeper tone)
    audio.sounds.gameMove = audio.createToneSound(400, 0.15, 0.4)  -- 400Hz, 0.15 seconds, 40% volume
    
    -- Win sound (ascending tones)
    audio.sounds.gameWin = audio.createWinSound()
    
    -- Tie sound (neutral tone)
    audio.sounds.gameTie = audio.createToneSound(300, 0.3, 0.2)  -- 300Hz, 0.3 seconds, 20% volume
    
    -- Create background music
    audio.backgroundMusic = audio.createBackgroundMusic()
    audio.backgroundMusic:setLooping(true)
    audio.backgroundMusic:setVolume(audio.currentMusicVolume)
    
    -- Start background music if enabled
    if audio.musicEnabled then
        audio.backgroundMusic:play()
    end
end

function audio.createToneSound(frequency, duration, volume)
    local sampleRate = 44100
    local samples = math.floor(sampleRate * duration)
    local soundData = love.sound.newSoundData(samples, sampleRate, 16, 1)
    
    for i = 0, samples - 1 do
        local t = i / sampleRate
        local envelope = math.exp(-t * 5) -- Exponential decay
        local wave = math.sin(2 * math.pi * frequency * t) * envelope * volume
        soundData:setSample(i, wave)
    end
    
    return love.audio.newSource(soundData, "static")
end

function audio.createWinSound()
    local sampleRate = 44100
    local duration = 0.5
    local samples = math.floor(sampleRate * duration)
    local soundData = love.sound.newSoundData(samples, sampleRate, 16, 1)
    
    for i = 0, samples - 1 do
        local t = i / sampleRate
        local progress = t / duration
        local frequency = 400 + progress * 400  -- Rising from 400Hz to 800Hz
        local envelope = math.exp(-t * 2) -- Slower decay for celebration
        local wave = math.sin(2 * math.pi * frequency * t) * envelope * 0.3
        soundData:setSample(i, wave)
    end
    
    return love.audio.newSource(soundData, "static")
end

function audio.createBackgroundMusic()
    local sampleRate = 44100
    local duration = 16.0  -- 16 seconds of gentle music
    local samples = math.floor(sampleRate * duration)
    local soundData = love.sound.newSoundData(samples, sampleRate, 16, 1)
    
    -- Create a gentle piano-like melody
    -- Using pentatonic scale for a pleasant sound: C, D, E, G, A
    local notes = {261.63, 293.66, 329.63, 392.00, 440.00}  -- C4, D4, E4, G4, A4
    local melody = {1, 3, 5, 3, 1, 2, 3, 2, 1, 5, 4, 3, 2, 1, 3, 1}  -- Simple melody pattern
    
    for i = 0, samples - 1 do
        local t = i / sampleRate
        local progress = t / duration
        
        -- Current note in melody (changes every second)
        local noteIndex = math.floor(progress * #melody) + 1
        if noteIndex > #melody then noteIndex = #melody end
        local currentNote = notes[melody[noteIndex]]
        
        -- Main melody with gentle attack and decay
        local noteProgress = (progress * #melody) % 1
        local envelope = math.sin(noteProgress * math.pi) * 0.15  -- Gentle sine envelope
        local mainMelody = math.sin(2 * math.pi * currentNote * t) * envelope
        
        -- Soft harmony (third above)
        local harmonyNote = currentNote * 1.25  -- Minor third
        local harmony = math.sin(2 * math.pi * harmonyNote * t) * envelope * 0.6
        
        -- Very soft bass (root note, octave below)
        local bassNote = currentNote * 0.5
        local bass = math.sin(2 * math.pi * bassNote * t) * 0.03
        
        -- Gentle reverb effect
        local reverb = 0
        if i > sampleRate * 0.1 then  -- Start reverb after 0.1 seconds
            local delayedSample = i - math.floor(sampleRate * 0.1)
            reverb = mainMelody * 0.2 * math.exp(-t * 2)
        end
        
        -- Combine all elements with master volume control
        local masterEnvelope = 0.8 + 0.2 * math.sin(progress * math.pi * 0.5)  -- Very gentle volume variation
        local wave = (mainMelody + harmony + bass + reverb) * masterEnvelope * 0.3
        
        -- Soft filter to remove harshness
        if i > 0 then
            wave = wave * 0.7 + soundData:getSample(i-1) * 0.3  -- Simple low-pass filter
        end
        
        soundData:setSample(i, math.max(-1, math.min(1, wave)))  -- Clamp to prevent distortion
    end
    
    return love.audio.newSource(soundData, "static")
end

function audio.playSound(soundName)
    if audio.soundEnabled and audio.sounds[soundName] then
        local source = audio.sounds[soundName]:clone()
        source:play()
    end
end

function audio.toggleMusic()
    audio.musicEnabled = not audio.musicEnabled
    if audio.musicEnabled then
        if audio.backgroundMusic then
            audio.backgroundMusic:play()
        end
    else
        if audio.backgroundMusic then
            audio.backgroundMusic:pause()
        end
    end
end

function audio.updateMusicVolume()
    if audio.backgroundMusic then
        audio.backgroundMusic:setVolume(audio.musicEnabled and audio.currentMusicVolume or 0)
    end
end

function audio.toggleSound()
    audio.soundEnabled = not audio.soundEnabled
end

return audio
