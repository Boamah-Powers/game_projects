-- Paddle class

Paddle = Class{}

function Paddle:init()
    -- x is placed in the middle
    self.x = VIRTUAL_WIDTH / 2 - 32

    -- y is placed a little above the bottom edge of the screen
    self.y = VIRTUAL_HEIGHT - 32

    -- start with no velocity
    self.dx = 0

    -- starting dimension
    self.width = 64
    self.height = 16

    -- the skin only has the effect of changing color
    self.skin = 1

    -- size variant
    self.size = 2
end

function Paddle:update(dt)
    -- keyboard input
    if love.keyboard.isDown('left') then
        self.dx = -PADDLE_SPEED
    elseif love.keyboard.isDown('right') then
        self.dx = PADDLE_SPEED
    else 
        self.dx = 0
    end

    -- movement
    if self.dx < 0 then
        self.x = math.max(0, self.x + self.dx * dt)
    else
        self.x = math.min(VIRTUAL_WIDTH - self.width, self.x + self.dx * dt)
    end
end

function Paddle:render()
    love.graphics.draw(gTextures['main'], gFrames['paddles'][self.size + 4 * (self.skin - 1)],
                        self.x, self.y)
end