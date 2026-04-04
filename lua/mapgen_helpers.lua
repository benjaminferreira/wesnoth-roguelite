-- mapgen_helpers.lua — shared map generation framework
-- Rules:
-- 1. Guaranteed meandering path between castles
-- 2. Fill pass upgrades ~40% of remaining base terrain
-- 3. Irregular dense borders (2-3 hex deep, ~75% coverage, varied terrain)
-- 4. Terrain blending with ~75% transition zones
-- 5. Cave maps carve path first, then chambers
-- 6. Special items, bridges, ruins placed contextually
-- 7. Small castles (1 keep + 6 castle), varied types, varied villages

local H = {}

function H.rand(min, max)
    return wesnoth.random(min, max)
end

-- Random map size: shared pool for all biomes
-- Returns width, height
function H.random_map_size()
    local sizes = {
        {34, 22},  -- wide standard
        {32, 24},  -- balanced
        {30, 26},  -- tall-ish
        {36, 22},  -- extra wide
        {28, 28},  -- square
        {32, 22},  -- medium wide
        {30, 22},  -- compact wide
        {34, 24},  -- large
    }
    local pick = sizes[H.rand(1, #sizes)]
    return pick[1], pick[2]
end

-- Hex grid utilities (Wesnoth staggered columns, 1-indexed)
-- Odd columns are shifted down
function H.hex_neighbors(x)
    if x % 2 == 1 then
        return {{0,-1},{1,0},{1,1},{0,1},{-1,1},{-1,0}}
    else
        return {{0,-1},{1,-1},{1,0},{0,1},{-1,0},{-1,-1}}
    end
end
-- dir: 1=N 2=NE 3=SE 4=S 5=SW 6=NW
function H.hex_step(x, y, dir)
    local n = H.hex_neighbors(x)
    return x + n[dir][1], y + n[dir][2]
end
-- Bridge terrain for each hex direction
H.bridge_for_dir = {"Ww^Bw|","Ww^Bw/","Ww^Bw\\","Ww^Bw|","Ww^Bw/","Ww^Bw\\"}

-- Call fn(nx, ny) for each hex neighbor of (x, y) within bounds
function H.for_each_neighbor(x, y, width, height, fn)
    local nbrs = H.hex_neighbors(x)
    for _, off in ipairs(nbrs) do
        local nx, ny = x + off[1], y + off[2]
        if nx >= 1 and nx <= width and ny >= 1 and ny <= height then
            fn(nx, ny)
        end
    end
end

function H.init_map(width, height, base_terrain)
    local tiles = {}
    for y = 1, height do
        tiles[y] = {}
        for x = 1, width do
            tiles[y][x] = base_terrain
        end
    end
    return tiles
end

function H.place_cluster(tiles, width, height, cx, cy, terrain, size)
    for dy = -size, size do
        for dx = -size, size do
            local x, y = cx + dx, cy + dy
            if x >= 1 and x <= width and y >= 1 and y <= height then
                -- Use euclidean distance for rounder shapes
                local dist = math.sqrt(dx * dx + dy * dy)
                if dist <= size + 0.5 and H.rand(1, 100) > dist * 15 then
                    if tiles[y][x] ~= "Re^Gvs" then tiles[y][x] = terrain end
                end
            end
        end
    end
end

-- Rule 1: Carve a guaranteed meandering path between two points
-- Path is 1 tile wide, crosses rivers in straight lines with bridges
function H.carve_path(tiles, width, height, x1, y1, x2, y2, path_terrain, rough_terrain)
    rough_terrain = rough_terrain or "Gd"
    local path = {}
    local on_path = {}
    local function key(px, py) return py * 1000 + px end
    local function is_water(px, py)
        if px < 1 or px > width or py < 1 or py > height then return false end
        local t = tiles[py][px]
        return t == "Ww" or t == "Wo"
    end

    -- Try a straight-line bridge in hex direction dir from (sx,sy)
    -- Returns water tiles + landing coords, or nil
    local function try_hex_bridge(sx, sy, dir)
        local water = {}
        local cx, cy = H.hex_step(sx, sy, dir)
        for _ = 1, 4 do
            if cx < 1 or cx > width or cy < 1 or cy > height then return nil end
            if is_water(cx, cy) then
                table.insert(water, {cx, cy})
                cx, cy = H.hex_step(cx, cy, dir)
            else
                if #water > 0 then
                    -- Verify water extends on BOTH sides of the bridge
                    -- dir and opposite are the crossing axis; check the other 4 dirs
                    local opp = ((dir + 2) % 6) + 1
                    local has_left = false
                    local has_right = false
                    for _, w in ipairs(water) do
                        local nbrs = H.hex_neighbors(w[1])
                        for ndir = 1, 6 do
                            if ndir ~= dir and ndir ~= opp then
                                local nx = w[1] + nbrs[ndir][1]
                                local ny = w[2] + nbrs[ndir][2]
                                if is_water(nx, ny) then
                                    -- Split into left/right based on direction index
                                    if ndir < dir or (dir == 1 and ndir == 6) then
                                        has_left = true
                                    else
                                        has_right = true
                                    end
                                end
                            end
                        end
                    end
                    if not (has_left and has_right) then return nil end
                    return water, cx, cy
                end
                return nil
            end
        end
        return nil
    end

    -- PRE-SCAN: find river and place a bridge before pathing
    local bridge_bank = nil
    local bridge_land = nil
    local bridge_bank2 = nil
    local bridge_land2 = nil
    local total_bridges = 0
    local br = H.rand(1, 100)
    local max_bridges = (br <= 15) and 1 or (br <= 75) and 2 or 3
    local want_two = max_bridges >= 2

    -- Check if a bridge tile would be adjacent to another bridge (parallel check)
    local function bridge_adjacent(bx, by)
        local bn = H.hex_neighbors(bx)
        for _, off in ipairs(bn) do
            local nx2, ny2 = bx + off[1], by + off[2]
            if nx2 >= 1 and nx2 <= width and ny2 >= 1 and ny2 <= height then
                local bt = tiles[ny2][nx2]
                if type(bt) == "string" and bt:find("^Bw", 1, true) then return true end
            end
        end
        return false
    end

    for attempt = 1, 20 do
        if total_bridges >= 1 and not want_two then break end
        if total_bridges >= 2 then break end
        local sx = x1 + math.floor((x2 - x1) * H.rand(2, 8) / 10)
        local sy = y1 + math.floor((y2 - y1) * H.rand(2, 8) / 10)
        sx = math.max(3, math.min(width - 2, sx))
        sy = math.max(3, math.min(height - 2, sy))
        local placed = false
        for dy = -3, 3 do
            if placed then break end
            for dx = -3, 3 do
                if placed then break end
                local wx, wy = sx + dx, sy + dy
                if wx >= 2 and wx <= width-1 and wy >= 2 and wy <= height-1 and is_water(wx, wy) then
                    local nbrs = H.hex_neighbors(wx)
                    for dir = 1, 6 do
                        local bx, by = wx + nbrs[dir][1], wy + nbrs[dir][2]
                        if bx >= 1 and bx <= width and by >= 1 and by <= height and not is_water(bx, by) then
                            local opp = ((dir - 1 + 3) % 6) + 1
                            local wt, lx, ly = try_hex_bridge(bx, by, opp)
                            if wt then
                                -- Don't place too close to existing bridge
                                local too_close = false
                                if bridge_bank then
                                    local d = math.abs(bx - bridge_bank[1]) + math.abs(by - bridge_bank[2])
                                    if d < 6 then too_close = true end
                                end
                                if not too_close then
                                    -- Check no bridge tile would be parallel to existing
                                    local parallel = false
                                    for _, w in ipairs(wt) do
                                        if bridge_adjacent(w[1], w[2]) then parallel = true; break end
                                    end
                                    if not parallel then
                                        local bridge = H.bridge_for_dir[opp]
                                        for _, w in ipairs(wt) do
                                            tiles[w[2]][w[1]] = bridge
                                        end
                                        total_bridges = total_bridges + 1
                                        if total_bridges == 1 then
                                            bridge_bank = {bx, by}
                                            bridge_land = {lx, ly}
                                        else
                                            bridge_bank2 = {bx, by}
                                            bridge_land2 = {lx, ly}
                                        end
                                        placed = true
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    local x, y = x1, y1
    table.insert(path, {x, y})
    on_path[key(x, y)] = true

    -- Waypoints for meandering
    local waypoints = {}
    local sr = H.rand(1, 100)
    local segments = (sr <= 30) and 2 or (sr <= 70) and 3 or 4
    for i = 1, segments do
        local wx, wy
        if math.abs(x2 - x1) >= math.abs(y2 - y1) then
            wx = x1 + math.floor((x2 - x1) * i / (segments + 1))
            wy = H.rand(4, height - 3)
        else
            wx = H.rand(4, width - 3)
            wy = y1 + math.floor((y2 - y1) * i / (segments + 1))
        end
        table.insert(waypoints, {wx, wy})
    end
    -- Nudge waypoints off impassable/skipped tiles
    for wi, wp in ipairs(waypoints) do
        local wt = tiles[wp[2]][wp[1]]
        if wt == "Re^Gvs" or wt == "Xu" or wt == "Mm^Xm" or wt == "Xue" or wt == "Xos" or wt == "Ww" or wt == "Wo" then
            local nbrs = H.hex_neighbors(wp[1])
            for _, off in ipairs(nbrs) do
                local nx, ny = wp[1] + off[1], wp[2] + off[2]
                if nx >= 3 and nx <= width-2 and ny >= 3 and ny <= height-2 then
                    local nt = tiles[ny][nx]
                    if nt ~= "Re^Gvs" and nt ~= "Xu" and nt ~= "Mm^Xm" and nt ~= "Xue" and nt ~= "Xos" and nt ~= "Ww" and nt ~= "Wo" then
                        waypoints[wi] = {nx, ny}
                        break
                    end
                end
            end
        end
    end
    if bridge_bank and bridge_land then
        local ins = math.floor(#waypoints / 2) + 1
        table.insert(waypoints, ins, bridge_bank)
        table.insert(waypoints, ins + 1, bridge_land)
    end
    if bridge_bank2 and bridge_land2 then
        -- Insert second bridge waypoints near the end
        local ins2 = math.max(1, #waypoints - 1)
        table.insert(waypoints, ins2, bridge_bank2)
        table.insert(waypoints, ins2 + 1, bridge_land2)
    end
    table.insert(waypoints, {x2, y2})

    -- Walk through waypoints using hex neighbors
    for _, wp in ipairs(waypoints) do
        local tx, ty = wp[1], wp[2]
        local stuck = 0
        while (x ~= tx or y ~= ty) and stuck < 400 do
            stuck = stuck + 1

            -- Pick a hex neighbor that moves toward the target
            local best_dir = nil
            local best_dist = math.abs(tx - x) + math.abs(ty - y)
            local candidates = {}
            local nbrs = H.hex_neighbors(x)
            for dir = 1, 6 do
                local nx = x + nbrs[dir][1]
                local ny = y + nbrs[dir][2]
                if nx >= 2 and nx <= width-1 and ny >= 2 and ny <= height-1 then
                    local d = math.abs(tx - nx) + math.abs(ty - ny)
                    if d < best_dist then
                        table.insert(candidates, {dir, nx, ny, d})
                    end
                end
            end
            -- Also add some random neighbors for meandering (65% chance)
            if H.rand(1, 100) <= 65 then
                local rdir = H.rand(1, 6)
                local rnx = x + nbrs[rdir][1]
                local rny = y + nbrs[rdir][2]
                if rnx >= 2 and rnx <= width-1 and rny >= 2 and rny <= height-1 then
                    -- Insert at front 60% of the time so it's preferred over optimal
                    if H.rand(1, 100) <= 60 then
                        table.insert(candidates, 1, {rdir, rnx, rny, -1})
                    else
                        table.insert(candidates, {rdir, rnx, rny, 999})
                    end
                end
            end

            -- Sort by distance (closest first), but random candidate at end
            table.sort(candidates, function(a, b) return a[4] < b[4] end)

            local moved = false
            for _, c in ipairs(candidates) do
                local nx, ny = c[2], c[3]
                local t = tiles[ny][nx]
                local first = t:sub(1, 1)

                if first == "K" or first == "C" then
                    x, y = nx, ny
                    table.insert(path, {x, y})
                    moved = true
                    break
                elseif t == "Xu" or t == "Mm^Xm" or t == "Re^Gvs" then
                    -- skip
                elseif is_water(nx, ny) then
                    -- Try live crossing if under bridge limit
                    local nbrs2 = H.hex_neighbors(x)
                    for dir2 = 1, 6 do
                        local wt2, lx2, ly2 = try_hex_bridge(x, y, dir2)
                        if wt2 and #wt2 <= 4 then
                            -- Check no parallel bridges
                            local par = false
                            for _, w in ipairs(wt2) do
                                if bridge_adjacent(w[1], w[2]) then par = true; break end
                            end
                            if not par then
                                local crossing_type
                                if total_bridges < max_bridges then
                                    crossing_type = H.bridge_for_dir[dir2]
                                    total_bridges = total_bridges + 1
                                else
                                    crossing_type = "Wwf"  -- ford
                                end
                                for _, w in ipairs(wt2) do
                                    tiles[w[2]][w[1]] = crossing_type
                                    table.insert(path, w)
                                    on_path[key(w[1], w[2])] = true
                                end
                                x, y = lx2, ly2
                                tiles[y][x] = path_terrain
                                table.insert(path, {x, y})
                                on_path[key(x, y)] = true
                                -- Continue one more step in same direction
                                local cx2, cy2 = H.hex_step(x, y, dir2)
                                if cx2 >= 2 and cx2 <= width-1 and cy2 >= 2 and cy2 <= height-1 and not is_water(cx2, cy2) then
                                    tiles[cy2][cx2] = path_terrain
                                    x, y = cx2, cy2
                                    table.insert(path, {x, y})
                                    on_path[key(x, y)] = true
                                end
                                moved = true
                                break
                            end
                        end
                    end
                else
                    -- Check if this is a bridge tile — walk across without overwriting
                    local is_bridge = t:find("^Bw", 1, true) ~= nil
                    if is_bridge then
                        x, y = nx, ny
                        table.insert(path, {x, y})
                        on_path[key(x, y)] = true
                        moved = true
                        break
                    end
                    -- Hex triangle check: count hex neighbors already on path
                    local pn = 0
                    local hn = H.hex_neighbors(nx)
                    for _, off in ipairs(hn) do
                        if on_path[key(nx + off[1], ny + off[2])] then pn = pn + 1 end
                    end
                    if pn > 1 and H.rand(1, 100) > 5 then
                        -- Would create a blob, skip (95% of the time)
                    else
                        x, y = nx, ny
                        if H.rand(1, 100) <= 80 then
                            tiles[y][x] = path_terrain
                        else
                            tiles[y][x] = rough_terrain
                        end
                        table.insert(path, {x, y})
                        on_path[key(x, y)] = true
                        moved = true
                        break
                    end
                end
            end
            -- If nothing worked, force move toward target
            if not moved then
                if math.abs(tx - x) >= math.abs(ty - y) then
                    x = x + (tx > x and 1 or -1)
                else
                    y = y + (ty > y and 1 or -1)
                end
                x = math.max(2, math.min(width-1, x))
                y = math.max(2, math.min(height-1, y))
                table.insert(path, {x, y})
            end
        end
    end

    return path
end

-- Carve a natural river with smooth width transitions
-- Width changes are rare and gradual (see rules in design doc)
function H.carve_river(tiles, width, height, vertical)
    -- Decide width pattern: 45% no change, 35% one change, 20% two changes
    local start_width = H.rand(1, 3)
    local changes = 0
    local roll = H.rand(1, 100)
    if roll <= 45 then changes = 0
    elseif roll <= 80 then changes = 1
    else changes = 2 end

    -- Build width schedule: {from_pos, width}
    local total = vertical and height or width
    local schedule = {{1, start_width}}
    if changes >= 1 then
        local pos1 = H.rand(math.floor(total * 0.3), math.floor(total * 0.5))
        local w1 = math.max(1, start_width + H.rand(-1, 1))
        table.insert(schedule, {pos1, w1})
        if changes >= 2 then
            local pos2 = H.rand(math.floor(total * 0.6), math.floor(total * 0.8))
            local w2 = math.max(1, w1 + H.rand(-1, 1))
            table.insert(schedule, {pos2, w2})
        end
    end

    -- Get width at a given position
    local function get_width(pos)
        local w = schedule[1][2]
        for _, s in ipairs(schedule) do
            if pos >= s[1] then w = s[2] end
        end
        return w
    end

    -- Carve the river
    local center
    if vertical then
        center = H.rand(math.floor(width * 0.3), math.floor(width * 0.7))
        for y = 1, height do
            -- Curve 75%, go straight 25%
            if H.rand(1, 100) <= 75 then
                center = center + (H.rand(1, 2) == 1 and 1 or -1)
            end
            center = math.max(4, math.min(width - 3, center))
            local w = get_width(y)
            local half = math.floor(w / 2)
            for dx = -half, half + (w % 2 == 0 and 0 or 0) do
                local nx = center + dx
                if nx >= 1 and nx <= width then
                    -- Deep water in center of wide rivers (30%)
                    if dx == 0 and w >= 2 and H.rand(1, 100) <= 30 then
                        tiles[y][nx] = "Wo"
                    else
                        tiles[y][nx] = "Ww"
                    end
                end
            end
        end
    else
        center = H.rand(math.floor(height * 0.3), math.floor(height * 0.7))
        for x = 1, width do
            if H.rand(1, 100) <= 75 then
                center = center + (H.rand(1, 2) == 1 and 1 or -1)
            end
            center = math.max(4, math.min(height - 3, center))
            local w = get_width(x)
            local half = math.floor(w / 2)
            for dy = -half, half do
                local ny = center + dy
                if ny >= 1 and ny <= height then
                    if dy == 0 and w >= 2 and H.rand(1, 100) <= 30 then
                        tiles[ny][x] = "Wo"
                    else
                        tiles[ny][x] = "Ww"
                    end
                end
            end
        end
    end
end

-- Thin stream: always 1 tile wide, gentle curves
function H.carve_stream(tiles, width, height, vertical)
    local x, y
    if vertical then
        x = H.rand(6, width - 5)
        y = 1
    else
        x = 1
        y = H.rand(5, height - 4)
    end
    while x >= 1 and x <= width and y >= 1 and y <= height do
        tiles[y][x] = "Ww"
        if vertical then
            y = y + 1
            if H.rand(1, 100) <= 40 then x = x + H.rand(-1, 1) end
            x = math.max(3, math.min(width - 2, x))
        else
            x = x + 1
            if H.rand(1, 100) <= 40 then y = y + H.rand(-1, 1) end
            y = math.max(3, math.min(height - 2, y))
        end
    end
end

-- Rule 2: Fill pass — upgrade remaining base terrain to secondary textures
function H.fill_pass(tiles, width, height, base, fill_terrains, pct)
    pct = pct or 40
    for y = 2, height - 1 do
        for x = 2, width - 1 do
            if tiles[y][x] == base and H.rand(1, 100) <= pct then
                tiles[y][x] = fill_terrains[H.rand(1, #fill_terrains)]
            end
        end
    end
end

-- Rule 3: Irregular dense borders (2-3 hex deep, ~75% coverage)
function H.dense_borders(tiles, width, height, border_terrains, corner_terrain)
    for x = 1, width do
        for y = 1, height do
            local t = tiles[y][x]
            -- Skip water, bridges, farmland, and edge-friendly fixture tiles
            if t == "Ww" or t == "Wo" or t == "Wwf" or t == "Re^Gvs"
               or t == "Gg^Efm" or t == "Gd^Edb" or t == "Gd^Edt"
               or t == "Dd^Edb" or t == "Dd^Es" or t == "Aa^Esa"
               or t == "Mdd" or t == "Ss"
               or (type(t) == "string" and t:find("^Bw", 1, true)) then
                -- leave it
            else
                local dist = math.min(x, y, width + 1 - x, height + 1 - y)
                if dist <= 1 then
                    tiles[y][x] = border_terrains[H.rand(1, #border_terrains)]
                elseif dist == 2 and H.rand(1, 100) <= 75 then
                    tiles[y][x] = border_terrains[H.rand(1, #border_terrains)]
                elseif dist == 3 and H.rand(1, 100) <= 40 then
                    tiles[y][x] = border_terrains[H.rand(1, #border_terrains)]
                end
            end
        end
    end
    -- Heavier corners
    if corner_terrain then
        for _, pos in ipairs({{1,1},{1,height},{width,1},{width,height}}) do
            for dy = 0, 2 do
                for dx = 0, 2 do
                    local cx = pos[1] + (pos[1] == 1 and dx or -dx)
                    local cy = pos[2] + (pos[2] == 1 and dy or -dy)
                    if cx >= 1 and cx <= width and cy >= 1 and cy <= height then
                        local ct = tiles[cy][cx]
                        if ct ~= "Ww" and ct ~= "Wo" and H.rand(1, 100) <= 80 then
                            tiles[cy][cx] = corner_terrain
                        end
                    end
                end
            end
        end
    end
end

-- Rule 4: Terrain blending — place transition terrain around clusters (~75%)
function H.blend_around(tiles, width, height, source_terrain, blend_terrain)
    local coords = {}
    for y = 2, height - 1 do
        for x = 2, width - 1 do
            if tiles[y][x] == source_terrain then
                local nbrs = H.hex_neighbors(x)
                for _, off in ipairs(nbrs) do
                    local nx, ny = x + off[1], y + off[2]
                    if nx >= 1 and nx <= width and ny >= 1 and ny <= height then
                        table.insert(coords, {nx, ny})
                    end
                end
            end
        end
    end
    for _, c in ipairs(coords) do
        local t = tiles[c[2]][c[1]]
        -- Only blend onto base-ish terrain, not features
        if (t == "Gg" or t == "Gd" or t == "Gs" or t == "Aa" or t == "Uu" or t == "Ds" or t == "Hh")
           and H.rand(1, 100) <= 75 then
            tiles[c[2]][c[1]] = blend_terrain
        end
    end
end

-- Rule 6: Fix any remaining water tiles on path that carve_path missed
function H.place_bridges(tiles, width, height, path)
    -- Bridges now handled by carve_path directly
end

-- Scatter single castle/ruin tiles across the map
function H.maybe_scatter_ruins(tiles, width, height, valid_terrains, chance)
    chance = chance or 25
    if H.rand(1, 100) > chance then return end
    local ruin_types = {"Cer", "Chr", "Cdr", "Chw", "Chs", "Cvr", "Ch", "Ce"}
    for _ = 1, H.rand(2, 7) do
        local rx, ry = H.rand(3, width - 2), H.rand(3, height - 2)
        local t = tiles[ry][rx]
        for _, vt in ipairs(valid_terrains) do
            if t == vt then
                tiles[ry][rx] = ruin_types[H.rand(1, #ruin_types)]
                break
            end
        end
    end
end

-- Rule 6: Scatter special items/ruins
function H.scatter_specials(tiles, width, height, specials, valid_terrains, count)
    local placed = 0
    local attempts = 0
    while placed < count and attempts < 200 do
        local x, y = H.rand(3, width - 2), H.rand(3, height - 2)
        local t = tiles[y][x]
        for _, vt in ipairs(valid_terrains) do
            if t == vt then
                tiles[y][x] = specials[H.rand(1, #specials)]
                placed = placed + 1
                break
            end
        end
        attempts = attempts + 1
    end
end

-- Rule 7: Place castles — horizontal (left/right) or vertical (top/bottom)
-- MUST be called LAST
function H.place_castles(tiles, width, height, base, keep_types, castle_types, vertical)
    local p1x, p1y, p2x, p2y
    if vertical then
        p1x = H.rand(5, width - 4)
        p1y = 4
        p2x = H.rand(5, width - 4)
        p2y = height - 3
    else
        p1x = 4
        p1y = H.rand(5, height - 4)
        p2x = width - 3
        p2y = H.rand(5, height - 4)
    end

    local keep1 = keep_types[H.rand(1, #keep_types)]
    local castle1 = castle_types[H.rand(1, #castle_types)]
    local keep2 = keep_types[H.rand(1, #keep_types)]
    local castle2 = castle_types[H.rand(1, #castle_types)]

    -- 15% chance each side gets a ruined castle variant
    if H.rand(1, 100) <= 15 then keep1 = "Khr"; castle1 = "Chr" end
    if H.rand(1, 100) <= 15 then keep2 = "Khr"; castle2 = "Chr" end

    -- Clear safe zones (skip water and bridges)
    for _, pos in ipairs({{p1x, p1y}, {p2x, p2y}}) do
        for dy = -2, 2 do
            for dx = -2, 2 do
                local x, y = pos[1] + dx, pos[2] + dy
                if x >= 1 and x <= width and y >= 1 and y <= height then
                    local t = tiles[y][x]
                    if t ~= "Ww" and t ~= "Wo" and not (type(t) == "string" and t:find("^Bw", 1, true)) then
                        tiles[y][x] = base
                    end
                end
            end
        end
    end

    -- Place keep + surrounding castle tiles
    local function place_one(kx, ky, keep, castle)
        tiles[ky][kx] = keep
        local nbrs = H.hex_neighbors(kx)
        local max_ct = H.rand(5, 6)
        local count = 0
        -- Always start from hex neighbors of keep
        -- Shuffle which neighbors we use for variety
        local order = {1,2,3,4,5,6}
        for i = 6, 2, -1 do
            local j = H.rand(1, i)
            order[i], order[j] = order[j], order[i]
        end
        -- Place castle tiles on shuffled neighbors, skip 0-1
        local skip_count = H.rand(0, 1)
        local skipped = 0
        for _, idx in ipairs(order) do
            if count >= max_ct then break end
            if skipped < skip_count then
                skipped = skipped + 1
            else
                local off = nbrs[idx]
                local cx, cy = kx + off[1], ky + off[2]
                if cx >= 2 and cx <= width-1 and cy >= 2 and cy <= height-1 then
                    tiles[cy][cx] = castle
                    count = count + 1
                end
            end
        end
    end

    place_one(p1x, p1y, keep1, castle1)
    place_one(p2x, p2y, keep2, castle2)

    -- Validate: each keep must have 4-6 adjacent castle tiles
    -- If not, fill in missing neighbors
    for _, pos in ipairs({{p1x, p1y, castle1}, {p2x, p2y, castle2}}) do
        local kx, ky, ct = pos[1], pos[2], pos[3]
        local nbrs = H.hex_neighbors(kx)
        local castle_count = 0
        for _, off in ipairs(nbrs) do
            local nx, ny = kx + off[1], ky + off[2]
            if nx >= 1 and nx <= width and ny >= 1 and ny <= height then
                local t = tiles[ny][nx]
                if t:sub(1, 1) == "C" then castle_count = castle_count + 1 end
            end
        end
        if castle_count < 4 then
            -- Fill hex neighbors until we have at least 5
            for _, off in ipairs(nbrs) do
                if castle_count >= 5 then break end
                local nx, ny = kx + off[1], ky + off[2]
                if nx >= 1 and nx <= width and ny >= 1 and ny <= height then
                    local t = tiles[ny][nx]
                    if t:sub(1, 1) ~= "C" and t:sub(1, 1) ~= "K" then
                        tiles[ny][nx] = ct
                        castle_count = castle_count + 1
                    end
                end
            end
        end
    end

    return p1x, p1y, p2x, p2y
end

-- Rule 7: Scatter varied village types
function H.scatter_villages(tiles, width, height, village_types, valid_terrains, count)
    local placed = 0
    local attempts = 0
    local mid = math.floor(width / 2)
    local left_count, right_count = 0, 0

    while placed < count and attempts < 300 do
        local vx
        if left_count > right_count + 1 then
            vx = H.rand(mid + 1, width - 2)
        elseif right_count > left_count + 1 then
            vx = H.rand(3, mid)
        else
            vx = H.rand(3, width - 2)
        end
        local vy = H.rand(3, height - 2)
        local t = tiles[vy][vx]
        local valid = false
        for _, vt in ipairs(valid_terrains) do
            if t == vt then valid = true; break end
        end
        if valid then
            tiles[vy][vx] = village_types[H.rand(1, #village_types)]
            placed = placed + 1
            if vx <= mid then left_count = left_count + 1
            else right_count = right_count + 1 end
        end
        attempts = attempts + 1
    end

    -- Contested center village
    local cy = H.rand(math.floor(height/2) - 1, math.floor(height/2) + 1)
    local cx = H.rand(math.floor(width/2) - 2, math.floor(width/2) + 2)
    if cx >= 1 and cx <= width and cy >= 1 and cy <= height then
        tiles[cy][cx] = village_types[H.rand(1, #village_types)]
    end
end


-- ============================================================
-- FIXTURE SYSTEM — reusable terrain features for any biome
-- Each fixture is a function that stamps a small feature onto the map.
-- Generators call H.maybe_fixture(tiles, W, HT, "fixture_name", chance%)
-- ============================================================

function H.maybe_fixture(tiles, width, height, name, chance)
    if H.rand(1, 100) > chance then return end

    -- Pick a random spot — margin depends on fixture type
    local edge_ok = {farmland_patch=true, flower_field=true, dead_grove=true,
        bone_pile=true, desert_bones=true, snow_drift=true, rocky_ridge=true,
        swamp_patch=true, pond=true}
    local fx, fy
    if edge_ok[name] then
        fx = H.rand(2, width - 1)
        fy = H.rand(2, height - 1)
    else
        fx = H.rand(5, width - 4)
        fy = H.rand(3, height - 2)
    end

    if name == "lone_mountain" then
        -- Mountain peak with surrounding hills (hex)
        tiles[fy][fx] = "Mm"
        H.for_each_neighbor(fx, fy, width, height, function(nx, ny)
            if H.rand(1,100) > 30 then
                tiles[ny][nx] = H.rand(1,3) == 1 and "Mm" or "Hh"
            end
        end)

    elseif name == "pond" then
        H.place_cluster(tiles, width, height, fx, fy, "Ww", 1)
        -- Reeds/lilies around it
        H.for_each_neighbor(fx, fy, width, height, function(nx, ny)
            if tiles[ny][nx] ~= "Ww" and H.rand(1,100) > 70 then
                tiles[ny][nx] = "Ss"
            end
        end)

    elseif name == "lake" then
        H.place_cluster(tiles, width, height, fx, fy, "Ww", H.rand(2, 3))
        -- Stream flowing out
        local sx = fx
        for y = fy+1, math.min(height-2, fy + H.rand(3, 6)) do
            if H.rand(1,3) == 1 then sx = sx + H.rand(-1,1) end
            sx = math.max(3, math.min(width-2, sx))
            tiles[y][sx] = "Ww"
        end

    elseif name == "stream" then
        H.carve_river(tiles, width, height, true)

    elseif name == "river_horizontal" then
        H.carve_river(tiles, width, height, false)

    elseif name == "mushroom_grove" then
        H.place_cluster(tiles, width, height, fx, fy, "Gg^Em", 2)
        tiles[fy][fx] = "Gg^Efm"

    elseif name == "farmland_patch" then
        -- Pre-check: find a spot where the full rectangle fits on clear ground
        local col_dir = ({2, 3})[H.rand(1, 2)]
        local row_dir = (col_dir == 2) and 4 or 1
        local cols = H.rand(2, 3)
        local rows = H.rand(2, 3)
        -- Collect all candidate positions
        local cells = {}
        local sx, sy = fx, fy
        local ok = true
        for r = 1, rows do
            local cx, cy = sx, sy
            for c = 1, cols do
                if cx < 1 or cx > width or cy < 1 or cy > height then ok = false; break end
                local t = tiles[cy][cx]
                local f = t:sub(1,1)
                if f == "K" or f == "C" or t == "Rr" or t == "Rp" or t == "Ww" or t == "Wo" or t == "Xu" or t == "Re^Gvs" then
                    ok = false; break
                end
                table.insert(cells, {cx, cy})
                cx, cy = H.hex_step(cx, cy, col_dir)
            end
            if not ok then break end
            sx, sy = H.hex_step(sx, sy, row_dir)
        end
        -- Only place if every cell was clear
        if ok and #cells == cols * rows then
            for _, cell in ipairs(cells) do
                tiles[cell[2]][cell[1]] = "Re^Gvs"
            end
        end

    elseif name == "ruins" then
        local size = H.rand(1, 3)
        if size == 1 then
            -- Small: 2-3 scattered ruin tiles with dirt between
            tiles[fy][fx] = "Chr"
            for _ = 1, H.rand(1, 2) do
                local nx, ny = H.hex_step(fx, fy, H.rand(1, 6))
                if nx >= 1 and nx <= width and ny >= 1 and ny <= height then
                    tiles[ny][nx] = "Cer"
                end
            end
        elseif size == 2 then
            -- Medium: keep ruin + 2-3 scattered castle tiles with road/dirt gaps
            tiles[fy][fx] = "Khr"
            local placed = 0
            for _ = 1, 8 do
                if placed >= 3 then break end
                local dir = H.rand(1, 6)
                local nx, ny = H.hex_step(fx, fy, dir)
                -- Sometimes skip one hex for a gap
                if H.rand(1, 2) == 1 then nx, ny = H.hex_step(nx, ny, dir) end
                if nx >= 2 and nx <= width-1 and ny >= 2 and ny <= height-1 then
                    if tiles[ny][nx] ~= "Khr" and tiles[ny][nx] ~= "Chr" then
                        tiles[ny][nx] = (H.rand(1,2)==1) and "Chr" or "Cer"
                        placed = placed + 1
                    end
                end
            end
            -- Dirt/road between pieces
            H.for_each_neighbor(fx, fy, width, height, function(nx, ny)
                if tiles[ny][nx] ~= "Khr" and tiles[ny][nx] ~= "Chr" and tiles[ny][nx] ~= "Cer" then
                    if H.rand(1,100) > 60 then tiles[ny][nx] = "Gd" end
                end
            end)
        else
            -- Large: scattered ruin tiles in a loose area, connected by dirt
            tiles[fy][fx] = "Khr"
            local cx, cy = fx, fy
            for _ = 1, H.rand(4, 6) do
                local dir = H.rand(1, 6)
                cx, cy = H.hex_step(cx, cy, dir)
                if cx >= 2 and cx <= width-1 and cy >= 2 and cy <= height-1 then
                    local r = H.rand(1, 100)
                    if r > 50 then tiles[cy][cx] = (H.rand(1,2)==1) and "Chr" or "Cer"
                    elseif r > 20 then tiles[cy][cx] = "Gd"
                    end
                end
            end
        end
        -- Scatter single ruin tiles nearby
        for _ = 1, H.rand(1, 3) do
            local sx, sy = fx + H.rand(-4, 4), fy + H.rand(-3, 3)
            if sx>=1 and sx<=width and sy>=1 and sy<=height then
                local t = tiles[sy][sx]
                if t:sub(1,1) ~= "K" and t:sub(1,1) ~= "C" and t ~= "Ww" and t ~= "Xu" then
                    tiles[sy][sx] = "Cer"
                end
            end
        end

    elseif name == "campfire" then
        tiles[fy][fx] = "Gd^Ecf"
        H.for_each_neighbor(fx, fy, width, height, function(nx, ny)
            if H.rand(1,100) > 50 then tiles[ny][nx] = "Gd" end
        end)

    elseif name == "swamp_patch" then
        H.place_cluster(tiles, width, height, fx, fy, "Ss", H.rand(2, 3))
        -- Small water in center
        tiles[fy][fx] = "Ww"

    elseif name == "cave_lake" then
        H.place_cluster(tiles, width, height, fx, fy, "Ww", H.rand(1, 2))

    elseif name == "cave_chasm" then
        H.place_cluster(tiles, width, height, fx, fy, "Qxu", 1)

    elseif name == "cave_mushrooms" then
        H.place_cluster(tiles, width, height, fx, fy, "Uu^Tf", H.rand(2, 3))
        tiles[fy][fx] = "Gg^Ii"
        -- Scatter 1-3 more sunbeams nearby
        local cx, cy = fx, fy
        for _ = 1, H.rand(1, 3) do
            cx, cy = H.hex_step(cx, cy, H.rand(1, 6))
            if cx >= 2 and cx <= width-1 and cy >= 2 and cy <= height-1 then
                tiles[cy][cx] = "Gg^Ii"
            end
        end

    elseif name == "oasis" then
        H.place_cluster(tiles, width, height, fx, fy, "Gg", 2)
        tiles[fy][fx] = "Ww"
        H.for_each_neighbor(fx, fy, width, height, function(nx, ny)
            if tiles[ny][nx] == "Gg" and H.rand(1,2) == 1 then
                tiles[ny][nx] = "Dd^Ftd"
            end
        end)

    elseif name == "great_tree" then
        tiles[fy][fx] = "Gg^Fet"
        -- Surrounding forest
        H.for_each_neighbor(fx, fy, width, height, function(nx, ny)
            if H.rand(1,100) > 40 then tiles[ny][nx] = "Gs^Fp" end
        end)

    elseif name == "sunlit_clearing" then
        -- Grass patch with multiple sunbeams (important for lawful units)
        H.place_cluster(tiles, width, height, fx, fy, "Gg", H.rand(2, 3))
        tiles[fy][fx] = "Gg^Ii"
        -- Scatter 1-5 more sunbeam tiles on hex neighbors and beyond
        local beams = H.rand(1, 5)
        local cx, cy = fx, fy
        for _ = 1, beams do
            local dir = H.rand(1, 6)
            cx, cy = H.hex_step(cx, cy, dir)
            if cx >= 2 and cx <= width-1 and cy >= 2 and cy <= height-1 then
                tiles[cy][cx] = "Gg^Ii"
            end
        end
        -- Flowers around the clearing
        H.for_each_neighbor(fx, fy, width, height, function(nx, ny)
            if tiles[ny][nx] == "Gg" and H.rand(1,3) == 1 then
                tiles[ny][nx] = "Gg^Efm"
            end
        end)

    elseif name == "stone_circle" then
        -- Standing stones in a hex ring
        local nbrs = H.hex_neighbors(fx)
        for _, off in ipairs(nbrs) do
            local nx, ny = fx + off[1], fy + off[2]
            if nx >= 1 and nx <= width and ny >= 1 and ny <= height then
                if H.rand(1, 100) > 25 then tiles[ny][nx] = "Gd^Edt" end
            end
        end
        tiles[fy][fx] = "Gd^Ecf"

    elseif name == "watchtower" then
        tiles[fy][fx] = "Hh^Vhh"
        H.for_each_neighbor(fx, fy, width, height, function(nx, ny)
            if H.rand(1, 100) > 50 then tiles[ny][nx] = "Hh" end
        end)

    elseif name == "graveyard" then
        -- Tombstones and dead trees
        tiles[fy][fx] = "Gd^Es"
        H.for_each_neighbor(fx, fy, width, height, function(nx, ny)
            local r = H.rand(1, 100)
            if r > 70 then tiles[ny][nx] = "Gd^Es"
            elseif r > 50 then tiles[ny][nx] = "Gd"
            end
        end)

    elseif name == "ancient_temple" then
        -- Stone pillars in a hex pattern (caves)
        tiles[fy][fx] = "Isr^Ebn"
        local nbrs = H.hex_neighbors(fx)
        for i, off in ipairs(nbrs) do
            local nx, ny = fx + off[1], fy + off[2]
            if nx >= 1 and nx <= width and ny >= 1 and ny <= height then
                if i % 2 == 0 then
                    tiles[ny][nx] = "Xos"
                else
                    tiles[ny][nx] = "Isr"
                end
            end
        end

    elseif name == "lava_vent" then
        tiles[fy][fx] = "Ql"
        H.for_each_neighbor(fx, fy, width, height, function(nx, ny)
            local r = H.rand(1, 100)
            if r > 60 then tiles[ny][nx] = "Qlf"
            elseif r > 30 then tiles[ny][nx] = "Urb"
            end
        end)

    elseif name == "frozen_lake" then
        H.place_cluster(tiles, width, height, fx, fy, "Ai", H.rand(2, 3))
        H.for_each_neighbor(fx, fy, width, height, function(nx, ny)
            if tiles[ny][nx] ~= "Ai" and H.rand(1, 100) > 50 then
                tiles[ny][nx] = "Ha"
            end
        end)

    elseif name == "bandit_camp" then
        tiles[fy][fx] = "Gd^Ecf"
        H.for_each_neighbor(fx, fy, width, height, function(nx, ny)
            tiles[ny][nx] = "Gd"
        end)

    elseif name == "fairy_ring" then
        -- Mushrooms in a hex ring around flowers
        tiles[fy][fx] = "Gg^Efm"
        H.for_each_neighbor(fx, fy, width, height, function(nx, ny)
            if H.rand(1, 100) > 30 then tiles[ny][nx] = "Gg^Em" end
        end)

    elseif name == "island" then
        H.place_cluster(tiles, width, height, fx, fy, "Ww", 2)
        tiles[fy][fx] = "Gg"
        if H.rand(1,2) == 1 then
            local nx, ny = H.hex_step(fx, fy, H.rand(1,6))
            if nx >= 1 and nx <= width and ny >= 1 and ny <= height then tiles[ny][nx] = "Gg" end
        end
        H.for_each_neighbor(fx, fy, width, height, function(nx, ny)
            if tiles[ny][nx] == "Ww" and H.rand(1,100) > 75 then tiles[ny][nx] = "Ww^Vm" end
        end)

    elseif name == "pit" then
        tiles[fy][fx] = "Qxu"

    elseif name == "mountain_lake" then
        tiles[fy][fx] = "Wo"
        local nbrs = H.hex_neighbors(fx)
        for _, d in ipairs({1,2,6}) do
            local nx, ny = fx + nbrs[d][1], fy + nbrs[d][2]
            if nx >= 1 and nx <= width and ny >= 1 and ny <= height then tiles[ny][nx] = "Mm" end
        end
        for _, d in ipairs({3,4,5}) do
            local nx, ny = fx + nbrs[d][1], fy + nbrs[d][2]
            if nx >= 1 and nx <= width and ny >= 1 and ny <= height then tiles[ny][nx] = "Ww" end
        end

    elseif name == "desert_patch" then
        H.place_cluster(tiles, width, height, fx, fy, "Dd", H.rand(1,2))
        local r = H.rand(1,3)
        if r == 1 then
            tiles[fy][fx] = "Ww"
            H.for_each_neighbor(fx, fy, width, height, function(nx, ny)
                if tiles[ny][nx] == "Dd" and H.rand(1,2) == 1 then tiles[ny][nx] = "Dd^Ftd" end
            end)
        elseif r == 2 then tiles[fy][fx] = "Dd^Vda"
        else tiles[fy][fx] = "Dd^Ftd"
        end

    elseif name == "signpost" then
        tiles[fy][fx] = "Rr^Es"
        local nx, ny = H.hex_step(fx, fy, H.rand(1,6))
        if nx >= 1 and nx <= width and ny >= 1 and ny <= height then tiles[ny][nx] = "Rr" end

    elseif name == "flower_field" then
        tiles[fy][fx] = "Gg^Efm"
        H.for_each_neighbor(fx, fy, width, height, function(nx, ny)
            if H.rand(1,100) > 30 then tiles[ny][nx] = "Gg^Efm" end
        end)

    elseif name == "dead_grove" then
        tiles[fy][fx] = "Gd^Edt"
        H.for_each_neighbor(fx, fy, width, height, function(nx, ny)
            local r2 = H.rand(1,100)
            if r2 > 60 then tiles[ny][nx] = "Gd^Edt"
            elseif r2 > 40 then tiles[ny][nx] = "Gd^Edb" end
        end)

    elseif name == "windmill" then
        tiles[fy][fx] = "Gg^Wm"
        H.for_each_neighbor(fx, fy, width, height, function(nx, ny)
            if H.rand(1,100) > 50 then tiles[ny][nx] = "Re^Gvs" end
        end)

    elseif name == "volcano" then
        tiles[fy][fx] = "Mv^Xo"
        H.for_each_neighbor(fx, fy, width, height, function(nx, ny)
            local r2 = H.rand(1,100)
            if r2 > 60 then tiles[ny][nx] = "Mm"
            elseif r2 > 30 then tiles[ny][nx] = "Hh" end
        end)

    elseif name == "bone_pile" then
        tiles[fy][fx] = "Gd^Edb"
        H.for_each_neighbor(fx, fy, width, height, function(nx, ny)
            if H.rand(1,100) > 65 then tiles[ny][nx] = "Gd^Edb" end
        end)

    elseif name == "cave_spring" then
        tiles[fy][fx] = "Ww"
        H.for_each_neighbor(fx, fy, width, height, function(nx, ny)
            if H.rand(1,100) > 70 then tiles[ny][nx] = "Uu^Tf" end
        end)

    elseif name == "snow_drift" then
        H.place_cluster(tiles, width, height, fx, fy, "Aa^Esa", H.rand(1,2))

    elseif name == "ice_pillars" then
        local nbrs = H.hex_neighbors(fx)
        for i, off in ipairs(nbrs) do
            if i % 2 == 0 then
                local nx, ny = fx + off[1], fy + off[2]
                if nx >= 1 and nx <= width and ny >= 1 and ny <= height then tiles[ny][nx] = "Ms" end
            end
        end
        tiles[fy][fx] = "Ai"

    elseif name == "desert_bones" then
        tiles[fy][fx] = "Dd^Edb"
        H.for_each_neighbor(fx, fy, width, height, function(nx, ny)
            local r2 = H.rand(1,100)
            if r2 > 70 then tiles[ny][nx] = "Dd^Edb"
            elseif r2 > 50 then tiles[ny][nx] = "Dd^Es" end
        end)

    elseif name == "rocky_ridge" then
        local dir = H.rand(1, 6)
        local cx, cy = fx, fy
        -- Detect biome for appropriate hill type
        local hill = "Hh"
        H.for_each_neighbor(fx, fy, width, height, function(nx, ny)
            local t = tiles[ny][nx]
            if t == "Dd" or t == "Ds" or t == "Hd" then hill = "Hd"
            elseif t == "Aa" or t == "Ha" then hill = "Ha"
            elseif t == "Uu" or t == "Ur" or t == "Uue" then hill = "Uh"
            end
        end)
        for _ = 1, H.rand(3, 5) do
            if cx >= 2 and cx <= width-1 and cy >= 2 and cy <= height-1 then
                tiles[cy][cx] = H.rand(1,3) == 1 and "Mdd" or hill
            end
            cx, cy = H.hex_step(cx, cy, dir)
        end

    elseif name == "swamp_hut" then
        tiles[fy][fx] = "Ss^Vhs"
        H.for_each_neighbor(fx, fy, width, height, function(nx, ny)
            if H.rand(1,100) > 50 then tiles[ny][nx] = "Ss" end
        end)

    elseif name == "forest_shrine" then
        tiles[fy][fx] = "Gg^Edt"
        H.for_each_neighbor(fx, fy, width, height, function(nx, ny)
            local r2 = H.rand(1,100)
            if r2 > 60 then tiles[ny][nx] = "Gs^Fp"
            elseif r2 > 40 then tiles[ny][nx] = "Gg^Efm" end
        end)

    elseif name == "hill_fort" then
        tiles[fy][fx] = "Hh^Vhh"
        H.for_each_neighbor(fx, fy, width, height, function(nx, ny)
            if H.rand(1,100) > 40 then tiles[ny][nx] = "Hh" end
        end)

    elseif name == "water_lilies" then
        H.for_each_neighbor(fx, fy, width, height, function(nx, ny)
            if tiles[ny][nx] == "Ww" and H.rand(1,100) > 50 then tiles[ny][nx] = "Ww^Ewl" end
        end)
        if tiles[fy][fx] == "Ww" then tiles[fy][fx] = "Ww^Ewf" end

    elseif name == "brazier_circle" then
        local nbrs = H.hex_neighbors(fx)
        for i, off in ipairs(nbrs) do
            local nx, ny = fx + off[1], fy + off[2]
            if nx >= 1 and nx <= width and ny >= 1 and ny <= height then
                if i % 2 == 1 then tiles[ny][nx] = "Ur^Ebn"
                else tiles[ny][nx] = "Ur" end
            end
        end
        tiles[fy][fx] = "Ur^Ecf"
    end
end

function H.build_map_string(tiles, width, height, p1x, p1y, p2x, p2y)
    local rows = {}
    for y = 1, height do
        local row = {}
        for x = 1, width do
            local t = tiles[y][x]
            if x == p1x and y == p1y then
                t = "1 " .. t
            elseif x == p2x and y == p2y then
                t = "2 " .. t
            end
            row[x] = t
        end
        rows[y] = table.concat(row, ", ")
    end
    return table.concat(rows, "\n")
end

return H
