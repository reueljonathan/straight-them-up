local gameplay = {}

local time = 90
local points = 0
local gameover = false
local changeToState

local background, cardImg
local hand = love.graphics.newImage('img/hand.png')
local handx = 324
local handy = 475

local suits = {'heart', 'diamond', 'club', 'spade'}
local values = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13} 
local cards = {}
local playerCards = {}

function randomizeCards(index) 
    cards[index] = { {suit = suits[math.random(4)], value = values[math.random(12)]}} 
end

function randomizePlayerCards()
    playerCards = {
        {
            suit = suits[math.random(4)],
            value = values[math.random(12)]
        },
        {
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
    cardImg = love.graphics.newImage('/img/card.png')
    
    handx = 2
    cards = {}
    playerCards= {}
    
    for i=1, 5 do
        randomizeCards(i)
    end
    randomizePlayerCards()
end

function gameplay.keyreleased(key)
    if gameover and changeToState ~= nil then
        changeToState('states.menu')
    else
        if key == 'left' and handx > 0 then
            handx = handx - 1
        elseif key == 'right' and handx < 4 then
            handx = handx + 1
        elseif key == 'up' then
            table.insert(cards[handx+1], playerCards[1])
            table.insert(cards[handx+1], playerCards[2])
            if #cards[handx+1] == 7 then
                searchCombinations(cards[handx+1])
                randomizeCards(handx+1)
            end 
            randomizePlayerCards() 
        end 
    end 
end

function gameplay.draw()
    love.graphics.draw(background, 0, 0)

    love.graphics.print( math.floor(time), 20, 15)

    love.graphics.draw( hand, 20+ (152*handx), handy )
    for i=1, #playerCards do
        love.graphics.print( playerCards[i].value .. ' ' .. playerCards[i].suit, 25 + (152*handx), handy+(20*i))
    end
    for i=1, #cards do 
        for j=1, #cards[i] do
            love.graphics.draw(cardImg, 20+(i-1)*152, 30+(j*20))
            love.graphics.print(cards[i][j].value .. ' ' .. cards[i][j].suit, 20 + (i-1)*152, 30 + (j*20))
        end
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
end

function gameplay.setChangeToState(cts)
    changeToState = cts
end

return gameplay
