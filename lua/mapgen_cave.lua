local H = wesnoth.dofile("~add-ons/Wesnoth_Roguelite/lua/mapgen_helpers.lua")
local W, HT = 26, 20
-- Start with all walls
local tiles = H.init_map(W, HT, "Xu")

-- Carve chambers
local chambers = {}
for _ = 1, H.rand(4, 6) do
    local cx, cy = H.rand(5, W-4), H.rand(4, HT-3)
    local size = H.rand(2, 3)
    table.insert(chambers, {cx, cy})
    for dy = -size, size do
        for dx = -size, size do
            local x, y = cx + dx, cy + dy
            if x >= 1 and x <= W and y >= 1 and y <= HT then
                local dist = math.abs(dx) + math.abs(dy)
                if dist <= size then
                    tiles[y][x] = "Uu"
                end
            end
        end
    end
end

-- Connect chambers with passages
for i = 1, #chambers - 1 do
    local ax, ay = chambers[i][1], chambers[i][2]
    local bx, by = chambers[i+1][1], chambers[i+1][2]
    local x, y = ax, ay
    while x ~= bx or y ~= by do
        tiles[y][x] = "Uu"
        if x < bx then x = x + 1
        elseif x > bx then x = x - 1
        end
        if y < by then y = y + 1
        elseif y > by then y = y - 1
        end
        if x >= 1 and x <= W and y >= 1 and y <= HT then
            tiles[y][x] = "Uu"
        end
    end
end

-- Scatter mushrooms and cave features
for y = 1, HT do
    for x = 1, W do
        if tiles[y][x] == "Uu" then
            local r = H.rand(1, 100)
            if r > 95 then tiles[y][x] = "Uu^Uf"  -- mushrooms
            elseif r > 90 then tiles[y][x] = "Uu^Ii" -- campfire
            end
        end
    end
end

H.scatter_villages(tiles, W, HT, "Uu^Vu", {"Uu"}, 4)
H.add_borders(tiles, W, HT, "Xu", "Xu")
local p1x, p1y, p2x, p2y = H.place_castles(tiles, W, HT, "Uu", "Ke", "Ce")
return H.build_map_string(tiles, W, HT, p1x, p1y, p2x, p2y)
