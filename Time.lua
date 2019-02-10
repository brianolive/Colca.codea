time = {}
    
time.total = 0
time.frame = 1
time.second = 0
    
function time.start()
    time.total = time.total + 1
    time.frame = time.frame + 1
        
    if time.frame == 61 then
        time.frame = 1
        time.second = time.second + 1
    end
end
    
function time.enter()   
    return true
end
    
function time.act()
    pushStyle()
        
    textMode(CORNER)
    fill(255, 255, 255, 255)
    text(tostring(time.second) .. "." .. tostring(time.frame), 30, HEIGHT - 30)
        
    popStyle()
end
    
function time.exit() 
    return false
end
