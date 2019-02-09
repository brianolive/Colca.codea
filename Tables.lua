studio = {}

studio.b = {
    rot = 0
}
studio.b.tweens = {}

studio.falling = {
    fallingFade = 0
}
studio.falling.tweens = {}

studio.whiteText = {
    fade = 0
}
studio.whiteText.tweens = {}

title = {
    fade = 0
}
title.tweens = {}

title.underline = {
    fade = 0,
    length
}
title.underline.tweens = {}

function studio.b.rotate(params)
    studio.b.tweens.rot = tween(
        params.duration,
        studio.b,
        {rot = params[1]},
        params[2]
    )
end

function studio.b.draw(params)
    pushStyle()
    
    font("Copperplate-Bold")
    fontSize(60)
    textMode(CORNER)
    
    local B = image(44, 61)
    setContext(B)
            
    fill(255, 255, 255, studio.whiteText.fade)
    text("B", 0, 0)
            
    setContext()
    spriteMode(CORNER)
            
    translate(WIDTH / 2 + 85, HEIGHT / 2 - 15)
    rotate(studio.b.rot)
    sprite(B, 0, 0)
    rotate(-studio.b.rot)
    translate(-(WIDTH / 2 + 85), -(HEIGHT / 2 - 15))
            
    popStyle()
end

function studio.falling.colorFadeIn(params)
    studio.falling.tweens.fallingFadeIn = tween(
        params.duration,
        studio.falling,
        {fallingFade = 255},
        tween.easing.cubicIn
    )
end

function studio.falling.colorFadeOut(params)
    studio.falling.tweens.fallingFadeOut = tween(
        params.duration,
        studio.falling,
        {fallingFade = 0},
        tween.easing.cubicIn
    )
end

function studio.falling.draw(params)
    pushStyle()
            
    font("Copperplate-Bold")
    fontSize(60)         
        
    fill(201, 59, 15, studio.falling.fallingFade)
    textMode(CORNER)
    text("Falling", WIDTH / 2 - 176, HEIGHT / 2 - 15)
    
    popStyle()
end

function studio.whiteText.whiteFadeIn(params)
    studio.whiteText.tweens.whiteFadeIn = tween(
        params.duration,
        studio.whiteText,
        {fade = 255},
        tween.easing.cubicIn
    )
end

function studio.whiteText.whiteFadeOut(params)
    studio.whiteText.tweens.whiteFadeOut = tween(
        params.duration,
        studio.whiteText,
        {fade = 0},
        tween.easing.cubicIn
    )
end

function studio.whiteText.draw(params)
    pushStyle()
    
    fill(255, 255, 255, studio.whiteText.fade)
    
    font("Copperplate-Bold")
    fontSize(60)
    textMode(CORNER)
    text("Falling", WIDTH / 2 - 176, HEIGHT / 2 - 15)
    text("'s", WIDTH / 2 + 130, HEIGHT / 2 - 15)
            
    font("Copperplate-Light")
    textMode(CENTER)
    fontSize(26)
    text("Studio", WIDTH / 2, HEIGHT / 2 - 20)
    
    popStyle()
end

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