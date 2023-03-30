--[[
    PlayState is the state where the actual gameplay happens
]]

PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0
    self.score = 0

    -- initialize the last recorded Y for a gap placement to base other gaps off of
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
    self.timer = self.timer + dt

    -- spawn pipe pair
    if self.timer > 2 then
        -- modify the last Y coordinate placed so the pipe gaps aren't too far apart
        -- no higher than 10 pixels below the top edge of the screen
        -- no lower than a gap length (90 pixels) from the bottom
        local y = math.max(
            -PIPE_HEIGHT + 10,
            math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT)
        )

        self.lastY = y

        table.insert(self.pipePairs, PipePair(y))

        self.timer = 0
    end

    -- check for scored points
    for k, pair in pairs(self.pipePairs) do
        if not pair.scored then
            if pair.x + PIPE_WIDTH < self.bird.x then
                self.score = self.score + 1
                pair.scored = true
            end
        end

        pair:update(dt)
    end
 
    -- removing pipes that are past the screen
    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    -- checking for collisions
    for k, pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                gStateMachine:change("score", { score = self.score })
            end
        end
    end

    self.bird:update(dt)

    if self.bird.y > VIRTUAL_HEIGHT - 15 then
        gStateMachine:change("score", { score = self.score })
    end
end

function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(bigFont)
    love.graphics.print("Score: " .. tostring(self.score), 8, 8)

    self.bird:render()
end

function PlayState:enter()
    SCROLLING = true
end

function PlayState:exit()
    SCROLLING = false
end
