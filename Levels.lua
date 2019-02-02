function levels()
    levels = {}
    
    levels["Red"] = {
        colcaCount = 20,
        dropFrequency = 1,
        dropRange = {300, HEIGHT - 300},
        hangTime = {10, 15},
        maxFalls = 2,
        mixable = 3,
        colors = {
            color(255, 0, 0),
            color(0, 255, 0)
        }
    }
end
