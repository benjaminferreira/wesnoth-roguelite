local H = wesnoth.dofile("~add-ons/Wesnoth_Roguelite/lua/mapgen_helpers.lua")
-- Lava cave: dark volcanic cavern with stone walls
local W, HT, MAP_SIZE = H.random_map_size()
local tiles = H.init_map(W, HT, "Ur")

-- Stone wall border (ancient temple walls)
for x = 1, W do for y = 1, HT do
    local dist = math.min(x, y, W+1-x, HT+1-y)
    if dist <= 1 then tiles[y][x] = "Xos"
    elseif dist == 2 and H.rand(1,100) <= 75 then tiles[y][x] = "Xos"
    elseif dist == 3 and H.rand(1,100) <= 35 then tiles[y][x] = "Xos"
    end
end end

-- Dark flagstone areas
for _ = 1, H.rand(2, 4) do
    H.place_cluster(tiles, W, HT, H.rand(5, W-4), H.rand(4, HT-3), "Urb", H.rand(2, 3))
end

-- Stone wall pillars inside
for _ = 1, H.rand(2, 4) do H.place_cluster(tiles, W, HT, H.rand(6, W-5), H.rand(5, HT-4), "Xos", 1) end

-- Lava pools (fewer — 2-3 not 3-5)
for _ = 1, H.rand(2, 3) do H.place_cluster(tiles, W, HT, H.rand(6, W-5), H.rand(5, HT-4), "Ql", 1) end

-- Short lava stream (30%, only half the map height, won't block castle-to-castle)
if H.rand(1,100) <= 30 then
    local lx = H.rand(10, W-10)
    local start_y = H.rand(4, math.floor(HT/2))
    for y = start_y, math.min(HT-3, start_y + H.rand(4, 7)) do
        if H.rand(1,3) == 1 then lx = lx + H.rand(-1,1) end
        lx = math.max(5, math.min(W-4, lx))
        if tiles[y][lx] ~= "Xos" then tiles[y][lx] = "Qlf" end
    end
end

H.maybe_fixture(tiles, W, HT, "cave_chasm", 35)
H.maybe_fixture(tiles, W, HT, "sunlit_clearing", 15)
H.maybe_fixture(tiles, W, HT, "ancient_temple", 35)
H.maybe_fixture(tiles, W, HT, "lava_vent", 45)
H.maybe_fixture(tiles, W, HT, "cave_lake", 20)
H.maybe_fixture(tiles, W, HT, "brazier_circle", 30)
H.maybe_fixture(tiles, W, HT, "bone_pile", 20)
H.maybe_fixture(tiles, W, HT, "volcano", 15)
H.maybe_fixture(tiles, W, HT, "rocky_ridge", 10)

-- Subtle floor variety
for y = 2, HT-1 do for x = 2, W-1 do
    if tiles[y][x] == "Ur" then
        local r = H.rand(1,100)
        if r > 90 then tiles[y][x] = "Urb"
        elseif r > 82 then tiles[y][x] = "Uu"
        elseif r > 78 then tiles[y][x] = "Uue"
        end
    end
end end

H.scatter_specials(tiles, W, HT, {"Ur^Ebn", "Uu^Efs", "Urb^Ebn"}, {"Ur", "Urb", "Uu"}, H.rand(4, 7))

local p1x, p1y, p2x, p2y = H.place_castles(tiles, W, HT, "Ur", {"Kud", "Ke"}, {"Cud", "Ce"})
local path = H.carve_path(tiles, W, HT, p1x, p1y, p2x, p2y, "Urb", "Ur")
H.scatter_villages(tiles, W, HT, {"Uu^Vu"}, {"Ur", "Uu", "Urb"}, nil, MAP_SIZE)
return H.build_map_string(tiles, W, HT, p1x, p1y, p2x, p2y)
