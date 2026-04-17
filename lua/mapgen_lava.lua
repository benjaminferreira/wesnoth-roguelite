local H = wesnoth.dofile("~add-ons/Wesnoth_Roguelite/lua/mapgen_helpers.lua")
local W, HT, MAP_SIZE = H.random_map_size()
local tiles = H.init_map(W, HT, "Ur")

-- Volcanic border — organic mix of dry mountains, dunes, and dead trees
for x = 1, W do for y = 1, HT do
    local dist = math.min(x, y, W+1-x, HT+1-y)
    if dist <= 1 then
        local r = H.rand(1,100)
        if r > 15 then tiles[y][x] = "Md"
        elseif r > 5 then tiles[y][x] = "Hd^Fdw"
        else tiles[y][x] = "Ql" end
    elseif dist == 2 then
        local r = H.rand(1,100)
        if r > 40 then tiles[y][x] = "Md"
        elseif r > 20 then tiles[y][x] = "Hd"
        elseif r > 8 then tiles[y][x] = "Hd^Fdw"
        elseif r > 4 then tiles[y][x] = "Ql"
        end
    elseif dist == 3 then
        local r = H.rand(1,100)
        if r > 70 then tiles[y][x] = "Md"
        elseif r > 50 then tiles[y][x] = "Hd"
        elseif r > 35 then tiles[y][x] = "Hd^Fdw"
        elseif r > 25 then tiles[y][x] = "Dd^Fdw"
        elseif r > 22 then tiles[y][x] = "Ql"
        end
    elseif dist == 4 and H.rand(1,100) > 75 then
        tiles[y][x] = ({"Hd","Hd^Fdw","Dd"})[H.rand(1,3)]
    end
end end

-- Cave floor transition zones
for _ = 1, H.rand(3, 5) do
    H.place_cluster(tiles, W, HT, H.rand(4, W-3), H.rand(3, HT-2), "Uu", H.rand(1, 2))
end

-- Cave hills for elevation
for _ = 1, H.rand(4, 7) do
    H.place_cluster(tiles, W, HT, H.rand(5, W-4), H.rand(4, HT-3), "Uh", 1)
end

-- Road texture — ancient volcanic paths
for _ = 1, H.rand(2, 4) do
    H.place_cluster(tiles, W, HT, H.rand(5, W-4), H.rand(4, HT-3), "Rrc", H.rand(1, 2))
end

-- Dark flagstone areas
for _ = 1, H.rand(3, 5) do
    H.place_cluster(tiles, W, HT, H.rand(5, W-4), H.rand(4, HT-3), "Urb", H.rand(2, 3))
end

-- Scorched desert patches (dried volcanic soil with dunes and ruins)
for _ = 1, H.rand(3, 5) do
    local dx, dy = H.rand(6, W-5), H.rand(5, HT-4)
    if tiles[dy][dx] ~= "Md" and tiles[dy][dx] ~= "Ql" and tiles[dy][dx] ~= "Qlf" then
        H.place_cluster(tiles, W, HT, dx, dy, "Dd", H.rand(2, 3))
        -- Convert some desert tiles to dunes (desert hills)
        H.for_each_neighbor(dx, dy, W, HT, function(nx, ny)
            if tiles[ny][nx] == "Dd" and H.rand(1,100) > 50 then tiles[ny][nx] = "Hd" end
        end)
        -- Desert fortress ruins on the patch
        if H.rand(1,100) > 30 then
            tiles[dy][dx] = ({"Cdr","Kdr"})[H.rand(1,2)]
        end
    end
end

-- Dead trees scattered across all desert/dune tiles
for y = 3, HT-2 do for x = 3, W-2 do
    local t = tiles[y][x]
    if (t == "Dd" or t == "Hd") and H.rand(1,100) > 60 then
        tiles[y][x] = t .. "^Fdw"
    end
end end

-- Lava pools
for _ = 1, H.rand(2, 3) do
    H.place_cluster(tiles, W, HT, H.rand(6, W-5), H.rand(5, HT-4), "Ql", 1)
end

-- Short lava stream (30%)
if H.rand(1,100) <= 30 then
    local lx = H.rand(10, W-10)
    local start_y = H.rand(4, math.floor(HT/2))
    for y = start_y, math.min(HT-3, start_y + H.rand(4, 7)) do
        if H.rand(1,3) == 1 then lx = lx + H.rand(-1,1) end
        lx = math.max(5, math.min(W-4, lx))
        if tiles[y][lx] ~= "Md" then tiles[y][lx] = "Qlf" end
    end
end

H.maybe_fixture(tiles, W, HT, "cave_chasm", 35)
H.maybe_fixture(tiles, W, HT, "lava_vent", 45)
H.maybe_fixture(tiles, W, HT, "brazier_circle", 30)
H.maybe_fixture(tiles, W, HT, "bone_pile", 20)
H.maybe_fixture(tiles, W, HT, "volcano", 15)
H.maybe_fixture(tiles, W, HT, "rocky_ridge", 15)
H.maybe_fixture(tiles, W, HT, "ruins", 15)
H.maybe_fixture(tiles, W, HT, "pit", 15)
H.maybe_fixture(tiles, W, HT, "dead_grove", 25)
H.maybe_fixture(tiles, W, HT, "desert_bones", 20)

-- Floor variety
for y = 2, HT-1 do for x = 2, W-1 do
    if tiles[y][x] == "Ur" then
        local r = H.rand(1,100)
        if r > 90 then tiles[y][x] = "Urb"
        elseif r > 84 then tiles[y][x] = "Uh"
        elseif r > 80 then tiles[y][x] = "Uu"
        end
    end
end end

H.scatter_specials(tiles, W, HT, {"Ur^Ebn", "Uu^Efs", "Urb^Ebn"}, {"Ur", "Urb", "Uu"}, H.rand(4, 7))

local p1x, p1y, p2x, p2y = H.place_castles(tiles, W, HT, "Ur", {"Kud", "Ke", "Kf"}, {"Cud", "Ce", "Cf"})
local path = H.carve_path(tiles, W, HT, p1x, p1y, p2x, p2y, "Rrc", "Ur")
H.scatter_villages(tiles, W, HT, {"Uu^Vu"}, {"Ur", "Uu", "Urb", "Dd", "Hd", "Dd^Fdw", "Hd^Fdw"}, nil, MAP_SIZE)
-- Fix villages that landed on desert tiles to use desert village type
for y = 2, HT-1 do for x = 2, W-1 do
    if tiles[y][x] == "Uu^Vu" then
        local desert_neighbor = false
        H.for_each_neighbor(x, y, W, HT, function(nx, ny)
            local t = tiles[ny][nx]
            if t == "Dd" or t == "Hd" or t:find("^Dd") or t:find("^Hd") then desert_neighbor = true end
        end)
        if desert_neighbor then tiles[y][x] = "Dd^Vda" end
    end
end end
return H.build_map_string(tiles, W, HT, p1x, p1y, p2x, p2y)
