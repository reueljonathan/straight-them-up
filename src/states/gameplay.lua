local gameplay = {}

local time = 60
local startTime, starting
local points = 0
local gameover = false
local changeToState

local fontHud
local background, cardsImg
local shuffler = {}
local handx = 324
local handy = 475

local suits = {'heart', 'diamond', 'club', 'spade'}
local values = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13} 
local cards = {}

local enemies
local bullets

local frameTime = 1/60-- forcing 60fps

local currentFrame

local message, combination

local combinationTime, combinationAlpha

function randomizeCards() 
    return  { {suit = suits[math.random(4)], value = values[math.random(12)]}} 
end

function randomizePlayerCards(player)
    player.cards = {
        {
            x=nil,
            y=nil,
            suit = suits[math.random(4)],
            value = values[math.random(12)],
            width = 25,
            height = 36
        },
        {
            x=nil,
            y=nil,
            suit = suits[math.random(4)],
            value = values[math.random(12)],
            width = 25,
            height = 36
        }
    } 
end

function isFlush(hand) 
    for i=1, 4 do
        if hand[i].suit ~= hand[i+1].suit then
            return false
        end 
    end 
    return true
end

function isRoyalStraight(hand)
    return (
        hand[1].value == 1 and  -- A
        hand[2].value == 10 and -- 10
        hand[3].value == 11 and -- J
        hand[4].value == 12 and -- Q
        hand[5].value == 13 )   -- K
end

function isStraight(hand)
    for i=1, 4 do
        if hand[i].value ~= (hand[i+1].value-1) then
            return false
        end
    end 
    return true
end

function isFourOfKind(hand)
    return (
        hand[1].value == hand[2].value and
        hand[2].value == hand[3].value and
        hand[3].value == hand[4].value
    ) or (
        hand[2].value == hand[3].value and
        hand[3].value == hand[4].value and
        hand[4].value == hand[5].value
    )
end

function isFullHouse(hand)
    return (
        hand[1].value == hand[2].value and
        hand[3].value == hand[4].value and
        hand[4].value == hand[5].value
    ) or (
        hand[1].value == hand[2].value and
        hand[2].value == hand[3].value and
        hand[4].value == hand[5].value
    )
end

function isThreeOfKind(hand)
    return (
        hand[1].value == hand[2].value and
        hand[2].value == hand[3].value 
    ) or ( 
        hand[2].value == hand[3].value and
        hand[3].value == hand[4].value
    ) or (
        hand[3].value == hand[4].value and
        hand[4].value == hand[5].value
    )
end

function isTwoPairs(hand)
    return (
        hand[1].value == hand[2].value and
        hand[3].value == hand[4].value
    ) or (
        hand[1].value == hand[2].value and
        hand[4].value == hand[5].value
    ) or (
        hand[2].value == hand[3].value and
        hand[4].value == hand[5].value 
    )
end

function isPair(hand)
    for i=1, 4 do
        if hand[i].value == hand[i+1].value then
            return true
        end
    end

    return false
end

function getSubgroup(hand, start, size)
    local subgroup = {}

    for i=1, size do
        subgroup[i] = hand[start+i-1]
    end

    return subgroup
end

