local H = wesnoth.dofile("~add-ons/Wesnoth_Roguelite/lua/mapgen_helpers.lua")
local W, HT = 30, 22
local tiles = H.init_map(W, HT, "Gg")

-- Swamp pools
for _ = 1, H.rand(6, 9) do
    H.place_cluster(tiles, W, HT, H.rand(3, W-2), H.rand(3, HT-2), "Ss", H.rand(2, 3))
end
-- Shallow water pools
for _ = 1, H.rand(3, 5) do
    H.place_cluster(tiles, W, HT, H.rand(4, W-3), H.rand(4, HT-3), "Ww", H.rand(1, 2))
end
-- Muddy forest
for _ = 1, H.rand(3, 5) do
    H.place_cluster(tiles, W, HT, H.rand(3, W-2), H.rand(3, HT-2), "Gs^Fp", H.rand(1, 3))
end
-- Dirt paths
for _ = 1, 3 do
    H.place_cluster(tiles, W, HT, H.rand(3, W-2), H.rand(3, HT-2), "Gd", 2)
end

H.scatter_villages(tiles, W, HT, "Ss^Vhs", {"Gg", "Ss", "Gd"}, 5)
H.add_borders(tiles, W, HT, "Ss", "Ww")
local p1x, p1y, p2x, p2y = H.place_castles(tiles, W, HT, "Gg", "Ke", "Ce")
return H.build_map_string(tiles, W, HT, p1x, p1y, p2x, p2y)
