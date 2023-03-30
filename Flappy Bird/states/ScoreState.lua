ScoreState = Class{__includes = BaseState}

function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
        gStateMachine:change("countdown")
    end
end

function ScoreState:render()
    love.graphics.setFont(bigFont)
    love.graphics.printf("Nice try!", 0, 64, VIRTUAL_WIDTH, "center")

    love.graphics.setFont(hugeFont)
    love.graphics.printf("Score: " .. tostring(self.score), 0, VIRTUAL_HEIGHT / 2 - 30, VIRTUAL_WIDTH, "center")

    love.graphics.setFont(mediumFont)
    love.graphics.printf("Press Enter to Play Again!", 0, VIRTUAL_HEIGHT - 60, VIRTUAL_WIDTH, "center")
end
