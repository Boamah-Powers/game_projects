-- StartState class

-- StartState inherits from BaseState
StartState = Class{__includes = BaseState}

-- shows which option is highlighted
local highlighted = 1

function StartState:update(dt)
    -- toggle highlighted option if arrow key up or down is pressed
    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
        highlighted = highlighted == 1 and 2 or 1
        gSounds['paddle-hit']:play()
    end

    -- confirm option on start screen
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gSounds['confirm']:play()

        if highlighted == 1 then
            gStateMachine:change('play')
        end
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function StartState:render()
    -- title
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf("BREAKOUT", 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')

    -- instructions
    love.graphics.setFont(gFonts['medium'])

    -- if we're highlighting 1, render that option blue
    if highlighted == 1 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.printf("START", 0, VIRTUAL_HEIGHT / 2 + 70, VIRTUAL_WIDTH, 'center')

    -- reset the color
    love.graphics.setColor(1, 1, 1, 1)

    -- render option 2 blue if we're highlighting that one
    if highlighted == 2 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.printf("HIGH SCORES", 0, VIRTUAL_HEIGHT / 2 + 90, VIRTUAL_WIDTH, 'center')

    -- reset the color
    love.graphics.setColor(1, 1, 1, 1)
end