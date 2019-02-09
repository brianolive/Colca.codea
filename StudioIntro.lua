function studioIntro()
    local scene = {}
    scene.action = action
    
    -- local variables
    local start
    local stop
    local action

    -- local functions
    
    function scene.enter()
        return true
    end
    
    function scene.act()
        start = start or time.total
        action = action or scene.action(start)

        -- start, stop, object (draw), action (tween)
        action{120, 222, studio.whiteText, "whiteFadeIn"}
        action{120, 230, studio.b}
        action{120, 138, studio.falling, "colorFadeIn"}
        action{223, 400, studio.whiteText}
        action{139, 400, studio.falling}
        action{231, 275, studio.b, "rotate", {-5, tween.easing.cubicIn}}
        action{276, 335, studio.b, "rotate", {-30, tween.easing.bounceOut}}
        action{401, 460, studio.whiteText, "whiteFadeOut"}
        action{336, 460, studio.b}
        action{401, 460, studio.falling, "colorFadeOut"}
        
        stop = (time.total == start + 500)
    end
    
    function scene.exit()
        return stop
    end
    
    function scene.touched()
        -- Do nothing
    end
    
    return scene
end
