local menu = {} 

local changeToState
local background, presskeyImg, titleImg

local pressAlphaTime, alphaRad

function menu.reset()
    background = love.graphics.newImage('img/menu.png')
    presskeyImg = love.graphics.newImage('img/presskey.png')
    titleImg = love.graphics.newImage('img/title.png')
    pressAlphaTime = 0
    alphaRad = 0
end

function menu.update(dt)
    pressAlphaTime = pressAlphaTime + dt 
    if pressAlphaTime > 0.012 then -- 12ms
        alphaRad = alphaRad + 0.1
        
        if alphaRad > 6.28 then alphaRad = 0 end

        pressAlphaTime = 0
    end 
end

function menu.draw()
    love.graphics.draw(background, 0, 0)
    love.graphics.setColor(1,1,1, 1 + math.sin(alphaRad))
    love.graphics.draw(presskeyImg, 253, 470)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(titleImg, 107, 100)
end

function menu.keypressed(key)
    if changeToState ~= nil then
        changeToState('states.gameplay')
    end
end

function menu.keyreleased(key)

end

function menu.setChangeToState(cts)
    changeToState = cts
end


return menu
