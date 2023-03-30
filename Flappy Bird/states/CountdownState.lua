--[[
    Countdown State is used to display a countdown from 3 to 1 on the screen
]]

CountdownState = Class{__includes = BaseState}

COUNTDOWN_TIME = 0.75

function CountdownState:init()
    self.timer = 0
    self.count = 3
end

function CountdownState:update(dt)
    self.timer = self.timer + dt

    if self.timer > COUNTDOWN_TIME then
        self.timer = self.timer % COUNTDOWN_TIME

        self.count = self.count - 1

        if self.count == 0 then
            gStateMachine:change("play")
        end
    end
end

function CountdownState:render()
    love.graphics.setFont(hugeFont)
    love.graphics.printf(tostring(self.count), 0, VIRTUAL_HEIGHT / 2 - 40, VIRTUAL_WIDTH, "center")
end
