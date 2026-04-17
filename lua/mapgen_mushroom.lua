local H = wesnoth.dofile("~add-ons/Wesnoth_Roguelite/lua/mapgen_helpers.lua")
local W, HT, MAP_SIZE = H.random_map_size()
local tiles = H.init_map(W, HT, "Gg")

-- Cave wall border on ALL edges
for x = 1, W do
    tiles[1][x] = "Xue"
    if H.rand(1,100) <= 60 then tiles[2][x] = "Xue" end
    if H.rand(1,100) <= 40 then tiles[HT][x] = "Xue" end
    if H.rand(1,100) <= 20 then tiles[HT-1][x] = "Xue" end
end
for y = 1, HT do
    tiles[y][1] = "Xue"
    if H.rand(1,100) <= 55 then tiles[y][2] = "Xue" end
    tiles[y][W] = "Xue"
    if H.rand(1,100) <= 55 then tiles[y][W-1] = "Xue" end
end

-- Cave floor framing — organic, not a solid wall.
-- Thin border with probability falloff, plus scattered blobs near edges.
for x = 1, W do
    for y = 1, HT do
        local dist = math.min(x, y, W+1-x, HT+1-y)
        if tiles[y][x] ~= "Xue" and tiles[y][x] ~= "Xu" then
            if dist <= 2 and H.rand(1,100) <= 80 then
                tiles[y][x] = "Uu"
            elseif dist == 3 and H.rand(1,100) <= 45 then
                tiles[y][x] = "Uu"
            elseif dist == 4 and H.rand(1,100) <= 15 then
                tiles[y][x] = "Uu"
            end
        end
    end
end

-- Scattered cave floor blobs near edges (irregular, not uniform)
for _ = 1, H.rand(4, 6) do
    local edge = H.rand(1,4)
    local cx, cy
    if edge == 1 then cx, cy = H.rand(4, W-3), H.rand(3, 6)
    elseif edge == 2 then cx, cy = H.rand(4, W-3), H.rand(HT-5, HT-2)
    elseif edge == 3 then cx, cy = H.rand(3, 6), H.rand(4, HT-3)
    else cx, cy = H.rand(W-5, W-2), H.rand(4, HT-3) end
    H.place_cluster(tiles, W, HT, cx, cy, "Uu", H.rand(1, 2))
end

-- Mushroom groves on grass
for _ = 1, H.rand(6, 10) do
    local mx, my = H.rand(5, W-4), H.rand(4, HT-3)
    local t = tiles[my][mx]
    if t ~= "Xue" and t ~= "Xu" then
        local mush = (t == "Uu" or t == "Uue") and "Uu^Tf" or ({"Gg^Em", "Gg^Emf", "Gg^Tf", "Gd^Em"})[H.rand(1,4)]
        H.place_cluster(tiles, W, HT, mx, my, mush, H.rand(1, 2))
    end
end

-- Individual mushroom scatter
for _ = 1, H.rand(8, 14) do
    local x, y = H.rand(4, W-3), H.rand(4, HT-3)
    local t = tiles[y][x]
    if t == "Gg" or t == "Gd" or t == "Gs" then
        tiles[y][x] = ({"Gg^Em", "Gg^Emf", "Gg^Tf"})[H.rand(1,3)]
    end
end

-- Flowers
for _ = 1, H.rand(5, 9) do
    local x, y = H.rand(5, W-4), H.rand(4, HT-3)
    if tiles[y][x] == "Gg" then tiles[y][x] = "Gg^Efm" end
end

-- Scattered trees — denser, mixed types for grove feel
for _ = 1, H.rand(8, 14) do
    local x, y = H.rand(5, W-4), H.rand(4, HT-3)
    if tiles[y][x] == "Gg" or tiles[y][x] == "Gs" then
        tiles[y][x] = ({"Gs^Fp", "Gg^Fms", "Gll^Fp", "Gg^Fds"})[H.rand(1,4)]
    end
end

