-- Colca

function setup()
    displayMode(FULLSCREEN)
    time()
    stage()
    levels()
    
    --table.insert(stage.left, time)
    --table.insert(stage.left, studioIntro())
    --table.insert(stage.left, menu())
    table.insert(stage.left, red())
end

function draw()
    background(0, 0, 0, 255)
    
    time.start()
    direct()
end