function searchCombinations(hand)    
    -- It is very important to sort the list (the hand) in ascending order,
    -- because all the following functions consider that
    -- when searching for the poker combinations 
    table.sort( hand, function (a,b)
        return a.value < b.value
    end)

    for i=1, 3 do
        local subhand = getSubgroup(hand, i, 5)
        
        if isFlush(subhand) and isRoyalStraight(subhand) then
            print('royal flush')
            for j=1, #hand do
                print('  '..hand[j].value .. ' '.. hand[j].suit)
            end
            return 512, 'ROYAL FLUSH! +512'
        end
    end
   
    for i=1, 3 do
        local subhand = getSubgroup(hand, i, 5)
        
        if isFlush(subhand) and isStraight(subhand) then
            print('straight flush')
            for j=1, #hand do
                print('  '..hand[j].value .. ' '.. hand[j].suit)
            end
            return 216, 'STRAIGHT FLUSH! +216'
        end
    end
 
    for i=1, 3 do
        local subhand = getSubgroup(hand, i, 5)
        if isFourOfKind(subhand) then
            print('foak')
            for j=1, #hand do
                print('  '..hand[j].value .. ' '.. hand[j].suit)
            end
            return 128, 'FOUR OF A KIND! +128'
        end
    end

    for i=1, 3 do
        local subhand = getSubgroup(hand, i, 5)
        
        if isFullHouse(subhand) then
            print('full house')
            for j=1, #hand do
                print('  '..hand[j].value .. ' '.. hand[j].suit)
            end
            return 64, 'FULL HOUSE! +64'
        end
    end

    for i=1, 3 do
        local subhand = getSubgroup(hand, i, 5)
        
        if isFlush(subhand) then
            print('flush')
            for j=1, #hand do
                print('  '..hand[j].value .. ' '.. hand[j].suit)
            end
            return 32, 'FLUSH! +32'
        end
    end

    for i=1, 3 do
        local subhand = getSubgroup(hand, i, 5)
        
        if isStraight(subhand) then
            print('straight')
            for j=1, #hand do
                print('  '..hand[j].value .. ' '.. hand[j].suit)
            end
            return 16, 'STRAIGHT! + 16'
        end
    end

    for i=1, 3 do
        local subhand = getSubgroup(hand, i, 5)
        
        if isThreeOfKind(subhand) then
            print('toak')
            for j=1, #hand do
                print('  '..hand[j].value .. ' '.. hand[j].suit)
            end
            return 8, 'THREE OF A KIND! +8'
        end
    end

    for i=1, 3 do
        local subhand = getSubgroup(hand, i, 5)
        
        if isTwoPairs(subhand) then
            print('two pairs')
            for j=1, #hand do
                print('  '..hand[j].value .. ' '.. hand[j].suit)
            end
            return 4, 'TWO PAIRS! +4'
        end
    end

    for i=1, 3 do
        local subhand = getSubgroup(hand, i, 5)
        
        if isPair(subhand) then
            print('pair')

            for j=1, #hand do
                print('  '..hand[j].value .. ' '.. hand[j].suit)
            end

            return 2, 'PAIR! +2'
        end
    end


    print('high card')
    return 1, 'HIGH CARD! +1'
end

function gameplay.reset()
    currentFrame = 0
    time = 60
    points = 0
    gameover = false
    background = love.graphics.newImage('/img/background.png')
    cardsImg = love.graphics.newImage('/img/cards.png')
    fontHud = love.graphics.setNewFont('/fonts/Comfortaa-Regular.ttf', 25)
    starting = true
    startTime = 4
    combinationAlpha = 1
    combinationTime = 0

    shuffler = {
        img = love.graphics.newImage('/img/shuffler.png'),
        x = 400-18,
        y = 500,
        cards = {},
        firedCards=0,
        firing = false,
        timeFromLastShoot = 0,
        timeReloading = 0,
        update = function(self, dt)
            if love.keyboard.isDown('left') and self.x > 20 then
                self.x = self.x - 5
            elseif love.keyboard.isDown('right') and self.x < 750 then
                self.x = self.x + 5
            end

            if self.firing and not self.reloading then
                if self.firedCards == 0 then
                    local copy = {
                        x = self.x + 3,
                        y = self.y + 2,
                        value = self.cards[1].value,
                        suit = self.cards[1].suit,
                        width = self.cards[1].width,
                        height = self.cards[1].height     
                    }
                    
                    --bullets = {}
                    table.insert( bullets, copy)
                    self.firedCards =  1
                elseif self.firedCards == 1 then
                    self.timeFromLastShoot = self.timeFromLastShoot + dt
                    
                    if self.timeFromLastShoot > 0.05 then -- if 50ms from last shoot
                        local copy = {
                            x = self.x + 3,
                            y = self.y + 2,
                            value = self.cards[2].value,
                            suit = self.cards[2].suit,
                            width = self.cards[2].width,
                            height = self.cards[2].height     
                        }
                        table.insert( bullets, copy)
                        self.timeFromLastShoot = 0
                        self.firedCards = 2 
                    end
                else
                    self.firing = false
                    self.firedCards = 0
                    self.reloading = true             
                    randomizePlayerCards(self)
                end 
            end
            
            if self.reloading then
                self.timeReloading = self.timeReloading + dt
                
                if self.timeReloading > 1.5 then
                    self.reloading = false
                    self.timeReloading = 0
                end
            end
        end
    }

    enemies = {}
    bullets = {}

    for i=1, 5 do
        table.insert(enemies, createEnemie())
    end

    handx = 2
    cards = {}
    
    randomizePlayerCards(shuffler)

end

function gameplay.keyreleased(key)

end

function gameplay.keypressed(key)
    if gameover and changeToState ~= nil then
        changeToState('states.menu')
    else
        if key == 'up' then
            print('fire!')
            if not shuffler.firing and not shuffler.reloading then
                shuffler.firing = true
            end
        end 
    end 
end

function drawCard(value, suit, x, y)
    local cardQuad, line, column

    if suit == 'heart' then
        line = 0
    elseif suit == 'diamond' then
        line = 1
    elseif suit == 'spade' then
        line = 2
    else
        line = 3
    end

    column = value-1

    cardQuad = love.graphics.newQuad(column*25, line*36, 25, 36, cardsImg:getDimensions())

    love.graphics.draw(cardsImg, cardQuad, x, y)
