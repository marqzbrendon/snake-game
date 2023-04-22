collision = require("collision")
overlapPos = require("overlap")

function love.load()
    math.randomseed(os.time())

    snakes = {}
    for i = 4, 1, -1 do 
        local snake = {}
        snake.x = 250
        snake.y = 350
        snake.w = 50
        snake.h = 50
        if i == 1 then
            snake.dir = "right"
        end
        table.insert(snakes, snake)
    end

    current_pos = {}
    for i = 1, #snakes, 1 do
        local tuple = {snakes[i].x, snakes[i].y}
        table.insert(current_pos, tuple)
    end

    food = {}
    food.w = 50
    food.h = 50
    food.x = math.random(0, 15) * 50
    food.y = math.random(0, 15) * 50
    while true do
        local overlap = overlapPos.checkPos(current_pos, food)
        if not overlap then
            break
        end
        food.w = 50
        food.h = 50
        food.x = math.random(0, 15) * 50
        food.y = math.random(0, 15) * 50
    end
     

    count = 0
    updateDelay = 1
end

function love.update(dt)
    count = count + dt -- dt is in seconds

    if love.keyboard.isDown("right") and snakes[1].dir ~= "left" then
        snakes[1].dir = "right"
    elseif love.keyboard.isDown("left") and snakes[1].dir ~= "right" then
        snakes[1].dir = "left"
    elseif love.keyboard.isDown("up") and snakes[1].dir ~= "down" then
        snakes[1].dir = "up"
    elseif love.keyboard.isDown("down") and snakes[1].dir ~= "up" then
        snakes[1].dir = "down"
    end

    if count > updateDelay then
        local prev_x = 0
        local prev_y = 0

        for i = 1, #snakes, 1 do
            if i == 1 then 
                if snakes[i].dir == "right" then
                    snakes[i].x = snakes[i].x + 50
                elseif snakes[i].dir == "left" then
                    snakes[i].x = snakes[i].x - 50
                elseif snakes[i].dir == "up" then
                    snakes[i].y = snakes[i].y - 50
                elseif snakes[i].dir == "down" then
                    snakes[i].y = snakes[i].y + 50
                end

                if snakes[i].x + 1 < 0 then
                    snakes[i].x = 750
                elseif snakes[i].x - 1 > 750 then
                    snakes[i].x = 0
                end
        
                if snakes[i].y + 1 < 0 then
                    snakes[i].y = 550
                elseif snakes[i].y - 1 > 550 then
                    snakes[i].y = 0
                end

                if collision.AABB(snakes[i].x, snakes[i].y, snakes[i].w, snakes[i].h, food.x, food.y, food.w, food.h) then
                    local snake = {}
                    snake.x = food.x
                    snake.y = food.y
                    snake.w = food.w
                    snake.h = food.h
                    snake.dir = snakes[i].dir
                    table.insert(snakes, 1, snake)
                    
                    while #food > 0 do
                        table.remove(food)
                    end

                    local food = {}
                    food.w = 50
                    food.h = 50
                    food.x = math.random(0, 15) * 50
                    food.y = math.random(0, 15) * 50
                    while true do
                        local overlap = overlapPos.checkPos(current_pos, food)
                        if not overlap then
                            break
                        end
                        food.w = 50
                        food.h = 50
                        food.x = math.random(0, 15) * 50
                        food.y = math.random(0, 15) * 50
                    end
                    table.insert(food, food)
                    break
                end

                prev_x = snakes[i].x
                prev_y = snakes[i].y
            else
                local current_x = snakes[i].x
                local current_y = snakes[i].y

                snakes[i].x = prev_x
                snakes[i].y = prev_y
                prev_x = current_x
                prev_y = current_y

                while #current_pos > 0 do
                    table.remove(current_pos)
                end
                for i = 1, #snakes, 1 do
                    local tuple = {snakes[i].x, snakes[i].y}
                    table.insert(current_pos, tuple)
                end
            end
        end
        count = 0
    end
end

function love.draw()
    for i = 1, #snakes, 1 do
        if i == 1 then
            love.graphics.setColor(255/255, 0/255, 0/255)
            love.graphics.rectangle("fill", snakes[i].x, snakes[i].y, snakes[i].w, snakes[i].h)
        else
            love.graphics.setColor(255/255, 255/255, 255/255)
            love.graphics.rectangle("fill", snakes[i].x, snakes[i].y, snakes[i].w, snakes[i].h)
        end
        love.graphics.setColor(0/255, 255/255, 0/255)
        love.graphics.rectangle("fill", food.x, food.y, food.w, food.h)
    end
end