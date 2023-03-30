--[[

]]

push = require "push"
Class = require "class"

require "StateMachine"
require "states.BaseState"
require "states.TitleScreenState"
require "states.CountdownState"
require "states.PlayState"
require "states.ScoreState"
require "states.PauseState"

require "Bird"
require "Pipe"
require "PipePair"

-- game window settings
WINDOW_WIDTH = 1920
WINDOW_HEIGHT = 1080

-- virtual window settings
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 300

local background = love.graphics.newImage("images/background.png")
local ground = love.graphics.newImage("images/ground.png")
-- parallax

-- -- speeds
local BACKGROUND_SPEED = 30
local GROUND_SPEED = 60

-- -- positions
local BACKGROUND_SCROLL = 0
local GROUND_SCROLL = 0

-- -- looping point
local BACKGROUND_LOOPING_POINT = 413

SCROLLING = true

function love.load()
    math.randomseed(os.time())

    love.graphics.setDefaultFilter("nearest", "nearest")

    love.window.setTitle("FBird Project")

    -- createing fonts
    smallFont = love.graphics.newFont("fonts/font.ttf", 8)
    mediumFont = love.graphics.newFont("fonts/flappy.ttf", 14)
    bigFont = love.graphics.newFont("fonts/flappy.ttf", 28)
    hugeFont = love.graphics.newFont("fonts/flappy.ttf", 56)

    love.graphics.setFont(bigFont)

    sounds = {
        ['jump'] = love.audio.newSource('audio/jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('audio/explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('audio/hurt.wav', 'static'),
        ['score'] = love.audio.newSource('audio/score.wav', 'static'),
        -- https://freesound.org/people/xsgianni/sounds/388079/
        ['music'] = love.audio.newSource('audio/marios_way.mp3', 'static')
    }

    -- start music
    sounds['music']:setLooping(true)
    sounds['music']:play()

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    gStateMachine = StateMachine {
        ["title"] = function() return TitleScreenState() end,
        ["countdown"] = function() return CountdownState() end,
        ["play"] = function() return PlayState() end,
        ["score"] = function() return ScoreState() end,
        ["pause"] = function() return PauseState() end
    }
    gStateMachine:change("title")

    -- keys pressed controller
    love.keyboard.keysPressed = {}

    -- mouse pressed controller
    love.mouse.buttonsPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == "escape" then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end

function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
end

function love.update(dt)
    if SCROLLING then
        BACKGROUND_SCROLL = (BACKGROUND_SCROLL + BACKGROUND_SPEED * dt) % BACKGROUND_LOOPING_POINT
        GROUND_SCROLL = (GROUND_SCROLL + GROUND_SPEED * dt) % VIRTUAL_WIDTH
    end

    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end

function love.draw()
    push:start()

    -- render background
    love.graphics.draw(background, -BACKGROUND_SCROLL, 0)

    gStateMachine:render()

    -- render ground
    love.graphics.draw(ground, -GROUND_SCROLL, VIRTUAL_HEIGHT - 15)

    push:finish()
end