end

function collide(a, b)
    return  a.x < b.x+b.width and
            a.x + a.width > b.x and
            a.y < b.y + b.height and
            a.y + a.height > b.y
end

function createEnemie()
    local e = {
        x = math.floor( math.random() *760) + 20,
        y = math.floor( math.random() *200 ) + 20,
        width = 25,
        height = 36,
        update = function(self, dt)
            self.x = self.x + 1

            if(self.x > 800) then
                self.x = -25
            end

            for i=1, #bullets do
                if not bullets[i].isDead and collide(self, bullets[i]) then
                    local copy = {
                        x = bullets[i].x,
                        y = bullets[i].y,
                        width = bullets[i].width,
                        height = bullets[i].height,
                        value = bullets[i].value,
                        suit = bullets[i].suit 
                    }
                    table.insert(self.cards, copy)
                    bullets[i].isDead = true
                end 
            end
        end,
        cards = randomizeCards()
    }
    return e
end

function removeDeadBullets(bullets)
    local new = {}
    
    for i=1, #bullets do
        if not bullets[i].isDead then
            table.insert( new, bullets[i] )
        end
    end
    
    return new
end

function gameplay.draw()
    love.graphics.draw(background, 0, 0)
    
    love.graphics.print( 'time: '.. math.floor(time), 20, 15)
    love.graphics.print( 'points: ' .. points, 150, 15)

    for i=1, #enemies do 
        for j=1, #enemies[i].cards do
            drawCard( enemies[i].cards[j].value, enemies[i].cards[j].suit, enemies[i].x, enemies[i].y + (j-1)*15)
        end
    end

    for i=1, #bullets do
        if bullets[i] and not bullets[i].isDead then
            drawCard( bullets[i].value, bullets[i].suit, bullets[i].x, bullets[i].y)
        end
    end
    
    if #shuffler.cards > 0 then
        drawCard(shuffler.cards[1].value, shuffler.cards[1].suit, shuffler.x + 3, shuffler.y+2)
    end
    love.graphics.draw(shuffler.img, shuffler.x, shuffler.y)
    
    for i=1, #shuffler.cards do
       drawCard(shuffler.cards[i].value, shuffler.cards[i].suit, shuffler.x - 12 + (i-1)*30, shuffler.y + 60) 
    end

    if gameover then
        love.graphics.print("GAME OVER!", 370, 300)
    end

    love.graphics.print( tostring(love.timer.getFPS()), 750, 20)
    
    if starting then
        if math.floor(startTime) == 0 then
            love.graphics.print( 'GO!', 370, 250)
        else
            love.graphics.print( math.floor(startTime), 390, 250)
        end
    end
    
    if showCombinationType then
        love.graphics.setColor(1,1,1, 1-(combinationAlpha*combinationAlpha*combinationAlpha*combinationAlpha)) -- 1 - alpha^4
        love.graphics.print(combinationType, 300,  20)
        love.graphics.setColor(1,1,1,1)
    end
        
end

function gameplay.update(dt)
    if starting and startTime > 0 then
        startTime = startTime - dt 
        return
    else
       starting = false
    end

    if time < 0 then 
        gameover = true
    else
        time = time - dt
    end

    if not gameover then
        if currentFrame + dt > frameTime then -- trying to force 60fps, i really don't know if it works, no time to figure out now. =(
            if #enemies < 1 then
                table.insert( enemies, createEnemie() )
            end

            for i=1, #enemies do
                if #enemies[i].cards == 7 then
                    local addPoints

                    addPoints, combinationType = searchCombinations(enemies[i].cards)
                    points = points + addPoints
                    enemies[i].cards = randomizeCards()
                    showCombinationType = true
                    combinationAlpha = 0
                else
                    enemies[i]:update(currentFrame + dt)
                end
            end
        
 
            for i=1, #bullets do
                if bullets[i] and not bullets[i].isDead then
                    bullets[i].y = bullets[i].y - 7
            
                    if bullets[i].y < -35 then
                        bullets[i].isDead = true 
                    end
                end
            end
            
            bullets = removeDeadBullets(bullets)
        

            shuffler:update(currentFrame + dt)
            currentFrame = 0
            drawFrame = true
            
            if showCombinationType then
                combinationTime = combinationTime + dt

                if combinationTime > 0.005 then
                    combinationAlpha = combinationAlpha + 0.1 
                    combinationTime = 0
                end
                 
                if combinationAlpha == 1 then
                    showCombinationType = false
                end
            end
        else
            currentFrame = currentFrame + dt 
        end
    end
    
end

function gameplay.setChangeToState(cts)
    changeToState = cts
end

return gameplay
