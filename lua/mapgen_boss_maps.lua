-- mapgen_boss_maps.lua — Generate boss maps using the shared mapgen framework
-- Run from Wesnoth: wesnoth.dofile("~add-ons/Wesnoth_Roguelite/lua/mapgen_boss_maps.lua")
-- Or call individual functions to get map strings

local H = wesnoth.dofile("~add-ons/Wesnoth_Roguelite/lua/mapgen_helpers.lua")

local BM = {}

-- ============================================================
-- BRIARWEN — Forest with clearings, 7-10 villages
-- ============================================================
function BM.briarwen()
    local W, HT = 30, 24
    local tiles = H.init_map(W, HT, "Gg")

    -- Dense forest clusters
    for _ = 1, H.rand(10, 14) do
        H.place_cluster(tiles, W, HT, H.rand(4, W-3), H.rand(4, HT-3), "Gg^Fms", H.rand(2, 3))
    end
    -- Pine forest patches
    for _ = 1, H.rand(6, 9) do
        H.place_cluster(tiles, W, HT, H.rand(4, W-3), H.rand(4, HT-3), "Gs^Fp", H.rand(1, 3))
    end
    -- Light forest
    for _ = 1, H.rand(4, 6) do
        H.place_cluster(tiles, W, HT, H.rand(3, W-2), H.rand(3, HT-2), "Gll^Fp", H.rand(1, 2))
    end
    -- Small clearings (grass patches in the forest)
    for _ = 1, H.rand(3, 5) do
        H.place_cluster(tiles, W, HT, H.rand(6, W-5), H.rand(5, HT-4), "Gg", H.rand(1, 2))
    end
    -- A few hills
    for _ = 1, H.rand(2, 4) do
        H.place_cluster(tiles, W, HT, H.rand(5, W-4), H.rand(5, HT-4), "Hh^Fp", 1)
    end
    -- Small streams
    for _ = 1, H.rand(1, 2) do
        local sx = H.rand(8, W-8)
        local sy = H.rand(3, HT-3)
        for i = 0, H.rand(3, 6) do
            local wy = sy + i
            if wy <= HT then tiles[wy][sx + H.rand(-1, 1)] = "Ww" end
        end
    end

    -- Fill pass
    H.fill_pass(tiles, W, HT, "Gg", {"Gs", "Gs^Fp", "Gg^Fms", "Gll^Fp"}, 40)
    -- Dense forest borders
    H.dense_borders(tiles, W, HT, {"Gg^Fms", "Gs^Fp", "Gll^Fp"}, "Gg^Fms")

    -- Castles: player bottom-left, Briarwen top-right
    local p1x, p1y, p2x, p2y = H.place_castles(tiles, W, HT, "Gg", {"Ke", "Ce"}, {"Ce", "Ce"})
    -- Carve a path
    local path = H.carve_path(tiles, W, HT, p1x, p1y, p2x, p2y, "Gd")
    -- Villages: spread across map
    H.scatter_villages(tiles, W, HT, {"Gg^Vh", "Gg^Ve", "Gg^Vl"}, {"Gg", "Gs", "Gd", "Gll^Fp"}, nil, "medium")

    return H.build_map_string(tiles, W, HT, p1x, p1y, p2x, p2y)
end

