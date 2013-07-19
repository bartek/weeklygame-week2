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
        @spawn = {x, y}
        @box = Box x, y, @w, @h
        @destination = Vec2d x, y

        sprite = Spriter unpack assets.player
        @a = StateAnim "up", {
            up: sprite\seq {0}
            down: sprite\seq {0}, 0, true
        }


    move: (dx, dy) =>
        collided_x = false
        collided_y = false
        for o in *@world.tiles
            if o.obstacle and o\touches_box @ and o.box\bottom_of @
                print "COLLIDING FROM THE BOTTOM"

        collided_x, collided_y

    update: (dt) =>
        disx = @destination.x - @box.x
        disy = @destination.y - @box.y

        delta = Vec2d disx, disy
        delta = delta\normalized!
        delta *= dt

        speed = @speed

        dx, dy = unpack delta

        collided_x, collided_y = @move unpack delta

        dx *= speed
        dy *= speed

        distance = math.floor math.sqrt (disx * disx) + (disy * disy)

        if distance <= (speed * dt) / 2
            @box.x = @destination.x
            @box.y = @destination.y
        else
            @box.x += dx
            @box.y += dy

    set_loc: (x, y) =>
        @box.x = x
        @box.y = y

    set_destination: (x, y) =>
        @destination = {x: x, y: y}

    draw: =>
        graphics.setColor 255, 255, 255
        @a\draw @box.x, @box.y
