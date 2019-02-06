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
    scenes(2)
    levels()
end

function draw()
    background(0, 0, 0, 255)
    
    time.start()
    scenes.direct()
end