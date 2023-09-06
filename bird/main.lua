-- requiring the push library for virtual resolution
push = require 'push'

-- requiring the  class library 
Class = require 'class'

-- including the Bird class in the main lua file
require 'Bird'

-- defining physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- defining virtual screen dimentsions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- loading of background image
local background = love.graphics.newImage('background.png')
local backgroundScroll = 0                                      -- variable to keep track of amount of background scroll

-- loading of ground image
local ground = love.graphics.newImage('ground.png')
local groundScroll = 0                                          -- variable to keep track of amount of ground scroll

-- defining speed values for the background and ground images
local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

-- setting the background looping point to avoid running out of image
local BACKGROUND_LOOPING_POINT = 413

-- instantiating a bird object
local bird = Bird()

function love.load()
    -- setting filter on downscale and upscale to nearest to avoid blurring images
   love.graphics.setDefaultFilter('nearest', 'nearest') 

    -- setting title for the window that will be displayed
   love.window.setTitle('Flappy Bird')

   -- setting up virtual resolution with push library
   push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    vsync = true,
    fullscreen = false,
    resizable = true,
   })
end

-- redirecting resize to push 
function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    -- defining escape key to exit game
    if key == 'escape' then
        love.event.quit()
    end
end

function love.update(dt)
    -- the variables offset the images giving the illusion that one is moving faster than the other
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH
end

function love.draw()
    -- signals push to start rendering
    push:start()

    love.graphics.draw(background, -backgroundScroll, 0)
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    bird:render()

    -- signals push to end rendering
    push:finish()
end
