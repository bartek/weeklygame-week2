import random from math

require "player"
require "obstacles"
require "lovekit.lists"

class GameState
    attach: (love) =>
        love.update = self\update
        love.draw = self\draw
        love.keypressed = self\keypressed
        love.mousepressed = self\mousepressed

    update: =>
    draw: =>
    keypressed: =>
    mousepressed: =>


class World extends GameState
    new: =>
        @obstacles = ReuseList!

    -- auto set player to class instance.
    spawn_player: (@player) =>

    update: (dt) =>
        doit = 0.5 * random!

        -- temp test dump of obstacles
        if doit > 0.45
            @obstacles\add Obstacle, random(0, 600), 0

        @obstacles\update dt

    collides: (thing) =>
        for o in *@obstacles
            if o\touches_box thing.box
                return true
        return false

    draw: =>
        @player\draw! if @player
        @obstacles\draw!

class Game extends GameState
    new: =>
        @w = World!
        @player = Player @w, 100, 100
        @w\spawn_player @player

    mousepressed: (x, y, button) =>
        @player\set_destination x, y
    
    update: (dt) =>
        @w\update dt
        @player\update dt

    draw: =>
        @w\draw!

love.load = ->
    game = Game!
    game\attach love