-- ============================================================
-- MAGGASH — Open field, NO villages, flat terrain
-- ============================================================
function BM.maggash()
    local W, HT = 28, 22
    local tiles = H.init_map(W, HT, "Gg")

    -- Dry grass patches
    for _ = 1, H.rand(6, 10) do
        H.place_cluster(tiles, W, HT, H.rand(3, W-2), H.rand(3, HT-2), "Gd", H.rand(2, 3))
    end
    -- Scattered dirt
    for _ = 1, H.rand(4, 6) do
        H.place_cluster(tiles, W, HT, H.rand(4, W-3), H.rand(4, HT-3), "Re", H.rand(1, 2))
    end
    -- A few low hills (not many — mostly flat)
    for _ = 1, H.rand(2, 3) do
        H.place_cluster(tiles, W, HT, H.rand(5, W-4), H.rand(5, HT-4), "Hh", 1)
    end
    -- Sparse bushes/trees (very few)
    for _ = 1, H.rand(2, 4) do
        local x, y = H.rand(4, W-3), H.rand(4, HT-3)
        if tiles[y][x] == "Gg" then tiles[y][x] = "Gg^Fds" end
    end

    -- Fill pass — keep it mostly open
    H.fill_pass(tiles, W, HT, "Gg", {"Gs", "Gd", "Gg"}, 30)
    -- Light borders
    H.dense_borders(tiles, W, HT, {"Gg^Fds", "Hh", "Gs"}, "Gg^Fds")

    -- Player castle: left side, small (3 castle hexes for slow deploy)
    local p1x, p1y = 3, math.floor(HT / 2)
    tiles[p1y][p1x] = "1 Ke"
    -- Only 3 castle hexes around the keep
    local nbrs = H.hex_neighbors(p1x)
    local placed = 0
    for _, off in ipairs(nbrs) do
        if placed >= 3 then break end
        local nx, ny = p1x + off[1], p1y + off[2]
        if nx >= 1 and nx <= W and ny >= 1 and ny <= HT then
            tiles[ny][nx] = "Ce"
            placed = placed + 1
        end
    end

    -- Enemy keep: right side (Maggash spawns here, horde spawns across right half)
    local p2x, p2y = W - 2, math.floor(HT / 2)
    tiles[p2y][p2x] = "2 Kh"

    -- NO villages at all
    return H.build_map_string(tiles, W, HT, p1x, p1y, p2x, p2y)
end

-- ============================================================
-- PALE CONDUCTOR — Long horizontal graveyard/swamp
-- ============================================================
function BM.pale_conductor()
    local W, HT = 36, 20
    local tiles = H.init_map(W, HT, "Ss")

    -- Left side: solid ground (player zone)
    for y = 1, HT do
        for x = 1, 7 do
            tiles[y][x] = ({"Gg", "Gs", "Gd", "Gg", "Gs"})[H.rand(1, 5)]
        end
    end
    -- Transition zone (columns 8-10): mixed
    for y = 1, HT do
        for x = 8, 10 do
            tiles[y][x] = ({"Gd", "Ss", "Gd", "Sm", "Ss"})[H.rand(1, 5)]
        end
    end
    -- Middle: swamp with water channels
    for _ = 1, H.rand(3, 5) do
        local sx = H.rand(12, W-8)
        local sy = H.rand(2, HT-1)
        for i = 0, H.rand(4, 8) do
            local wy = sy + i
            local wx = sx + H.rand(-1, 1)
            if wy >= 1 and wy <= HT and wx >= 1 and wx <= W then
                tiles[wy][wx] = "Ww"
            end
        end
    end
    -- Mud patches
    for _ = 1, H.rand(6, 10) do
        H.place_cluster(tiles, W, HT, H.rand(10, W-4), H.rand(3, HT-2), "Sm", H.rand(1, 2))
    end
    -- Dead forest patches
    for _ = 1, H.rand(4, 7) do
        H.place_cluster(tiles, W, HT, H.rand(8, W-3), H.rand(3, HT-2), "Ss^Fds", H.rand(1, 2))
    end
    -- Ruins/gravestones
    for _ = 1, H.rand(3, 5) do
        local x, y = H.rand(12, W-5), H.rand(3, HT-2)
        if not H.is_village(tiles[y][x]) then tiles[y][x] = "Gd^Edt" end
    end

    -- Blend water edges
    H.blend_around(tiles, W, HT, "Ww", "Sm")
    -- Fill pass
    H.fill_pass(tiles, W, HT, "Ss", {"Sm", "Gd", "Ss^Fds", "Ss"}, 40)
    -- Dense swamp borders
    H.dense_borders(tiles, W, HT, {"Ss", "Sm", "Ww"}, "Ww")

    -- Castles
    local p1x, p1y = 3, math.floor(HT / 2)
    tiles[p1y][p1x] = "1 Ke"
    local nbrs = H.hex_neighbors(p1x)
    for _, off in ipairs(nbrs) do
        local nx, ny = p1x + off[1], p1y + off[2]
        if nx >= 1 and nx <= W and ny >= 1 and ny <= HT then tiles[ny][nx] = "Ce" end
    end

    local p2x, p2y = W - 2, math.floor(HT / 2)
    tiles[p2y][p2x] = "2 Kh"
    nbrs = H.hex_neighbors(p2x)
    for _, off in ipairs(nbrs) do
        local nx, ny = p2x + off[1], p2y + off[2]
        if nx >= 1 and nx <= W and ny >= 1 and ny <= HT then tiles[ny][nx] = "Ch" end
    end

    -- Path
    local path = H.carve_path(tiles, W, HT, p1x, p1y, p2x, p2y, "Gd")
    H.place_bridges(tiles, W, HT, path)
    -- Villages: player side 2-3, contested middle 3-4, enemy side 2-3
    H.scatter_villages(tiles, W, HT, {"Ss^Vhs", "Gd^Vh", "Gg^Vh"}, {"Gg", "Gs", "Gd", "Ss"}, nil, "large")

    return H.build_map_string(tiles, W, HT, p1x, p1y, p2x, p2y)
