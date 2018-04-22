local gameplay = {}

local time = 10
local gameover = false
local changeToState

local hand = love.graphics.newImage('img/hand.png')
local handx = 20
local handy = 475

function gameplay.keyreleased(key)
    if gameover and changeToState ~= nil then
        changeToState('states.menu')
    else
        if key == 'left' then
            handx = handx - 125
        elseif key == 'right' then
            handx = handx + 125
        end 
    end 
end

function gameplay.draw()
    love.graphics.print( math.floor(time), 20, 15)

    love.graphics.draw( hand, handx, handy )

    if gameover then
        love.graphics.print("GAME OVER, DUDE", 400, 300)
    end
end

function gameplay.update(dt)
    if time < 0 then 
        gameover = true
    else
        time = time - dt
    end
end

function gameplay.setChangeToState(cts)
    changeToState = cts
end

return gameplay
