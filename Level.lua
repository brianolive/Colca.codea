local level
    
function levelScene()
    local scene = {}
    scene.action = action
    
    -- local variables
    local start
    local stop
    local action
    
    function scene.enter()
        return true
    end
    
    function scene.act()
        start = start or time.total
        action = action or scene.action(start)

        if levels[levels.current].type == "teach" then
            action{241, 264, level.mixBoxes, "show"}
            action{265, stop, level.mixBoxes}
            action{341, 352, level.finger, "tap", {200}}
            action{353, 442, level.finger, "tap", {0}}
        elseif levels[levels.current].type == "play" then
            action{1, 180, level.message, "show", {"Ready"}}
        end
        
        action{181, 1, level.slots, "init"}
        action{181, stop, level.slots, "ifDropTime", {start}}
        action{181, stop, level, "ifOver"}
    end
    
    function scene.exit()
        return stop
    end
    
    function scene.touched(t)
        action{1, stop, level, "ifTouched", {t}}
    end
    
    return scene
end

level = {
    finger = {
        alpha = 0,
        tweens = {}
    },
    finishFade = color(0, 0, 0, 0),
    message = {
        alpha = 0,
        tweens = {}
    },
    mixBoxes = {
        alpha = 0,
        tweens = {}
    },
    slots = {
        tweens = {}
    },
    tweens = {}
}

-- local variables
local dropSpeed = 7
local falls = 0
local finish = false
local goodMixes = 0
local hangingColcas = 0
local missedMixes = 0
local slot
local slotCount
local spacing
local totalColcas = 0

-- local functions
local createColca
local dropColca
local dropTime
local getAvailableSlot
local initSlot
local levelOver
local lowest
local slotsAvailable

