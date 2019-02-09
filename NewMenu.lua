function newMenuScene()
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
        action{120, 222, studioIntro.whiteText, "whiteFadeIn"}
        
        --stop = (time.total == start + 500)
    end
    
    function scene.exit()
        return stop
    end
    
    function scene.touched()
        -- Do nothing
    end
    
    return scene
end


