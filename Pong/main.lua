--[[

]]

-- push is a library that will allow us to draw our game at a virtual
-- resolution, instead of however large our window is; used to provide
-- a more retro aesthethic
--
-- https://github.com/Ulydev/push
PUSH = require "push"

-- the "Class" library we're using will allow us to represent anything in
-- ourt game as code, rather than keeping track of many disparate variables and
-- methods
--
-- https://github.com/vrld/hump/blob/master/class.lua
CLASS = require "class"

require 'Ball'
require 'Paddle'

-- game window settings
WINDOW_WIDTH = 1920
WINDOW_HEIGHT = 1080

-- virtual window settings
VIRTUAL_WIDTH = 500
VIRTUAL_HEIGHT = 300

-- paddle speed
PADDLE_SPEED = 200

-- maximum score
WINNING_SCORE = 10

function love.load()
    -- setting filter
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- seed for random
    math.randomseed(os.time())

    -- game window title
    love.window.setTitle("PONG Project!")

    -- fonts
    SMALLFONT = love.graphics.newFont("font.ttf", 8)
    LARGEFONT = love.graphics.newFont("font.ttf", 16)
    SCOREFONT = love.graphics.newFont("font.ttf", 24)
    TITLEFONT = love.graphics.newFont("font.ttf", 32)

    -- initialize our virtual resolution, which will be rendered within our
    -- actual window no matter its resolution
    PUSH:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    -- setup sound effects
    SOUNDS = {
        ["paddle_hit"] = love.audio.newSource("sounds/paddle_hit.wav", "static"),
        ["score"] = love.audio.newSource("sounds/score.wav", "static"),
        ["wall_hit"] = love.audio.newSource("sounds/wall_hit.wav", "static")
    }

    -- create pĺayers
    PLAYER1 = PADDLE(0, VIRTUAL_HEIGHT / 2 - 20, 5, 20)
    PLAYER2 = PADDLE(VIRTUAL_WIDTH - 5, VIRTUAL_HEIGHT / 2 - 20, 5, 20)

    -- create the ball
    BALL = Ball(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2, 4, 4)

    -- players scores
    PLAYER1SCORE = 0
    PLAYER2SCORE = 0

    -- serving player
    PLAYERSERVING = math.random(2)

    -- winner
    WINNER = 0

    -- set game initial state
    GameState = "start"
end

function love.update(dt)
    if GameState == "start" then
        BALL:reset()
    else
        -- player 1 movement
        if love.keyboard.isDown("w") then
            PLAYER1.dy = -PADDLE_SPEED
        elseif love.keyboard.isDown("s") then
            PLAYER1.dy = PADDLE_SPEED
        else
            PLAYER1.dy = 0
        end

        -- player 2 movement
        if love.keyboard.isDown("up") then
            PLAYER2.dy = -PADDLE_SPEED
        elseif love.keyboard.isDown("down") then
            PLAYER2.dy = PADDLE_SPEED
        else
            PLAYER2.dy = 0
        end

        if GameState == "serve" then
            -- define ball x velocity
            if PLAYERSERVING == 1 then
                BALL.dx = math.random(150, 180)
            else
                BALL.dx = -math.random(150, 180)
            end

            -- randomize inital ball dy
            BALL.dy = math.random(-100, 100)
        end

        if GameState == "play" then
            -- check for collisions between ball and paddles
            if BALL:collision(PLAYER1)then
                BALL.dx = -BALL.dx * PLAYER1.reflect_speed

                if BALL.dy > 0 then
                    BALL.dy = math.random(10, 150)
                else
                    BALL.dy = -math.random(10, 150)
                end

                SOUNDS["paddle_hit"]:play()
            elseif BALL:collision(PLAYER2) then
                BALL.dx = -BALL.dx * PLAYER2.reflect_speed

                if BALL.dy > 0 then
                    BALL.dy = math.random(10, 150)
                else
                    BALL.dy = -math.random(10, 150)
                end

                SOUNDS["paddle_hit"]:play()
            end

            -- check if ball is past the horizontal boundaries
            if BALL.x > (PLAYER2.x + PLAYER2.width) - BALL.width then
                -- player 1 scored
                PLAYERSERVING = 2
                PLAYER1SCORE = PLAYER1SCORE + 1

                if PLAYER1SCORE > WINNING_SCORE / 2 then
                    PLAYER1.x = PLAYER1.x + VIRTUAL_WIDTH / (2 * WINNING_SCORE)
                else
                    PLAYER2.reflect_speed = PLAYER2.reflect_speed + 0.02
                end

                if PLAYER1SCORE == WINNING_SCORE then
                    WINNER = 1
                    GameState = "done"
                else
                    GameState = "serve"
                end

                SOUNDS["score"]:play()

                BALL:reset()
            elseif BALL.x < PLAYER1.x then
                -- player 2 scored
                PLAYERSERVING = 1
                PLAYER2SCORE = PLAYER2SCORE + 1

                if PLAYER2SCORE > WINNING_SCORE / 2 then
                    PLAYER2.x = PLAYER2.x - VIRTUAL_WIDTH / (2 * WINNING_SCORE)
                else
                    PLAYER1.reflect_speed = PLAYER1.reflect_speed + 0.02
                end

                if PLAYER2SCORE == WINNING_SCORE then
                    WINNER = 2
                    GameState = "done"
                else
                    GameState = "serve"
                end

                SOUNDS["score"]:play()

                BALL:reset()
            end
        end

        if GameState == "play" then
            BALL:update(dt)
        end

        PLAYER1:update(dt)
        PLAYER2:update(dt)
    end
