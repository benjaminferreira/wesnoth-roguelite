local H = wesnoth.dofile("~add-ons/Wesnoth_Roguelite/lua/mapgen_helpers.lua")
-- Cave: sometimes narrow corridor, sometimes open cavern
local narrow = H.rand(1, 3) == 1
local W, HT, MAP_SIZE = H.random_map_size()
if narrow then W, HT = HT, W end

-- Start with cave floor, then ADD walls as obstacles
local tiles = H.init_map(W, HT, "Uu")

-- Add wall border (thick, irregular)
for x = 1, W do
    for y = 1, HT do
        local dist = math.min(x, y, W + 1 - x, HT + 1 - y)
        if dist <= 1 then
            tiles[y][x] = "Xu"
        elseif dist == 2 and H.rand(1, 100) <= 80 then
            tiles[y][x] = "Xu"
        elseif dist == 3 and H.rand(1, 100) <= 50 then
            tiles[y][x] = "Xu"
        elseif dist == 4 and H.rand(1, 100) <= 20 then
            tiles[y][x] = "Xu"
        end
    end
end

-- Add wall pillars/obstacles inside (NOT blocking the whole map)
for _ = 1, H.rand(4, 7) do
    local px, py = H.rand(6, W-5), H.rand(5, HT-4)
    H.place_cluster(tiles, W, HT, px, py, "Xu", H.rand(1, 2))
end

-- Rockbound hills inside cave
for _ = 1, H.rand(2, 4) do
    H.place_cluster(tiles, W, HT, H.rand(6, W-5), H.rand(5, HT-4), "Uh", H.rand(1, 2))
end

-- Underground water
if H.rand(1, 2) == 1 then
    local wx, wy = H.rand(8, W-8), H.rand(6, HT-6)
    H.place_cluster(tiles, W, HT, wx, wy, "Ww", H.rand(1, 2))
end

-- Chasms (small, decorative)
if H.rand(1, 3) == 1 then
    local cx, cy = H.rand(8, W-8), H.rand(6, HT-6)
    H.place_cluster(tiles, W, HT, cx, cy, "Qxu", 1)
end

-- Floor variety
for y = 2, HT-1 do
    for x = 2, W-1 do
        if tiles[y][x] == "Uu" then
            local r = H.rand(1, 100)
            if r > 92 then tiles[y][x] = "Uu^Tf"
            elseif r > 86 then tiles[y][x] = "Uue"
            elseif r > 82 then tiles[y][x] = "Ur"
            elseif r > 79 then tiles[y][x] = "Uh"
            end
        end
    end
end

-- Wall variety
for y = 1, HT do
    for x = 1, W do
        if tiles[y][x] == "Xu" then
            local r = H.rand(1, 100)
            if r > 92 then tiles[y][x] = "Xue"
            elseif r > 87 then tiles[y][x] = "Xuc"
            end
        end
    end
end

-- Villages

-- Fixtures
H.maybe_fixture(tiles, W, HT, "cave_lake", 40)
H.maybe_fixture(tiles, W, HT, "cave_chasm", 25)
H.maybe_fixture(tiles, W, HT, "cave_mushrooms", 50)
H.maybe_fixture(tiles, W, HT, "sunlit_clearing", 30)
H.maybe_fixture(tiles, W, HT, "ancient_temple", 25)
H.maybe_fixture(tiles, W, HT, "cave_spring", 30)
H.maybe_fixture(tiles, W, HT, "brazier_circle", 25)
H.maybe_fixture(tiles, W, HT, "bone_pile", 20)
H.maybe_fixture(tiles, W, HT, "pit", 15)
H.maybe_fixture(tiles, W, HT, "rocky_ridge", 10)
H.maybe_fixture(tiles, W, HT, "pond", 15)
H.maybe_fixture(tiles, W, HT, "water_lilies", 10)
H.maybe_fixture(tiles, W, HT, "abandoned_mine", 20)
H.maybe_fixture(tiles, W, HT, "flagstone_plaza", 15)
H.maybe_fixture(tiles, W, HT, "mycelium_patch", 15)

-- Light sources
H.scatter_specials(tiles, W, HT,
    {"Uu^Efs", "Uu^Ii"},
    {"Uu", "Uue"}, H.rand(3, 5))

-- Castles LAST
local p1x, p1y, p2x, p2y = H.place_castles(tiles, W, HT, "Uu",
    {"Kud", "Ke", "Kf"},
    {"Cud", "Ce", "Cf"}, narrow)

-- Path (mostly cosmetic since cave is already open)
local path = H.carve_path(tiles, W, HT, p1x, p1y, p2x, p2y, "Ur", "Uu")

H.scatter_villages(tiles, W, HT,
    {"Uu^Vu", "Uu^Vud"},
    {"Uu", "Uue", "Ur"}, nil, MAP_SIZE)
return H.build_map_string(tiles, W, HT, p1x, p1y, p2x, p2y)
