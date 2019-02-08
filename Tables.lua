title = {
    fade
}
title.tweens = {}

function title.fadeIn(duration)
    title.fade = 0
    
    title.tweens.fade = tween(
        duration,
        title,
        {fade = 255}
    )
end

function title.fadeOut(duration)  
    title.tweens.fade = tween(
        duration,
        title,
        {fade = 0}
    )
end

function title.draw()
    pushStyle()
    
    font("Futura-Medium")
    fill(127, 127, 127, title.fade)
    fontSize(35)
    
    text(levels[levels.current].name, WIDTH / 2, HEIGHT / 2)
    
    popStyle()
end

title.underline = {
    fade,
    length
}
title.underline.tweens = {}

function title.underline.fadeIn(duration)
    title.underline.fade = 0
    
    title.underline.tweens.fade = tween(
        duration,
        title.underline,
        {fade = 255}
    )
end

function title.underline.fadeOut(duration)  
    title.underline.tweens.fade = tween(
        duration,
        title.underline,
        {fade = 0}
    )
end

function title.underline.stretch(duration)
    pushStyle()
    
    font("Futura-Medium")
    fontSize(35)
    local titleSize = textSize(levels[levels.current].name)
    title.underline.length = (WIDTH / 2) - (titleSize / 2)
    
    popStyle()

    title.underline.tweens.length = tween(
        duration,
        title.underline,
        {length = (WIDTH / 2) + (titleSize / 2)},
        tween.easing.elasticOut
    )
end

function title.underline.draw()
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