end

function love.resize(w, h)
    PUSH:resize(w, h)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "r" then
        resetGame()
    elseif key == "enter" or key == "return" then
        if GameState == "start" then
            GameState = "serve"
        elseif GameState == "rules" then
            GameState = "start"
        elseif GameState == "serve" then
            GameState = "play"
        elseif GameState == "done" then
            local temp = WINNER == 1 and 2 or 1
            resetGame()
            
            PLAYERSERVING = temp
            GameState = "serve"
        end
    elseif GameState == "start" and key == "h" then
        GameState = "rules"
    end
end

function love.draw()
    PUSH:start()

    -- Clear the screen
    love.graphics.clear(0/255, 0/255, 0/255, 255/255)

    if GameState == "start" then
        -- Main Title
        love.graphics.setFont(TITLEFONT)
        love.graphics.setColor(255/255, 0/255, 0/255, 255/255)
        love.graphics.printf("Welcome to", 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, "center")
        love.graphics.setColor(0/255, 0/255, 255/255, 255/255)
        love.graphics.printf("| PO", 0, VIRTUAL_HEIGHT / 3 + 35, VIRTUAL_WIDTH-80, "center")
        love.graphics.setColor(255/255, 0/255, 0/255, 255/255)
        love.graphics.printf("NG |", 0, VIRTUAL_HEIGHT / 3 + 35, VIRTUAL_WIDTH+90, "center")
        love.graphics.setColor(0/255, 0/255, 255/255, 255/255)
        love.graphics.printf("Project!", 0, VIRTUAL_HEIGHT / 3 + 70, VIRTUAL_WIDTH, "center")

        -- Start game message
        love.graphics.setFont(SMALLFONT)
        love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
        love.graphics.printf("Press Enter to play!", 0, VIRTUAL_HEIGHT - 80, VIRTUAL_WIDTH, "center")
        love.graphics.printf("Press h to see the rules :)", 0, VIRTUAL_HEIGHT - 40, VIRTUAL_WIDTH, "center")
    elseif GameState == "rules" then
        love.graphics.printf("This game follows the basic Pong rules, these rules being:", 50, 10, VIRTUAL_WIDTH, "left")
        love.graphics.printf("1. If the ball goes through one of the paddles, the opponent recieves a point", 50, 20, VIRTUAL_WIDTH, "left")
        love.graphics.printf("2. The first player to score 10 points wins", 50, 30, VIRTUAL_WIDTH, "left")
        love.graphics.printf("This version has two more rules though:", 50, 50, VIRTUAL_WIDTH, "left")
        love.graphics.printf("3. For scores up to 5, the opponent will reflect the ball faster for each point the player scores", 50, 60, VIRTUAL_WIDTH, "left")
        love.graphics.printf("4. For socres above 5, the player will be positioned forward, towards the center of the field, therefore reducing their field for each point the player scores", 50, 70, VIRTUAL_WIDTH, "left")
        love.graphics.printf("Press Enter to return to the main screen!", 50, VIRTUAL_HEIGHT - 40, VIRTUAL_WIDTH, "center")
    else
        -- Scoreboard
        displayScore()

        if GameState == "serve" then
            love.graphics.setFont(LARGEFONT)
            if PLAYERSERVING == 1 then
                love.graphics.setColor(0/255, 0/255, 255/255, 255/255)
            else
                love.graphics.setColor(255/255, 0/255, 0/255, 255/255)
            end
            love.graphics.printf("Player " .. tostring(PLAYERSERVING) .. "'s serve!", 0, 20, VIRTUAL_WIDTH, "center")
            love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
            love.graphics.setFont(SMALLFONT)
            love.graphics.printf("Press Enter to serve!", 0, 40, VIRTUAL_WIDTH, "center")

            love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
        end

        if GameState == "play" then
            love.graphics.setColor(0/255, 0/255, 255/255, 124/255)
            love.graphics.rectangle("fill", 0, 0, PLAYER1.x, VIRTUAL_HEIGHT)
            love.graphics.setColor(255/255, 0/255, 0/255, 124/255)
            love.graphics.rectangle("fill", PLAYER2.x + PLAYER2.width, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

            love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
        end

        if GameState == "done" then
            love.graphics.setFont(LARGEFONT)
            love.graphics.printf("Congratulations to the winner", 0, 20, VIRTUAL_WIDTH, "center")
            
            if WINNER == 1 then
                love.graphics.setColor(0/255, 0/255, 255/255, 255/255)
            else
                love.graphics.setColor(255/255, 0/255, 0/255, 255/255)
            end
            love.graphics.setFont(TITLEFONT)
            love.graphics.printf("Player " .. tostring(WINNER), 0, 40, VIRTUAL_WIDTH, "center")

            love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
            love.graphics.setFont(SMALLFONT)
            love.graphics.printf("Press Enter to start a new game!", 0, VIRTUAL_HEIGHT - 40, VIRTUAL_WIDTH, "center")
        end

        PLAYER1:render()
        PLAYER2:render()
    end

    love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
    BALL:render()

    displayFPS()

    PUSH:finish()
end

function displayScore()
    love.graphics.setFont(SCOREFONT)

    love.graphics.setColor(0/255, 0/255, 255/255, 255/255)
    love.graphics.print(tostring(PLAYER1SCORE), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.setColor(255/255, 0/255, 0/255, 255/255)
    love.graphics.print(tostring(PLAYER2SCORE), VIRTUAL_WIDTH / 2 + 40, VIRTUAL_HEIGHT / 3)

    love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
end

function displayFPS()
    love.graphics.setFont(SMALLFONT)
    love.graphics.setColor(0/255, 255/255, 0/255, 255/255)
    love.graphics.printf("FPS: " .. love.timer.getFPS(), 30, 0, VIRTUAL_WIDTH, "left")

    love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
end

function resetGame()
    -- reset player 1 stats
    PLAYER1.x = 0
    PLAYER1.reflect_speed = 1.03

    -- reset player 2 stats
    PLAYER2.x = VIRTUAL_WIDTH - 5
    PLAYER2.reflect_speed = 1.03

    -- reset score
    PLAYER1SCORE = 0
    PLAYER2SCORE = 0

    -- set winner to non existing player
    WINNER = 0

    -- define a random starting player
    PLAYERSERVING = math.random(2)

    GameState = "start"
end
