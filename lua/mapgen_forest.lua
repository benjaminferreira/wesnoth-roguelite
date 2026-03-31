local H = wesnoth.dofile("~add-ons/Wesnoth_Roguelite/lua/mapgen_helpers.lua")
local W, HT = 32, 22
local tiles = H.init_map(W, HT, "Gg")

-- Heavy forest with clearings
for _ = 1, H.rand(7, 10) do
    H.place_cluster(tiles, W, HT, H.rand(3, W-2), H.rand(3, HT-2), "Gs^Fp", H.rand(2, 4))
end
for _ = 1, H.rand(2, 4) do
    H.place_cluster(tiles, W, HT, H.rand(4, W-3), H.rand(4, HT-3), "Hh", H.rand(1, 2))
end
for _ = 1, 3 do
    H.place_cluster(tiles, W, HT, H.rand(3, W-2), H.rand(3, HT-2), "Gd", 2)
end
-- Stream
local rx = H.rand(13, W-13)
for y = 1, HT do
    if H.rand(1,3) == 1 then rx = rx + H.rand(-1,1) end
    rx = math.max(9, math.min(W-9, rx))
    tiles[y][rx] = "Ww"
end

H.scatter_villages(tiles, W, HT, "Gg^Ve", {"Gg", "Gd", "Gs^Fp"}, 6)
H.add_borders(tiles, W, HT, "Gs^Fp", "Mm")
local p1x, p1y, p2x, p2y = H.place_castles(tiles, W, HT, "Gg", "Ke", "Ce")
return H.build_map_string(tiles, W, HT, p1x, p1y, p2x, p2y)
