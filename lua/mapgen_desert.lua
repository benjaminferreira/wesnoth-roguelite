local H = wesnoth.dofile("~add-ons/Wesnoth_Roguelite/lua/mapgen_helpers.lua")
local W, HT = 34, 22
local tiles = H.init_map(W, HT, "Ds")

-- Sand dunes
for _ = 1, H.rand(3, 5) do
    H.place_cluster(tiles, W, HT, H.rand(4, W-3), H.rand(4, HT-3), "Dd", H.rand(2, 3))
end
-- Rocky outcrops
for _ = 1, H.rand(2, 4) do
    H.place_cluster(tiles, W, HT, H.rand(4, W-3), H.rand(4, HT-3), "Hd", H.rand(1, 2))
end
-- Oases (grass + water)
for _ = 1, H.rand(2, 3) do
    local ox, oy = H.rand(6, W-5), H.rand(4, HT-3)
    H.place_cluster(tiles, W, HT, ox, oy, "Gg", 2)
    tiles[oy][ox] = "Ww"
end
-- Scattered palms
for _ = 1, H.rand(3, 5) do
    H.place_cluster(tiles, W, HT, H.rand(3, W-2), H.rand(3, HT-2), "Dd^Dc", 1)
end

H.scatter_villages(tiles, W, HT, "Dd^Vda", {"Ds", "Dd", "Gg"}, 5)
H.add_borders(tiles, W, HT, "Dd", "Hd")
local p1x, p1y, p2x, p2y = H.place_castles(tiles, W, HT, "Ds", "Ke", "Ce")
return H.build_map_string(tiles, W, HT, p1x, p1y, p2x, p2y)
