local menu = {} 

local changeToState

function menu.update(dt)
    
end

function menu.draw()
   love.graphics.print("Skkk eae man", 400, 300) 
end

function menu.keyreleased(key)
    if changeToState ~= nil then
        changeToState('states.gameplay')
    end
end

function menu.setChangeToState(cts)
    changeToState = cts
end

return menu
