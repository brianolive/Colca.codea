function scenes(n)
    local currentScene = n or 1
    
    scenes = {
        {studioIntroScene},
        {menuScene},
        {mixBoardScene, "Red"},
        {playScene, "Red"}
    }
    
    function scenes.next(n)
        currentScene = n or currentScene + 1

        if scenes[currentScene] then
            -- Scene, Level
            levels.current = scenes[currentScene][2]
            table.insert(stage.left, scenes[currentScene][1]())
        end
    end
    
    function scenes.direct(n)  
        for i, v in ipairs(stage.left) do
            if stage.left[i].enter() == true then
                table.insert(stage, stage.left[i])
                table.remove(stage.left, i)
            end
        end
        
        for i, v in ipairs(stage) do
            stage[i].act()
            
            if stage[i].exit() == true then
                table.remove(stage, i)
                scenes.next()
            end
        end
    end

    scenes.next(currentScene)
    
    return scenes
end
