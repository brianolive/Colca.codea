function menu()
    local scene = {}
    local anim = {
        colcaFade = 255,
        colcaStringFade = 255,
        descendColca = HEIGHT + 200,
        descendString = HEIGHT + 200,
        fade = 0,
        playFade = 0,
        playColor = color(255, 255, 255, 255),
        backgroundColor = color(0, 0, 0, 255),
        leftMountain = 400,
        rightMountain = -1100,
        centerMountainFade = 0,
        finalFadeOut = 0,
        leftMountainColor = color(68, 121, 59, 255),
        rightMountainColor = color(58, 91, 53, 255),
        middleMountainColor = color(255, 255, 255, 0),
        volcanoRed = color(0, 0, 0, 0)
    }
    local start
    local colcaDown = false
    local playStarted
    local playEnded
    local sceneEnded
    
    local function fadeOut()
        tween(1, anim, {finalFadeOut = 255}, tween.easing.linear,
            function() sceneEnded = time.total scene.exit(true) end)
    end
    
    function scene.enter()
        return true
    end
    
    function scene.act()
        background(anim.backgroundColor)
        start = start or time.total

        if time.total == start then
            --tween(1, anim.backgroundFade, {r = 0, g = 34, b = 56})
            tween(1, anim.backgroundColor, {r = 0, g = 126, b = 158})
        end
        
        if playEnded and time.total == playEnded + 60 then
            pushStyle()
            
            fill(212, 212, 212, 255)
            rect(-5, -5, WIDTH + 10, HEIGHT + 10)
            
            popStyle()
        end
        
        if playEnded and time.total == playEnded + 70 then
            pushStyle()
            
            fill(80, 78, 78, 255)
            rect(-5, -5, WIDTH + 10, HEIGHT + 10)
            
            popStyle()
        end
        
        if time.total == start + 60 then
            tween(5, anim, {descendColca = HEIGHT / 2 - 45, descendString =
                HEIGHT / 2 - 45}, tween.easing.elasticOut, function() colcaDown =
                true end)
        end
            
        if time.total == start + 90 then  
            tween(1, anim, {leftMountain = 0}, tween.easing.bounceOut)
            tween(1.25, anim, {rightMountain = -600}, tween.easing.bounceOut)
            tween(1, anim.middleMountainColor, {a = 255}, tween.easing.linear)
        end
        
        if time.total == start + 90 then
            tween(1.5, anim, {fade = 255}, tween.easing.cubicIn)
        end
        
        if time.total == start + 210 then
            tween(0.3, anim, {playFade = 255}, tween.easing.cubicIn)
        end
        
        if time.total > start + 60 and not sceneEnded then
            pushStyle()
            
            stroke(245, 218, 0, anim.colcaStringFade)
            strokeWidth(10)
            line(WIDTH / 2 - 177, HEIGHT, WIDTH / 2 - 177, anim.descendString + 100)
            
            stroke(245, 218, 0, anim.colcaFade)
            strokeWidth(20)
            fill(0, 0, 0, 0)
            ellipse(WIDTH / 2 - 177, anim.descendColca, 200)
            
            popStyle()

            pushStyle()
            
            tint(anim.middleMountainColor)
            sprite("Project:mtn", 600, 100, 1000)
            
            popStyle()
            
            pushStyle()
          
            fill(anim.rightMountainColor)
            
            translate(300, 0)
            rotate(22)
            rect(0, anim.rightMountain, 1400, 600)
            rotate(-22)
            translate(-300, 0)
            
            popStyle()
            
            pushStyle()
            
            fill(anim.leftMountainColor)
            
            translate(600, 0)
            rotate(140)
            rect(anim.leftMountain, anim.leftMountain, 800, 400)
            rotate(-140)
            translate(-600, 0)
            
            popStyle()
        end
        
        if time.total > start + 90 and not sceneEnded then
            tint(255, 255, 255, anim.fade)
            sprite("Project:c", WIDTH / 2 - 417, HEIGHT / 2 + 120, 175)
            sprite("Project:l", WIDTH / 2  - 7, HEIGHT / 2 + 230, 11)
            sprite("Project:c", WIDTH / 2 + 158, HEIGHT / 2 + 120, 175)
            sprite("Project:a", WIDTH / 2 + 398, HEIGHT / 2 + 120, 245)
        end

        if time.total > start + 210 and not sceneEnded then
            pushStyle()
            
            textMode(CENTER)
            fill(anim.playColor.r, anim.playColor.g, anim.playColor.b, anim.playFade)
            font("Futura-Medium")
            fontSize(40)
            text("Play", WIDTH / 2 + 500, HEIGHT / 2 - 300)
            
            popStyle()
        end
        
        if time.total > start + 240 then
            if vec2(CurrentTouch.x, CurrentTouch.y):dist(vec2(WIDTH / 2 + 500,
                HEIGHT / 2 - 300)) < 50 then
                
                if playStarted == nil then
                    tween(0.1, anim.playColor, {r = 245, g = 218, b = 0})
                    playStarted = true
                end
                
                if CurrentTouch.state == ENDED and colcaDown == true and
                    playEnded == nil then
                    
                    --tween(0.1, anim, {colcaStringFade = 0}, tween.easing.linear)
                    anim.colcaStringFade = 0  
                    tween(1.0, anim, {
                        descendColca = -200,
                        fade = 0,
                        colcaFade = 0,
                        playFade = 0
                    }, tween.easing.linear)
                    tween(1.75, anim.backgroundColor, {r = 10, g = 0, b = 0},
                        tween.easing.linear)
                    tween(2.5, anim.leftMountainColor, {r = 50, g = 50, b = 50},
                        tween.easing.linear)
                    tween(2.5, anim.rightMountainColor, {r = 30, g = 30, b = 30},
                        tween.easing.linear)
                    tween(2.5, anim.middleMountainColor, {r = 25, g = 15, b = 15},
                        tween.easing.linear)
                    playEnded = time.total
                end
            end
        end
        
        if playEnded and time.total == playEnded + 30 then
            tween(4, anim.volcanoRed, {r = 124, g = 31, b = 33, a = 50},
                tween.easing.linear, fadeOut)
        end
        
        if playEnded and time.total > playEnded + 30 then
            pushStyle()
            
            fill(anim.volcanoRed)
            ellipse(WIDTH / 2 - 47, 256, 20, 10)
            fill(25, 18, 18, anim.volcanoRed.a)
            ellipse(WIDTH / 2 - 47, 256, 10, 5)
            
            popStyle()
        end
        
        pushStyle()
        
        fill(0, 0, 0, anim.finalFadeOut)
        rect(-5, -5, WIDTH + 5 , HEIGHT + 5)
        
        popStyle()
    end
    
    function scene.exit(bool)
        return bool
    end
    
    return scene
end
