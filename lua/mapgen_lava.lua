local H = wesnoth.dofile("~add-ons/Wesnoth_Roguelite/lua/mapgen_helpers.lua")
local W, HT = 26, 18
local tiles = H.init_map(W, HT, "Xu")

-- Carve chambers
local chambers = {}
for _ = 1, H.rand(3, 5) do
    local cx, cy = H.rand(5, W-4), H.rand(4, HT-3)
    table.insert(chambers, {cx, cy})
    for dy = -2, 2 do
        for dx = -2, 2 do
            local x, y = cx + dx, cy + dy
            if x >= 1 and x <= W and y >= 1 and y <= HT then
                if math.abs(dx) + math.abs(dy) <= 3 then
                    tiles[y][x] = "Uu"
                end
            end
        end
    end
end

-- Connect with passages
for i = 1, #chambers - 1 do
    local ax, ay = chambers[i][1], chambers[i][2]
    local bx, by = chambers[i+1][1], chambers[i+1][2]
    local x, y = ax, ay
    while x ~= bx or y ~= by do
        if x >= 1 and x <= W and y >= 1 and y <= HT then
            tiles[y][x] = "Uu"
        end
        if x < bx then x = x + 1 elseif x > bx then x = x - 1 end
        if y < by then y = y + 1 elseif y > by then y = y - 1 end
    end
end

-- Lava rivers through the cave
local lx = H.rand(8, W-8)
for y = 1, HT do
    if H.rand(1,3) == 1 then lx = lx + H.rand(-1,1) end
    lx = math.max(4, math.min(W-4, lx))
    if tiles[y][lx] == "Uu" then
        tiles[y][lx] = "Ql"  -- lava
    end
end

H.scatter_villages(tiles, W, HT, "Uu^Vu", {"Uu"}, 3)
H.add_borders(tiles, W, HT, "Xu", "Xu")
local p1x, p1y, p2x, p2y = H.place_castles(tiles, W, HT, "Uu", "Ke", "Ce")
return H.build_map_string(tiles, W, HT, p1x, p1y, p2x, p2y)
