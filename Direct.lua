function direct()
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
        end
    end
end
