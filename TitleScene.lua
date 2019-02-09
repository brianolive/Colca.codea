function titleScene()
    local scene = {}
    scene.action = action
    
    -- local variables
    local start
    local stop
    local action

    -- local functions
    
    function scene.enter()
        return true
    end
    
    function scene.act()
        start = start or time.total
        action = action or scene.action(start)

        -- start, stop, object (draw), action (tween)
        action{61, 90, title.underline, "fadeIn", {}}
        action{61, 360, title.underline, "stretch"}
        action{121, 180, title, "fadeIn"}
        action{181, 360, title}
        action{361, 420, title.underline, "fadeOut"}
        action{361, 420, title, "fadeOut"}
        
        stop = (time.total == start + 421)
    end
    
    function scene.exit()
        return stop
    end
    
    function scene.touched()
        -- Do nothing
    end
    
    return scene
end

title = {
    fade = 0
}
title.tweens = {}

title.underline = {
    fade = 0,
    length
}
title.underline.tweens = {}

function title.fadeIn(params)   
    title.tweens.fade = tween(
        params.duration,
        title,
        {fade = 255}
    )
end

function title.fadeOut(params)  
    title.tweens.fade = tween(
        params.duration,
        title,
        {fade = 0}
    )
end

function title.draw(params)
    pushStyle()
    
    font("Futura-Medium")
    fill(127, 127, 127, title.fade)
    fontSize(35)
    
    text(levels[levels.current].name, WIDTH / 2, HEIGHT / 2)
    
    popStyle()
end

function title.underline.fadeIn(params)  
    title.underline.tweens.fade = tween(
        params.duration,
        title.underline,
        {fade = 255}
    )
end

function title.underline.fadeOut(params)  
    title.underline.tweens.fade = tween(
        params.duration,
        title.underline,
        {fade = 0}
    )
end

function title.underline.stretch(params)
    pushStyle()
    
    font("Futura-Medium")
    fontSize(35)
    local titleSize = textSize(levels[levels.current].name)
    title.underline.length = (WIDTH / 2) - (titleSize / 2)
    
    popStyle()

    title.underline.tweens.length = tween(
        params.duration,
        title.underline,
        {length = (WIDTH / 2) + (titleSize / 2)},
        tween.easing.elasticOut
    )
end

function title.underline.draw(params)
    pushStyle()
    
    font("Futura-Medium")
    fontSize(35)
    local titleSize = textSize(levels[levels.current].name)
    
    local col = levels[levels.current].col
    stroke(col.r, col.g, col.b, title.underline.fade)
    strokeWidth(3)

    line((WIDTH / 2) - (titleSize / 2), (HEIGHT / 2) - 20, title.underline.length or (WIDTH / 2) - (titleSize / 2), (HEIGHT / 2) - 20)
    
    popStyle()
end