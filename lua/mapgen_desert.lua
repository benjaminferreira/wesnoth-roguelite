local H = wesnoth.dofile("~add-ons/Wesnoth_Roguelite/lua/mapgen_helpers.lua")
local W, HT, MAP_SIZE = H.random_map_size()
local tiles = H.init_map(W, HT, "Dd")

for _ = 1, H.rand(4, 7) do H.place_cluster(tiles, W, HT, H.rand(4, W-3), H.rand(4, HT-3), "Ds", H.rand(2, 3)) end
for _ = 1, H.rand(3, 5) do H.place_cluster(tiles, W, HT, H.rand(4, W-3), H.rand(4, HT-3), "Hd", H.rand(1, 2)) end
for _ = 1, H.rand(8, 12) do
    local x, y = H.rand(2, W-1), H.rand(2, HT-1)
    if tiles[y][x] == "Dd" then tiles[y][x] = ({"Ds", "Hd", "Dd^Edp", "Dd^Esd"})[H.rand(1,4)] end
end

H.maybe_fixture(tiles, W, HT, "oasis", 60)
H.maybe_fixture(tiles, W, HT, "oasis", 30)
H.maybe_fixture(tiles, W, HT, "lone_mountain", 25)
H.maybe_fixture(tiles, W, HT, "ruins", 30)
H.maybe_fixture(tiles, W, HT, "campfire", 20)
H.maybe_fixture(tiles, W, HT, "desert_bones", 40)
H.maybe_fixture(tiles, W, HT, "bone_pile", 25)
H.maybe_fixture(tiles, W, HT, "pit", 10)
H.maybe_fixture(tiles, W, HT, "stone_circle", 15)
H.maybe_fixture(tiles, W, HT, "rocky_ridge", 35)
H.maybe_fixture(tiles, W, HT, "rainforest_thicket", 20)

-- Convert fixtures to desert variants
for y = 1, HT do for x = 1, W do
    if tiles[y][x] == "Mm" then tiles[y][x] = "Mdd" end
    if tiles[y][x] == "Hh" then tiles[y][x] = "Hd" end
end end

H.fill_pass(tiles, W, HT, "Dd", {"Ds", "Hd", "Dd^Edp", "Dd^Esd"}, 35)
H.dense_borders(tiles, W, HT, {"Hd", "Dd", "Mdd", "Hd"}, "Mdd")

H.maybe_scatter_ruins(tiles, W, HT, {"Dd", "Ds"}, 25, {"Chw", "Chs"})
local p1x, p1y, p2x, p2y = H.place_castles(tiles, W, HT, "Dd", {"Kd", "Ke", "Kdr"}, {"Cd", "Ce", "Cdr"})
local path = H.carve_path(tiles, W, HT, p1x, p1y, p2x, p2y, "Rd", "Ds")
H.place_bridges(tiles, W, HT, path)
H.scatter_villages(tiles, W, HT, {"Dd^Vda", "Dd^Vdt", "Ds^Vdt"}, {"Dd", "Ds", "Hd"}, nil, MAP_SIZE)
return H.build_map_string(tiles, W, HT, p1x, p1y, p2x, p2y)
