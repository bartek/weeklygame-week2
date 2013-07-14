import graphics from love

require "lovekit.geometry"

export Player

class Player
    w: 40
    h: 60
    speed: 500

    new: (@world, x, y) =>
        @box = Box x, y, @w, @h

        @destination = Vec2d x, y

    update: (dt) =>
        disx = @destination.x - @box.x
        disy = @destination.y - @box.y

        delta = Vec2d disx, disy
        delta = delta\normalized!
        delta *= dt

        speed = @speed

        dx, dy = unpack delta

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
        @destination = Vec2d x, y

    draw: =>
        graphics.rectangle "fill",
            @box.x, @box.y, @w, @h
