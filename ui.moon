require "config"
require "lovekit.image"

export HealthBar

class HealthBar
    new: (lives=3) =>
        @lives = lives
        @sprite = imgfy "assets/chipmunk.png"

    decrease: () =>
        @lives -= 1

    draw: =>
        -- Chipmunks everywhere!
        padding = 10
        y = padding
        x = screen.w - padding
        for i=1,@lives + 1
            @sprite\draw x, y
            x -= @sprite\width!
