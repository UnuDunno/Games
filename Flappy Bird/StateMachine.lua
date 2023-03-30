--[[

]]

StateMachine = Class{}

function StateMachine:init(state)
    self.empty = {
        enter = function() end,
        update = function() end,
        render = function() end,
        exit = function() end
    }

    self.states = state or self.empty
    self.current = self.empty
end

function StateMachine:change(stateName, params)
    assert(self.states[stateName])
    self.current:exit()
    self.current = self.states[stateName]()
    self.current:enter(params)
end

function StateMachine:update(dt)
    self.current:update(dt)
end

function StateMachine:render()
    self.current:render()
end
