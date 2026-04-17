local H = wesnoth.dofile("~add-ons/Wesnoth_Roguelite/lua/mapgen_helpers.lua")
local W, HT, MAP_SIZE = H.random_map_size()
local tiles = H.init_map(W, HT, "Ww")

-- Create distinct separate islands with gaps between them
-- Player island (left)
H.place_cluster(tiles, W, HT, 5, math.floor(HT/2), "Gg", 4)

-- 3-5 stepping stone islands across the middle, spaced apart
local islands = {}
local num = H.rand(3, 5)
for i = 1, num do
    local ix = 5 + math.floor((W - 10) * i / (num + 1))
    local iy = math.floor(HT/2) + H.rand(-4, 4)
    iy = math.max(5, math.min(HT - 4, iy))
    local sz = H.rand(2, 3)
    H.place_cluster(tiles, W, HT, ix, iy, "Gg", sz)
    table.insert(islands, {ix, iy})
end

-- Enemy island (right)
H.place_cluster(tiles, W, HT, W - 4, math.floor(HT/2), "Gg", 4)

-- Beaches on island edges
for y = 2, HT-1 do for x = 2, W-1 do
    if tiles[y][x] == "Gg" then
        local nbrs = H.hex_neighbors(x)
        for _, off in ipairs(nbrs) do
            local nx, ny = x + off[1], y + off[2]
            if nx >= 1 and nx <= W and ny >= 1 and ny <= HT then
                if tiles[ny][nx] == "Ww" and H.rand(1, 100) > 50 then
                    tiles[ny][nx] = "Ds"
                end
            end
        end
    end
end end

-- Island features: trees, hills, flowers
for y = 3, HT-2 do for x = 3, W-2 do
    if tiles[y][x] == "Gg" then
        local r = H.rand(1, 100)
        if r > 92 then tiles[y][x] = "Gg^Ftp"
        elseif r > 87 then tiles[y][x] = "Gs^Fp"
        elseif r > 84 then tiles[y][x] = "Hh"
        elseif r > 82 then tiles[y][x] = "Gd"
        end
    end
end end

-- Reef and water features
for _ = 1, H.rand(3, 6) do
    local rx, ry = H.rand(5, W-4), H.rand(3, HT-2)
    if tiles[ry][rx] == "Ww" then tiles[ry][rx] = "Wwr" end
end
for _ = 1, H.rand(2, 4) do
    local lx, ly = H.rand(3, W-2), H.rand(3, HT-2)
    if tiles[ly][lx] == "Ww" then tiles[ly][lx] = "Ww^Ewf" end
end

H.fill_pass(tiles, W, HT, "Gg", {"Gd", "Gs"}, 30)

-- Island fixtures
H.maybe_fixture(tiles, W, HT, "ruins", 20)
H.maybe_fixture(tiles, W, HT, "campfire", 15)
H.maybe_fixture(tiles, W, HT, "rocky_ridge", 15)
H.maybe_fixture(tiles, W, HT, "bone_pile", 10)
H.maybe_fixture(tiles, W, HT, "watchtower", 15)
H.maybe_fixture(tiles, W, HT, "shell_beach", 25)
H.maybe_fixture(tiles, W, HT, "rainforest_thicket", 15)

-- Villages
for _ = 1, H.rand(1, 2) do
    local vx, vy = H.rand(10, W-9), H.rand(4, HT-3)
    if tiles[vy][vx] == "Ww" then tiles[vy][vx] = "Ww^Vm" end
end

-- Castles LAST
local p1x, p1y, p2x, p2y = H.place_castles(tiles, W, HT, "Gg", {"Ke", "Kh", "Ket", "Ko"}, {"Ce", "Ch", "Co"})

-- Ensure land around castles with beach transition
for _, pos in ipairs({{p1x, p1y}, {p2x, p2y}}) do
    for dy = -3, 3 do
        for dx = -3, 3 do
            local ax, ay = pos[1] + dx, pos[2] + dy
            if ax >= 1 and ax <= W and ay >= 1 and ay <= HT then
                local t = tiles[ay][ax]
                if t == "Ww" or t == "Wo" or t == "Wwr" then
                    local dist = math.abs(dx) + math.abs(dy)
                    if dist <= 2 then tiles[ay][ax] = "Gg"
                    elseif dist <= 3 then tiles[ay][ax] = "Ds"
                    else tiles[ay][ax] = "Wwf"
                    end
                end
            end
        end
    end
    -- Add a few trees/features on the island
    H.for_each_neighbor(pos[1], pos[2], W, HT, function(nx, ny)
        local t = tiles[ny][nx]
        if t == "Gg" and H.rand(1,100) > 60 then tiles[ny][nx] = "Gs^Fp" end
    end)
