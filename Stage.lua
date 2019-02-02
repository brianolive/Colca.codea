function stage()
    stage = {}
    stage.left = {}
    
    stage.slots = {}
    stage.slotCount = 10
    stage.dropSpeed = 7
    
    local spacing = (WIDTH - 200) / (stage.slotCount - 1)
    for i = 1, stage.slotCount do
        stage.slots[i] = {}
        stage.slots[i].x = 100 + (spacing * (i - 1))
        stage.slots[i].col = color(0, 0, 0, 255)
        stage.slots[i].stringWidth = 5
    end
end
