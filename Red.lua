function red()
    local scene = {}  
    
    local start
    local slots = {}
    local slotCount = 10
    local spacing = (WIDTH - 200) / (slotCount - 1)
    local dropSpeed = 7
    hangingColcas = 0
    totalColcas = 0
    local lowestHeight = math.maxinteger
    local lowestColca = nil
    falls = 0
    missedMixes = 0
    
    local function dropTime()
        return math.floor(time.total - start) % (levels["Red"].dropFrequency * 60) == 0
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
        local col = levels["Red"].colors[math.random(1, #levels["Red"].colors)]
        local hangTime = math.floor(math.random(levels["Red"].hangTime[1],
            levels["Red"].hangTime[2]))
            
        slots[slot].start = time.total
        slots[slot].col = col
        slots[slot].dropHeight = HEIGHT
        slots[slot].hangTime = hangTime
    end
    
    local function initSlot(slotNumber)
        slots[slotNumber] = {}
        slots[slotNumber].x = 100 + (spacing * (slotNumber - 1))
        slots[slotNumber].col = color(0, 0, 0, 255)
        slots[slotNumber].stringWidth = 5
    end
    
    local function dropColca(slot)
        local lowestDropPoint = math.floor(math.random(levels["Red"].dropRange[1],
            levels["Red"].dropRange[2]))
        
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
        for i = 1, levels["Red"].mixable do
            lowestHeights[i] = math.maxinteger
        end
        
        local lowestSlots = {}
        for i, v in ipairs(slots) do
            if slots[i].col ~= color(0, 0, 0, 255) then
                for j = 1, levels["Red"].mixable do
                    if slots[i].dropHeight < lowestHeights[j] then
                        table.insert(lowestHeights, j, slots[i].dropHeight)
                        table.insert(lowestSlots, j, i)
                        break
                    end
                end

                lowestHeights[levels["Red"].mixable + 1] = nil
                lowestSlots[levels["Red"].mixable + 1] = nil
            end
        end
        
        local low = false
        for i = 1, levels["Red"].mixable do
            if lowestSlots[i] == slot then
                return true
            end
        end
        
        return false, lowestSlots
    end
    
    local function finish()
        print("done")
    end
    
    function scene.enter()
        for i = 1, slotCount do
            initSlot(i)
        end
        
        return true
    end
    
    function scene.act()
        start = start or time.total
        
        if time.total < start + 120 then
            return
        end
        
        if totalColcas > levels["Red"].colcaCount or falls > levels["Red"].maxFalls then
            finish()
        end
        
        local slot
        if dropTime() == true then   
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
                    strokeWidth(slots[i].stringWidth)
                else
                    strokeWidth(0)
                end
                line(slots[i].x, HEIGHT, slots[i].x, slots[i].dropHeight + 50)
                
                stroke(255)
                strokeWidth(math.min(1, slots[i].stringWidth))
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
                        
                        initSlot(lowestTable[i])
                        hangingColcas = hangingColcas - 1
                        matchingColor = true
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