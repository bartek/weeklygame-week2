import graphics from love

require "lovekit.geometry"
require "config"

PATH = 'o'
OBSTACLE = 'x'
MAX_DISTANCE = 2

export Obstacle
export SinglePath
export generate_block
export PATH
export OBSTACLE

-- Base class for a tile on the screen. All obstacles or path
-- ways must sublcass this.
class Tile extends Box
    new: (@world, @x, @y) =>
    update: (dt) =>
        self\move 0, @world.level_config.tile_speed

        -- return true if item is still alive.
        if @y > screen.h
            return false
        true

    draw: =>
        love.graphics.setColor(255, 255, 255)
        graphics.rectangle "fill",
            @x, @y, @w, @h

class Obstacle extends Tile
    obstacle: true
    w: 48
    h: 48

class SinglePath extends Tile
    obstacle: false
    w: 48
    h: 48

    draw: =>
        love.graphics.setColor(66, 23, 99)
        graphics.rectangle "fill",
            @x, @y, @w, @h

walk_path = (mt, current, goal) ->
    options = {}
    i, j = unpack current

    --print "Current", unpack current
    --print "Goal", unpack goal
    --print "POSL", math.abs(goal[2] - (j - 1))
    --print "POSR", math.abs(goal[2] - (j + 1))

    -- Done!
    if current[1] == goal[1] and current[2] == goal[2]
        return mt
    
    -- TODO: review
    if mt[i][j - 1] == nil or math.abs(goal[2] - (j - 1)) >= MAX_DISTANCE
        -- Can't go left
        print "NO LEFT"
    else
        options[#options + 1] = 'left'
    
    -- TODO: review
    if mt[i][j + 1] == nil or math.abs(goal[2] - (j + 1)) >= MAX_DISTANCE
        -- Can't go right
        print "NO RIGHT"
    else
        options[#options + 1] = 'right'

    if mt[i + 1] == nil
        -- Can't go up
        print "NO UP"
    else
        -- TODO: Should be variable.
        for i=1, 10
            options[#options + i] = 'up'

    -- Empty options means we can't go anywhere and the game is broken :(
    if #options == 0
        return false

    choice = options[math.random 1, #options]

    if choice == 'right'
        j = j + 1
    elseif choice == 'left'
        j = j - 1
    elseif choice == 'up'
        i = i + 1

    mt[i][j] = PATH
    current = {i, j}

    walk_path mt, current, goal

generate_block = (columns, rows, current, goal, mt) ->
    -- Define a matrix that contains PATHs and OBSTACLEs, which will
    -- allow us to render a tileset.
    -- TODO: Allow existing mt to be passed, so we can generate
    -- blocks that have more than one path.

    if mt == nil
        mt = {}
        for i=1,rows
            mt[i] = {}
            for j=1,columns
                mt[i][j] = OBSTACLE

    -- Setup initial.
    i, j = unpack current
    mt[i][j] = PATH
    i, j = unpack goal
    mt[i][j] = PATH

    mt = walk_path mt, current, goal
    mt