-- Small forest clusters (2-3 trees together)
for _ = 1, H.rand(3, 5) do
    local x, y = H.rand(6, W-5), H.rand(5, HT-4)
    if tiles[y][x] == "Gg" or tiles[y][x] == "Gs" then
        H.place_cluster(tiles, W, HT, x, y, ({"Gg^Fms", "Gll^Fp"})[H.rand(1,2)], 1)
    end
end

H.maybe_fixture(tiles, W, HT, "cave_lake", 40)
H.maybe_fixture(tiles, W, HT, "sunlit_clearing", 50)
H.maybe_fixture(tiles, W, HT, "cave_spring", 25)
H.maybe_fixture(tiles, W, HT, "fairy_ring", 50)
H.maybe_fixture(tiles, W, HT, "pond", 45)
H.maybe_fixture(tiles, W, HT, "great_tree", 35)
H.maybe_fixture(tiles, W, HT, "flower_field", 40)
H.maybe_fixture(tiles, W, HT, "forest_shrine", 30)
H.maybe_fixture(tiles, W, HT, "ruins", 25)
H.maybe_fixture(tiles, W, HT, "stone_circle", 20)
H.maybe_fixture(tiles, W, HT, "water_lilies", 30)
H.maybe_fixture(tiles, W, HT, "ancient_temple", 15)
H.maybe_fixture(tiles, W, HT, "mycelium_patch", 25)
H.maybe_fixture(tiles, W, HT, "abandoned_mine", 15)
H.maybe_fixture(tiles, W, HT, "flagstone_plaza", 15)

H.fill_pass(tiles, W, HT, "Gg", {"Gd", "Gs", "Gll"}, 30)

-- Sunlight beams — target ~25% of total map tiles
-- Prioritize grass tiles, then fill on anything non-wall
local total_tiles = W * HT
local beam_target = math.floor(total_tiles * 0.12)
local beam_count = 0

-- Big sunlight clusters first (on grass)
for _ = 1, H.rand(5, 8) do
    local lx, ly = H.rand(6, W-5), H.rand(5, HT-4)
    local t = tiles[ly][lx]
    if t == "Gg" or t == "Gs" or t == "Gd" or t == "Gll" then
        H.place_cluster(tiles, W, HT, lx, ly, "Gg^Ii", H.rand(2, 3))
    end
end
-- Count what clusters placed
for y = 1, HT do for x = 1, W do
    if tiles[y][x] == "Gg^Ii" then beam_count = beam_count + 1 end
end end

-- Pass 1: scatter on grass tiles
for _ = 1, beam_target * 3 do
    if beam_count >= beam_target then break end
    local x, y = H.rand(4, W-3), H.rand(3, HT-2)
    local t = tiles[y][x]
    if t == "Gg" or t == "Gd" or t == "Gs" or t == "Gll" then
        tiles[y][x] = "Gg^Ii"
        beam_count = beam_count + 1
    end
end
-- Pass 2: fill remaining on cave floor if needed
for _ = 1, (beam_target - beam_count) * 3 do
    if beam_count >= beam_target then break end
    local x, y = H.rand(3, W-2), H.rand(2, HT-1)
    local t = tiles[y][x]
    if t ~= "Xue" and t ~= "Xu" and t ~= "Gg^Ii" then
        tiles[y][x] = "Gg^Ii"
        beam_count = beam_count + 1
    end
end

local p1x, p1y, p2x, p2y = H.place_castles(tiles, W, HT, "Gg", {"Ke", "Kh", "Kv", "Kud"}, {"Ce", "Ch", "Cv", "Cud"})
local path = H.carve_path(tiles, W, HT, p1x, p1y, p2x, p2y, "Gd", "Gg")
H.scatter_villages(tiles, W, HT, {"Gg^Vh", "Gg^Ve", "Uu^Vu"}, {"Gg", "Gd", "Uu"}, nil, MAP_SIZE)
return H.build_map_string(tiles, W, HT, p1x, p1y, p2x, p2y)
