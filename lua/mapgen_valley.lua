local H = wesnoth.dofile("~add-ons/Wesnoth_Roguelite/lua/mapgen_helpers.lua")
-- Valley: sometimes vertical (top/bottom castles), always has central feature
local vertical = H.rand(1, 3) == 1
local W, HT, MAP_SIZE = H.random_map_size()
if vertical then W, HT = HT, W end
local tiles = H.init_map(W, HT, "Gg")

-- Valley walls along the narrow edges
if vertical then
    for y = 1, HT do
        for x = 1, H.rand(2, 4) do tiles[y][x] = H.rand(1,3)==1 and "Mm" or "Hh" end
        for x = W - H.rand(1, 3), W do tiles[y][x] = H.rand(1,3)==1 and "Mm" or "Hh" end
    end
else
    for x = 1, W do
        for y = 1, H.rand(2, 4) do tiles[y][x] = H.rand(1,3)==1 and "Mm" or "Hh" end
        for y = HT - H.rand(1, 3), HT do tiles[y][x] = H.rand(1,3)==1 and "Mm" or "Hh" end
    end
end

local trees = {"Gs^Fp", "Gg^Fds", "Gg^Fms"}
for _ = 1, H.rand(4, 7) do H.place_cluster(tiles, W, HT, H.rand(4, W-3), H.rand(5, HT-4), trees[H.rand(1,#trees)], H.rand(1, 3)) end
for _ = 1, H.rand(10, 18) do
    local x, y = H.rand(3, W-2), H.rand(4, HT-3)
    if tiles[y][x] == "Gg" then tiles[y][x] = trees[H.rand(1,#trees)] end
end

-- ALWAYS a central ruins to fight over (keep only 15% of the time)
local cx, cy = math.floor(W/2), math.floor(HT/2)
if H.rand(1, 100) <= 15 then
    tiles[cy][cx] = "Khr"  -- rare: usable keep
else
    tiles[cy][cx] = "Chr"  -- just castle ruins, no recruiting
end
for _, off in ipairs(H.hex_neighbors(cx)) do
    local nx, ny = cx+off[1], cy+off[2]
    if nx>=1 and nx<=W and ny>=1 and ny<=HT then
        tiles[ny][nx] = (H.rand(1,2)==1) and "Chr" or "Cer"
    end
end
-- Scatter ruin tiles around center
for _ = 1, H.rand(3, 6) do
    local sx, sy = cx + H.rand(-4, 4), cy + H.rand(-3, 3)
    if sx>=2 and sx<=W-1 and sy>=2 and sy<=HT-1 then
        local t = tiles[sy][sx]
        if t == "Gg" or t == "Gd" then tiles[sy][sx] = "Cer" end
    end
end

H.maybe_fixture(tiles, W, HT, "stream", 55)
H.maybe_fixture(tiles, W, HT, "pond", 35)
H.maybe_fixture(tiles, W, HT, "great_tree", 30)
H.maybe_fixture(tiles, W, HT, "campfire", 25)
H.maybe_fixture(tiles, W, HT, "flower_field", 20)
H.maybe_fixture(tiles, W, HT, "signpost", 20)
H.maybe_fixture(tiles, W, HT, "stone_circle", 15)
H.maybe_fixture(tiles, W, HT, "hill_fort", 15)
H.maybe_fixture(tiles, W, HT, "water_lilies", 20)
H.maybe_fixture(tiles, W, HT, "rocky_ridge", 5)

H.fill_pass(tiles, W, HT, "Gg", {"Gd", "Gs", "Gll", "Gg^Efm"}, 40)

local p1x, p1y, p2x, p2y = H.place_castles(tiles, W, HT, "Gg", {"Ke", "Kh"}, {"Ce", "Ch"}, vertical)
local path = H.carve_path(tiles, W, HT, p1x, p1y, p2x, p2y, "Rr")
H.place_bridges(tiles, W, HT, path)
H.scatter_villages(tiles, W, HT, {"Gg^Vh", "Gg^Ve", "Hh^Vhh", "Gg^Vl"}, {"Gg", "Gd", "Gs", "Hh"}, nil, MAP_SIZE)
return H.build_map_string(tiles, W, HT, p1x, p1y, p2x, p2y)
