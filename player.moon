import graphics from love

require "lovekit.geometry"

export Player

class Player
    w: 40
    h: 60
    speed: 10

    new: (@world, x, y) =>
        @velocity = Vec2d 0, 0
        @box = Box x, y, @w, @h

        @destination = Vec2d 0, 0

    update: (dt) =>
        @velocity = @destination if @destinaton

        delta = Vec2d @destination.x, @destination.y
        delta += @velocity

        speed = @speed

        delta *= dt
        delta = delta\normalized!

        dx, dy = unpack delta

        dx *= speed
        dy *= speed

        -- print "angle", math.atan2(dx, dy) * 180 / math.pi

        if math.floor(@box.x) > @destination.x
            @box.x -= dx
        elseif math.floor(@box.x) < @destination.x
            @box.x += dx

        if math.floor(@box.y) > @destination.y
            @box.y -= dy
        elseif math.floor(@box.y) < @destination.y
            @box.y += dy

    set_destination: (x, y) =>
        @destination = Vec2d x, y

    draw: =>
        graphics.rectangle "fill",
            @box.x, @box.y, @w, @h