function createColca(slot)
    local col = levels[levels.current].colors[math.random(1, #levels[levels.current].colors)]
    local hangTime = math.floor(math.random(levels[levels.current].hangTime[1],
        levels[levels.current].hangTime[2]))
            
    level.slots[slot].start = time.total
    level.slots[slot].col = col
    level.slots[slot].dropHeight = HEIGHT
    level.slots[slot].hangTime = hangTime
end

function dropColca(slot)
    local lowestDropPoint = math.floor(math.random(levels[levels.current].dropRange[1],
        levels[levels.current].dropRange[2]))

    level.slots[slot].dropTween = tween(
        dropSpeed,
        level.slots[slot],
        {dropHeight = lowestDropPoint},
        tween.easing.elasticOut
    )
        
    level.slots[slot].stringWidthTween = tween(
        level.slots[slot].hangTime,
        level.slots[slot],
        {stringWidth = 0},
        tween.easing.linear,
        function()
            tween.stop(level.slots[slot].dropTween)
            level.slots[slot].fallTween = tween(
                0.5,
                level.slots[slot],
                {dropHeight = -100},
                tween.easing.cubicIn,
                function()
                    initSlot(slot)
                    falls = falls + 1
                    hangingColcas = hangingColcas - 1
                
                    if falls > levels[levels.current].maxFalls then
                        levelOver(slot)
                    end
                end
            )
        end
    )
        
    hangingColcas = hangingColcas + 1
    totalColcas = totalColcas + 1
end

function dropTime(start)
    return math.floor(time.total - start) % (levels[levels.current].dropFrequency * 60) == 0
end

function getAvailableSlot()
    if slotsAvailable() == true then
        slot = math.random(1, slotCount)

        while level.slots[slot].col ~= color(0, 0, 0, 255) do
            slot = math.random(1, slotCount)
        end
            
        return slot
    else
        return 0
    end
end

function initSlot(slotNumber)
    level.slots[slotNumber] = {}
    level.slots[slotNumber].x = levels[levels.current].leftSlotX + (spacing * (slotNumber - 1))
    level.slots[slotNumber].col = color(0, 0, 0, 255)
    level.slots[slotNumber].stringWidth = 5
end

function levelOver(slot)
        finish = true

        tween(
            0.5,
            level.finishFade,
            {a = 255},
            tween.easing.linear,
            function()
                for i, v in ipairs(level.slots) do
                    tween.stopAll()
                    initSlot(i)
                end
            end
        )
        
        if slot ~= 0 then
            
        end
    end

local function lowest(slot)
    slot = slot or 0
        
    local lowestHeights = {}
    for i = 1, levels[levels.current].mixable do
        lowestHeights[i] = math.maxinteger
    end
        
    local lowestSlots = {}
    for i, v in ipairs(level.slots) do
        if level.slots[i].col ~= color(0, 0, 0, 255) then
            for j = 1, levels[levels.current].mixable do
                if level.slots[i].dropHeight < lowestHeights[j] then
                    table.insert(lowestHeights, j, level.slots[i].dropHeight)
                    table.insert(lowestSlots, j, i)
                    break
                end
            end

            lowestHeights[levels[levels.current].mixable + 1] = nil
            lowestSlots[levels[levels.current].mixable + 1] = nil
        end
    end
        
    local low = false
    for i = 1, levels[levels.current].mixable do
        if lowestSlots[i] == slot then
            return true
        end
    end
        
    return false, lowestSlots
end
    
function slotsAvailable()
    local available = false
    for i, v in ipairs(level.slots) do
        if level.slots[i].col == color(0, 0, 0, 255) then
            available = true
        end
    end
        
    return available
end

function level.finger.tap(params)
    level.finger.tweens.tap = tween(
        params.duration,
        level.finger,
        {alpha = params[1]},
        tween.easing.linear
    )
end

function level.finger.draw(params)
    pushStyle()
    
    fill(150, 150, 150, level.finger.alpha)
    ellipse((WIDTH / 3) / 2, (HEIGHT / 4) * 3 + ((HEIGHT / 4) / 2),  60, 62)
    
    popStyle()
end

function level.ifOver(params)
    if goodMixes >= (levels[levels.current].colcaCount - levels[levels.current].maxFalls) and
        hangingColcas == 0 then           
        levelOver(0)
    end
end

function level.ifTouched(params)
    local col
    local t = params[1]
    
    if mix(t) == true then
        col = getMixedColor()
        local matchingColor = false
            
        local _, lowestTable = lowest()
        
        for i = 1, #lowestTable do
            if col == level.slots[lowestTable[i]].col then
                if level.slots[lowestTable[i]] then
                    if level.slots[lowestTable[i]].dropTween then
                        tween.stop(level.slots[lowestTable[i]].dropTween)
                    end
                    if level.slots[lowestTable[i]].stringWidthTween then
                        tween.stop(level.slots[lowestTable[i]].stringWidthTween)
                    end
                    if level.slots[lowestTable[i]].fallTween then
                        tween.stop(level.slots[lowestTable[i]].fallTween)
                    end
                        
                    tween(
                        0.3,
                        level.slots[lowestTable[i]],
                        {dropHeight = HEIGHT},
                        tween.easing.cubicIn,
                        function()
                            initSlot(lowestTable[i])
                            hangingColcas = hangingColcas - 1
                        end
                    )
                        
                    matchingColor = true
                    goodMixes = goodMixes + 1
                end
                    
                break 
            end
        end
            
        if matchingColor == false then
            missedMixes = missedMixes + 1
        end
    end
end

function level.message.show(params)
    level.message.tweens.show = tween(
        2.5,
        level.message,
        {alpha = 255},
        tween.easing.linear,
        function()
            tween(
                0.5,
                level.message,
                {alpha = 0}
            )
        end
    )
end

function level.message.draw(params)
    pushStyle()
    
    font("Futura-Medium")
    fontSize(30)
    fill(127, 127, 127, level.message.alpha)
    text(params[1], WIDTH / 2, HEIGHT / 2)
    
    popStyle()
end

function level.mixBoxes.show(params)
    level.mixBoxes.tweens.show = tween(
        params.duration,
        level.mixBoxes,
        {alpha = 255},
        tween.easing.linear
    )
end

function level.mixBoxes.draw(params)
    local col = levels[levels.current].colors[1]

    if col.r == 255 then
        pushStyle()
        
        fill(0, 0, 0, 0)
        stroke(col.r, col.g, col.b, level.mixBoxes.alpha)
        strokeWidth(5)
        rect(0, (HEIGHT / 4) * 3,  WIDTH / 3, HEIGHT)
              
        popStyle()
    end
end

function level.slots.ifDropTime(params)
    if not finish and dropTime(params[1]) == true and totalColcas < levels[levels.current].colcaCount then
        slot = getAvailableSlot()
        if slot ~= 0 then
            createColca(slot)
            dropColca(slot)
        end
    end
end

function level.slots.init(params)
    if levels.current then
        slotCount = levels[levels.current].slotCount
        spacing = levels[levels.current].spacing
    end
    
    for i = 1, slotCount do
        initSlot(i)
    end
end

function level.slots.draw(params)
    for i = 1, slotCount do
        if level.slots[i].col ~= color(0, 0, 0, 255) then   
            pushStyle()
                
            stroke(level.slots[i].col)
            if lowest(i) then
                strokeWidth(math.ceil(level.slots[i].stringWidth))
            else
                strokeWidth(0)
            end
            line(level.slots[i].x, HEIGHT, level.slots[i].x, level.slots[i].dropHeight + 50)
                
            stroke(255)
            strokeWidth(math.min(1, math.ceil(level.slots[i].stringWidth)))
            line(level.slots[i].x, HEIGHT, level.slots[i].x, level.slots[i].dropHeight + 50)
                
            stroke(level.slots[i].col)
            if lowest(i) then
                strokeWidth(10)
            else
                strokeWidth(0)
            end

            fill(0, 0, 0, 0)
            ellipse(level.slots[i].x, level.slots[i].dropHeight, 100)
                
            stroke(255)
            fill(0, 0, 0, 0)
            strokeWidth(1)
            ellipse(level.slots[i].x, level.slots[i].dropHeight, 100)
                
            popStyle()
        end
    end
        
    if finish == true then
        fill(level.finishFade)
        rect(0, 0, WIDTH, HEIGHT)
    end
end
