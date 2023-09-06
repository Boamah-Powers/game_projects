-- Ball class to handle all ball related events

Ball = Class{}

-- Ball initialization called when Ball object is instantiated
function Ball:init(x, y, width, height)
    self.x = x - width / 2
    self.y = y - height / 2
    self.width = width
    self.height = height

    -- Tracks the motion of the ball in the X and Y directions
    self.dx = math.random(2) == 1 and 100 or -100
    self.dy = math.random(-50, 50)
end

-- Places the ball at the center with random intial velocity on both axes
function Ball:reset() 
    self.x = VIRTUAL_WIDTH / 2 - self.width / 2
    self.y = VIRTUAL_HEIGHT / 2 - self.height / 2
    self.dx = math.random(2) == 1 and 100 or -100
    self.dy = math.random(-50, 50)
end

-- Ball collision detection with paddle function (returns boolean value)
function Ball:collides(paddle)
    -- checks if the ball isn't colliding with a paddle
    if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
        return false
    end

    if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
        return false
    end 

    -- returning true if overlapping
    return true
end

-- Ball update function 
function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    -- detect upper and lower screen boundary collision and reverse if collided
    if ball.y <= 0 then
        ball.y = 0
        ball.dy = -ball.dy
        sounds['wall_hit']:play()
    end

    -- -4 to account for the ball's size
    if ball.y >= VIRTUAL_HEIGHT - 4 then
        ball.y = VIRTUAL_HEIGHT - 4
        ball.dy = -ball.dy
        sounds['wall_hit']:play()
    end

end

function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end
