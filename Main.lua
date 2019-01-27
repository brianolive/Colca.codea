-- Colca

function setup()
    touches = {}
    colora = {}
    slots = {}
    
    gameOver = false
end

function draw()
    background(0, 0, 0, 255)
    
    if gameOver == false then
        update()
    
        for k, v in pairs(colora) do
            v.draw()
        end
    end
end

function update()
    if math.random() > .99 then
        local i = #colora + 1
        local c = math.random(1, #colors)
        local speed = math.random() * 3
        local position = nil
        local y = HEIGHT
        
        while position == nil do
            local slot = math.random(1, 20)
            
            if slots[slot] == nil then
                position = ((WIDTH - 100) // 20) * slot
                slots[slot] = 1
            end
        end
        
        colora[i] = {}
        colora[i].draw = function()
            y = math.floor(y - speed)
            
            if y < 0 then
                gameOver = true
            end
            
            strokeWidth(3)
            stroke(colors[c])
            line(position, y, position, HEIGHT)
            
            strokeWidth(2)
            stroke(180, 180, 180, 255)
            line(position - 2, y, position - 2, HEIGHT)
            
            strokeWidth(1)
            stroke(255, 255, 255, 255)
            ellipse(position, y, 32)
            
            strokeWidth(4)
            stroke(colors[c])
            fill(0)
            ellipse(position, y, 30)
        end   
    end
end

colors = {}
colors[1] = color(255, 0, 0)
colors[2] = color(0, 255, 0)
