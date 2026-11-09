function love.load()
    -- Make everything use nearest neighbour filtering (crisp pixels)
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- load images
    bikeBlueImg = love.graphics.newImage("assets/blue_bike.png")
    bikeRedImg  = love.graphics.newImage("assets/red_bike.png")

    -- optional glow images if you made them
    bikeBlueGlow = love.graphics.newImage("assets/blue_bike_glow.png")
    bikeRedGlow  = love.graphics.newImage("assets/bike_red_glow.png")

    -- if you load a trail tile (1x1 or small)
    trailBlue = love.graphics.newImage("assets/trail_blue.png")
    
    -- your other setup...
end
function drawBikeWithGlow(x, y, bikeImg, glowImg, r,g,b)
    -- draw glow behind with additive blending
    love.graphics.setBlendMode("add")
    love.graphics.setColor(r,g,b,0.7) -- glow tint, alpha
    love.graphics.draw(glowImg, x - glowImg:getWidth()/2, y - glowImg:getHeight()/2)
    love.graphics.setBlendMode("alpha")

    -- draw main bike
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(bikeImg, x - bikeImg:getWidth()/2, y - bikeImg:getHeight()/2)
end
function love.load()
    love.window.setTitle("TRON Lightcycle")
    love.window.setMode(800, 600)
    width, height = love.graphics.getDimensions()

    cellSize = 6
    cols = math.floor(width / cellSize)
    rows = math.floor(height / cellSize)
    speed = 15

    -- colors
    player1Color = {0, 1, 1}     -- cyan
    player2Color = {1, 0.4, 0.1} -- orange-red

    player1 = {
        x = math.floor(cols / 4),
        y = math.floor(rows / 2),
        dir = "right",
        color = player1Color,
        trail = {}
    }

    player2 = {
        x = math.floor(3 * cols / 4),
        y = math.floor(rows / 2),
        dir = "left",
        color = player2Color,
        trail = {}
    }

    grid = {}
    for i = 0, cols do
        grid[i] = {}
    end

    timer = 0
    gameOver = false
end

function love.update(dt)
    if gameOver then return end
    timer = timer + dt
    if timer > 1 / speed then
        timer = 0
        movePlayer(player1)
        aiMove(player2)
        movePlayer(player2)
    end
end

function movePlayer(p)
    if p.dir == "up" then p.y = p.y - 1 end
    if p.dir == "down" then p.y = p.y + 1 end
    if p.dir == "left" then p.x = p.x - 1 end
    if p.dir == "right" then p.x = p.x + 1 end

    if p.x < 0 or p.y < 0 or p.x >= cols or p.y >= rows or grid[p.x][p.y] then
        gameOver = true
        return
    end

    grid[p.x][p.y] = true
    table.insert(p.trail, {x = p.x, y = p.y, alpha = 1})
end

-- 🔥 Smarter AI: moves toward the player, avoids walls/trails
function aiMove(p)
    local targetX, targetY = player1.x, player1.y

    -- prefer the direction that reduces distance to player
    local bestDir = p.dir
    local bestDist = math.huge

    local dirs = {
        {name="up",    dx=0,  dy=-1},
        {name="down",  dx=0,  dy=1},
        {name="left",  dx=-1, dy=0},
        {name="right", dx=1,  dy=0}
    }

    for _, d in ipairs(dirs) do
        local nx, ny = p.x + d.dx, p.y + d.dy
        if not (nx < 0 or ny < 0 or nx >= cols or ny >= rows or grid[nx][ny]) then
            local dist = math.abs(nx - targetX) + math.abs(ny - targetY)
            if dist < bestDist then
                bestDist = dist
                bestDir = d.name
            end
        end
    end

    p.dir = bestDir
end

function love.keypressed(key)
    if gameOver and key == "r" then
        love.load()
    end

    if key == "up" and player1.dir ~= "down" then player1.dir = "up" end
    if key == "down" and player1.dir ~= "up" then player1.dir = "down" end
    if key == "left" and player1.dir ~= "right" then player1.dir = "left" end
    if key == "right" and player1.dir ~= "left" then player1.dir = "right" end
end

function love.draw()
    love.graphics.setBackgroundColor(0, 0, 0.05)

    -- glowing grid background
    love.graphics.setColor(0, 0.3, 0.6, 0.2)
    for x = 0, cols do
        love.graphics.line(x * cellSize, 0, x * cellSize, height)
    end
    for y = 0, rows do
        love.graphics.line(0, y * cellSize, width, y * cellSize)
    end

    -- additive blending for glow
    love.graphics.setBlendMode("add")
    drawTrail(player1)
    drawTrail(player2)
    love.graphics.setBlendMode("alpha")

    -- players
    love.graphics.setColor(player1.color)
    love.graphics.rectangle("fill", player1.x * cellSize, player1.y * cellSize, cellSize, cellSize)
    love.graphics.setColor(player2.color)
    love.graphics.rectangle("fill", player2.x * cellSize, player2.y * cellSize, cellSize, cellSize)

    if gameOver then
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("GAME OVER\nPress R to Restart", 0, height / 2 - 30, width, "center")
    end
end

-- ⚡ Faster fading trail
function drawTrail(p)
    for i, seg in ipairs(p.trail) do
        seg.alpha = seg.alpha - 0.01  -- faster fade
        if seg.alpha > 0 then
            love.graphics.setColor(p.color[1], p.color[2], p.color[3], seg.alpha)
            love.graphics.rectangle("fill", seg.x * cellSize, seg.y * cellSize, cellSize, cellSize)
        end
    end
end
