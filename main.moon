import graphics from love
import random from math

require "player"
require "levels"
require "obstacles"
require "lovekit.lists"

-- when to level up
TIMED_LEVEL_UP = 50

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


class BoxedDrawList extends DrawList
    show_boxes: true

-- TODO They beat the game.
class GameWon extends GameState
    draw: =>
        graphics.setColor 255, 255, 255
        graphics.print "You beat the game.", 0, 0

class World extends GameState
    -- tiles we're allowed to render.
    obstacles: {
        Rock,
    }

    paths: {
        SinglePath,
    }

    new: =>
        @tiles = BoxedDrawList!
        @last_tile = nil
        @level = 1
        @level_config = levels[@level]
        @time = 0
        @start = love.timer.getTime()

    set_level: (dt) =>
        -- Get the level based on a simple timelapse. Every N
        -- seconds we move up a level.
        @time += (love.timer.getFPS() * dt) / 12
        if @time > TIMED_LEVEL_UP
            @level += 1
            @time = 0
            @level_config = levels[@level]
            if @level_config == nil
                time = math.ceil(love.timer.getTime() - @start)
                GameWon(self, time)\attach love

    -- auto set player to class instance.
    spawn_player: (@player) =>
        @spawn_tiles!

    -- pick an obstacle object to represent the tile passed.
    pick_tile: (tile) =>
        -- TODO: Constants.
        if tile == 'x'
            return @obstacles[math.random 1, #@obstacles]
        elseif tile == 'o'
            return @paths[math.random 1, #@paths]

    build_block: (rows, columns, mt) =>
        -- build a block. Call it multiple times to build more than
        -- one path, perhaps hilarity will ensue?
        pivot = math.random 1, columns
        current = {1, math.random (pivot - 1), (pivot + 1)}
        goal = {rows, math.random (pivot - 1), (pivot + 1)}

        mt = generate_block columns, rows, current, goal, mt
        mt

    spawn_tiles: =>
        -- spawn tiles onto the screen by generating a block
        x = 0
        y = 0
        xpadding = 10
        ypadding = 0

        rows = math.random 5, 10
        columns = math.floor screen.w / (tilesettings.w + xpadding)

        mt = nil

        -- build paths based on our toughness
        path_count = @level_config.paths
        for i=1,path_count
            mt = @build_block rows, columns, mt

        -- debug
        for i, row in ipairs mt
           print ''
           for j, cell in ipairs row
                io.write(cell)

        last_tile = nil
        for i, row in ipairs mt
            x = 0
            tile = nil
            for j, cell in ipairs row
                tile = @pick_tile cell
                tile = tile self, x, y

                @tiles\add tile

                x += tile.w + xpadding

            -- last run
            if i == rows
                last_tile = tile


            -- adjust the y pos based on the last tiles height.
            -- they are all the same!
            y -= @tiles[#@tiles].h + ypadding

        @last_tile = last_tile
        @last_tile

    update: (dt) =>
        -- Spawn the next set of tiles as soon as the last item in the list
        -- is past the y point.
        if @last_tile and @last_tile.y > screen.h
            @spawn_tiles!

        @set_level dt

        @tiles\update dt

    collides: (thing) =>
        for o in *@tiles
            if o.obstacle and o\touches_box thing.box
                return true
        return false

    draw: =>
        @tiles\draw!
        @player\draw! if @player

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
    graphics.setMode(screen.w, screen.h)

    game = Game!
    game\attach love
