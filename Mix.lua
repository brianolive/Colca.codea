function mix(t)
    if #stage.touches == 0 and t.state == BEGAN then
            stage.mixedColor = {}
        end
        
    if t.state == ENDED then              
        stage.mixedColor[#stage.mixedColor + 1] = vec2(t.x, t.y)
        stage.touches[t.id] = nil
                
        local count = 0
        for k, v in pairs(stage.touches) do
            count = count + 1
        end
                
        if count == 0 then
            return true
        end
    else
        stage.touches[t.id] = 1
    end
    
    return false
end

function getMixedColor()
    local r, g, b = 0, 0, 0
    local value = 0
    local rowHeight = HEIGHT / 4
    
    for i, v in ipairs(stage.mixedColor) do
        if v.y > rowHeight * 3 and v.y < HEIGHT then
            value = 255
        elseif v.y > rowHeight * 2 then
            value = 191
        elseif v.y > rowHeight then
            value = 127
        else
            value = 63
        end
        
        if v.x < WIDTH / 3 then
            r = value
        elseif v.x < (WIDTH / 3) * 2 then
            g = value
        else
            b = value
        end
    end

    return color(r, g, b)
end

function drawMix(col)
    if col.r == 255 then
        pushStyle()
        
        fill(0, 0, 0, 0)
        stroke(col)
        strokeWidth(5)
        rect(0, (HEIGHT / 4) * 3,  WIDTH / 3, HEIGHT)
              
        popStyle()
    end
end

function drawTap(col, tap)
    if col.r == 255 then
        pushStyle()

        fill(150, 150, 150, tap)
        ellipse((WIDTH / 3) / 2, (HEIGHT / 4) * 3 + ((HEIGHT / 4) / 2),  60, 62)
        
        popStyle()
    end
end
