-- mapgen_helpers.lua — shared functions for all biome generators

local H = {}

function H.rand(min, max)
    return wesnoth.random(min, max)
end

function H.init_map(width, height, base_terrain)
    local tiles = {}
    for y = 1, height do
        tiles[y] = {}
        for x = 1, width do
            tiles[y][x] = base_terrain
        end
    end
    return tiles
end

function H.place_cluster(tiles, width, height, cx, cy, terrain, size)
    for dy = -size, size do
        for dx = -size, size do
            local x, y = cx + dx, cy + dy
            if x >= 1 and x <= width and y >= 1 and y <= height then
                local dist = math.abs(dx) + math.abs(dy)
                if dist <= size and H.rand(1, 100) > dist * 20 then
                    tiles[y][x] = terrain
                end
            end
        end
    end
end

function H.place_castles(tiles, width, height, base, keep, castle)
    local p1x, p1y = 3, H.rand(4, height - 3)
    local p2x, p2y = width - 2, H.rand(4, height - 3)

    -- Clear safe zones
    for _, pos in ipairs({{p1x, p1y}, {p2x, p2y}}) do
        for dy = -2, 2 do
            for dx = -2, 2 do
                local x, y = pos[1] + dx, pos[2] + dy
                if x >= 1 and x <= width and y >= 1 and y <= height then
                    tiles[y][x] = base
                end
            end
        end
    end

    -- Place keeps + castles
    for _, info in ipairs({{p1x, p1y}, {p2x, p2y}}) do
        local kx, ky = info[1], info[2]
        tiles[ky][kx] = keep
        for dy = -1, 1 do
            for dx = -1, 1 do
                if not (dx == 0 and dy == 0) then
                    local cx, cy = kx + dx, ky + dy
                    if cx >= 1 and cx <= width and cy >= 1 and cy <= height then
                        tiles[cy][cx] = castle
                    end
                end
            end
        end
    end

    return p1x, p1y, p2x, p2y
end

function H.build_map_string(tiles, width, height, p1x, p1y, p2x, p2y)
    local rows = {}
    for y = 1, height do
        local row = {}
        for x = 1, width do
            local t = tiles[y][x]
            if x == p1x and y == p1y then
                t = "1 " .. t
            elseif x == p2x and y == p2y then
                t = "2 " .. t
            end
            row[x] = t
        end
        rows[y] = table.concat(row, ", ")
    end
    return table.concat(rows, "\n")
end

function H.scatter_villages(tiles, width, height, village, valid_terrains, count)
    -- Place villages semi-symmetrically: for each village on the left half,
    -- try to place one on the right half at a mirrored-ish position
    local placed = 0
    local attempts = 0
    while placed < count and attempts < 300 do
        local vx = H.rand(3, math.floor(width / 2))
        local vy = H.rand(3, height - 2)
        local t = tiles[vy][vx]
        local valid = false
        for _, vt in ipairs(valid_terrains) do
            if t == vt then valid = true; break end
        end
        if valid then
            tiles[vy][vx] = village
            placed = placed + 1
            -- Mirror on right side (with slight offset)
            local mx = width + 1 - vx + H.rand(-1, 1)
            local my = vy + H.rand(-1, 1)
            mx = math.max(2, math.min(width - 1, mx))
            my = math.max(2, math.min(height - 1, my))
            local mt = tiles[my][mx]
            for _, vt in ipairs(valid_terrains) do
                if mt == vt then
                    tiles[my][mx] = village
                    placed = placed + 1
                    break
                end
            end
        end
        attempts = attempts + 1
    end
end

-- Add border ornamentation to map edges
function H.add_borders(tiles, width, height, border_terrain, corner_terrain)
    for x = 1, width do
        if tiles[1][x] ~= "Ke" and tiles[1][x] ~= "Ce" then
            tiles[1][x] = border_terrain
        end
        if tiles[height][x] ~= "Ke" and tiles[height][x] ~= "Ce" then
            tiles[height][x] = border_terrain
        end
    end
    for y = 1, height do
        if tiles[y][1] ~= "Ke" and tiles[y][1] ~= "Ce" then
            tiles[y][1] = border_terrain
        end
        if tiles[y][width] ~= "Ke" and tiles[y][width] ~= "Ce" then
            tiles[y][width] = border_terrain
        end
    end
    -- Corners get heavier terrain
    if corner_terrain then
        tiles[1][1] = corner_terrain
        tiles[1][width] = corner_terrain
        tiles[height][1] = corner_terrain
        tiles[height][width] = corner_terrain
    end
end

return H
