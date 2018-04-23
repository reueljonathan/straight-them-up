local gameplay = {}

local time = 90
local points = 0
local gameover = false
local changeToState

local background, cardsImg
local shuffler = {}
local handx = 324
local handy = 475

local suits = {'heart', 'diamond', 'club', 'spade'}
local values = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13} 
local cards = {}

local enemies
local bullets

function randomizeCards() 
    return  { {suit = suits[math.random(4)], value = values[math.random(12)]}} 
end

function randomizePlayerCards(player)
    player.cards = {
        {
            x=nil,
            y=nil,
            suit = suits[math.random(4)],
            value = values[math.random(12)]
        },
        {
            x=nil,
            y=nil,
            suit = suits[math.random(4)],
            value = values[math.random(12)]
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
            return
        end
    end
   
    for i=1, 3 do
        local subhand = getSubgroup(hand, i, 5)
        
        if isFlush(subhand) and isStraight(subhand) then
            print('straight flush')
            for j=1, #hand do
                print('  '..hand[j].value .. ' '.. hand[j].suit)
            end
            return
        end
    end

    for i=1, 3 do
        local subhand = getSubgroup(hand, i, 5)
        
        if isFourOfKind(subhand) then
            print('foak')
            for j=1, #hand do
                print('  '..hand[j].value .. ' '.. hand[j].suit)
            end
            return
        end
    end

    for i=1, 3 do
        local subhand = getSubgroup(hand, i, 5)
        
        if isFullHouse(subhand) then
            print('full house')
            for j=1, #hand do
                print('  '..hand[j].value .. ' '.. hand[j].suit)
            end
            return
        end
    end

    for i=1, 3 do
        local subhand = getSubgroup(hand, i, 5)
        
        if isFlush(subhand) then
            print('flush')
            for j=1, #hand do
                print('  '..hand[j].value .. ' '.. hand[j].suit)
            end
            return
        end
    end

    for i=1, 3 do
        local subhand = getSubgroup(hand, i, 5)
        
        if isStraight(subhand) then
            print('straight')
            for j=1, #hand do
                print('  '..hand[j].value .. ' '.. hand[j].suit)
            end
            return
        end
    end

    for i=1, 3 do
        local subhand = getSubgroup(hand, i, 5)
        
        if isThreeOfKind(subhand) then
            print('toak')
            for j=1, #hand do
                print('  '..hand[j].value .. ' '.. hand[j].suit)
            end
            return
        end
    end

    for i=1, 3 do
        local subhand = getSubgroup(hand, i, 5)
        
        if isTwoPairs(subhand) then
            print('two pairs')
            for j=1, #hand do
                print('  '..hand[j].value .. ' '.. hand[j].suit)
            end
            return
        end
    end

    for i=1, 3 do
        local subhand = getSubgroup(hand, i, 5)
        
        if isPair(subhand) then
            print('pair')

            for j=1, #hand do
                print('  '..hand[j].value .. ' '.. hand[j].suit)
            end

            return
        end
    end


    print('high card')
    return
end

function gameplay.reset()
    time = 90
    points = 0
    gameover = false
    background = love.graphics.newImage('/img/background.png')
    cardsImg = love.graphics.newImage('/img/cards.png')

    shuffler = {
        img = love.graphics.newImage('/img/shuffler.png'),
        x = 400-18,
        y = 500,
        cards = {},
        firedCards=0,
        firing = false,
        timeFromLastShoot = 0,
        update = function(self, dt)
            if love.keyboard.isDown('left') and self.x > 20 then
                self.x = self.x - 1
            elseif love.keyboard.isDown('right') and self.x < 750 then
                self.x = self.x + 1
            end

            if self.firing then
                if self.firedCards == 0 then
                    local b = self.cards[1] -- table.remove(self.cards, 1)
                    b.x = self.x + 3
                    b.y = self.y + 2
                    table.insert( bullets, b)
                    self.firedCards =  1
                elseif self.firedCards == 1 then
                    self.timeFromLastShoot = self.timeFromLastShoot + dt
                    
                    if self.timeFromLastShoot > 0.2 then -- if 200ms from last shoot
                        local b = self.cards[2] -- table.remove(self.cards, 1)
                        b.x = self.x + 3
                        b.y = self.y + 2
                        table.insert( bullets, b)
                        self.timeFromLastShoot = 0
                        self.firedCards = 2 
                    end
                else
                    self.firing = false             
                    self.firedCards = 0
                    randomizePlayerCards(self)
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
            if not shuffler.firing then
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

function createEnemie()
    local e = {
        x = math.floor( math.random() *760) + 20,
        y = math.floor( math.random() *200 ) + 20,
        update = function(self, dt)
            self.x = self.x + 0.1

            if(self.x > 800) then
                self.x = -25
            end

        end,
        cards = randomizeCards()
    }
    return e
end

function gameplay.draw()
    love.graphics.draw(background, 0, 0)
    
    love.graphics.print( math.floor(time), 20, 15)

    --love.graphics.draw( hand, 20+ (152*handx), handy )

    

    for i=1, #enemies do 
        for j=1, #enemies[i].cards do
            --love.graphics.draw(cardImg, 20+(i-1)*152, 30+(j*20))
            --love.graphics.print(cards[i][j].value .. ' ' .. cards[i][j].suit, 20 + (i-1)*152, 30 + (j*20))
            drawCard( enemies[i].cards[j].value, enemies[i].cards[j].suit, enemies[i].x, enemies[i].y)
        end
    end

    for i=1, #bullets do
        drawCard( bullets[i].value, bullets[i].suit, bullets[i].x, bullets[i].y)
    end
    
    if #shuffler.cards > 0 then
        drawCard(shuffler.cards[1].value, shuffler.cards[1].suit, shuffler.x + 3, shuffler.y+2)
    end
    love.graphics.draw(shuffler.img, shuffler.x, shuffler.y)
    
    for i=1, #shuffler.cards do
       drawCard(shuffler.cards[i].value, shuffler.cards[i].suit, shuffler.x - 12 + (i-1)*30, shuffler.y + 60) 
    end

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

    if not gameover then
        if #enemies < 5 then
            table.insert( enemies, createEnemie() )
        end

        for i=1, #enemies do
            enemies[i]:update(dt)
        end
        
        -- remove dead bullets
        --[[local i = 1
        local size = #bullets
        repeat
            if bullets[i] and bullets[i].isDead then
                table.remove( bullets, i)
                size = #bullets
            else
                i = i + 1
            end
        until i == size]]
 
        for i=1, #bullets do
            bullets[i].y = bullets[i].y - 1
            
            if bullets[i].y < -35 then
               bullets[i].isDead = true 
            end
        end

        

        shuffler:update(dt)
    end
end

function gameplay.setChangeToState(cts)
    changeToState = cts
end

return gameplay
