import random from math

OBSTACLE = 'x'
PATH = 'o'
RANDOM = '!'

MAX_DISTANCE = 2
MOVEMENTS = 0

walk_path = (mt, current, goal) ->
    options = {}
    -- from the current point, can we go left or right?
    i, j = unpack current

    print "Current", unpack current
    print "Goal", unpack goal
    print "POSL", math.abs(goal[2] - (j - 1))
    print "POSR", math.abs(goal[2] - (j + 1))

    MOVEMENTS += 1

    -- done!
    if current[1] == goal[1] and current[2] == goal[2]
        print "Found the path in " .. MOVEMENTS .. " movements :)"
        return mt
    
    if mt[i][j - 1] == nil or math.abs(goal[2] - (j - 1)) >= MAX_DISTANCE
        -- Can't go left
        print "NO LEFT"
    else
        options[#options + 1] = 'left'
    
    if mt[i][j + 1] == nil or math.abs(goal[2] - (j + 1)) >= MAX_DISTANCE
        -- Can't go right
        print "NO RIGHT"
    else
        options[#options + 1] = 'right'

    if mt[i + 1] == nil
        -- Can't go up
        print "NO UP"
    else
        for i=1, 1
            options[#options + i] = 'up'

    -- empty options means we cant go anywhere!
    if #options == 0
        print "OH NO"
        return false

    choice = options[math.random 1, #options]

    print "WENT", choice

    if choice == 'right'
        j = j + 1
    elseif choice == 'left'
        j = j - 1
    elseif choice == 'up'
        i = i + 1

    mt[i][j] = PATH
    current = {i, j}

    walk_path mt, current, goal

test_path_gen = ->
    -- define a matrix full of blocks, then dig/walk through the blocks, 
    -- until you reach the end goal from the starting point.
    mt = {}
    for i=1,10
        mt[i] = {}
        for j=1,10
            mt[i][j] = OBSTACLE

    current = {1, 5}
    goal = {#mt, 4}

    i, j = unpack current
    mt[i][j] = PATH
    i, j = unpack goal
    mt[i][j] = PATH

    mt = walk_path mt, current, goal
    
    if mt == false
        print "You broke it"

    for i, row in ipairs mt
       print ''
       for j, cell in ipairs row
            io.write(cell)

test_path_gen!
