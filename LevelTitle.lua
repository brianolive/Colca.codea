function levelTitle()
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
        action{61, 90, title.underline, "fadeIn", {}}
        action{61, 360, title.underline, "stretch"}
        action{121, 180, title, "fadeIn"}
        action{181, 360, title}
        action{361, 420, title.underline, "fadeOut"}
        action{361, 420, title, "fadeOut"}
        
        stop = (time.total == start + 421)
    end
    
    function scene.exit()
        return stop
    end
    
    function scene.touched()
        -- Do nothing
    end
    
    return scene
end
