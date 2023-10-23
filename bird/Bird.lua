-- creating the bird class from the 
-- class library
Bird = Class{}

-- determines how fast the bird falls
local GRAVITY = 15

local ANTI_GRAVITY_CONSTANT = -3

-- init function of the bird class
function Bird:init()
    -- loading image of the bird
    self.image = love.graphics.newImage('bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    -- setting the x and y coordinates of the bird
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

    -- determines the rate at which bird falls
    self.dy = 0
end

-- performs AABB collision detection
function Bird:collides(pipe) 
    -- coordinates of the bird has been offset by 2 shrink the bounding box of the bird
    if (self.x + 2) + (self.width - 4) >= pipe.x and self.x + 2 <= pipe.x + PIPE_WIDTH then
        if (self.y + 2) + (self.height - 4) >= pipe.y and self.y + 2 <= pipe.y + PIPE_HEIGHT then
            return true
        end
    end

    return false
end

-- updates the state of the bird
function Bird:update(dt)
    -- increases the rate of fall
    self.dy = self.dy + GRAVITY * dt

    if love.keyboard.wasPressed('space') then
       self.dy = ANTI_GRAVITY_CONSTANT 
       sounds['jump']:play()
    end

    -- updating the y coordinate of the bird
    self.y = self.y + self.dy
end

-- draws the bird to the screen
function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end