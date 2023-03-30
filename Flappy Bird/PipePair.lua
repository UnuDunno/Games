PipePair = Class{}

local GAP_HEIGHT = 90

function PipePair:init(y)
    self.scored = false

    self.x = VIRTUAL_WIDTH + 32
    self.y = y

    -- pipes that form a pair
    self.pipes = {
        ["upper"] = Pipe("top", self.y),
        ["lower"] = Pipe("bottom", self.y + PIPE_HEIGHT + GAP_HEIGHT)
    }

    -- controlls whether the pipe pair is ready to be removed from the screen
    self.remove = false
end

function PipePair:update(dt)
    if self.x > -PIPE_WIDTH then
        self.x = self.x - PIPE_SPEED * dt
        self.pipes["upper"].x = self.x
        self.pipes["lower"].x = self.x
    else
        self.remove = true
    end
end

function PipePair:render()
    for l, pipe in pairs(self.pipes) do
        pipe:render()
    end
end
