local H = wesnoth.dofile("~add-ons/Wesnoth_Roguelite/lua/mapgen_helpers.lua")
-- Mountains: sometimes a narrow pass (vertical), sometimes wide
local narrow = H.rand(1, 3) == 1
local W, HT = H.random_map_size()
if narrow then W, HT = HT, W end  -- flip for narrow pass
local tiles = H.init_map(W, HT, "Hh")

-- Mountain ranges (connected ridges)
for _ = 1, H.rand(2, 3) do
    local mx, my = H.rand(6, W-5), H.rand(4, HT-4)
    for _ = 1, H.rand(4, 7) do
        H.place_cluster(tiles, W, HT, mx, my, "Mm", H.rand(1, 2))
        mx = mx + H.rand(-2, 2); my = my + H.rand(-1, 1)
        mx = math.max(4, math.min(W-3, mx)); my = math.max(3, math.min(HT-2, my))
    end
end

-- Impassable peaks ONLY on borders, not center (max 15% of mountains)
for y = 1, HT do for x = 1, W do
    local dist = math.min(x, y, W+1-x, HT+1-y)
    if tiles[y][x] == "Mm" and dist <= 3 and H.rand(1,100) > 60 then
        tiles[y][x] = "Mm^Xm"
    end
end end

-- Valleys
for _ = 1, H.rand(3, 5) do H.place_cluster(tiles, W, HT, H.rand(4, W-3), H.rand(4, HT-3), "Gg", H.rand(2, 3)) end
for _ = 1, H.rand(2, 4) do H.place_cluster(tiles, W, HT, H.rand(4, W-3), H.rand(4, HT-3), "Gs^Fp", H.rand(1, 2)) end

-- Scatter individual trees in valleys
for _ = 1, H.rand(8, 15) do
    local x, y = H.rand(3, W-2), H.rand(3, HT-2)
    if tiles[y][x] == "Gg" then tiles[y][x] = "Gs^Fp" end
end

-- Fixtures
H.maybe_fixture(tiles, W, HT, "lake", 35)
H.maybe_fixture(tiles, W, HT, "stream", 40)
H.maybe_fixture(tiles, W, HT, "pond", 30)
H.maybe_fixture(tiles, W, HT, "campfire", 25)
H.maybe_fixture(tiles, W, HT, "ruins", 20)
H.maybe_fixture(tiles, W, HT, "watchtower", 30)
H.maybe_fixture(tiles, W, HT, "mountain_lake", 30)
H.maybe_fixture(tiles, W, HT, "hill_fort", 25)
H.maybe_fixture(tiles, W, HT, "signpost", 20)
H.maybe_fixture(tiles, W, HT, "bandit_camp", 15)
H.maybe_fixture(tiles, W, HT, "bone_pile", 10)
H.maybe_fixture(tiles, W, HT, "pit", 10)
H.maybe_fixture(tiles, W, HT, "rocky_ridge", 10)

H.fill_pass(tiles, W, HT, "Hh", {"Gd", "Gg", "Hhd"}, 25)
H.scatter_villages(tiles, W, HT, {"Hh^Vhh", "Gg^Vh", "Gg^Vl"}, {"Hh", "Gg", "Gd"}, 5)
H.dense_borders(tiles, W, HT, {"Mm", "Mm", "Hh", "Mm^Xm"}, "Mm^Xm")

local p1x, p1y, p2x, p2y = H.place_castles(tiles, W, HT, "Gg", {"Ke", "Kh"}, {"Ce", "Ch"}, narrow)
local path = H.carve_path(tiles, W, HT, p1x, p1y, p2x, p2y, "Gd", "Rb")
H.place_bridges(tiles, W, HT, path)
return H.build_map_string(tiles, W, HT, p1x, p1y, p2x, p2y)
