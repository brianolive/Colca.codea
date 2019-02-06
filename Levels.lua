function levels()
    levels = {}
    
    levels["RedTitle"] = {
        name = "Red",
        col = color(255, 0, 0),
        nextScene = "RedIntro"
    }
    
    levels["RedIntro"] = {
        type = "intro",
        slotCount = 3,
        spacing = 129,
        leftSlotX = (WIDTH - 358),
        colcaCount = 3,
        dropFrequency = 1,
        dropRange = {300, HEIGHT - 300},
        hangTime = {30, 30},
        maxFalls = 1,
        mixable = 3,
        nextScene = "Red",
        colors = {
            color(255, 0, 0)
        }
    }
    
    levels["Red"] = {
        type = "play",
        slotCount = 10,
        spacing = (WIDTH - 200) / 9,
        leftSlotX = 100,
        colcaCount = 20,
        dropFrequency = 1,
        dropRange = {300, HEIGHT - 300},
        hangTime = {5, 8},
        maxFalls = 0,
        mixable = 3,
        colors = {
            color(255, 0, 0)
        }
    }
end
