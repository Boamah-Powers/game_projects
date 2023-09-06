-- creating bird class from the class library
Bird = Class{}

-- defining the initialization of the bird class
function Bird:init()
    self.image = love.graphics.newImage('bird.png')
    self.width = self.image:getWidth()                  -- gets the width from the loaded image
    self.height = self.image:getHeight()                -- gets the height from the loaded image

    -- positioning the instantiated bird at the center of the screen
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)
end

-- function to draw bird to screen
function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end