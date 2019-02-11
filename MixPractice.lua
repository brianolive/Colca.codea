function mixPracticeScene()
    local mixPractice = MixPractice()
    local scene = {}
    scene.action = action
    
    -- local variables
    local start
    local stop
    local action
    local colors = levels[levels.current].colors
    
    function scene.enter()
        return true
    end
    
    function scene.act()
        start = start or time.total
        action = action or scene.action(start)

        -- start, stop, object (draw), action (tween)
        action{1, 60, mixPractice, "fadeIn"}
        action{61, stop, mixPractice}
    end
    
    function scene.exit()
        return mixPractice.stop
    end
    
    function scene.touched(t)
        action{1, stop, mixPractice, "ifTouched", {t, colors}}
        action{1, stop, mixPractice, "ifTouchedEaster", {t}}
    end
    
    return scene
end

function MixPractice()
    local mixPractice = {
        all = false,
        fade = 0,
        mixedColor,
        stop = false,
        tweens = {}
    }
    
    function mixPractice.fadeIn(params)
        mixPractice.tweens.fade = tween(
            params.duration,
            mixPractice,
            {fade = 255}
        )
    end
    
    function mixPractice.ifTouched(params)
        local col
        local t = params[1]
        
        if t.state == BEGAN then
            stage.touches[t.id] = t
        elseif t.state == ENDED then
            stage.touches[t.id] = nil
        end
        
        r, g, b = 0
        for k, v in pairs(stage.touches) do
            local value
            
            if v.y > (HEIGHT / 4) * 3 and v.y < HEIGHT then
                value = 255
            elseif v.y > (HEIGHT / 4) * 2 then
                value = 191
            elseif v.y > (HEIGHT / 4) then
                value = 127
            else
                value = 63
            end
            
            if v.x < WIDTH / 3 then
                r = value
            elseif v.x < (WIDTH / 3) * 2 then
                g = value
            else
                b = value
            end
        end
        
        col = color(r, g, b)
        
        for i, v in ipairs(params[2]) do
            if col == v or mixPractice.all == true then
                mixPractice.mixedColor = col
            else
                mixPractice.mixedColor = nil
            end
        end
    end
    
    function mixPractice.ifTouchedEaster(params)
        local numTouches = 0
        for k, v in pairs(stage.touches) do
            numTouches = numTouches + 1
        end
        
        if params[1].state == BEGAN and params[1].tapCount == 4 then
            if numTouches == 2 then
                mixPractice.all = true
            else
                tween(
                1,
                mixPractice,
                {fade = 0},
                tween.easing.linear,
                function()
                    mixPractice.stop = true
                    scenes.next(3, levels.current)
                end
            )
            end
        end
    end
    
    function mixPractice.draw(params)
        pushStyle()
        
        fill(150, 150, 150, mixPractice.fade)
        for i = 0, 2 do
            for j = 0, 3 do
                rect((WIDTH / 3) * i, (HEIGHT / 4) * j, WIDTH / 3, HEIGHT / 4)
            end
        end
        
        if mixPractice.mixedColor then
            fill(mixPractice.mixedColor)
            
            stroke(127)
            strokeWidth(3)
                
            local rowHeight = HEIGHT / 4
            local rowWidth = WIDTH / 3
                    
            local r = mixPractice.mixedColor.r
            local g = mixPractice.mixedColor.g
            local b = mixPractice.mixedColor.b
            
            local x, y
                    
            x = 0
            y = rowHeight * (((r + 1) / 64) - 1)
            rect(x, y, rowWidth, rowHeight)
                    
            x = rowWidth
            y = rowHeight * (((g + 1) / 64) - 1)          
            rect(x, y, rowWidth, rowHeight)
                    
            x = rowWidth * 2
            y = rowHeight * (((b + 1) / 64) - 1)
            rect(x, y, rowWidth, rowHeight)
        end
        
        popStyle()
    end
    
    return mixPractice
end
