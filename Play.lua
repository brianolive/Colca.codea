function playScene()
    local play = Play()
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

        action{31, 210, play.message, "show", {"Ready"}}
        action{211, 211, play.slots, "init"}
        action{211, stop, play.slots, "ifDropTime", {start}}
        action{211, stop, play, "ifOver"}
        
        action{1, stop, play.curtain}
    end
    
    function scene.exit()
        return play.curtain.stop
    end
    
    function scene.touched(t)
        action{1, stop, play, "ifTouched", {t}}
    end
    
    return scene
end

function Play()
    local play = {
        curtain = {
            alpha = 0,
            stop = false
        },
        finger = {
            alpha = 0,
            tweens = {}
        },
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
                
        play.slots[slot].start = time.total
        play.slots[slot].col = col
        play.slots[slot].dropHeight = HEIGHT
        play.slots[slot].hangTime = hangTime
    end
    
    function dropColca(slot)
        local lowestDropPoint = math.floor(math.random(levels[levels.current].dropRange[1],
            levels[levels.current].dropRange[2]))
        
        play.slots[slot].dropTween = tween(
            dropSpeed,
            play.slots[slot],
            {dropHeight = lowestDropPoint},
            tween.easing.elasticOut
        )
            
        play.slots[slot].stringWidthTween = tween(
            play.slots[slot].hangTime,
            play.slots[slot],
            {stringWidth = 0},
            tween.easing.linear,
            function()
                tween.stop(play.slots[slot].dropTween)
                play.slots[slot].fallTween = tween(
                    0.5,
                    play.slots[slot],
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
            
            while play.slots[slot].col ~= color(0, 0, 0, 255) do
                slot = math.random(1, slotCount)
            end
                
            return slot
        else
            return 0
        end
    end
    
    function initSlot(slotNumber)
        play.slots[slotNumber] = {}
        play.slots[slotNumber].x = levels[levels.current].leftSlotX + (spacing * (slotNumber - 1))
        play.slots[slotNumber].col = color(0, 0, 0, 255)
        play.slots[slotNumber].stringWidth = 5
    end
    
    function levelOver(slot)
        finish = true
        
        tween(
            0.5,
            play.curtain,
            {alpha = 255},
            tween.easing.linear,
            function()
                tween.stopAll()
            
                for i, v in ipairs(play.slots) do
                    initSlot(i)
                end
            
                if slot ~= 0 then
                    play.curtain.stop = true                
                else
                    play.curtain.stop = true
                end
            end
        )
    end
    
    local function lowest(slot)
        slot = slot or 0
            
        local lowestHeights = {}
        for i = 1, levels[levels.current].mixable do
            lowestHeights[i] = math.maxinteger
        end
            
        local lowestSlots = {}
        for i, v in ipairs(play.slots) do
            if play.slots[i].col ~= color(0, 0, 0, 255) then
                for j = 1, levels[levels.current].mixable do
                    if play.slots[i].dropHeight < lowestHeights[j] then
                        table.insert(lowestHeights, j, play.slots[i].dropHeight)
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
        for i, v in ipairs(play.slots) do
            if play.slots[i].col == color(0, 0, 0, 255) then
                available = true
            end
        end
            
        return available
    end
    
    function play.curtain.draw(params)
        pushStyle()
        
        if finish == true then
            fill(0, 0, 0, play.curtain.alpha)
            rect(0, 0, WIDTH, HEIGHT)
        end
        
        popStyle()
    end
    
    function play.finger.tap(params)
        play.finger.tweens.tap = tween(
            params.duration,
            play.finger,
            {alpha = params[1]},
            tween.easing.linear
        )
    end
    
    function play.finger.draw(params)
        pushStyle()
        
        fill(150, 150, 150, play.finger.alpha)
        ellipse((WIDTH / 3) / 2, (HEIGHT / 4) * 3 + ((HEIGHT / 4) / 2),  60, 62)
        
        popStyle()
    end
    
    function play.ifOver(params)
        if finish == false and goodMixes >= (levels[levels.current].colcaCount -
            levels[levels.current].maxFalls) and hangingColcas == 0 then
            
            levelOver(0)
        end
    end
    
    function play.ifTouched(params)
        local col
        local t = params[1]
        
        if mix(t) == true then
            col = getMixedColor()
            local matchingColor = false
                
            local _, lowestTable = lowest()
            
            for i = 1, #lowestTable do
                if col == play.slots[lowestTable[i]].col then
                    if play.slots[lowestTable[i]] then
                        if play.slots[lowestTable[i]].dropTween then
                            tween.stop(play.slots[lowestTable[i]].dropTween)
                        end
                        if play.slots[lowestTable[i]].stringWidthTween then
                            tween.stop(play.slots[lowestTable[i]].stringWidthTween)
                        end
                        if play.slots[lowestTable[i]].fallTween then
                            tween.stop(play.slots[lowestTable[i]].fallTween)
                        end
                            
                        tween(
                            0.3,
                            play.slots[lowestTable[i]],
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
    
    function play.message.show(params)
        play.message.tweens.show = tween(
            2.5,
            play.message,
            {alpha = 255},
            tween.easing.linear,
            function()
                tween(
                    0.5,
                    play.message,
                    {alpha = 0}
                )
            end
        )
    end
    
    function play.message.draw(params)
        pushStyle()
        
        font("Futura-Medium")
        fontSize(30)
        fill(127, 127, 127, play.message.alpha)
        text(params[1], WIDTH / 2, HEIGHT / 2)
        
        popStyle()
    end
    
    function play.mixBoxes.show(params)
        play.mixBoxes.tweens.show = tween(
            params.duration,
            play.mixBoxes,
            {alpha = 255},
            tween.easing.linear
        )
    end
    
    function play.mixBoxes.draw(params)
        local col = levels[levels.current].colors[1]
        
        if col.r == 255 then
            pushStyle()
            
            fill(0, 0, 0, 0)
            stroke(col.r, col.g, col.b, play.mixBoxes.alpha)
            strokeWidth(5)
            rect(0, (HEIGHT / 4) * 3,  WIDTH / 3, HEIGHT)
                
            popStyle()
        end
    end
    
    function play.slots.ifDropTime(params)
        if not finish and dropTime(params[1]) == true and totalColcas < levels[levels.current].colcaCount then
            slot = getAvailableSlot()
            if slot ~= 0 then
                createColca(slot)
                dropColca(slot)
            end
        end
    end
    
    function play.slots.init(params)
        if levels.current then
            slotCount = levels[levels.current].slotCount
            spacing = levels[levels.current].spacing
        end
        
        for i = 1, slotCount do
            initSlot(i)
        end
    end
    
    function play.slots.draw(params)
        for i = 1, slotCount do
            if play.slots[i].col ~= color(0, 0, 0, 255) then   
                pushStyle()
                    
                stroke(play.slots[i].col)
                if lowest(i) then
                    strokeWidth(math.ceil(play.slots[i].stringWidth))
                else
                    strokeWidth(0)
                end
                line(play.slots[i].x, HEIGHT, play.slots[i].x, play.slots[i].dropHeight + 50)
                    
                stroke(255)
                strokeWidth(math.min(1, math.ceil(play.slots[i].stringWidth)))
                line(play.slots[i].x, HEIGHT, play.slots[i].x, play.slots[i].dropHeight + 50)
                    
                stroke(play.slots[i].col)
                if lowest(i) then
                    strokeWidth(10)
                else
                    strokeWidth(0)
                end
                
                fill(0, 0, 0, 0)
                ellipse(play.slots[i].x, play.slots[i].dropHeight, 100)
                    
                stroke(255)
                fill(0, 0, 0, 0)
                strokeWidth(1)
                ellipse(play.slots[i].x, play.slots[i].dropHeight, 100)
                    
                popStyle()
            end
        end
    end
    
    return play
end
