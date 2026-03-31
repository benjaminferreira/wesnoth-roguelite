local H = wesnoth.dofile("~add-ons/Wesnoth_Roguelite/lua/mapgen_helpers.lua")
local W, HT = 28, 20
local tiles = H.init_map(W, HT, "Hh")

-- Mountain ranges and peaks
for _ = 1, H.rand(4, 6) do
    H.place_cluster(tiles, W, HT, H.rand(4, W-3), H.rand(4, HT-3), "Mm", H.rand(2, 3))
end
-- Valleys of grass between mountains
for _ = 1, H.rand(3, 5) do
    H.place_cluster(tiles, W, HT, H.rand(3, W-2), H.rand(3, HT-2), "Gg", H.rand(2, 3))
end
-- Scattered forest in valleys
for _ = 1, H.rand(2, 4) do
    H.place_cluster(tiles, W, HT, H.rand(3, W-2), H.rand(3, HT-2), "Gs^Fp", H.rand(1, 2))
end
-- Impassable peaks
for _ = 1, H.rand(1, 3) do
    H.place_cluster(tiles, W, HT, H.rand(6, W-5), H.rand(4, HT-3), "Mm^Xm", 1)
end

H.scatter_villages(tiles, W, HT, "Hh^Vhh", {"Hh", "Gg"}, 5)
H.add_borders(tiles, W, HT, "Mm", "Mm^Xm")
local p1x, p1y, p2x, p2y = H.place_castles(tiles, W, HT, "Gg", "Ke", "Ce")
return H.build_map_string(tiles, W, HT, p1x, p1y, p2x, p2y)
