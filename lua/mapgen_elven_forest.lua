local H = wesnoth.dofile("~add-ons/Wesnoth_Roguelite/lua/mapgen_helpers.lua")
-- Elven forest: taller, narrower — feels like a deep forest corridor
local W, HT = H.random_map_size()
local tiles = H.init_map(W, HT, "Gg")

-- Elven-specific trees: great trees, deciduous, tropical (no pine!)
local trees = {"Gg^Fds", "Gg^Fms", "Gg^Fet"}
for _ = 1, H.rand(10, 14) do
    H.place_cluster(tiles, W, HT, H.rand(3, W-2), H.rand(3, HT-2), trees[H.rand(1,#trees)], H.rand(2, 3))
end
-- Lots of great trees (the signature elven tree)
for _ = 1, H.rand(5, 8) do
    local x, y = H.rand(3, W-2), H.rand(3, HT-2)
    tiles[y][x] = "Gg^Fet"
end
-- Individual tree scatter for variety
for _ = 1, H.rand(15, 25) do
    local x, y = H.rand(2, W-1), H.rand(2, HT-1)
    if tiles[y][x] == "Gg" or tiles[y][x] == "Gd" then
        tiles[y][x] = trees[H.rand(1, #trees)]
    end
end

H.maybe_fixture(tiles, W, HT, "great_tree", 60)
H.maybe_fixture(tiles, W, HT, "stream", 50)
H.maybe_fixture(tiles, W, HT, "pond", 35)
H.maybe_fixture(tiles, W, HT, "ruins", 35)
H.maybe_fixture(tiles, W, HT, "mushroom_grove", 20)
H.maybe_fixture(tiles, W, HT, "fairy_ring", 40)
H.maybe_fixture(tiles, W, HT, "stone_circle", 20)
H.maybe_fixture(tiles, W, HT, "forest_shrine", 35)
H.maybe_fixture(tiles, W, HT, "flower_field", 30)
H.maybe_fixture(tiles, W, HT, "water_lilies", 25)
H.maybe_fixture(tiles, W, HT, "island", 15)
H.maybe_fixture(tiles, W, HT, "rocky_ridge", 10)

-- Gentle hills
if H.rand(1,2) == 1 then
    for _ = 1, H.rand(2, 3) do H.place_cluster(tiles, W, HT, H.rand(5, W-4), H.rand(5, HT-4), "Hh", H.rand(1, 2)) end
end

H.fill_pass(tiles, W, HT, "Gg", {"Gd", "Gs", "Gll", "Gg^Efm"}, 40)
H.scatter_villages(tiles, W, HT, {"Gg^Ve", "Gg^Ve", "Gg^Vl", "Gg^Ve"}, {"Gg", "Gd", "Gs", "Gll"}, H.rand(5, 7))
if H.rand(1,2) == 1 then H.scatter_specials(tiles, W, HT, {"Gg^Efm", "Gg^Em"}, {"Gg", "Gd"}, H.rand(3, 6)) end
H.dense_borders(tiles, W, HT, {"Gg^Fds", "Gg^Fms", "Gg^Fet", "Hh"}, nil)

-- Elven castles
local p1x, p1y, p2x, p2y = H.place_castles(tiles, W, HT, "Gg", {"Kv", "Kv"}, {"Cv", "Cv"})
-- Overgrown cobble path (not a road — feels more natural)
local path = H.carve_path(tiles, W, HT, p1x, p1y, p2x, p2y, "Rp", "Gll")
H.place_bridges(tiles, W, HT, path)
return H.build_map_string(tiles, W, HT, p1x, p1y, p2x, p2y)
