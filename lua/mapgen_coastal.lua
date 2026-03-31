local H = wesnoth.dofile("~add-ons/Wesnoth_Roguelite/lua/mapgen_helpers.lua")
local W, HT = 34, 24
-- Start with water
local tiles = H.init_map(W, HT, "Ww")

-- Create islands / landmasses
-- Player island on left
H.place_cluster(tiles, W, HT, 5, H.rand(6, HT-5), "Gg", H.rand(4, 5))
H.place_cluster(tiles, W, HT, 7, H.rand(5, HT-4), "Gg", 3)
-- Enemy island on right
H.place_cluster(tiles, W, HT, W-4, H.rand(6, HT-5), "Gg", H.rand(4, 5))
H.place_cluster(tiles, W, HT, W-6, H.rand(5, HT-4), "Gg", 3)
-- Central island(s)
for _ = 1, H.rand(2, 4) do
    H.place_cluster(tiles, W, HT, H.rand(12, W-11), H.rand(5, HT-4), "Gg", H.rand(2, 3))
end
-- Shallow water bridges between islands
for _ = 1, H.rand(3, 5) do
    local bx, by = H.rand(8, W-7), H.rand(3, HT-2)
    H.place_cluster(tiles, W, HT, bx, by, "Ww^Bw|", 1)
end
-- Sand beaches on island edges
for y = 2, HT-1 do
    for x = 2, W-1 do
        if tiles[y][x] == "Gg" then
            for dy = -1, 1 do
                for dx = -1, 1 do
                    if tiles[y+dy] and tiles[y+dy][x+dx] == "Ww" and H.rand(1,100) > 60 then
                        tiles[y+dy][x+dx] = "Ds"
                    end
                end
            end
        end
    end
end
-- Forest on islands
for _ = 1, H.rand(3, 5) do
    local fx, fy = H.rand(3, W-2), H.rand(3, HT-2)
    if tiles[fy][fx] == "Gg" then
        H.place_cluster(tiles, W, HT, fx, fy, "Gs^Fp", H.rand(1, 2))
    end
end

H.scatter_villages(tiles, W, HT, "Gg^Vh", {"Gg", "Ds"}, 5)
local p1x, p1y, p2x, p2y = H.place_castles(tiles, W, HT, "Gg", "Ke", "Ce")
return H.build_map_string(tiles, W, HT, p1x, p1y, p2x, p2y)
