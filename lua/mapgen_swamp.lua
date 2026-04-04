local H = wesnoth.dofile("~add-ons/Wesnoth_Roguelite/lua/mapgen_helpers.lua")
local W, HT = H.random_map_size()
local tiles = H.init_map(W, HT, "Gg")

-- Swamp pools
for _ = 1, H.rand(8, 12) do H.place_cluster(tiles, W, HT, H.rand(3, W-2), H.rand(3, HT-2), "Ss", H.rand(2, 3)) end
-- Muddy quagmire patches
for _ = 1, H.rand(3, 5) do H.place_cluster(tiles, W, HT, H.rand(4, W-3), H.rand(4, HT-3), "Sm", H.rand(1, 2)) end
-- Water pools
for _ = 1, H.rand(3, 5) do H.place_cluster(tiles, W, HT, H.rand(4, W-3), H.rand(4, HT-3), "Ww", H.rand(1, 2)) end
-- Muddy forest
for _ = 1, H.rand(4, 7) do H.place_cluster(tiles, W, HT, H.rand(3, W-2), H.rand(3, HT-2), "Gs^Fp", H.rand(1, 3)) end
-- Dry raised patches (like small islands in the swamp)
for _ = 1, H.rand(2, 3) do H.place_cluster(tiles, W, HT, H.rand(5, W-4), H.rand(5, HT-4), "Ds", H.rand(1, 2)) end

-- Individual scatter
for _ = 1, H.rand(12, 20) do
    local x, y = H.rand(2, W-1), H.rand(2, HT-1)
    if tiles[y][x] == "Gg" then tiles[y][x] = ({"Ss", "Gd", "Gs^Fp", "Sm", "Ds"})[H.rand(1,5)] end
end

H.blend_around(tiles, W, HT, "Ww", "Ss")

H.maybe_fixture(tiles, W, HT, "swamp_patch", 50)
H.maybe_fixture(tiles, W, HT, "lake", 30)
H.maybe_fixture(tiles, W, HT, "ruins", 30)
H.maybe_fixture(tiles, W, HT, "campfire", 25)
H.maybe_fixture(tiles, W, HT, "graveyard", 35)
H.maybe_fixture(tiles, W, HT, "dead_grove", 30)
H.maybe_fixture(tiles, W, HT, "swamp_hut", 35)
H.maybe_fixture(tiles, W, HT, "water_lilies", 30)
H.maybe_fixture(tiles, W, HT, "bone_pile", 20)
H.maybe_fixture(tiles, W, HT, "mushroom_grove", 20)
H.maybe_fixture(tiles, W, HT, "island", 15)
H.maybe_fixture(tiles, W, HT, "rocky_ridge", 10)

-- Water lilies
for _ = 1, H.rand(3, 6) do
    local lx, ly = H.rand(3, W-2), H.rand(3, HT-2)
    if tiles[ly][lx] == "Ww" then tiles[ly][lx] = "Ww^Ewf" end
end

H.fill_pass(tiles, W, HT, "Gg", {"Ss", "Gd", "Gs", "Sm"}, 50)
H.scatter_villages(tiles, W, HT, {"Ss^Vhs", "Gg^Vh", "Gg^Vc", "Ds^Vda"}, {"Gg", "Ss", "Gd", "Ds", "Sm"}, 6)
H.dense_borders(tiles, W, HT, {"Ss", "Gs^Fp", "Sm", "Ww"}, "Ww")

H.maybe_scatter_ruins(tiles, W, HT, {"Gg", "Gd", "Ss"}, 50)
local p1x, p1y, p2x, p2y = H.place_castles(tiles, W, HT, "Gg", {"Ke", "Khs"}, {"Ce", "Chs"})
local path = H.carve_path(tiles, W, HT, p1x, p1y, p2x, p2y, "Gd")
H.place_bridges(tiles, W, HT, path)
return H.build_map_string(tiles, W, HT, p1x, p1y, p2x, p2y)
