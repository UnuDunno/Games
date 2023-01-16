--[[
    Represents a paddle that is used to reflect the ball
]]

PADDLE = CLASS{}

function PADDLE:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    -- paddle y velocity
    self.dy = 0

    -- determines the rate in which the ball speed will be increased
    self.reflect_speed = 1.03
end

--[[
    Updates the paddle position since last frame,
    position is updated based on dt (deltaTime)
]]
function PADDLE:update(dt)
    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt)
    else
        self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy * dt)
    end
end

function PADDLE:render()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end
