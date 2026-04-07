local H = wesnoth.dofile("~add-ons/Wesnoth_Roguelite/lua/mapgen_helpers.lua")
local W, HT, MAP_SIZE = H.random_map_size()
-- Dry grass base — the signature plains look
local tiles = H.init_map(W, HT, "Gs")

-- Dominant: dry dirt patches
for _ = 1, H.rand(5, 8) do H.place_cluster(tiles, W, HT, H.rand(3, W-2), H.rand(3, HT-2), "Gd", H.rand(2, 3)) end

-- Rolling hills (gentle)
local hx, hy = H.rand(8, W-8), H.rand(5, HT-5)
for _ = 1, H.rand(3, 5) do
    H.place_cluster(tiles, W, HT, hx, hy, "Hh", H.rand(1, 2))
    hx = hx + H.rand(-3, 3); hy = hy + H.rand(-2, 2)
    hx = math.max(4, math.min(W-3, hx)); hy = math.max(3, math.min(HT-2, hy))
end

-- Very sparse trees (just a few copses, not forest)
for _ = 1, H.rand(2, 4) do
    local x, y = H.rand(3, W-2), H.rand(3, HT-2)
    tiles[y][x] = "Gs^Fp"
end

-- NO river. Maybe a tiny pond (30%)
if H.rand(1, 100) <= 30 then
    local px, py = H.rand(10, W-10), H.rand(6, HT-6)
    tiles[py][px] = "Ww"
end

H.maybe_fixture(tiles, W, HT, "lone_mountain", 15)
H.maybe_fixture(tiles, W, HT, "farmland_patch", 15)
H.maybe_fixture(tiles, W, HT, "campfire", 25)
H.maybe_fixture(tiles, W, HT, "ruins", 20)
H.maybe_fixture(tiles, W, HT, "stone_circle", 25)
H.maybe_fixture(tiles, W, HT, "watchtower", 20)
H.maybe_fixture(tiles, W, HT, "bandit_camp", 15)
H.maybe_fixture(tiles, W, HT, "signpost", 30)
H.maybe_fixture(tiles, W, HT, "flower_field", 25)
H.maybe_fixture(tiles, W, HT, "windmill", 30)
H.maybe_fixture(tiles, W, HT, "dead_grove", 15)
H.maybe_fixture(tiles, W, HT, "graveyard", 10)
H.maybe_fixture(tiles, W, HT, "hill_fort", 20)
H.maybe_fixture(tiles, W, HT, "desert_patch", 10)
H.maybe_fixture(tiles, W, HT, "pond", 20)
H.maybe_fixture(tiles, W, HT, "rocky_ridge", 25)

-- Scattered ruins variant (50% of plains maps)
if H.rand(1, 2) == 1 then
    for _ = 1, H.rand(4, 8) do
        local rx, ry = H.rand(3, W-2), H.rand(3, HT-2)
        if tiles[ry][rx] == "Gs" or tiles[ry][rx] == "Gd" then
            tiles[ry][rx] = ({"Cer", "Chr", "Cer"})[H.rand(1, 3)]
        end
    end
end

-- Fill: keep it yellow/dry — no green grass
H.fill_pass(tiles, W, HT, "Gs", {"Gd", "Gs"}, 30)


-- NO border trees for plains — just gentle hills at edges
-- (plains are supposed to be open and flat)

-- Castles
H.maybe_scatter_ruins(tiles, W, HT, {"Gs", "Gd"}, 50)
local p1x, p1y, p2x, p2y = H.place_castles(tiles, W, HT, "Gs", {"Ke", "Kh"}, {"Ce", "Ch"})

-- Road
local path = H.carve_path(tiles, W, HT, p1x, p1y, p2x, p2y, "Rr")
H.place_bridges(tiles, W, HT, path)

H.scatter_villages(tiles, W, HT, {"Gg^Vh", "Gg^Vwm", "Hh^Vhh", "Gg^Vhc"}, {"Gs", "Gd", "Hh"}, nil, MAP_SIZE)
return H.build_map_string(tiles, W, HT, p1x, p1y, p2x, p2y)
