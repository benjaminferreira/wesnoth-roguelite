-- lua/trait_utils.lua
-- Applies random traits to leaders. The engine skips leaders (canrecruit=yes)
-- for MP OOS prevention, so we replicate the logic here.
local TU = {}

function TU.apply_random_traits(unit)
    local ut = wesnoth.unit_types[unit.type]
    if not ut then return end
    local race = wesnoth.races[ut.race]
    if not race then return end

    local num = race.num_traits or 2
    if num == 0 then return end

    -- race.traits is string-keyed in 1.18, use pairs not ipairs
    local available = {}
    if race.traits then
        for id, trait in pairs(race.traits) do
            local cfg = trait.__cfg or (type(trait) == "table" and trait) or nil
            if cfg then table.insert(available, cfg) end
        end
    end
    if #available == 0 then return end

    -- Check existing traits
    local existing = {}
    local mods = wml.get_child(unit.__cfg, "modifications")
    if mods then
        for trait in wml.child_range(mods, "trait") do
            existing[trait.id] = true
        end
    end

    local filled = 0
    for _ in pairs(existing) do filled = filled + 1 end

    -- Pick random traits for remaining slots
    for i = filled + 1, num do
        local pool = {}
        for _, t in ipairs(available) do
            if not existing[t.id] then
                table.insert(pool, t)
            end
        end
        if #pool == 0 then break end
        local pick = pool[wesnoth.random(1, #pool)]
        unit:add_modification("trait", pick)
        existing[pick.id] = true
    end
end

return TU
