function mixBoardScene()
    local mixBoard = MixBoard()
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
        action{31, 360, mixBoard.sparkle, "all", {colors}}
        action{181, 400, mixBoard.newColor, "fadeIn", {colors[#colors]}}
        action{401, stop, mixBoard.newColor, "ifTapReminder", {colors[#colors]}}
        action{300, 600, mixBoard.title.underline, "fadeIn", {}}
        action{300, 600, mixBoard.title.underline, "stretch"}
        action{601, 760, mixBoard.title.underline}
        action{421, 480, mixBoard.title, "fadeIn"}
        action{481, 700, mixBoard.title}
        action{701, 820, mixBoard.title, "fadeOut"}
        action{701, 820, mixBoard.title.underline, "fadeOut"}
        action{31, stop, mixBoard, "fadeIn"}
    end
    
    function scene.exit()
        return mixBoard.stop
    end
    
    function scene.touched(t)
        action{1, stop, mixBoard, "ifTouchedEaster", {t}}
        action{181, stop, mixBoard, "ifTouched", {t, colors[#colors]}}
    end
    
    return scene
end

function MixBoard()
    local mixBoard = {
        fade = 255,
        newColor = {
            border = 127,
            fade = 0
        },
        sparkle = {
            rButton = 0,
            gButton = 0,
            bButton = 0,
            fade = 0
        },
        stop = false,
        title = {
            fade = 0,
            tweens = {},
            underline = {
                fade = 0,
                length
            }
        },
        tweens = {}
    }
    
    function mixBoard.fadeIn(params)
        mixBoard.tweens.fade = tween(
            2,
            mixBoard,
            {fade = 0}
        )
    end
    
    function mixBoard.ifTouched(params)
        local col
        local t = params[1]
        
        if mix(t) == true then
            col = getMixedColor()
            if col == params[2] then
                tween(
                    1,
                    mixBoard,
                    {fade = 255},
                    tween.easing.linear,
                    function()
                        mixBoard.stop = true
                        scenes.next(4, levels.current)
                    end
                )
            end
        end
    end
    
    function mixBoard.ifTouchedEaster(params)
        local t = params[1]
        
        if t.state == BEGAN and t.tapCount == 4 then
            mixBoard.stop = true
            scenes.next(5, "Red")
        end
    end
    
    function mixBoard.draw(params)
        pushStyle()
        
        fill(0, 0, 0, mixBoard.fade)
        rect(0, 0, WIDTH, HEIGHT)
        
        popStyle()
    end
    
    function mixBoard.newColor.fadeIn(params)
        mixBoard.tweens.newColorFade = tween(
            3,
            mixBoard.newColor,
            {fade = 255},
            tween.easing.linear
        )
    end
    
    function mixBoard.newColor.ifTapReminder(params)
        if time.total % 120 == 0 or time.total % 121 == 0 then
            mixBoard.tweens.newColorBorder = tween(
                0.05,
                mixBoard.newColor,
                {border = 255},
                tween.easing.linear,
                function()
                    tween.reset(mixBoard.tweens.newColorBorder)
                end
            )
        end
    end
    
    function mixBoard.newColor.draw(params)
        pushStyle()
        
        fill(0, 0, 0, mixBoard.newColor.fade)
        rect(0, 0, WIDTH, HEIGHT)
        
        fill(params[1].r, params[1].g, params[1].b, mixBoard.newColor.fade)
        stroke(mixBoard.newColor.border, mixBoard.newColor.border,
            mixBoard.newColor.border, mixBoard.newColor.fade)
        strokeWidth(3)
        rect(0, (HEIGHT / 4) * 3, WIDTH / 3, (HEIGHT / 4)) 
        
        popStyle()
    end
    
    function mixBoard.sparkle.all(params)
        mixBoard.tweens.sparkleFade = tween(
            0.15,
            mixBoard.sparkle,
            {fade = 255},
            {easing = tween.easing.linear},
            function()
                mixBoard.sparkle.rButton = math.random(0, 4)
                mixBoard.sparkle.gButton = math.random(0, 4)
                mixBoard.sparkle.bButton = math.random(0, 4)
            
                tween.reset(mixBoard.tweens.sparkleFade)
                mixBoard.sparkle.all()
            end
        )
    end
    
    function mixBoard.sparkle.draw(params)       
        pushStyle()
        
        stroke(127, 127, 127, mixBoard.sparkle.fade)
        strokeWidth(3)
            
        local rowHeight = HEIGHT / 4
        local rowWidth = WIDTH / 3
                
        local r = math.max(0, (64 * mixBoard.sparkle.rButton) - 1)
        local g = math.max(0, (64 * mixBoard.sparkle.gButton) - 1)
        local b = math.max(0, (64 * mixBoard.sparkle.bButton) - 1)
        
        local unlockedColor = false
        for i = 1, #params[1] - 1 do
            if color(r, g, b) == params[1][i] then
                unlockedColor = true
                break
            end
        end
        
        if unlockedColor == true then
            fill(r, g, b, mixBoard.sparkle.fade)
        else
            fill(127, 127, 127, mixBoard.sparkle.fade)
        end
        local x, y
                
        x = 0
        y = rowHeight * (mixBoard.sparkle.rButton - 1)
        rect(x, y, rowWidth, rowHeight)
                
        x = rowWidth
        y = rowHeight * (mixBoard.sparkle.gButton - 1)               
        rect(x, y, rowWidth, rowHeight)
                
        x = rowWidth * 2
        y = rowHeight * (mixBoard.sparkle.bButton - 1)
        rect(x, y, rowWidth, rowHeight)
            
        popStyle()
    end
    
    function mixBoard.title.fadeIn(params)   
        mixBoard.tweens.titleFade = tween(
            params.duration,
            mixBoard.title,
            {fade = 255}
        )
    end
    
    function mixBoard.title.fadeOut(params)  
        mixBoard.tweens.titleFade = tween(
            params.duration,
            mixBoard.title,
            {fade = 0}
        )
    end
    
    function mixBoard.title.draw(params)
        pushStyle()
        
        font("Futura-Medium")
        fill(127, 127, 127, mixBoard.title.fade)
        fontSize(35)
        
        text(levels[levels.current].name, WIDTH / 2, HEIGHT / 2)
        
        popStyle()
    end
    
    function mixBoard.title.underline.fadeIn(params)  
        mixBoard.tweens.underlineFade = tween(
            params.duration,
            mixBoard.title.underline,
            {fade = 255}
        )
    end
    
    function mixBoard.title.underline.fadeOut(params)  
        mixBoard.tweens.underlineFade = tween(
            params.duration,
            mixBoard.title.underline,
            {fade = 0}
        )
    end
    
    function mixBoard.title.underline.stretch(params)
        pushStyle()
        
        font("Futura-Medium")
        fontSize(35)
        local titleSize = textSize(levels[levels.current].name)
        mixBoard.title.underline.length = (WIDTH / 2) - (titleSize / 2)
        
        popStyle()
        
        mixBoard.tweens.underlineLength = tween(
            params.duration,
            mixBoard.title.underline,
            {length = (WIDTH / 2) + (titleSize / 2)},
            tween.easing.elasticOut
        )
    end
    
    function mixBoard.title.underline.draw(params)
        pushStyle()
        
        font("Futura-Medium")
        fontSize(35)
        local titleSize = textSize(levels[levels.current].name)
        
        local col = levels[levels.current].colors[#levels[levels.current].colors]
        stroke(col.r, col.g, col.b, mixBoard.title.underline.fade)
        strokeWidth(3)
        
        line((WIDTH / 2) - (titleSize / 2), (HEIGHT / 2) - 20, mixBoard.title.underline.length or
            (WIDTH / 2) - (titleSize / 2), (HEIGHT / 2) - 20)
        
        popStyle()
    end
    
    return mixBoard
end
