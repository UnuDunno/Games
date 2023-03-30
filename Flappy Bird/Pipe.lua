Pipe = Class{}

PIPE_WIDTH = 70
PIPE_HEIGHT = 300

PIPE_SPEED = 60

local PIPE_IMAGE = love.graphics.newImage("images/pipe.png")

function Pipe:init(orientation, y)
    self.x = VIRTUAL_WIDTH + 64
    self.y = y

    self.width = PIPE_WIDTH
    self.height = PIPE_HEIGHT

    self.orientation = orientation
end

function Pipe:update(dt)
    
end

function Pipe:render()
    love.graphics.draw(
        PIPE_IMAGE,                                                     -- Image to be drawn
        self.x,                                                         -- X position
        self.orientation == "top" and self.y + PIPE_HEIGHT or self.y,   -- Y position
        0,                                                              -- Orientation
        1,                                                              -- X scale
        self.orientation == "top" and -1 or 1                           -- Y scale
    )
end
