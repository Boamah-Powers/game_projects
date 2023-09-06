-- Paddle class to handle all paddle related activities

Paddle = Class{}

-- Paddle initialization called when Paddle object is instantiated
function Paddle:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = 0
end

-- Paddle update function to handle movement of paddle objects
function Paddle:update(dt)
    -- handles movement of paddle upwards 
    if self.dy < 0 then
        -- use of math.max avoids exceeding the screen border
        self.y = math.max(0, self.y + self.dy * dt)

    -- handles movement of paddle downwards
    else
        -- use of math.min avoids exceeding the screen border
        self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy * dt)
    end
end

-- Paddle render function to render the paddle on the canvas
function Paddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end