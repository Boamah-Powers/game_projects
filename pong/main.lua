--[[
    My Attempt at recreating the popular pong game
]]

-- Dimension for window size
WINDOW_HEIGHT = 720
WINDOW_WIDTH = 1280

-- Dimension to be implemented by push to give retro feel
VIRTUAL_HEIGHT = 243
VIRTUAL_WIDTH = 432

-- Including the push library for virtual dimensions
push = require 'push'

-- Including the class library to enable syntax similar to that used in other languages
Class = require 'class'

-- Paddle class for paddle logic
require 'Paddle'

-- Ball class for ball logic
require 'Ball'

-- Speed at which paddles will be moved
PADDLE_SPEED = 200

-- Load function provided by love
function love.load()
    -- Setting the filter for either minimized or maximized window to nearest to preserve retro feel
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Seeding the random number generator to prevent generating same numbers
    math.randomseed(os.time())

    -- Set title for the window
    love.window.setTitle('Pong')

    -- loading font for welcome message
    smallFont = love.graphics.newFont('font.ttf', 8)

    -- loading font for message display
    largeFont = love.graphics.newFont('font.ttf', 26)

    -- loading font for scores
    scoreFont = love.graphics.newFont('font.ttf', 32)

    -- setting font
    love.graphics.setFont(smallFont)

    -- loading sound effects
    sounds =  {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
    }

    -- Setting up screen to use virtual dimensions
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen =  false,
        resizable = true,
        vsync = true,
    })

    -- Initializing variables to keep track of player scores
    player1Score = 0
    player2Score = 0

    -- Initialize variable to keep track of which player serves
    servingPlayer = 1

    -- Intializing paddle objects
    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)

    -- Intializing ball at the center of the screen
    ball = Ball(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2, 4, 4)

    -- game state variable used to transition between different parts of the game
    gameState = 'start'
end


function love.resize(w,h)
    push:resize(w,h)
end

-- Update function that updates the state of the game
function love.update(dt)
    -- checks if game state is serving and determines which direction to move
    if gameState == 'serve' then
        ball.dy = math.random(-50, 50)
        if servingPlayer == 1 then
            ball.dx = math.random(140,200)
        else
            ball.dx = -math.random(140, 200)
        end
    -- moving ball only when in play state
    elseif gameState == 'play' then
        ball:update(dt)

        -- check if ball has collided and update the direction of the ball
        if ball:collides(player1) then
            ball.dx = -ball.dx * 1.03 -- reverses direction in the X axis and increases speed
            ball.x = player1.x + 5    -- shifts position to avoid getting stuch in an infinite loop

            -- reflects ball in the same direction by different angle
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150) 
            else
                ball.dy = math.random(10, 150)
            end

            sounds['paddle_hit']:play()

        end
        if ball:collides(player2) then
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x - 4

            -- reflects ball in the same direction by different angle
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end

            sounds['paddle_hit']:play()

        end

        -- Checks if player 1 missed the ball, updates player 2 score and resets ball
        if ball.x < 0 then
            -- updating serving player and score of opponent
            servingPlayer = 1
            player2Score = player2Score + 1
            sounds['score']:play()

            -- checks winning condition 
            if player2Score == 10 then
                winningPlayer = 2
                gameState = 'done'
            else
                gameState = 'serve'
                ball:reset()
            end
        end

        if ball.x > VIRTUAL_WIDTH then
            servingPlayer = 2
            player1Score = player1Score + 1
            sounds['score']:play()

            if player1Score == 10 then
                winningPlayer = 3
                gameState = 'done'
            else
                gameState = 'serve'
                ball:reset()
            end
        end
    end

    -- player 1 movement
    if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end

    -- player 2 movement
    if love.keyboard.isDown('up') then
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end

    -- updating paddle state
    player1:update(dt)
    player2:update(dt)

end

-- Function by love to track key events
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
        elseif gameState == 'done' then
            gameState = 'serve'

            -- ball's new reset method
            ball:reset()

            -- resetting scores to 0
            player1Score = 0
            player2Score = 0

            -- setting the serving player to the loser of previous game for fairness
            if winningPlayer == 1 then
                servingPlayer = 2
            else
                servingPlayer = 1
            end
        end
    end
end


function love.draw()
    -- begin rendering at virtual resolution
    push:apply('start')

    -- formatting the screen with grey background
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    -- draw different things based on the state of the game
    love.graphics.setFont(smallFont)

    displayScore()

    if gameState == 'start' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Welcome to Pong!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to begin!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Player ' .. tostring(servingPlayer) .. "'s serve!", 
            0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to serve!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'play' then
        -- no UI messages to display in play
    elseif gameState == 'done' then
        -- UI messages
        love.graphics.setFont(largeFont)
        love.graphics.printf('Player ' .. tostring(winningPlayer) .. ' wins!',
            0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to restart!', 0, 30, VIRTUAL_WIDTH, 'center')
    end
    -- render paddles
    player1:render()
    player2:render()

    -- render ball
    ball:render()

    -- end rendering at virtual resolution
    push:apply('end')
end

function displayScore()
    -- print score on the left and right center of the screen
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, 
        VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30,
        VIRTUAL_HEIGHT / 3)
end