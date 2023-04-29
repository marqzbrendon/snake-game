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
            snake.fixed_dir = "right"
        end
        table.insert(snakes, snake)
    end

    current_pos = {}
    for i = 1, #snakes, 1 do
        local tuple = {snakes[i].x, snakes[i].y}
        table.insert(current_pos, tuple)
    end

    foods = {}
    local food = {}
    food.w = 50
    food.h = 50
    food.x = math.random(1, 15) * 50
    food.y = math.random(1, 10) * 50
    while true do
        local overlap = overlapPos.checkPos(current_pos, food)
        if not overlap then
            break
        end
        food.w = 50
        food.h = 50
        food.x = math.random(1, 15) * 50
        food.y = math.random(1, 10) * 50
    end
    table.insert(foods, food)

    count = 0
    updateDelay = 1
end

function love.update(dt)
    count = count + dt

    if love.keyboard.isDown("right") and snakes[1].fixed_dir ~= "left" then
        snakes[1].dir = "right"
    elseif love.keyboard.isDown("left") and snakes[1].fixed_dir ~= "right" then
        snakes[1].dir = "left"
    elseif love.keyboard.isDown("up") and snakes[1].fixed_dir ~= "down" then
        snakes[1].dir = "up"
    elseif love.keyboard.isDown("down") and snakes[1].fixed_dir ~= "up" then
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

                snakes[i].fixed_dir = snakes[i].dir

                if collision.AABB(snakes[i].x, snakes[i].y, snakes[i].w, snakes[i].h, foods[1].x, foods[1].y, foods[1].w, foods[1].h) then
                    if updateDelay > 0.2 then
                        updateDelay = updateDelay - 0.07
                    end
                    local snake = {}
                    snake.x = foods[1].x
                    snake.y = foods[1].y
                    snake.w = foods[1].w
                    snake.h = foods[1].h
                    snake.dir = snakes[i].dir
                    table.insert(snakes, 1, snake)

                    local tuple = {snake.x, snake.y}
                    table.insert(current_pos, tuple)

                    local food = {}
                    food.w = 50
                    food.h = 50
                    food.x = math.random(1, 15) * 50
                    food.y = math.random(1, 10) * 50
                    while true do
                        local overlap = overlapPos.checkPos(current_pos, food)
                        if not overlap then
                            break
                        end
                        food.w = 50
                        food.h = 50
                        food.x = math.random(1, 15) * 50
                        food.y = math.random(1, 10) * 50
                    end
                    table.insert(foods, 1, food)
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
        love.graphics.setColor(255/255, 0/255, 0/255)   
        love.graphics.rectangle("fill", snakes[i].x, snakes[i].y, snakes[i].w, snakes[i].h)
    end
    love.graphics.setColor(0/255, 255/255, 0/255)
    love.graphics.rectangle("fill", foods[1].x, foods[1].y, foods[1].w, foods[1].h)
end