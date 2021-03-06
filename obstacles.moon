import graphics from love

require "lovekit.geometry"
require "lovekit.image"
require "config"

PATH = 'o'
OBSTACLE = 'x'
MAX_DISTANCE = 2

export Rock
export SinglePath
export generate_block
export PATH
export OBSTACLE

-- Base class for a tile on the screen. All obstacles or path
-- ways must sublcass this.
class Tile extends Box
    new: (@world, @x, @y) =>
    update: (dt) =>
        self\move 0, @world.level.config.tile_speed

        -- return true if item is still alive.
        if @y > screen.h
            return false
        true

    draw: =>
        graphics.rectangle "fill",
            @x, @y, @w, @h

class Obstacle extends Tile
    obstacle: true
    w: 48
    h: 48

    draw: =>
        @sprite\draw @x, @y if @sprite

class Rock extends Obstacle
    new: (...) =>
        super ...
        @sprite = imgfy unpack assets.rock


class Collectible extends Tile
    w: 48
    h: 48

    draw: =>
        @sprite\draw @x, @y if @sprite

class Coin extends Collectible
    new: (...) =>
        super ...
        @sprite = imgfy unpack assets.coin
        @dead = false

    update: (dt) =>
        if @world.player.box\touches_box self
            @dead = true
        super dt

class SinglePath extends Tile
    obstacle: false
    w: 48
    h: 48

    new: (...) =>
        super ...

        @collectible = nil
        -- Decide if there should be a collectible here.
        if math.random! > 0.5
            @collectible = Coin @world, @x, @y

    update: (dt) =>
        @collectible\update dt if @collectible
        if @collectible and @collectible.dead == true
            @collectible = nil
            @world.player\up_score!
        super dt

    draw: =>
        @collectible\draw! if @collectible

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
    if not mt[i][j - 1] == nil or math.abs(goal[2] - (j - 1)) >= MAX_DISTANCE
        -- Can't go left
        pass
    else
        options[#options + 1] = 'left'
    
    if mt[i][j + 1] == nil or math.abs(goal[2] - (j + 1)) >= MAX_DISTANCE
        -- Can't go right
        pass
    else
        options[#options + 1] = 'right'

    if mt[i + 1] == nil
        -- Can't go up
        pass
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
