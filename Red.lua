function red(level)
    local scene = {}  
    
    local start
    finish = false
    local finishFade = color(0, 0, 0, 0)
    local slots = {}
    local slotCount = levels[level].slotCount
    local spacing = levels[level].spacing
    local dropSpeed = 7
    hangingColcas = 0
    totalColcas = 0
    falls = 0
    goodMixes = 0
    missedMixes = 0
    local anim = {border = 0, tap = 0, readyFade = 0}
    
    local function dropTime()
        return math.floor(time.total - start) % (levels[level].dropFrequency * 60) == 0
    end
    
    local function slotsAvailable()
        local available = false
        for i, v in ipairs(slots) do
            if slots[i].col ==color(0, 0, 0, 255) then
                available = true
            end
        end
        
        return available
    end
    
    local function getAvailableSlot()
        if slotsAvailable() == true then
            slot = math.random(1, slotCount)
            
            while slots[slot].col ~= color(0, 0, 0, 255) do
                slot = math.random(1, slotCount)
            end
            
            return slot
        else
            return 0
        end
    end
    
    local function createColca(slot)
        local col = levels[level].colors[math.random(1, #levels[level].colors)]
        local hangTime = math.floor(math.random(levels[level].hangTime[1],
            levels[level].hangTime[2]))
            
        slots[slot].start = time.total
        slots[slot].col = col
        slots[slot].dropHeight = HEIGHT
        slots[slot].hangTime = hangTime
    end
    
    local function initSlot(slotNumber)
        slots[slotNumber] = {}
        slots[slotNumber].x = levels[level].leftSlotX + (spacing * (slotNumber - 1))
        slots[slotNumber].col = color(0, 0, 0, 255)
        slots[slotNumber].stringWidth = 5
    end
    
    local function levelOver(slot)
        finish = true

        tween(
            0.5,
            finishFade,
            {a = 255},
            tween.easing.linear,
            function()
                for i, v in ipairs(slots) do
                    tween.stopAll()
                    initSlot(i)
                end
            end
        )
        
        if slot ~= 0 then
            
        end
    end
    
    local function showMix()
        if time.total == start + 240 then
            tween(
                0.4,
                anim,
                {border = 255},
                tween.easing.linear
            )
        end
        
        if time.total == start + 340 then
            local tapTween =
            tween(
                0.2,
                anim,
                {tap = 200},
                tween.easing.linear,
                function()
                    tween(
                        1.5,
                        anim,
                        {tap = 0}
                    )
                end
            )
        end
    end
    
    local function showReady()      
        tween(
            2.5,
            anim,
            {readyFade = 255},
            tween.easing.linear,
            function()
                tween(
                    0.5,
                    anim,
                    {readyFade = 0}
                )
            end
        )
    end
    
    local function dropColca(slot)
        local lowestDropPoint = math.floor(math.random(levels[level].dropRange[1],
            levels[level].dropRange[2]))
        
        slots[slot].dropTween = tween(
            dropSpeed,
            slots[slot],
            {dropHeight = lowestDropPoint},
            tween.easing.elasticOut
        )
        
        slots[slot].stringWidthTween = tween(
            slots[slot].hangTime,
            slots[slot],
            {stringWidth = 0},
            tween.easing.linear,
            function()
                tween.stop(slots[slot].dropTween)
                slots[slot].fallTween = tween(
                    0.5,
                    slots[slot],
                    {dropHeight = -100},
                    tween.easing.cubicIn,
                    function()
                        initSlot(slot)
                        falls = falls + 1
                        hangingColcas = hangingColcas - 1
                
                        if falls > levels[level].maxFalls then
                            levelOver(slot)
                        end
                    end
                )
            end
        )
        
        hangingColcas = hangingColcas + 1
        totalColcas = totalColcas + 1
    end
    
    local function lowest(slot)
        slot = slot or 0
        
        local lowestHeights = {}
        for i = 1, levels[level].mixable do
            lowestHeights[i] = math.maxinteger
        end
        
        local lowestSlots = {}
        for i, v in ipairs(slots) do
            if slots[i].col ~= color(0, 0, 0, 255) then
                for j = 1, levels[level].mixable do
                    if slots[i].dropHeight < lowestHeights[j] then
                        table.insert(lowestHeights, j, slots[i].dropHeight)
                        table.insert(lowestSlots, j, i)
                        break
                    end
                end

                lowestHeights[levels[level].mixable + 1] = nil
                lowestSlots[levels[level].mixable + 1] = nil
            end
        end
        
        local low = false
        for i = 1, levels[level].mixable do
            if lowestSlots[i] == slot then
                return true
            end
        end
        
        return false, lowestSlots
    end
    
    function scene.enter()
        for i = 1, slotCount do
            initSlot(i)
        end
        
        return true
    end
    
    function scene.act()
        start = start or time.total
        
        if levels[level].type == "intro" then
            if time.total < start + 120 then
                return
            elseif time.total == start + 240 or time.total == start + 340 then
                showMix()
            end 
        elseif levels[level].type == "play" and time.total == start then
            showReady()
        end
        
        if levels[level].type == "intro" and time.total > start + 240 then
            local col = color()
            col.r = levels[level].colors[1].r
            col.g = levels[level].colors[1].g
            col.b = levels[level].colors[1].b
            drawMix(color(col.r, col.g, col.b, anim.border))
            drawTap(color(col.r, col.g, col.b), anim.tap)
        end
        
        if levels[level].type == "play" and time.total < start + 240 then
            pushStyle()
            
            font("Futura-Medium")
            fontSize(30)
            fill(127, 127, 127, anim.readyFade)
            text("Ready", WIDTH / 2, HEIGHT / 2)
            
            popStyle()
            
            return
        end
        
        if goodMixes >= (levels[level].colcaCount - levels[level].maxFalls) and
            hangingColcas == 0 then
            
            levelOver(0)
        end
        
        local slot
        if not finish and dropTime() == true and totalColcas < levels[level].colcaCount then   
            slot = getAvailableSlot()
            if slot ~= 0 then
                createColca(slot)
                dropColca(slot)
            end
        end
        
        for i = 1, slotCount do
            if slots[i].col ~= color(0, 0, 0, 255) then   
                pushStyle()
                
                stroke(slots[i].col)
                if lowest(i) then
                    strokeWidth(math.ceil(slots[i].stringWidth))
                else
                    strokeWidth(0)
                end
                line(slots[i].x, HEIGHT, slots[i].x, slots[i].dropHeight + 50)
                
                stroke(255)
                strokeWidth(math.min(1, math.ceil(slots[i].stringWidth)))
                line(slots[i].x, HEIGHT, slots[i].x, slots[i].dropHeight + 50)
                
                stroke(slots[i].col)
                if lowest(i) then
                    strokeWidth(10)
                else
                    strokeWidth(0)
                end

                fill(0, 0, 0, 0)
                ellipse(slots[i].x, slots[i].dropHeight, 100)
                
                stroke(255)
                fill(0, 0, 0, 0)
                strokeWidth(1)
                ellipse(slots[i].x, slots[i].dropHeight, 100)
                
                popStyle()
            end
        end
        
        if finish == true then
            fill(finishFade)
            rect(0, 0, WIDTH, HEIGHT)
        end
    end
    
    function scene.exit()
        return false
    end
    
    function scene.touched(t)
        local col
        if mix(t) == true then
            col = getMixedColor()
            local matchingColor = false
            
            local _, lowestTable = lowest()
        
            for i = 1, #lowestTable do
                if col == slots[lowestTable[i]].col then
                    if slots[lowestTable[i]] then
                        if slots[lowestTable[i]].dropTween then
                            tween.stop(slots[lowestTable[i]].dropTween)
                        end
                        if slots[lowestTable[i]].stringWidthTween then
                            tween.stop(slots[lowestTable[i]].stringWidthTween)
                        end
                        if slots[lowestTable[i]].fallTween then
                            tween.stop(slots[lowestTable[i]].fallTween)
                        end
                        
                        tween(
                            0.3,
                            slots[lowestTable[i]],
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

    return scene
end