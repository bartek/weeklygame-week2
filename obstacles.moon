import graphics from love

require "lovekit.geometry"

export Obstacle

class Obstacle extends Box
    w: 48
    h: 48
    alive: true

    new: (@x, @y) =>

    update: (dt) =>
        self\move 0, 10

    draw: =>
        graphics.rectangle "fill",
            @x, @y, @w, @h
