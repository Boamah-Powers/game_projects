-- creating the pipe class from the 
-- class library
Pipe = Class{}

-- loading pipe image
local PIPE_IMAGE = love.graphics.newImage('pipe.png')

-- determines how fast pipes scroll
PIPE_SCROLL_SPEED = -60

-- height and width of pipe image
PIPE_HEIGHT = PIPE_IMAGE:getHeight()
PIPE_WIDTH = PIPE_IMAGE:getWidth()

-- Pipe init function
function Pipe:init(orientation, y) 
    -- sets the x and y coordinates of the pipe
    self.x = VIRTUAL_WIDTH
    self.y = y

    -- gets width of the pipe
    self.width = PIPE_WIDTH
    self.height = PIPE_HEIGHT

    -- orientation of the pipe
    self.orientation = orientation
end

-- updates the position of the pipe
function Pipe:update(dt)

end

-- draws pipe to screen
function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, self.x, 
        (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y), 
        0, 1, self.orientation == 'top' and -1 or 1)
end