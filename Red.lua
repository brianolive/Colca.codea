function red()
    local scene = {}  
    local anim = {}
    
    local start
    local hangingColcas = 0
    local totalColcas = 0
    local falls = 0
    
    function finish()
        print("done")
    end
    
    function scene.enter()
        return true
    end
    
    function scene.act()
        background(0, 0, 0, 255)
        start = start or time.total
        
        if totalColcas > levels["Red"].colcaCount or falls > levels["Red"].maxFalls then
            finish()
        end
        
        local slot
        if math.floor(time.total - start) % (levels["Red"].dropFrequency * 60) == 0
            and hangingColcas < stage.slotCount then
            
            slot = math.random(1, stage.slotCount)
            local col = levels["Red"].colors[math.random(1, #levels["Red"].colors)]
            local dropHeight = math.floor(math.random(levels["Red"].dropRange[1],
                levels["Red"].dropRange[2]))
            
            while stage.slots[slot].col ~= color(0, 0, 0, 255) do
                slot = math.random(1, stage.slotCount)
            end
            
            stage.slots[slot].start = time.total
            stage.slots[slot].col = col
            stage.slots[slot].dropHeight = HEIGHT
            stage.slots[slot].hangTime = math.floor(math.random(levels["Red"].hangTime[1],
                levels["Red"].hangTime[2]))
            
            stage.slots[slot].dropTween = tween(stage.dropSpeed, stage.slots[slot],
                {dropHeight = dropHeight}, tween.easing.elasticOut)
            stage.slots[slot].stringWidthTween = tween(stage.slots[slot].hangTime,
                stage.slots[slot], {stringWidth = 0}, tween.easing.linear,
                function()
                    tween.stop(stage.slots[slot].dropTween)
                    stage.slots[slot].fallTween = tween(0.5, stage.slots[slot],
                        {dropHeight = -100}, tween.easing.cubicIn,
                    function()
                        stage.slots[slot].col = color(0, 0, 0, 255)
                        stage.slots[slot].stringWidth = 5
                        falls = falls + 1
                        hangingColcas = hangingColcas - 1
                    end)
                end)
            
            hangingColcas = hangingColcas + 1
            totalColcas = totalColcas + 1
        end
        
        for i = 1, stage.slotCount do
            if stage.slots[i].col ~= color(0, 0, 0, 255) then     
                pushStyle()
                
                stroke(stage.slots[i].col)
                strokeWidth(stage.slots[i].stringWidth)
                line(stage.slots[i].x, HEIGHT, stage.slots[i].x, stage.slots[i].dropHeight + 50)
                
                stroke(255)
                strokeWidth(math.min(1, stage.slots[i].stringWidth))
                line(stage.slots[i].x, HEIGHT, stage.slots[i].x, stage.slots[i].dropHeight + 50)
                
                stroke(stage.slots[i].col)
                strokeWidth(10)
                fill(0, 0, 0, 0)
                ellipse(stage.slots[i].x, stage.slots[i].dropHeight, 100)
                
                stroke(255)
                strokeWidth(1)
                fill(0, 0, 0, 0)
                ellipse(stage.slots[i].x, stage.slots[i].dropHeight, 100)
                
                popStyle()
            end
        end
    end
    
    function scene.exit()
        return false
    end
    
    return scene
end