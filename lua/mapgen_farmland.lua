local H = wesnoth.dofile("~add-ons/Wesnoth_Roguelite/lua/mapgen_helpers.lua")
local W, HT, MAP_SIZE = H.random_map_size()
local tiles = H.init_map(W, HT, "Gg")

-- Trees and hills first
for _ = 1, H.rand(3, 5) do H.place_cluster(tiles, W, HT, H.rand(3, W-2), H.rand(3, HT-2), "Gs^Fp", 1) end
for _ = 1, H.rand(1, 3) do H.place_cluster(tiles, W, HT, H.rand(3, W-2), H.rand(3, HT-2), "Hh", 1) end

-- Thin stream (60% chance)
if H.rand(1, 100) <= 60 then
    H.carve_stream(tiles, W, HT, H.rand(1, 2) == 1)
end

H.fill_pass(tiles, W, HT, "Gg", {"Gd", "Gs"}, 35)

-- Path and road FIRST
local p1x, p1y, p2x, p2y = H.place_castles(tiles, W, HT, "Gg", {"Ke", "Kh", "Ket"}, {"Ce", "Ch"})
local path = H.carve_path(tiles, W, HT, p1x, p1y, p2x, p2y, "Rr")
local rx = H.rand(math.floor(W/3), math.floor(2*W/3))
for y2 = 1, HT do
    if H.rand(1,5) == 1 then rx = rx + H.rand(-1,1) end
    rx = math.max(5, math.min(W-4, rx))
    local t = tiles[y2][rx]
    if t:sub(1,1) ~= "K" and t:sub(1,1) ~= "C" then tiles[y2][rx] = "Rr" end
end
H.place_bridges(tiles, W, HT, path)

-- THEN place farm plots — they'll avoid the path
for _ = 1, H.rand(12, 20) do
    H.maybe_fixture(tiles, W, HT, "farmland_patch", 100)
end

H.maybe_fixture(tiles, W, HT, "pond", 40)
H.maybe_fixture(tiles, W, HT, "windmill", 50)
H.maybe_fixture(tiles, W, HT, "campfire", 20)
H.maybe_fixture(tiles, W, HT, "ruins", 15)
H.maybe_fixture(tiles, W, HT, "signpost", 30)
H.maybe_fixture(tiles, W, HT, "flower_field", 20)
H.maybe_fixture(tiles, W, HT, "hill_fort", 15)
H.maybe_fixture(tiles, W, HT, "dead_grove", 10)
H.maybe_fixture(tiles, W, HT, "stone_circle", 10)
H.maybe_fixture(tiles, W, HT, "great_tree", 15)
H.maybe_fixture(tiles, W, HT, "stream", 15)
H.maybe_fixture(tiles, W, HT, "graveyard", 10)

H.scatter_villages(tiles, W, HT, {"Gg^Vh", "Gg^Vwm", "Gg^Vh", "Gg^Vhc"}, {"Gg", "Gd"}, nil, MAP_SIZE)
return H.build_map_string(tiles, W, HT, p1x, p1y, p2x, p2y)
