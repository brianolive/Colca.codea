function studioIntro()
    local scene = {}
    local anim = {fallingFade = 0, fade = 0, rot = 0}
    local start
    local exit = false
    
    local function nextScene()
        scenes.next()
        exit = true
    end
    
    function scene.enter()
        return true
    end
    
    function scene.act()
        background()
        start = start or time.total
        
        if time.total == start + 120 then
            tween(0.3, anim, {fallingFade = 255}, tween.easing.cubicIn)
            tween(1.7, anim, {fade = 255}, tween.easing.cubicIn)
        end
        
        if time.total == start + 230 then
            tween(0.75, anim, {rot = -5}, tween.easing.cubicIn, function()
                tween(1, anim, {rot = -30}, tween.easing.bounceOut) end)
        end
        
        if time.total == start + 400 then
            tween(1, anim, {fallingFade = 0, fade = 0}, tween.easing.cubicIn)
        end
        
        if time.total == start + 500 then
            nextScene()
        end
     
        if time.total > start + 120 then
            pushStyle()
            
            fill(255, 255, 255, anim.fade)
            
            font("Copperplate-Bold")
            fontSize(60)
            textMode(CORNER)
            text("Falling", WIDTH / 2 - 176, HEIGHT / 2 - 15)
            
            pushStyle()
            --fill(238, 136, 47, anim.fallingFade)
            fill(201, 59, 15, anim.fallingFade)
            textMode(CORNER)
            text("Falling ", WIDTH / 2 - 176, HEIGHT / 2 - 15)
            popStyle()
            
            pushStyle()
            local B = image(44, 61)
            setContext(B)
            
            fill(255, 255, 255, anim.fade)
            textMode(CORNER)
            text("B", 0, 0)
            
            setContext()
            spriteMode(CORNER)
            
            translate(WIDTH / 2 + 85, HEIGHT / 2 - 15)
            rotate(anim.rot)
            sprite(B, 0, 0)
            rotate(-anim.rot)
            translate(-(WIDTH / 2 + 85), -(HEIGHT / 2 - 15))
            
            popStyle()
            
            pushStyle()
            fill(255, 255, 255, anim.fade)
            fontSize(60)
            textMode(CORNER)
            text("'s", WIDTH / 2 + 130, HEIGHT / 2 - 15)
            popStyle()
            
            font("Copperplate-Light")
            textMode(CENTER)
            fontSize(26)
            text("Studio", WIDTH / 2, HEIGHT / 2 - 20)
            
            popStyle()     
        end
    end
    
    function scene.exit()
        return exit
    end
    
    function scene.touched(t)
        -- Do nothing
    end
    
    return scene
end
