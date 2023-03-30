PauseState = Class{__includes = BaseState}

function PauseState:enter(params)
    SCROLLING = false
    self.params = params
end

function PauseState:update(dt)
    if love.keyboard.wasPressed("space") or love.mouse.wasPressed(1) then
        gStateMachine:change("countdown", self.params)
    end
end

function PauseState:render()
    love.graphics.setFont(bigFont)
    love.graphics.printf("Game Paused!", 0, VIRTUAL_HEIGHT / 5, VIRTUAL_WIDTH, "center")

    love.graphics.setFont(hugeFont)
    love.graphics.printf("Score: " ..tostring(self.params.score), 0, VIRTUAL_HEIGHT / 2 - 40, VIRTUAL_WIDTH, "center")

    love.graphics.setFont(mediumFont)
    love.graphics.printf("Press 'space' or click to resume playing!", 0, VIRTUAL_HEIGHT / 2 + 40, VIRTUAL_WIDTH, "center")
end
