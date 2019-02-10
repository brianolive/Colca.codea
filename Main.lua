-- Colca

function setup()
    displayMode(FULLSCREEN)
    
    scenes(3)
    
    --table.insert(stage.left, time)
end

function draw()
    background(0, 0, 0, 255)
    
    time.start()
    scenes.direct()
end