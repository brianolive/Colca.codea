-- Colca

function setup()
    displayMode(FULLSCREEN)
    
    scenes(1)
    
    --table.insert(stage.left, time)
end

function draw()
    background(0, 0, 0, 255)
    
    time.start()
    scenes.direct()
end

--[[
function sceneTemplate()
    local sceneTable = SceneTable()
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
        
    end
    
    function scene.exit()
        return stop
    end
    
    function scene.touched()
        -- Do nothing
    end
    
    return scene
end
]]--