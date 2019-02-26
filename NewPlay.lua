function newPlayScene()
    local play = NewPlay()
    local scene = {}
    scene.action = action
    
    -- local variables
    local start
    local stop
    local action
    
    function scene.enter()
        return true
    end
    
    function scene.act()
        start = start or time.total
        action = action or scene.action(start)

        -- start, stop, object (draw), action (tween)
        action{31, 210, play.message, "show", {"Ready"}}
        action{211, 270, play.walls, "enter"}
        action{271, stop, play.walls}
    end
    
    function scene.exit()
        return stop
    end
    
    function scene.touched()
        -- Do nothing
    end
    
    return scene
end

function NewPlay()
    local play = {
        message = {
            alpha = 0
        },
        tweens = {},
        walls = {
            alpha = 0,
            x = 0
        }
    }
    
    function play.message.show(params)
        play.tweens.show = tween(
            2.5,
            play.message,
            {alpha = 255},
            tween.easing.linear,
            function()
                tween(
                    0.5,
                    play.message,
                    {alpha = 0}
                )
            end
        )
    end
    
    function play.message.draw(params)
        pushStyle()
        
        font("Futura-Medium")
        fontSize(30)
        fill(127, 127, 127, play.message.alpha)
        text(params[1], WIDTH / 2, HEIGHT / 2)
        
        popStyle()
    end
    
    function play.walls.enter(params)
        play.tweens.wallsEnter = tween(
            params.duration,
            play.walls,
            {alpha = 255, x = 350},
            tween.easing.bounceOut
        )
    end
    
    function play.walls.draw(params)
        pushStyle()
        background(63, 63, 63, 255)
        
        stroke(127, 127, 127, 255)
        strokeWidth(4)
        
        fill(0, 0, 0, 255)
        rect(play.walls.x, -5, WIDTH - (2 * play.walls.x), HEIGHT + 10)
        
        popStyle()
    end
    
    return play
end