end

-- ============================================================
-- SITHRAK — Lava rivers with bridges, volcanic
-- ============================================================
function BM.sithrak()
    local W, HT = 32, 24
    local tiles = H.init_map(W, HT, "Ur")

    -- Cave/volcanic base terrain
    for y = 1, HT do
        for x = 1, W do
            tiles[y][x] = ({"Ur", "Uu", "Urb", "Ur", "Uh"})[H.rand(1, 5)]
        end
    end
    -- Lava river running roughly vertical through the middle
    local lx = math.floor(W / 2) + H.rand(-2, 2)
    for y = 1, HT do
        local rx = lx + H.rand(-1, 1)
        for dx = -1, 1 do
            local x = rx + dx
            if x >= 1 and x <= W then tiles[y][x] = "Ql" end
        end
        lx = rx
    end
    -- Lava pools
    for _ = 1, H.rand(3, 5) do
        H.place_cluster(tiles, W, HT, H.rand(6, W-5), H.rand(4, HT-3), "Ql", H.rand(1, 2))
    end
    -- Mountains on edges
    for _ = 1, H.rand(4, 6) do
        H.place_cluster(tiles, W, HT, H.rand(2, W-1), H.rand(2, HT-1), "Mm", H.rand(1, 2))
    end
    -- Hills
    for _ = 1, H.rand(3, 5) do
        H.place_cluster(tiles, W, HT, H.rand(4, W-3), H.rand(4, HT-3), "Hh", H.rand(1, 2))
    end

    -- Bridges across lava (2-3 crossing points)
    -- Find lava column and place bridges
    for attempt = 1, 3 do
        local by = H.rand(4, HT - 3)
        for bx = 4, W - 3 do
            if tiles[by][bx] == "Ql" then
                -- Check if this is a narrow crossing
                local left_ok = bx > 1 and tiles[by][bx-1] ~= "Ql"
                local right_ok = bx < W and tiles[by][bx+1] ~= "Ql"
                if not left_ok or not right_ok then
                    -- Make it narrow: clear one side
                    tiles[by][bx] = "Ql^Bsb/"
                end
                break
            end
        end
    end

    -- Fill pass
    H.fill_pass(tiles, W, HT, "Ur", {"Uu", "Urb", "Uh", "Ur"}, 30)
    -- Dense borders
    H.dense_borders(tiles, W, HT, {"Mm", "Uu", "Ur"}, "Mm")

    -- Castles
    local p1x, p1y = 3, math.floor(HT / 2)
    tiles[p1y][p1x] = "1 Ke"
    local nbrs = H.hex_neighbors(p1x)
    for _, off in ipairs(nbrs) do
        local nx, ny = p1x + off[1], p1y + off[2]
        if nx >= 1 and nx <= W and ny >= 1 and ny <= HT then tiles[ny][nx] = "Ce" end
    end

    local p2x, p2y = W - 2, math.floor(HT / 2)
    tiles[p2y][p2x] = "2 Kh"
    nbrs = H.hex_neighbors(p2x)
    for _, off in ipairs(nbrs) do
        local nx, ny = p2x + off[1], p2y + off[2]
        if nx >= 1 and nx <= W and ny >= 1 and ny <= HT then tiles[ny][nx] = "Cha" end
    end

    -- Villages: sparse
    H.scatter_villages(tiles, W, HT, {"Uu^Vu"}, {"Ur", "Uu", "Urb", "Uh"}, nil, "small")

    return H.build_map_string(tiles, W, HT, p1x, p1y, p2x, p2y)
