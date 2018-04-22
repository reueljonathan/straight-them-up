local stateMachine 

function love.load()
    stateMachine = require 'stateMachine'
    stateMachine.changeToState 'states.menu'
end

function love.draw()
    stateMachine.draw()
end

function love.update(t)
    stateMachine.update(t)
end

function love.keyreleased(key)
    stateMachine.keyreleased(key)
end
