-- requiring push library for virtual graphics
push = require 'push'

-- requiring class library for creating classes
Class = require 'class'

-- including Bird class
require 'Bird'

-- including PipePair class
require 'PipePair'

-- including Pipe class
require 'Pipe'

-- state machine
require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/CountdownState'
require 'states/ScoreState'
require 'states/TitleScreenState'

-- variables for screen dimesion
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- ---------- BACKGROUND AND GROUND ------------------------------------

-- loading images for background and ground
local background = love.graphics.newImage('background.png')
local ground = love.graphics.newImage('ground.png')

-- offsets for drawing background and ground
local backgroundScroll = 0
local groundScroll = 0

-- determines how fast the images scroll
local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

-- looping point of images
local BACKGROUND_LOOPING_POINT = 413

-- ---------- BACKGROUND AND GROUND ------------------------------------

-- BIRD 
local bird = Bird()

-- PIPES
local pipePairs = {}
local lastY = - PIPE_HEIGHT + math.random(80) + 20

-- timer to control spawning of pipes
local spawnTimer = 0
local SPAWN_TIMER_LIMIT = 3

-- scrolling variable to pause game on collision
local scrolling = true

-- load function
function love.load()
    -- sets filter on upscale and downscale to nearest to avoid blurry images
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- seed the RNG
    math.randomseed(os.time())

    -- sets title of window to 'Bird Remake'
    love.window.setTitle('Bird Remake')

    -- loading and setting font
    smallFont = love.graphics.newFont('font.ttf', 8)
    mediumFont = love.graphics.newFont('flappy.ttf', 14)
    flappyFont = love.graphics.newFont('flappy.ttf', 28)
    hugeFont = love.graphics.newFont('flappy.ttf', 56)
    love.graphics.setFont(flappyFont)

     -- initialize our table of sounds
     sounds = {
        ['jump'] = love.audio.newSource('jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('hurt.wav', 'static'),
        ['score'] = love.audio.newSource('score.wav', 'static'),

        -- https://freesound.org/people/xsgianni/sounds/388079/
        ['music'] = love.audio.newSource('marios_way.mp3', 'static')
    }

    -- kick off music
    sounds['music']:setLooping(true)
    sounds['music']:play()

    -- setting up push to render with virtual dimensions
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true,
    })

    -- initialize state machine with all state-returning functions
    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['play'] = function() return PlayState() end,
        ['countdown'] = function() return CountdownState() end,
        ['score'] = function() return ScoreState() end,
    }
    gStateMachine:change('title')

    -- tracks keypressed outside the keyspressed function
    love.keyboard.keysPressed = {}

end

-- resizes window
function love.resize(width, height)
    push:resize(width, height)
end

-- handles keypressed events
function love.keypressed(key)
    -- setting the value of key to true
    love.keyboard.keysPressed[key] = true

    -- exits the game if 'escape' is pressed
    if key == 'escape' then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

-- updates states of the game
function love.update(dt)
    -- sets background offset
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT

    -- sets ground offset
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH

    -- updates state of the game
    gStateMachine:update(dt)

    -- resets table
    love.keyboard.keysPressed = {}
end

-- love drawing function
function love.draw()
    -- applies virtual resolution
    push:start()

    -- background
    love.graphics.draw(background, -backgroundScroll, 0)

    -- render logic for current state
    gStateMachine:render()

    -- ground
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16) 

    -- end virtual resolution
    push:finish()
end