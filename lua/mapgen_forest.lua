local H = wesnoth.dofile("~add-ons/Wesnoth_Roguelite/lua/mapgen_helpers.lua")
local W, HT, MAP_SIZE = H.random_map_size()
local tiles = H.init_map(W, HT, "Gg")

-- Pick season (NO winter — that's a separate biome)
local seasons = {"summer", "fall", "mixed"}
local season = seasons[H.rand(1, #seasons)]

local trees = {}
if season == "summer" then
    trees = {"Gs^Fp", "Gg^Fds", "Gg^Fms"}
elseif season == "fall" then
    trees = {"Gll^Fdf", "Gll^Fmf", "Gs^Fp"}
else
    trees = {"Gs^Fp", "Gg^Fds", "Gll^Fdf", "Gg^Fms"}
end

local grounds = {"Gg", "Gd", "Gs"}
if season == "fall" then grounds = {"Gll", "Gd", "Gs", "Gg"} end

-- Forest clusters — use INDIVIDUAL tree placement for variety, not just blobs
for _ = 1, H.rand(10, 14) do
    local tree = trees[H.rand(1, #trees)]
    H.place_cluster(tiles, W, HT, H.rand(3, W-2), H.rand(3, HT-2), tree, H.rand(2, 3))
end
-- Scatter individual trees for variety between clusters
for _ = 1, H.rand(15, 25) do
    local x, y = H.rand(2, W-1), H.rand(2, HT-1)
    if tiles[y][x] == "Gg" or tiles[y][x] == "Gd" or tiles[y][x] == "Gs" then
        tiles[y][x] = trees[H.rand(1, #trees)]
    end
end

-- FIXTURES (each has a % chance)
H.maybe_fixture(tiles, W, HT, "lone_mountain", 25)
H.maybe_fixture(tiles, W, HT, "pond", 40)
H.maybe_fixture(tiles, W, HT, "lake", 30)
H.maybe_fixture(tiles, W, HT, "stream", 25)
H.maybe_fixture(tiles, W, HT, "great_tree", 35)
H.maybe_fixture(tiles, W, HT, "campfire", 30)
H.maybe_fixture(tiles, W, HT, "ruins", 20)
H.maybe_fixture(tiles, W, HT, "mushroom_grove", 25)
H.maybe_fixture(tiles, W, HT, "swamp_patch", 20)
H.maybe_fixture(tiles, W, HT, "farmland_patch", 15)
H.maybe_fixture(tiles, W, HT, "stone_circle", 15)
H.maybe_fixture(tiles, W, HT, "bandit_camp", 20)
H.maybe_fixture(tiles, W, HT, "fairy_ring", 20)
H.maybe_fixture(tiles, W, HT, "forest_shrine", 25)
H.maybe_fixture(tiles, W, HT, "flower_field", 15)
H.maybe_fixture(tiles, W, HT, "dead_grove", 15)
H.maybe_fixture(tiles, W, HT, "signpost", 20)
H.maybe_fixture(tiles, W, HT, "bone_pile", 10)
H.maybe_fixture(tiles, W, HT, "graveyard", 10)
H.maybe_fixture(tiles, W, HT, "hill_fort", 15)
H.maybe_fixture(tiles, W, HT, "rocky_ridge", 10)

-- Fill
H.fill_pass(tiles, W, HT, "Gg", grounds, 40)

-- Villages
local vtypes = {"Gg^Vh", "Gg^Ve", "Gg^Vl"}
if season == "fall" then vtypes = {"Gg^Vh", "Gg^Ve", "Gg^Vc"} end

-- Embellishments
if H.rand(1,2) == 1 then H.scatter_specials(tiles, W, HT, {"Gg^Efm"}, {"Gg", "Gd", "Gs"}, H.rand(3, 6)) end
if H.rand(1,3) == 1 then H.scatter_specials(tiles, W, HT, {"Gg^Es"}, {"Gg", "Gd"}, H.rand(2, 4)) end

-- Borders (varied, not just one type)
local btrees = {trees[1], trees[H.rand(1,#trees)], "Hh"}
H.dense_borders(tiles, W, HT, btrees, H.rand(1,3)==1 and "Mm" or nil)

-- Castles LAST
H.maybe_scatter_ruins(tiles, W, HT, {"Gg", "Gd", "Gs"}, 25)
local p1x, p1y, p2x, p2y = H.place_castles(tiles, W, HT, "Gg",
    {"Ke", "Kh"}, {"Ce", "Ch", "Chr"})

-- Path + bridges
local path = H.carve_path(tiles, W, HT, p1x, p1y, p2x, p2y, "Rr")
H.place_bridges(tiles, W, HT, path)

H.scatter_villages(tiles, W, HT, vtypes, {"Gg", "Gd", "Gs", "Gll", "Hh"}, nil, MAP_SIZE)
return H.build_map_string(tiles, W, HT, p1x, p1y, p2x, p2y)
