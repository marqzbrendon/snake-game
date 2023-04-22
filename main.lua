require "collision"

function love.load()
    math.randomseed(os.time())

    snakes = {}

    for i = 3, 1, -1 do 
        local snake = {}
        snake.x = 250
        snake.y = 350
        snake.w = 50
        snake.h = 50
        snake.speed = 1
        if i == 1 then
            snake.head = true
            snake.dir = "right"
        else
            snake.head = false
        end
        table.insert(snakes, snake)
    end

    food = {}
    food.w = 50
    food.h = 50
    food.x = math.random(0, 15) * 50
    food.y = math.random(0, 15) * 50

    count = 0
    updateDelay = 1
end

function love.update(dt)
    count = count + dt -- dt is in seconds

    if love.keyboard.isDown("right") then
        snake.dir = "right"
    elseif love.keyboard.isDown("left") then
        snake.dir = "left"
    elseif love.keyboard.isDown("up") then
        snake.dir = "up"
    elseif love.keyboard.isDown("down") then
        snake.dir = "down"
    end

    if count > updateDelay then

        if snake.dir == "right" then
            snake.x = snake.x + 50
        elseif snake.dir == "left" then
            snake.x = snake.x - 50
        elseif snake.dir == "up" then
            snake.y = snake.y - 50
        elseif snake.dir == "down" then
            snake.y = snake.y + 50
        end

        if snake.x + 1 < 0 then
            snake.x = 750
        elseif snake.x - 1 > 750 then
            snake.x = 0
        end

        if snake.y + 1 < 0 then
            snake.y = 550
        elseif snake.y - 1 > 550 then
            snake.y = 0
        end
        count = 0
    end
end

function love.draw()
    love.graphics.setColor(255/255, 255/255, 255/255)
    love.graphics.rectangle("fill", snake.x, snake.y, snake.w, snake.h)
    love.graphics.setColor(0/255, 255/255, 0/255)
    love.graphics.rectangle("fill", food.x, food.y, food.w, food.h)
end