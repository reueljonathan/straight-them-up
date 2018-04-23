local gameplay = {}

local time = 90
local points = 0
local gameover = false
local changeToState

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

function isFlush(list) 
    for i=1, 4 do
        if list[i].suit ~= list[i+1].suit then
            return false
        end 
    end 
    return true
end

function isRoyalStraight(list)
    return (
        list[1].value == 1 and  -- A
        list[2].value == 10 and -- 10
        list[3].value == 11 and -- J
        list[4].value == 12 and -- Q
        list[5].value == 13 )   -- K
end

function isStraight(list)
    for i=1, 4 do
        if list[i].value ~= (list[i+1].value-1) then
            return false
        end
    end 
    return true
end

function isFourOfKind(list)
    return (
        list[1].value == list[2].value and
        list[2].value == list[3].value and
        list[3].value == list[4].value
    ) or (
        list[2].value == list[3].value and
        list[3].value == list[4].value and
        list[4].value == list[5].value
    )
end

function isFullHouse(list)
    return (
        list[1].value == list[2].value and
        list[3].value == list[4].value and
        list[4].value == list[5].value
    ) or (
        list[1].value == list[2].value and
        list[2].value == list[3].value and
        list[4].value == list[5].value
    )
end

function isThreeOfKind(list)
    return (
        list[1].value == list[2].value and
        list[2].value == list[3].value 
    ) or ( 
        list[2].value == list[3].value and
        list[3].value == list[4].value
    ) or (
        list[3].value == list[4].value and
        list[4].value == list[5].value
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

function searchCombinations(list)
    local flush, straight, fourofkind, threeofkind
    
    -- It is very important to sort the list (the hand) in ascending order,
    -- because all the following functions consider that
    -- when searching for the poker combinations 
    table.sort( list, function (a,b)
        return a.value < b.value
    end)
    
    flush = isFlush(list)
    straight = isRoyalStraight(list)

    if flush and straight then
        -- royal flush
        print('royal flush') 
        return
    end

    straight = isStraight(list)

    if flush and straight then
        -- straight flush
        print('straight flush')
        return
    end

    if isFourOfKind(list) then
        print('four of a kind')
        return
    end

    if isFullHouse(list) then
        print('full house')
        return 
    end

    if flush then
        print('flush')
        return
    end

    if straight then
        print('straight')
        return
    end

    if isThreeOfKind(list) then
        print('toak')
        return
    end

    if isTwoPairs(list) then
        print('two pairs')
        return
    end

    if isPair(list) then
        print('pair')
        return
    end

    print('high card')
    return


end

function gameplay.reset()
    time = 90
    points = 0
    gameover = false
    
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
            if #cards[handx+1] == 5 then
                searchCombinations(cards[handx+1])
                randomizeCards(handx+1)
            end 
            randomizePlayerCards() 
        end 
    end 
end

function gameplay.draw()
    love.graphics.print( math.floor(time), 20, 15)

    love.graphics.draw( hand, 20+ (152*handx), handy )
    for i=1, #playerCards do
        love.graphics.print( playerCards[i].value .. ' ' .. playerCards[i].suit, 25 + (152*handx), handy+(20*i))
    end
    for i=1, #cards do 
        for j=1, #cards[i] do
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
