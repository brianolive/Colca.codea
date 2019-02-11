function menuScene()
    local menu = Menu()
    local scene = {}
    scene.action = action
    
    -- local variables
    local start
    local stop
    local action
    local colcaDown = false
    local playStarted
    local playEnded
    
    function scene.enter()
        return true
    end
    
    function scene.act()
        start = start or time.total
        action = action or scene.action(start)

        -- start, stop, object (draw), action (tween)
        action{1, 60, menu, "fadeToColor"}
        action{61, stop, menu}
        action{61, 360, menu.colca, "drop"}
        action{361, stop, menu.colca}
        action{91, 150, menu.middleMountain, "enter"}
        action{151, stop, menu.middleMountain}
        action{91, 150, menu.leftMountain, "enter"}
        action{151, stop, menu.leftMountain}
        action{91, 165, menu.rightMountain, "enter"}
        action{166, stop, menu.rightMountain}
        action{91, 181, menu.title, "fadeIn"}
        action{182, stop, menu.title}
        action{211, 228, menu.playButton, "fadeIn"}
        action{229, stop, menu.playButton, "ifPressed"}
        action{229, stop, menu.curtain}
    end
    
    function scene.exit()
        return stop
    end
    
    function scene.touched()
        -- Do nothing
    end
    
    return scene
end

