-- Colca

function setup()
    displayMode(FULLSCREEN)
    parameter.watch("totalColcas")
    parameter.watch("goodMixes")
    parameter.watch("missedMixes")
    parameter.watch("falls")
    parameter.watch("hangingColcas")
    parameter.watch("finish")

    time()
    stage()
    levels()
    
    --table.insert(stage.left, time)
    --table.insert(stage.left, studioIntro())
    --table.insert(stage.left, menu())
    --table.insert(stage.left, title("RedTitle"))
    --table.insert(stage.left, red("RedIntro"))
    table.insert(stage.left, red("Red"))
end

function draw()
    background(0, 0, 0, 255)
    
    time.start()
    direct()
end