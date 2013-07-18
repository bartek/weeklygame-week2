import graphics from love

require "lovekit.geometry"
require "lovekit.spriter"
require "config"

export Player

class Player
    w: 30
    h: 60
    speed: 500

    new: (@world, x, y) =>
        @box = Box x, y, @w, @h
        @destination = Vec2d x, y
        sprite = Spriter assets.player, 48, 64
        @a = StateAnim "up", {
            up: sprite\seq {0}
            down: sprite\seq {0}, 0, true
        }

    move: (dx, dy) =>
        @world\collides self

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
            -- temp stub for pushback. This wont quite work and can be
            -- forced out of the push, but collisions!
            @destination.y += 10

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
