local H = wesnoth.dofile("~add-ons/Wesnoth_Roguelite/lua/mapgen_helpers.lua")
local W, HT, MAP_SIZE = H.random_map_size()
-- Dry grass base — the signature plains look
local tiles = H.init_map(W, HT, "Gd")

-- Semi-dry grass patches scattered in
for _ = 1, H.rand(4, 7) do H.place_cluster(tiles, W, HT, H.rand(3, W-2), H.rand(3, HT-2), "Gs", H.rand(1, 2)) end

-- Occasional dirt patches
for _ = 1, H.rand(2, 3) do H.place_cluster(tiles, W, HT, H.rand(3, W-2), H.rand(3, HT-2), "Rd", H.rand(1, 2)) end

-- Rolling hills — multiple independent patches
for _ = 1, H.rand(2, 3) do
    local hx, hy = H.rand(6, W-5), H.rand(4, HT-3)
    for _ = 1, H.rand(2, 4) do
        H.place_cluster(tiles, W, HT, hx, hy, "Hh", H.rand(1, 2))
        hx = hx + H.rand(-3, 3); hy = hy + H.rand(-2, 2)
        hx = math.max(4, math.min(W-3, hx)); hy = math.max(3, math.min(HT-2, hy))
    end
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
H.maybe_fixture(tiles, W, HT, "flower_field", 25)
H.maybe_fixture(tiles, W, HT, "windmill", 30)
H.maybe_fixture(tiles, W, HT, "dead_grove", 15)
H.maybe_fixture(tiles, W, HT, "hill_fort", 20)
H.maybe_fixture(tiles, W, HT, "desert_patch", 10)
H.maybe_fixture(tiles, W, HT, "pond", 20)
H.maybe_fixture(tiles, W, HT, "rocky_ridge", 25)
H.maybe_fixture(tiles, W, HT, "stream", 15)
H.maybe_fixture(tiles, W, HT, "great_tree", 10)
H.maybe_fixture(tiles, W, HT, "bluff_overlook", 10)

-- Scattered ruins variant (50% of plains maps)
if H.rand(1, 2) == 1 then
    for _ = 1, H.rand(4, 8) do
        local rx, ry = H.rand(3, W-2), H.rand(3, HT-2)
        if tiles[ry][rx] == "Gd" or tiles[ry][rx] == "Gs" then
            tiles[ry][rx] = ({"Cer", "Chr", "Cer"})[H.rand(1, 3)]
        end
    end
end

-- Fill: keep it dry — Gd dominant with some Gs
H.fill_pass(tiles, W, HT, "Gd", {"Gs", "Gd"}, 30)


-- NO border trees for plains — just gentle hills at edges
-- (plains are supposed to be open and flat)

-- Castles
H.maybe_scatter_ruins(tiles, W, HT, {"Gd", "Gs"}, 50)
local p1x, p1y, p2x, p2y = H.place_castles(tiles, W, HT, "Gd", {"Ke", "Kh", "Ket", "Ko"}, {"Ce", "Ch", "Co"})

-- Road
local path = H.carve_path(tiles, W, HT, p1x, p1y, p2x, p2y, "Rr")
H.place_bridges(tiles, W, HT, path)

H.scatter_villages(tiles, W, HT, {"Gd^Vh", "Gd^Vwm", "Hh^Vhh", "Gd^Vhc"}, {"Gd", "Gs", "Hh"}, nil, MAP_SIZE)
return H.build_map_string(tiles, W, HT, p1x, p1y, p2x, p2y)
