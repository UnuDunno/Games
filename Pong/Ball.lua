--[[
    Represents a ball that bounces back and forth when colliding with paddles
    or walls
]]

Ball = CLASS{}

function Ball:init(x, y, width, height)
    -- ball dimensions
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    -- ball velocity
    self.dx = 0
    self.dy = 0
end

--[[
    Receives a paddle as parameter and check if
    there is a collision between the ball and
    the paddle
]]
function Ball:collision(paddle)
    if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
        return false
    elseif self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
        return false
    end

    return true
end

--[[
    Resets position to the middle of the screen
    with 0 velocity
]]
function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - self.width / 2
    self.y = VIRTUAL_HEIGHT / 2 - self.height / 2
    self.dx = 0
    self.dy = 0
end

--[[
    Updates the ball position since last frame,
    position is updated based on dt (deltaTime)
]]
function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    -- check if ball is inside y screen limits
    if self.y > VIRTUAL_HEIGHT - self.height then
        self.y = VIRTUAL_HEIGHT - self.height
        self.dy = -self.dy

        SOUNDS["wall_hit"]:play()
    elseif self.y < 0 then
        self.y = 0
        self.dy = -self.dy
        
        SOUNDS["wall_hit"]:play()
    end
end

function Ball:render()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end
