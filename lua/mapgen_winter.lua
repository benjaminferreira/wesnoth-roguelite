local H = wesnoth.dofile("~add-ons/Wesnoth_Roguelite/lua/mapgen_helpers.lua")
local W, HT, MAP_SIZE = H.random_map_size()
local tiles = H.init_map(W, HT, "Aa")

local trees = {"Aa^Fpa", "Aa^Fma", "Aa^Fda"}
for _ = 1, H.rand(7, 11) do H.place_cluster(tiles, W, HT, H.rand(3, W-2), H.rand(3, HT-2), trees[H.rand(1,#trees)], H.rand(2, 3)) end
for _ = 1, H.rand(10, 18) do
    local x, y = H.rand(2, W-1), H.rand(2, HT-1)
    if tiles[y][x] == "Aa" then tiles[y][x] = trees[H.rand(1,#trees)] end
end
for _ = 1, H.rand(3, 5) do H.place_cluster(tiles, W, HT, H.rand(4, W-3), H.rand(4, HT-3), "Ha", H.rand(1, 2)) end

H.maybe_fixture(tiles, W, HT, "lone_mountain", 30)
H.maybe_fixture(tiles, W, HT, "pond", 30)
H.maybe_fixture(tiles, W, HT, "campfire", 35)
H.maybe_fixture(tiles, W, HT, "frozen_lake", 40)
H.maybe_fixture(tiles, W, HT, "graveyard", 20)
H.maybe_fixture(tiles, W, HT, "bandit_camp", 20)
H.maybe_fixture(tiles, W, HT, "snow_drift", 35)
H.maybe_fixture(tiles, W, HT, "ice_pillars", 20)
H.maybe_fixture(tiles, W, HT, "dead_grove", 25)
H.maybe_fixture(tiles, W, HT, "ruins", 20)
H.maybe_fixture(tiles, W, HT, "stone_circle", 15)
H.maybe_fixture(tiles, W, HT, "bone_pile", 15)
H.maybe_fixture(tiles, W, HT, "signpost", 15)
H.maybe_fixture(tiles, W, HT, "rocky_ridge", 10)

-- Frozen lake (50%)
if H.rand(1,2) == 1 then H.place_cluster(tiles, W, HT, H.rand(10, W-10), H.rand(6, HT-6), "Ai", H.rand(2, 3)) end

-- Convert lone_mountain to snowy version
for y = 1, HT do for x = 1, W do
    if tiles[y][x] == "Mm" then tiles[y][x] = "Ms" end
    if tiles[y][x] == "Hh" then tiles[y][x] = "Ha" end
    if tiles[y][x] == "Ss" then tiles[y][x] = "Ai" end  -- frozen swamp
    if tiles[y][x] == "Ww" then tiles[y][x] = "Ai" end  -- frozen water
end end

H.fill_pass(tiles, W, HT, "Aa", {"Ha", "Aa^Esa"}, 25)
if H.rand(1,2) == 1 then H.scatter_specials(tiles, W, HT, {"Aa^Esa"}, {"Aa"}, H.rand(3, 6)) end
H.dense_borders(tiles, W, HT, {"Ha", "Aa^Fpa", "Ms", "Ha"}, "Ms")

H.maybe_scatter_ruins(tiles, W, HT, {"Aa", "Ha"}, 25, {"Chw", "Chs"})
local p1x, p1y, p2x, p2y = H.place_castles(tiles, W, HT, "Aa", {"Kea", "Kha", "Koa", "Kva", "Kfa"}, {"Cea", "Cha", "Coa", "Cva", "Cfa"})
local path = H.carve_path(tiles, W, HT, p1x, p1y, p2x, p2y, "Rra", "Aa")
H.place_bridges(tiles, W, HT, path)
H.scatter_villages(tiles, W, HT, {"Aa^Vha", "Aa^Vca", "Aa^Vla", "Aa^Vaa"}, {"Aa", "Ha"}, nil, MAP_SIZE)
return H.build_map_string(tiles, W, HT, p1x, p1y, p2x, p2y)
