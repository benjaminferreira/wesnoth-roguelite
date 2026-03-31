local H = wesnoth.dofile("~add-ons/Wesnoth_Roguelite/lua/mapgen_helpers.lua")
local W, HT = 32, 22
local tiles = H.init_map(W, HT, "Gg")

-- Hills along top and bottom edges (valley walls)
for x = 1, W do
    for y = 1, H.rand(2, 4) do
        tiles[y][x] = "Hh"
    end
    for y = HT - H.rand(1, 3), HT do
        tiles[y][x] = "Hh"
    end
end
-- Some mountains on the ridges
for _ = 1, H.rand(3, 5) do
    H.place_cluster(tiles, W, HT, H.rand(4, W-3), H.rand(1, 3), "Mm", 1)
end
for _ = 1, H.rand(3, 5) do
    H.place_cluster(tiles, W, HT, H.rand(4, W-3), H.rand(HT-2, HT), "Mm", 1)
end
-- Wildflowers and light forest in the valley
for _ = 1, H.rand(3, 5) do
    H.place_cluster(tiles, W, HT, H.rand(3, W-2), H.rand(6, HT-5), "Gs^Fp", H.rand(1, 2))
end
for _ = 1, H.rand(2, 4) do
    H.place_cluster(tiles, W, HT, H.rand(3, W-2), H.rand(6, HT-5), "Gd", 2)
end
-- Stream through the valley center
local rx = 1
local ry = H.rand(8, HT-8)
for x = 1, W do
    if H.rand(1,3) == 1 then ry = ry + H.rand(-1,1) end
    ry = math.max(5, math.min(HT-4, ry))
    tiles[ry][x] = "Ww"
end

H.scatter_villages(tiles, W, HT, "Gg^Vh", {"Gg", "Gd"}, 6)
H.add_borders(tiles, W, HT, "Mm", "Mm")
local p1x, p1y, p2x, p2y = H.place_castles(tiles, W, HT, "Gg", "Ke", "Ce")
return H.build_map_string(tiles, W, HT, p1x, p1y, p2x, p2y)
