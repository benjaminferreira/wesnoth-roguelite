local H = wesnoth.dofile("~add-ons/Wesnoth_Roguelite/lua/mapgen_helpers.lua")
local W, HT = 30, 22
local tiles = H.init_map(W, HT, "Aa")  -- snow

-- Frozen forest
for _ = 1, H.rand(5, 8) do
    H.place_cluster(tiles, W, HT, H.rand(3, W-2), H.rand(3, HT-2), "Aa^Fpa", H.rand(2, 3))
end
-- Snowy hills
for _ = 1, H.rand(2, 4) do
    H.place_cluster(tiles, W, HT, H.rand(4, W-3), H.rand(4, HT-3), "Ha", H.rand(1, 2))
end
-- Frozen lake/river
local rx = H.rand(12, W-12)
for y = 1, HT do
    if H.rand(1,3) == 1 then rx = rx + H.rand(-1,1) end
    rx = math.max(8, math.min(W-8, rx))
    tiles[y][rx] = "Ai"  -- ice
end

H.scatter_villages(tiles, W, HT, "Aa^Vha", {"Aa", "Ha"}, 5)
H.add_borders(tiles, W, HT, "Ha", "Mm")
local p1x, p1y, p2x, p2y = H.place_castles(tiles, W, HT, "Aa", "Ke", "Ce")
return H.build_map_string(tiles, W, HT, p1x, p1y, p2x, p2y)