function Menu()
    local menu = {
        backgroundColor = color(0, 0, 0, 255),
        colca = {
            dropColca = HEIGHT + 200,
            dropString = HEIGHT + 200,
            fade = 255,
            stringFade = 255
        },
        curtain = {},
        finalFadeOut = 0,
        leftMountain = {
            col = color(68, 121, 59, 255),
            xy = 400
        },
        middleMountain = {
            col = color(255, 255, 255, 0)
        },
        playButton = {
            alpha = 0,
            col = color(255, 255, 255)
        },
        rightMountain = {
            col = color(58, 91, 53, 255),
            y = -1100
        },
        title = {
            col = color(255, 255, 255, 0)
        },
        tweens = {},
        volcanoRed = color(0, 0, 0, 0)
    }
    
    function menu.fadeToColor(params)
        menu.fadeToColor = tween(
            params.duration,
            menu.backgroundColor,
            {r = 0, g = 126, b = 158}
        )
    end
    
    function menu.draw(params)
        pushStyle()
        
        background(menu.backgroundColor)
        
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
        
        popStyle()
    end
    
    function menu.colca.drop(params)
        menu.tweens.drop = tween(
            params.duration,
            menu.colca,
            {dropColca = HEIGHT / 2 - 45, dropString = HEIGHT / 2 - 45},
            tween.easing.elasticOut,
            function() colcaDown = true end
        )
    end
    
    function menu.colca.draw(params)
        pushStyle()
        
        stroke(245, 218, 0, menu.colca.fade)
        strokeWidth(10)
        line(WIDTH / 2 - 177, HEIGHT, WIDTH / 2 - 177, menu.colca.dropString + 100)
                
        stroke(255, 255, 255, menu.colca.stringFade)
        strokeWidth(1)
        line(WIDTH / 2 - 177 - 5, HEIGHT, WIDTH / 2 - 177 - 5, menu.colca.dropString + 100)
                
        stroke(245, 218, 0, menu.colca.fade)
        strokeWidth(20)
        fill(0, 0, 0, 0)
        ellipse(WIDTH / 2 - 177, menu.colca.dropColca, 200)
                
        stroke(255, 255, 255, menu.colca.fade)
        strokeWidth(1)
        fill(0, 0, 0, 0)
        ellipse(WIDTH / 2 - 177, menu.colca.dropColca, 200)
        
        popStyle()
    end
    
    function menu.curtain.draw(params)
        pushStyle()
            
        fill(0, 0, 0, menu.finalFadeOut)
        rect(-5, -5, WIDTH + 5 , HEIGHT + 5)
            
        popStyle()
    end
    
    function menu.leftMountain.enter(params)
        menu.tweens.enter = tween(
            params.duration,
            menu.leftMountain,
            {xy = 0},
            tween.easing.bounceOut
        )
    end
    
    function menu.leftMountain.draw(params)
        pushStyle()
        
        fill(menu.leftMountain.col)
                
        translate(600, 0)
        rotate(140)
        rect(menu.leftMountain.xy, menu.leftMountain.xy, 800, 400)
        rotate(-140)
        translate(-600, 0)
        
        popStyle()
    end
    
    function menu.middleMountain.enter(params)
        menu.tweens.enter = tween(
            params.duration,
            menu.middleMountain.col,
            {a = 255},
            tween.easing.linear
        )
    end
    
    function menu.middleMountain.draw()
        pushStyle()
                
        tint(menu.middleMountain.col)
        sprite("Project:mtn", 600, 100, 1000)
                
        popStyle()
    end
    
    function menu.playButton.fadeIn(params)
        menu.tweens.fadeIn = tween(
            params.duration,
            menu.playButton,
            {alpha = 255},
            tween.easing.cubicIn
        )
    end
    
    function menu.playButton.ifPressed(params)
        if vec2(CurrentTouch.x, CurrentTouch.y):dist(vec2(WIDTH / 2 + 500,
            HEIGHT / 2 - 300)) < 50 then
            
            if playStarted == nil then
                tween(
                    0.1,
                    menu.playButton.col,
                    {r = 245, g = 218, b = 0}
                )
                playStarted = true
            end
                    
            if CurrentTouch.state == ENDED and colcaDown == true and
                playEnded == nil then
                        
                menu.colca.stringFade = 0  
                tween(
                    1.0,
                    menu.colca,
                    {dropColca = -200, fade = 0},
                    tween.easing.linear
                )
                tween(
                    1.0,
                    menu.title.col,
                    {a = 0},
                    tween.easing.linear
                )
                tween(
                    1.0,
                    menu.playButton,
                    {alpha = 0},
                    tween.easing.linear
                )
                tween(
                    1.75,
                    menu.backgroundColor,
                    {r = 10, g = 0, b = 0},
                    tween.easing.linear
                )
                tween(
                    2.5,
                    menu.leftMountain.col,
                    {r = 50, g = 50, b = 50},
                    tween.easing.linear
                )
                tween(
                    2.5,
                    menu.rightMountain.col,
                    {r = 30, g = 30, b = 30},
                    tween.easing.linear
                )
                tween(
                    2.5,
                    menu.middleMountain.col,
                    {r = 25, g = 15, b = 15},
                    tween.easing.linear
                )
                
                playEnded = time.total
            end
        end
        
        if playEnded and time.total == playEnded + 30 then
            tween(
                4,
                menu.volcanoRed,
                {r = 124, g = 31, b = 33, a = 50},
                tween.easing.linear,
                function()
                    tween(
                        1,
                        menu,
                        {finalFadeOut = 255},
                        tween.easing.linear,
                        function()
                            sceneEnded = time.total
                            scenes.next(3, "Red")
                            exit = true
                        end
                    )
                end
            )
        end
            
        if playEnded and time.total > playEnded + 30 then
            pushStyle()
                
            fill(menu.volcanoRed)
            ellipse(WIDTH / 2 - 47, 256, 20, 10)
            fill(25, 18, 18, menu.volcanoRed.a)
            ellipse(WIDTH / 2 - 47, 256, 10, 5)
                
            popStyle()
        end
    end
    
    function menu.playButton.draw()
        pushStyle()
        
        textMode(CENTER)
        fill(menu.playButton.col.r, menu.playButton.col.g, menu.playButton.col.b,
            menu.playButton.alpha)
        font("Futura-Medium")
        fontSize(40)
        text("Play", WIDTH / 2 + 500, HEIGHT / 2 - 300)    
        
        popStyle()
    end
    
    function menu.rightMountain.enter(params)
        menu.tweens.enter = tween(
            params.duration,
            menu.rightMountain,
            {y = -600},
            tween.easing.bounceOut
        )
    end
    
    function menu.rightMountain.draw(params)
        pushStyle()
        
        fill(menu.rightMountain.col)
                
        translate(300, 0)
        rotate(22)
        rect(0, menu.rightMountain.y, 1400, 600)
        rotate(-22)
        translate(-300, 0)
        
        popStyle()
    end
    
    function menu.title.fadeIn(params)
        menu.tweens.fadeIn = tween(
            params.duration,
            menu.title.col,
            {a = 255},
            tween.easing.cubicIn
        )
    end
    
    function menu.title.draw()
        pushStyle()
        
        tint(menu.title.col)
        sprite("Project:c", WIDTH / 2 - 417, HEIGHT / 2 + 120, 175)
        sprite("Project:l", WIDTH / 2  - 7, HEIGHT / 2 + 230, 11)
        sprite("Project:c", WIDTH / 2 + 158, HEIGHT / 2 + 120, 175)
        sprite("Project:a", WIDTH / 2 + 398, HEIGHT / 2 + 120, 245)
        
        popStyle()
    end
    
    return menu
end