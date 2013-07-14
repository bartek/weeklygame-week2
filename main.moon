require "player"

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

    -- auto set player to class instance.
    spawn_player: (@player) =>

    draw: =>
        @player\draw! if @player

class Game extends GameState
    new: =>
        @w = World!
        @player = Player @w, 100, 100
        @w\spawn_player @player

    mousepressed: (x, y, button) =>
        print "mousepressed", x, y, button
        @player\set_destination x, y
    
    update: (dt) =>
        @w\update dt
        @player\update dt

    draw: =>
        @w\draw!

love.load = ->
    game = Game!
    game\attach love
