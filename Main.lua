-- Colca

function setup()
    displayMode(FULLSCREEN)
    time()
    stage()
    
    --table.insert(stage.left, time)
    table.insert(stage.left, studioIntro())
    --table.insert(stage.left, menu())
end

function draw()
    background(0, 0, 0, 255)
    
    time.tick()
    direct()
end