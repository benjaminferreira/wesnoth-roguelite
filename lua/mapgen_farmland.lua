local H = wesnoth.dofile("~add-ons/Wesnoth_Roguelite/lua/mapgen_helpers.lua")
local W, HT = 32, 22
local tiles = H.init_map(W, HT, "Gg")

-- Farm fields (re = cultivated)
for _ = 1, H.rand(5, 8) do
    H.place_cluster(tiles, W, HT, H.rand(4, W-3), H.rand(4, HT-3), "Re", H.rand(2, 3))
end
-- Dirt roads connecting farms
local ry = H.rand(8, HT-8)
for x = 1, W do
    if H.rand(1,5) == 1 then ry = ry + H.rand(-1,1) end
    ry = math.max(3, math.min(HT-2, ry))
    tiles[ry][x] = "Rr"
end
-- A cross road
local rx = H.rand(12, W-12)
for y = 1, HT do
    if H.rand(1,5) == 1 then rx = rx + H.rand(-1,1) end
    rx = math.max(5, math.min(W-4, rx))
    tiles[y][rx] = "Rr"
end
-- Scattered trees
for _ = 1, H.rand(2, 4) do
    H.place_cluster(tiles, W, HT, H.rand(3, W-2), H.rand(3, HT-2), "Gs^Fp", 1)
end
-- Small pond
local px, py = H.rand(8, W-7), H.rand(5, HT-4)
H.place_cluster(tiles, W, HT, px, py, "Ww", 1)

H.scatter_villages(tiles, W, HT, "Gg^Vh", {"Gg", "Re", "Gd"}, 8)
H.add_borders(tiles, W, HT, "Gs^Fp", "Hh")
local p1x, p1y, p2x, p2y = H.place_castles(tiles, W, HT, "Gg", "Ke", "Ce")
return H.build_map_string(tiles, W, HT, p1x, p1y, p2x, p2y)
