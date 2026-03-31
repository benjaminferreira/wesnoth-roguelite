local H = wesnoth.dofile("~add-ons/Wesnoth_Roguelite/lua/mapgen_helpers.lua")
local W, HT = 36, 22  -- wider, more open
local tiles = H.init_map(W, HT, "Gg")

-- Dirt patches and roads
for _ = 1, H.rand(4, 6) do
    H.place_cluster(tiles, W, HT, H.rand(3, W-2), H.rand(3, HT-2), "Gd", H.rand(2, 3))
end
-- A road running left to right
local ry = H.rand(8, HT-8)
for x = 1, W do
    if H.rand(1,4) == 1 then ry = ry + H.rand(-1,1) end
    ry = math.max(3, math.min(HT-2, ry))
    tiles[ry][x] = "Rr"
end
-- Sparse trees
for _ = 1, H.rand(3, 5) do
    H.place_cluster(tiles, W, HT, H.rand(3, W-2), H.rand(3, HT-2), "Gs^Fp", 1)
end
-- Gentle hills
for _ = 1, H.rand(2, 3) do
    H.place_cluster(tiles, W, HT, H.rand(4, W-3), H.rand(4, HT-3), "Hh", H.rand(1, 2))
end

H.scatter_villages(tiles, W, HT, "Gg^Vh", {"Gg", "Gd", "Rr"}, 7)
H.add_borders(tiles, W, HT, "Hh", "Mm")
local p1x, p1y, p2x, p2y = H.place_castles(tiles, W, HT, "Gg", "Ke", "Ce")
return H.build_map_string(tiles, W, HT, p1x, p1y, p2x, p2y)
