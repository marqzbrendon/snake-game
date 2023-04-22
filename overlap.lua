local overlapPos = {}

function overlapPos.checkPos(snake_pos, obj)
    for i = 1, #snake_pos do
        if snake_pos[i][1] == obj.x and snake_pos[i][2] == obj.y then
            return true
        end
    end
    return false
end

return overlapPos