end

-- Now connect islands with wooden bridges
-- Walk from player castle toward enemy castle, bridging water gaps
local x, y = p1x, p1y
local path = {{x, y}}
local visited = {}
visited[y * 1000 + x] = true

local stuck = 0
while (x ~= p2x or y ~= p2y) and stuck < 500 do
    stuck = stuck + 1
    local nbrs = H.hex_neighbors(x)
    local best = nil
    local best_dist = 9999

    -- Try all 6 hex neighbors
    for dir = 1, 6 do
        local nx = x + nbrs[dir][1]
        local ny = y + nbrs[dir][2]
        if nx >= 1 and nx <= W and ny >= 1 and ny <= HT and not visited[ny * 1000 + nx] then
            local d = math.abs(p2x - nx) + math.abs(p2y - ny)
            -- Add randomness for meandering on land
            local t = tiles[ny][nx]
            local is_land = t ~= "Ww" and t ~= "Wo" and t ~= "Wwr"
            if is_land then d = d - H.rand(0, 3) end  -- prefer land
            if d < best_dist or (d == best_dist and H.rand(1, 2) == 1) then
                best_dist = d
                best = {nx, ny, dir}
            end
        end
    end

    if best then
        local nx, ny, dir = best[1], best[2], best[3]
        local t = tiles[ny][nx]
        visited[ny * 1000 + nx] = true

        if t == "Ww" or t == "Wo" or t == "Ds" or t == "Wwr" then
            -- Water tile — try to bridge in this direction
            local bridge_tiles = {{nx, ny}}
            local cx, cy = nx, ny
            local found_land = false
            for _ = 1, 5 do
                local nnx, nny = H.hex_step(cx, cy, dir)
                if nnx < 1 or nnx > W or nny < 1 or nny > HT then break end
                local nt = tiles[nny][nnx]
                if nt == "Ww" or nt == "Wo" or nt == "Ds" or nt == "Wwr" then
                    table.insert(bridge_tiles, {nnx, nny})
                    visited[nny * 1000 + nnx] = true
                    cx, cy = nnx, nny
                else
                    -- Hit land — check perpendicular water on both sides
                    local opp = ((dir + 2) % 6) + 1
                    local has_left, has_right = false, false
                    for _, b in ipairs(bridge_tiles) do
                        local bn = H.hex_neighbors(b[1])
                        for nd = 1, 6 do
                            if nd ~= dir and nd ~= opp then
                                local bx2 = b[1] + bn[nd][1]
                                local by2 = b[2] + bn[nd][2]
                                if bx2 >= 1 and bx2 <= W and by2 >= 1 and by2 <= HT then
                                    local bt2 = tiles[by2][bx2]
                                    if bt2 == "Ww" or bt2 == "Wo" then
                                        if nd < dir or (dir == 1 and nd == 6) then has_left = true
                                        else has_right = true end
                                    end
                                end
                            end
                        end
                    end
                    if has_left and has_right then
                        local bt = "Ww^Bw|"
                        if dir == 2 or dir == 5 then bt = "Ww^Bw/"
                        elseif dir == 3 or dir == 6 then bt = "Ww^Bw\\" end
                        for _, b in ipairs(bridge_tiles) do
                            tiles[b[2]][b[1]] = bt
                        end
                        found_land = true
                    end
                    x, y = nnx, nny
                    table.insert(path, {x, y})
                    break
                end
            end
        else
            -- Land tile — place road
            x, y = nx, ny
            if t:sub(1,1) ~= "K" and t:sub(1,1) ~= "C" then
                tiles[y][x] = "Gd"
            end
            table.insert(path, {x, y})
        end
    else
        -- Force move: pick any unvisited hex neighbor
        local nbrs = H.hex_neighbors(x)
        local forced = false
        for dir = 1, 6 do
            local fx, fy = x + nbrs[dir][1], y + nbrs[dir][2]
            if fx >= 1 and fx <= W and fy >= 1 and fy <= HT and not visited[fy * 1000 + fx] then
                visited[fy * 1000 + fx] = true
                x, y = fx, fy
                table.insert(path, {x, y})
                forced = true
                break
            end
        end
        if not forced then break end
    end
end

H.scatter_villages(tiles, W, HT, {"Gg^Vht", "Gg^Vh"}, {"Gg", "Ds"}, nil, MAP_SIZE)
return H.build_map_string(tiles, W, HT, p1x, p1y, p2x, p2y)
