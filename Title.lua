function title(level)
    local scene = {}
    local anim = {
        fade = 0,
        gray = color(127, 127, 127, 0),
        underline = (WIDTH / 2) - 100
    }
    
    local start
    
    pushStyle()
    
    font("Futura-Medium")
    fontSize(35)
    local titleSize = textSize(levels[level].name)
    
    popStyle()
    
    function scene.enter()
        return true
    end
    
    function scene.act()
        start = start or time.total
        
        if time.total == start + 60 then
            tween(
                0.5,
                anim,
                {fade = 255},
                tween.easing.cubicIn
            )
            
            tween(
                4,
                anim,
                {underline = (WIDTH / 2) + (titleSize / 2)},
                tween.easing.elasticOut
            )
        end
        
        if time.total == start + 120 then
            tween(
                1,
                anim.gray,
                {a = 255},
                tween.easing.cubicIn
            )
        end
        
        if time.total == start + 360 then
            tween(
                1,
                anim,
                {fade = 0},
                tween.easing.cubicIn
            )
            
            tween(
                1,
                anim.gray,
                {r = 0, g = 0, b = 0, a = 0},
                tween.easing.cubicIn,
                function()
                    scenes.next()
                    scene.exit(true)
                end
            )
        end
        
        pushStyle()
        
        font("Futura-Medium")
        fill(anim.gray)
        fontSize(35)
        
        local col = levels[level].col
        stroke(col.r, col.g, col.b, anim.fade)
        strokeWidth(3)

        line((WIDTH / 2) - (titleSize / 2), (HEIGHT / 2) - 20, anim.underline, (HEIGHT / 2) - 20)
      
        fill(anim.gray)  
        text(levels[level].name, WIDTH / 2, HEIGHT / 2)
            
        popStyle()
    end
    
    function scene.exit(bool)
        return bool or false
    end
    
    function scene.touched(t)
        -- Do nothing
    end
    
    return scene
end
