-- creating the pipepair class from the 
-- class library
PipePair = Class{}

-- determines the gap between pipes
GAP_HEIGHT = math.random(90,100)

-- PipePair init function
function PipePair:init(y)
    -- initializes pipe past the right edge of the screen
    self.x = VIRTUAL_WIDTH + 32

    -- y value of the topmost pipe
    self.y = y

    -- creating two pipes that belong to the same pair
    self.pipes = {
        ['upper'] = Pipe('top', self.y),
        ['lower'] = Pipe('lower', self.y + PIPE_HEIGHT + GAP_HEIGHT),
    }
    GAP_HEIGHT = math.random(90,100)

    -- flag for whether the pair of pipes has gone past the left edge
    self.remove = false

    -- whether bird has flown past the pair of pipes
    self.scored = false
end

function PipePair:update(dt)
    -- remove pair of pipes if it has gone past the left edge
    -- else update its position
    if self.x > -PIPE_WIDTH then
        self.x = self.x + PIPE_SCROLL_SPEED * dt
        self.pipes['lower'].x = self.x
        self.pipes['upper'].x = self.x
    else
        self.remove = true
    end
end

function PipePair:render()
    for k, pipe in pairs(self.pipes) do
        pipe:render()
    end
end