end

-- ============================================================
-- IRONBAND — Vertical map, river crossing, mountains north
-- ============================================================
function BM.ironband()
    local W, HT = 24, 28
    local tiles = H.init_map(W, HT, "Gg")

    -- Southern half: grassland with some hills
    for y = math.floor(HT * 0.6), HT do
        for x = 1, W do
            tiles[y][x] = ({"Gg", "Gs", "Gg", "Gd", "Gg"})[H.rand(1, 5)]
        end
    end
    -- River running horizontally across the middle
    local ry = math.floor(HT * 0.45)
    for x = 1, W do
        tiles[ry][x] = "Ww"
        if H.rand(1, 100) <= 60 then tiles[ry+1][x] = "Ww" end
        if H.rand(1, 100) <= 30 then tiles[ry-1][x] = "Ww" end
    end
    -- Northern half: hills and mountains
    for y = 1, math.floor(HT * 0.4) do
        for x = 1, W do
            tiles[y][x] = ({"Hh", "Hh", "Mm", "Hh", "Gs", "Hh"})[H.rand(1, 6)]
        end
    end
    -- Mountain peaks along top edge
    for _ = 1, H.rand(3, 5) do
        H.place_cluster(tiles, W, HT, H.rand(3, W-2), H.rand(2, 4), "Mm", H.rand(1, 2))
    end
    -- Forest patches on hills
    for _ = 1, H.rand(3, 5) do
        H.place_cluster(tiles, W, HT, H.rand(3, W-2), H.rand(3, math.floor(HT*0.4)), "Hh^Fp", H.rand(1, 2))
    end
    -- Southern forest
    for _ = 1, H.rand(3, 5) do
        H.place_cluster(tiles, W, HT, H.rand(3, W-2), H.rand(math.floor(HT*0.65), HT-2), "Gg^Fms", H.rand(1, 2))
    end

    -- Bridges: 2 crossing points
    local b1x = math.floor(W * 0.3)
    local b2x = math.floor(W * 0.7)
    for _, bx in ipairs({b1x, b2x}) do
        for y = ry-1, ry+1 do
            if y >= 1 and y <= HT and tiles[y][bx] == "Ww" then
                tiles[y][bx] = "Ww^Bw|"
            end
        end
    end

    -- Fill pass
    H.fill_pass(tiles, W, HT, "Gg", {"Gs", "Gd", "Gg"}, 30)
    -- Blend water edges
    H.blend_around(tiles, W, HT, "Ww", "Gs")
    -- Dense borders
    H.dense_borders(tiles, W, HT, {"Mm", "Hh", "Gg^Fms"}, "Mm")

    -- Player castle: bottom center
    local p1x, p1y = math.floor(W / 2), HT - 2
    tiles[p1y][p1x] = "1 Ke"
    local nbrs = H.hex_neighbors(p1x)
    for _, off in ipairs(nbrs) do
        local nx, ny = p1x + off[1], p1y + off[2]
        if nx >= 1 and nx <= W and ny >= 1 and ny <= HT then tiles[ny][nx] = "Ce" end
    end

    -- Enemy keep: north center (Halvard's position — no canrecruit so just a marker)
    local p2x, p2y = math.floor(W / 2), 4
    tiles[p2y][p2x] = "2 Kh"

    -- Villages: some south, some near champions
    H.scatter_villages(tiles, W, HT, {"Gg^Vh", "Hh^Vhh", "Gg^Vhc"}, {"Gg", "Gs", "Hh", "Gd"}, nil, "medium")

    return H.build_map_string(tiles, W, HT, p1x, p1y, p2x, p2y)
end

-- ============================================================
-- GUTRIPPER (Maggash) — Open field, NO villages
-- ============================================================
BM.gutripper = BM.maggash

return BM
