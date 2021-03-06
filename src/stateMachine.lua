local stateMachine = {}

local actualState

function stateMachine.changeToState(state)
    actualState = require(state)
    actualState.setChangeToState( stateMachine.changeToState ) 
    actualState.reset()
end

function stateMachine.update(dt)
    actualState.update(dt)
end

function stateMachine.draw()
    actualState.draw()
end

function stateMachine.keyreleased(key)
    actualState.keyreleased(key)
end

function stateMachine.keypressed(key)
    actualState.keypressed(key)
end
return stateMachine
