import graphics from love

require "lovekit.geometry"
require "lovekit.spriter"
require "config"

export Player

class Player
    w: 48
    h: 60
    speed: 500

    new: (@world, x, y) =>
        @box = Box x, y, @w, @h
        @destination = Vec2d x, y

        sprite = Spriter unpack assets.player
        @a = StateAnim "up", {
            up: sprite\seq {0}
            down: sprite\seq {0}, 0, true
        }


    move: (dx, dy) =>
        collided = false
        while @world\collides self
            @box.y += 1
            collided = true

            if dx < 0 and dy == 0
                @box.x += 1
            elseif dx > 0 and dy == 0
                @box.x -= 1
        collided

    update: (dt) =>
        disx = @destination.x - @box.x
        disy = @destination.y - @box.y

        delta = Vec2d disx, disy
        delta = delta\normalized!
        delta *= dt

        speed = @speed

        dx, dy = unpack delta

        collided = @move unpack delta
        if collided
            "Collided but updating"

        dx *= speed
        dy *= speed

        distance = math.floor math.sqrt (disx * disx) + (disy * disy)

        if distance <= (speed * dt) / 2
            @box.x = @destination.x
            @box.y = @destination.y
        else
            @box.x += dx
            @box.y += dy

    set_destination: (x, y) =>
        @destination = {x: x, y: y}

    draw: =>
        graphics.setColor 255, 255, 255
        @a\draw @box.x, @box.y
