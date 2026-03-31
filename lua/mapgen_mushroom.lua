local H = wesnoth.dofile("~add-ons/Wesnoth_Roguelite/lua/mapgen_helpers.lua")
local W, HT = 28, 20
local tiles = H.init_map(W, HT, "Uu")

-- Dense mushroom groves
for _ = 1, H.rand(6, 9) do
    H.place_cluster(tiles, W, HT, H.rand(3, W-2), H.rand(3, HT-2), "Uu^Uf", H.rand(2, 3))
end
-- Some open cave floor
for _ = 1, H.rand(3, 5) do
    H.place_cluster(tiles, W, HT, H.rand(3, W-2), H.rand(3, HT-2), "Uu", 2)
end
-- Underground water pools
for _ = 1, H.rand(2, 3) do
    H.place_cluster(tiles, W, HT, H.rand(5, W-4), H.rand(4, HT-3), "Ww", H.rand(1, 2))
end
-- Cave walls for structure
for _ = 1, H.rand(3, 5) do
    H.place_cluster(tiles, W, HT, H.rand(4, W-3), H.rand(4, HT-3), "Xu", 1)
end

H.scatter_villages(tiles, W, HT, "Uu^Vu", {"Uu", "Uu^Uf"}, 5)
H.add_borders(tiles, W, HT, "Xu", "Xu")
local p1x, p1y, p2x, p2y = H.place_castles(tiles, W, HT, "Uu", "Ke", "Ce")
return H.build_map_string(tiles, W, HT, p1x, p1y, p2x, p2y)
