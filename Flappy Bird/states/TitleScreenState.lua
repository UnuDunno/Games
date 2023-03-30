--[[
    TitleScreenState display the Title on the screen
]]

TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:update(dt)
    if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
        gStateMachine:change("countdown")
    end
end

function TitleScreenState:render()
    love.graphics.setFont(bigFont)
    love.graphics.printf("Welcome to", 0, 64, VIRTUAL_WIDTH, "center")

    love.graphics.setFont(hugeFont)
    love.graphics.printf("FBird Project!", 0, 120, VIRTUAL_WIDTH, "center")

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Press Enter to play!', 0, 220, VIRTUAL_WIDTH, 'center')
end
