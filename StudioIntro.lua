function studioIntroScene()
    local studioIntro = StudioIntro()
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

        -- start, stop, object (draw), action (tween)
        action{120, 222, studioIntro.whiteText, "whiteFadeIn"}
        action{120, 230, studioIntro.b}
        action{120, 138, studioIntro.falling, "colorFadeIn"}
        action{223, 400, studioIntro.whiteText}
        action{139, 400, studioIntro.falling}
        action{231, 275, studioIntro.b, "rotate", {-5, tween.easing.cubicIn}}
        action{276, 335, studioIntro.b, "rotate", {-30, tween.easing.bounceOut}}
        action{401, 460, studioIntro.whiteText, "whiteFadeOut"}
        action{336, 460, studioIntro.b}
        action{401, 460, studioIntro.falling, "colorFadeOut"}
        
        stop = (time.total == start + 500)
    end
    
    function scene.exit()
        if stop == true then
            scenes.next(2)
        end
        
        return stop
    end
    
    function scene.touched()
        -- Do nothing
    end
    
    return scene
end

function StudioIntro()
    local studioIntro = {
        b = {
            rot = 0
        },
        falling = {
            fallingFade = 0
        },
        tweens = {},
        whiteText = {
            fade = 0
        }
    }
    
    function studioIntro.b.rotate(params)
        studioIntro.tweens.rot = tween(
            params.duration,
            studioIntro.b,
            {rot = params[1]},
            params[2]
        )
    end
    
    function studioIntro.b.draw(params)
        pushStyle()
        
        font("Copperplate-Bold")
        fontSize(60)
        textMode(CORNER)
        
        local B = image(44, 61)
        setContext(B)
                
        fill(255, 255, 255, studioIntro.whiteText.fade)
        text("B", 0, 0)
        
        setContext()
        spriteMode(CORNER)
                
        translate(WIDTH / 2 + 85, HEIGHT / 2 - 15)
        rotate(studioIntro.b.rot)
        sprite(B, 0, 0)
        rotate(-studioIntro.b.rot)
        translate(-(WIDTH / 2 + 85), -(HEIGHT / 2 - 15))
                
        popStyle()
    end
    
    function studioIntro.falling.colorFadeIn(params)
        studioIntro.tweens.fallingFadeIn = tween(
            params.duration,
            studioIntro.falling,
            {fallingFade = 255},
            tween.easing.cubicIn
        )
    end
    
    function studioIntro.falling.colorFadeOut(params)
        studioIntro.tweens.fallingFadeOut = tween(
            params.duration,
            studioIntro.falling,
            {fallingFade = 0},
            tween.easing.cubicIn
        )
    end
    
    function studioIntro.falling.draw(params)
        pushStyle()
        
        font("Copperplate-Bold")
        fontSize(60)         
            
        fill(201, 59, 15, studioIntro.falling.fallingFade)
        textMode(CORNER)
        text("Falling", WIDTH / 2 - 176, HEIGHT / 2 - 15)
        
        popStyle()
    end
    
    function studioIntro.whiteText.whiteFadeIn(params)
        studioIntro.tweens.whiteFadeIn = tween(
            params.duration,
            studioIntro.whiteText,
            {fade = 255},
            tween.easing.cubicIn
        )
    end
    
    function studioIntro.whiteText.whiteFadeOut(params)
        studioIntro.tweens.whiteFadeOut = tween(
            params.duration,
            studioIntro.whiteText,
            {fade = 0},
            tween.easing.cubicIn
        )
    end
    
    function studioIntro.whiteText.draw(params)
        pushStyle()
        
        fill(255, 255, 255, studioIntro.whiteText.fade)
        
        font("Copperplate-Bold")
        fontSize(60)
        textMode(CORNER)
        text("Falling", WIDTH / 2 - 176, HEIGHT / 2 - 15)
        text("'s", WIDTH / 2 + 130, HEIGHT / 2 - 15)
                
        font("Copperplate-Light")
        textMode(CENTER)
        fontSize(26)
        text("Studio", WIDTH / 2, HEIGHT / 2 - 20)
        
        popStyle()
    end
    
    return studioIntro
end
