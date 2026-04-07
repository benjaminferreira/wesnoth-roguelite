local H = wesnoth.dofile("~add-ons/Wesnoth_Roguelite/lua/mapgen_helpers.lua")
local W, HT, MAP_SIZE = H.random_map_size()
local tiles = H.init_map(W, HT, "Gg")

-- Cave walls on top edge + one side halfway down
for x = 1, W do
    tiles[1][x] = "Xue"
    if H.rand(1,100) <= 60 then tiles[2][x] = "Xue" end
    if H.rand(1,100) <= 25 then tiles[3][x] = "Xu" end
end
-- Extend wall down left side to about halfway
local cave_depth = H.rand(math.floor(HT*0.4), math.floor(HT*0.6))
for y = 1, cave_depth do
    tiles[y][1] = "Xue"
    if H.rand(1,100) <= 55 then tiles[y][2] = "Xue" end
end

-- Scattered cave floor patches (the underground parts)
for _ = 1, H.rand(2, 3) do
    H.place_cluster(tiles, W, HT, H.rand(4, W-3), H.rand(3, math.floor(HT*0.5)), "Uu", H.rand(1, 2))
end

-- Grass-based mushroom groves (the signature look) — always place
for _ = 1, H.rand(6, 10) do
    local mx, my = H.rand(4, W-3), H.rand(3, HT-2)
    local t = tiles[my][mx]
    if t ~= "Xue" and t ~= "Xu" then
        local mush = (t == "Uu" or t == "Uue") and "Uu^Tf" or ({"Gg^Em", "Gg^Emf", "Gg^Tf", "Gd^Em"})[H.rand(1,4)]
        H.place_cluster(tiles, W, HT, mx, my, mush, H.rand(1, 2))
    end
end

-- Individual mushroom scatter
for _ = 1, H.rand(8, 14) do
    local x, y = H.rand(3, W-2), H.rand(3, HT-2)
    local t = tiles[y][x]
    if t == "Gg" or t == "Gd" or t == "Gs" then
        tiles[y][x] = ({"Gg^Em", "Gg^Emf", "Gg^Tf"})[H.rand(1,3)]
    end
end

-- Trees
for _ = 1, H.rand(5, 8) do
    local x, y = H.rand(3, W-2), H.rand(3, HT-2)
    if tiles[y][x] == "Gg" then tiles[y][x] = "Gs^Fp" end
end

-- Flowers
for _ = 1, H.rand(3, 6) do
    local x, y = H.rand(3, W-2), H.rand(3, HT-2)
    if tiles[y][x] == "Gg" then tiles[y][x] = "Gg^Efm" end
end

-- Border trees and hills on sides and bottom (not top — that's the cave)
for x = 1, W do
    for y = 1, HT do
        local dist_bottom = HT + 1 - y
        local dist_side = math.min(x, W + 1 - x)
        if dist_bottom <= 1 or dist_side <= 1 then
            if tiles[y][x] ~= "Xue" and tiles[y][x] ~= "Xu" then
                tiles[y][x] = ({"Gs^Fp", "Hh", "Gs^Fp", "Gg^Em"})[H.rand(1,4)]
            end
        elseif (dist_bottom == 2 or dist_side == 2) and H.rand(1,100) <= 50 then
            if tiles[y][x] == "Gg" or tiles[y][x] == "Gd" then
                tiles[y][x] = ({"Gs^Fp", "Hh", "Gg^Em", "Gg^Tf"})[H.rand(1,4)]
            end
        end
    end
end

H.maybe_fixture(tiles, W, HT, "cave_lake", 40)
H.maybe_fixture(tiles, W, HT, "sunlit_clearing", 50)
H.maybe_fixture(tiles, W, HT, "cave_spring", 25)
H.maybe_fixture(tiles, W, HT, "fairy_ring", 40)
H.maybe_fixture(tiles, W, HT, "pond", 30)
H.maybe_fixture(tiles, W, HT, "great_tree", 30)
H.maybe_fixture(tiles, W, HT, "flower_field", 25)
H.maybe_fixture(tiles, W, HT, "forest_shrine", 20)
H.maybe_fixture(tiles, W, HT, "bone_pile", 10)
H.maybe_fixture(tiles, W, HT, "rocky_ridge", 10)

H.fill_pass(tiles, W, HT, "Gg", {"Gd", "Gs", "Gll"}, 30)

-- Massive sunlight patches — ~25% of map should have lightbeams
-- Big blobs first
for _ = 1, H.rand(3, 5) do
    local lx, ly = H.rand(5, W-4), H.rand(4, HT-3)
    H.place_cluster(tiles, W, HT, lx, ly, "Gg^Ii", H.rand(2, 3))
end
-- Individual scattered beams
for _ = 1, H.rand(6, 10) do
    local x, y = H.rand(3, W-2), H.rand(3, HT-2)
    local t = tiles[y][x]
    if t == "Gg" or t == "Gd" or t == "Gs" or t == "Gll" then
        tiles[y][x] = "Gg^Ii"
    end
end


local p1x, p1y, p2x, p2y = H.place_castles(tiles, W, HT, "Gg", {"Ke", "Kh"}, {"Ce", "Ch"})
local path = H.carve_path(tiles, W, HT, p1x, p1y, p2x, p2y, "Gd", "Gg")
H.scatter_villages(tiles, W, HT, {"Gg^Vh", "Gg^Ve", "Uu^Vu"}, {"Gg", "Gd", "Uu"}, nil, MAP_SIZE)
return H.build_map_string(tiles, W, HT, p1x, p1y, p2x, p2y)
