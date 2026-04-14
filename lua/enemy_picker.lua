-- enemy_picker.lua — Picks enemy faction, leader, and recruit list
-- Based on biome weights, battle number, and defeated leader tracking

local H = wesnoth.dofile("~add-ons/Wesnoth_Roguelite/lua/mapgen_helpers.lua")
local EP = {}

-- Biome → faction weights (from design config)
EP.biome_weights = {
    plains       = {loyalists=5, rebels=3, northerners=4, undead=2, drakes=2, knalgan=4},
    forest       = {loyalists=3, rebels=4, northerners=4, undead=2, drakes=3, knalgan=3},
    elven_forest = {loyalists=2, rebels=5, northerners=2, undead=3, drakes=1, knalgan=2},
    desert       = {loyalists=1, rebels=1, northerners=4, undead=3, drakes=4, knalgan=1},
    swamp        = {loyalists=1, rebels=1, northerners=3, undead=5, drakes=4, knalgan=1},
    winter       = {loyalists=4, rebels=4, northerners=4, undead=4, drakes=1, knalgan=4},
    mountain     = {loyalists=2, rebels=1, northerners=4, undead=2, drakes=3, knalgan=4},
    farmland     = {loyalists=5, rebels=1, northerners=3, undead=2, drakes=2, knalgan=2},
    valley       = {loyalists=3, rebels=3, northerners=3, undead=2, drakes=2, knalgan=3},
    cave         = {loyalists=1, rebels=1, northerners=3, undead=4, drakes=2, knalgan=4},
    lava         = {loyalists=1, rebels=1, northerners=1, undead=2, drakes=5, knalgan=2},
    mushroom     = {loyalists=1, rebels=5, northerners=1, undead=3, drakes=4, knalgan=2},
    coastal      = {loyalists=3, rebels=1, northerners=3, undead=2, drakes=4, knalgan=1},
}

-- Faction recruit pools by tier
EP.recruits = {
    loyalists = {
        core   = {"Spearman","Bowman","Cavalryman","Fencer","Merman Fighter","Heavy Infantryman","Mage","Horseman","Sergeant"},
        extra  = {"Peasant"},
        l2     = {"Swordsman","Pikeman","Longbowman","Knight","White Mage","Red Mage","Dragoon","Duelist","Shock Trooper","Lieutenant","Lancer","Javelineer","Merman Warrior"},
    },
    rebels = {
        core   = {"Elvish Fighter","Elvish Archer","Elvish Shaman","Elvish Scout","Wose","Merman Hunter","Mage"},
        extra  = {},
        l2     = {"Elvish Captain","Elvish Hero","Elvish Ranger","Elvish Marksman","Elvish Druid","Elvish Sorceress","Elvish Rider","Elder Wose","White Mage","Red Mage","Merman Spearman","Merman Netcaster"},
    },
    northerners = {
        core   = {"Orcish Grunt","Orcish Archer","Wolf Rider","Orcish Assassin","Troll Whelp","Naga Fighter","Goblin Spearman"},
        extra  = {"Goblin Impaler","Goblin Rouser"},
        l2     = {"Orcish Warrior","Orcish Crossbowman","Orcish Slayer","Troll","Troll Rocklobber","Goblin Knight","Goblin Pillager","Naga Warrior"},
    },
    undead = {
        core   = {"Skeleton","Skeleton Archer","Walking Corpse","Ghost","Vampire Bat","Dark Adept","Ghoul"},
        extra  = {"Skeleton Rider","Blood Bat"},
        l2     = {"Revenant","Deathblade","Bone Shooter","Dark Sorcerer","Necrophage","Wraith","Shadow","Bone Knight","Dread Bat"},
    },
    drakes = {
        core   = {"Drake Fighter","Drake Clasher","Drake Burner","Drake Glider","Saurian Skirmisher","Saurian Augur"},
        extra  = {},
        l2     = {"Drake Warrior","Drake Thrasher","Drake Arbiter","Fire Drake","Drake Flare","Sky Drake","Saurian Ambusher","Saurian Oracle","Saurian Soothsayer"},
    },
    knalgan = {
        core   = {"Dwarvish Fighter","Dwarvish Thunderer","Dwarvish Guardsman","Dwarvish Ulfserker","Thief","Poacher","Footpad","Gryphon Rider"},
        extra  = {},
        l2     = {"Dwarvish Steelclad","Dwarvish Thunderguard","Dwarvish Stalwart","Dwarvish Berserker","Rogue","Trapper","Outlaw","Gryphon Master","Bandit"},
    },
}

-- Named leaders per faction (unique characters — once killed, gone for the run)
-- L2 leaders for battles 1-9, L3 leaders for battles 11-14
EP.leaders = {
    loyalists = {
        l2 = {
            {type="Lieutenant",     name="Caradoc"},
            {type="Swordsman",      name="Owain"},
            {type="Pikeman",        name="Gwynnyn"},
            {type="Javelineer",     name="Addraer"},
            {type="Shock Trooper",  name="Blacyn"},
            {type="Longbowman",     name="Taercyn"},
            {type="White Mage",     name="Aethercyn"},
            {type="Red Mage",       name="Saercyn"},
        },
        l3 = {
            {type="General",        name="Haldar"},
            {type="Paladin",        name="Gweddyn"},
            {type="Grand Knight",   name="Rhaercyn"},
            {type="Arch Mage",      name="Dacyn"},
            {type="Master Bowman",  name="Glynvan"},
            {type="Iron Mauler",    name="Bladoc"},
            {type="Royal Guard",    name="Aethaercyn"},
        },
    },
    rebels = {
        l2 = {
            {type="Elvish Captain",   name="Faelindor"},
            {type="Elvish Hero",      name="Eäradrier"},
            {type="Elvish Ranger",    name="Celórion"},
            {type="Elvish Marksman",  name="Legéril"},
            {type="Elvish Druid",     name="Lómithrawien"},
            {type="Elvish Sorceress", name="Celarandra"},
            {type="Elder Wose",       name="Oakenroot"},
        },
        l3 = {
            {type="Elvish Marshal",      name="Galándel"},
            {type="Elvish Champion",     name="Tinorfiriand"},
            {type="Elvish Avenger",      name="Isithral"},
            {type="Elvish Shyde",        name="Eärithrawien"},
            {type="Elvish Enchantress",  name="Lómébrilindë"},
            {type="Ancient Wose",        name="Thornfather"},
        },
    },
    northerners = {
        l2 = {
            {type="Orcish Warrior",     name="Grak"},
            {type="Orcish Crossbowman", name="Bolg"},
            {type="Orcish Slayer",      name="Razik"},
            {type="Troll",              name="Grumsh"},
            {type="Troll Rocklobber",   name="Thudgut"},
        },
        l3 = {
            {type="Orcish Warlord",    name="Morgash"},
            {type="Orcish Nightblade", name="Vashka"},
            {type="Troll Warrior",     name="Krug"},
            {type="Great Troll",       name="Bogdush"},
            {type="Direwolf Rider",    name="Bashnark"},
            {type="Naga Myrmidon",     name="Ssithrak"},
        },
    },
    undead = {
        l2 = {
            {type="Dark Sorcerer",  name="Malachar"},
            {type="Revenant",       name="Aldous"},
            {type="Deathblade",     name="Kael"},
            {type="Bone Shooter",   name="Rattlebone"},
            {type="Necrophage",     name="Gorewail"},
        },
        l3 = {
            {type="Lich",         name="Veranthos"},
            {type="Necromancer",  name="Ardonna"},
            {type="Draug",        name="Mortic"},
            {type="Death Knight", name="Antrasis"},
            {type="Spectre",      name="Absu"},
            {type="Nightgaunt",   name="Addogin"},
        },
    },
    drakes = {
        l2 = {
            {type="Drake Warrior",  name="Varkhan"},
            {type="Drake Flare",    name="Pyraxis"},
            {type="Fire Drake",     name="Garushi"},
            {type="Drake Arbiter",  name="Kethran"},
            {type="Drake Thrasher", name="Grelnit"},
            {type="Saurian Oracle", name="Ssizer"},
        },
        l3 = {
            {type="Drake Blademaster", name="Draxxus"},
            {type="Drake Flameheart",  name="Morusté"},
            {type="Drake Enforcer",    name="Gridda"},
            {type="Inferno Drake",     name="Gashinar"},
            {type="Hurricane Drake",   name="Velnick"},
            {type="Drake Warden",      name="Veralon"},
        },
    },
    knalgan = {
        l2 = {
            {type="Dwarvish Steelclad",   name="Dulaithsol"},
            {type="Dwarvish Thunderguard", name="Aigcatsil"},
            {type="Dwarvish Stalwart",     name="Glamduras"},
            {type="Rogue",                 name="Blydd"},
            {type="Trapper",               name="Gwilam"},
        },
        l3 = {
            {type="Dwarvish Lord",        name="Pelaithas"},
            {type="Dwarvish Dragonguard", name="Trithduring"},
            {type="Dwarvish Sentinel",    name="Glamthaus"},
            {type="Assassin",             name="Cyryn"},
            {type="Fugitive",             name="Gwyrcyn"},
        },
    },
}

-- Leader type → lowest L1 recruit in that unit's advancement line
EP.leader_base = {
    Lieutenant="Sergeant", Swordsman="Spearman", Pikeman="Spearman", Javelineer="Spearman",
    ["Shock Trooper"]="Heavy Infantryman", Longbowman="Bowman", ["White Mage"]="Mage", ["Red Mage"]="Mage",
    General="Sergeant", ["Royal Guard"]="Spearman", Paladin="Horseman", ["Grand Knight"]="Horseman",
    ["Arch Mage"]="Mage", ["Master Bowman"]="Bowman", ["Iron Mauler"]="Heavy Infantryman",
    Cavalier="Cavalryman", Dragoon="Cavalryman", Knight="Horseman", Lancer="Horseman",
    ["Elvish Captain"]="Elvish Fighter", ["Elvish Hero"]="Elvish Fighter",
    ["Elvish Ranger"]="Elvish Archer", ["Elvish Marksman"]="Elvish Archer",
    ["Elvish Druid"]="Elvish Shaman", ["Elvish Sorceress"]="Elvish Shaman",
    ["Elder Wose"]="Wose", ["Elvish Marshal"]="Elvish Fighter", ["Elvish Champion"]="Elvish Fighter",
    ["Elvish Avenger"]="Elvish Archer", ["Elvish Shyde"]="Elvish Shaman",
    ["Ancient Wose"]="Wose", ["Elvish Sharpshooter"]="Elvish Archer",
    ["Orcish Warrior"]="Orcish Grunt", ["Orcish Crossbowman"]="Orcish Archer",
    ["Orcish Slayer"]="Orcish Assassin", Troll="Troll Whelp", ["Troll Rocklobber"]="Troll Whelp",
    ["Orcish Warlord"]="Orcish Grunt", ["Orcish Nightblade"]="Orcish Assassin",
    ["Troll Warrior"]="Troll Whelp", ["Great Troll"]="Troll Whelp",
    ["Direwolf Rider"]="Wolf Rider", ["Naga Myrmidon"]="Naga Fighter",
    ["Dark Sorcerer"]="Dark Adept", Revenant="Skeleton", Deathblade="Skeleton",
    ["Bone Shooter"]="Skeleton Archer", Necrophage="Ghoul",
    Lich="Dark Adept", Necromancer="Dark Adept", Draug="Skeleton",
    ["Death Knight"]="Skeleton Rider", Spectre="Ghost", Nightgaunt="Ghost",
    ["Drake Warrior"]="Drake Fighter", ["Drake Flare"]="Drake Burner", ["Fire Drake"]="Drake Burner",
    ["Drake Arbiter"]="Drake Clasher", ["Drake Thrasher"]="Drake Clasher",
    ["Saurian Oracle"]="Saurian Augur",
    ["Drake Blademaster"]="Drake Fighter", ["Drake Flameheart"]="Drake Burner",
    ["Drake Enforcer"]="Drake Clasher", ["Inferno Drake"]="Drake Burner",
    ["Hurricane Drake"]="Drake Glider", ["Drake Warden"]="Drake Clasher",
    ["Dwarvish Steelclad"]="Dwarvish Fighter", ["Dwarvish Thunderguard"]="Dwarvish Thunderer",
    ["Dwarvish Stalwart"]="Dwarvish Guardsman", Rogue="Thief", Trapper="Poacher",
    ["Dwarvish Lord"]="Dwarvish Fighter", ["Dwarvish Dragonguard"]="Dwarvish Thunderer",
    ["Dwarvish Sentinel"]="Dwarvish Guardsman", Assassin="Thief", Fugitive="Footpad",
}
function EP.get_base_recruit(leader_type) return EP.leader_base[leader_type] end

-- Pick a random subset of n items from a list
local function pick_n(list, n)
    local pool = {}
    for _, v in ipairs(list) do table.insert(pool, v) end
    local result = {}
    for _ = 1, math.min(n, #pool) do
        local i = wesnoth.random(1, #pool)
        table.insert(result, pool[i])
        table.remove(pool, i)
    end
    return result
end

-- Weighted random pick from a {key=weight} table
local function weighted_pick(weights)
    local total = 0
    for _, w in pairs(weights) do total = total + w end
    if total == 0 then return nil end
    local roll = wesnoth.random(1, total)
    local acc = 0
    for k, w in pairs(weights) do
        acc = acc + w
        if roll <= acc then return k end
    end
end

--- Pick enemy faction based on biome weights
-- Does NOT exclude player faction — mirror matchups are intended
function EP.pick_faction(biome)
    local bw = EP.biome_weights[biome] or EP.biome_weights.plains
    return weighted_pick(bw)
end

--- Build enemy recruit list based on battle number
-- Battles 1-2:  pick 4 from core L1
-- Battles 3-4:  full core L1
-- Battles 5:    full core + extra + pick 2 L2 (boss 1)
-- Battles 6-7:  full core + extra + pick 2 L2
-- Battles 8-9:  full core + extra + pick 4 L2
-- Battles 10:   full core + extra + all L2 (boss 2)
-- Battles 11-12: full core + extra + all L2
-- Battles 13-14: full core + extra + all L2
-- Bosses handled by build_boss_recruit_list
function EP.build_recruit_list(faction, battle_number, leader_type)
    local pool = EP.recruits[faction]
    if not pool then return {"Spearman"} end

    local result = {}

    -- Always include the leader's base unit line
    local forced = EP.get_base_recruit(leader_type)

    if battle_number <= 2 then
        result = pick_n(pool.core, 4)
    elseif battle_number <= 4 then
        for _, u in ipairs(pool.core) do table.insert(result, u) end
    elseif battle_number <= 7 then
        for _, u in ipairs(pool.core) do table.insert(result, u) end
        for _, u in ipairs(pool.extra) do table.insert(result, u) end
        local l2picks = pick_n(pool.l2, 2)
        for _, u in ipairs(l2picks) do table.insert(result, u) end
    elseif battle_number <= 9 then
        for _, u in ipairs(pool.core) do table.insert(result, u) end
        for _, u in ipairs(pool.extra) do table.insert(result, u) end
        local l2picks = pick_n(pool.l2, 4)
        for _, u in ipairs(l2picks) do table.insert(result, u) end
    else
        for _, u in ipairs(pool.core) do table.insert(result, u) end
        for _, u in ipairs(pool.extra) do table.insert(result, u) end
        for _, u in ipairs(pool.l2) do table.insert(result, u) end
    end

    -- Ensure leader's base recruit is in the list
    if forced then
        local found = false
        for _, u in ipairs(result) do if u == forced then found = true; break end end
        if not found then result[#result] = forced end -- replace last slot
    end

    return result
end

--- Build boss recruit list (full roster + L2 units)
function EP.build_boss_recruit_list(faction, battle_number, leader_type)
    local pool = EP.recruits[faction]
    if not pool then return {"Spearman"} end
    local result = {}
    for _, u in ipairs(pool.core) do table.insert(result, u) end
    for _, u in ipairs(pool.extra) do table.insert(result, u) end
    if battle_number >= 5 then
        local count = battle_number >= 10 and #pool.l2 or math.min(4, #pool.l2)
        local l2picks = pick_n(pool.l2, count)
        for _, u in ipairs(l2picks) do table.insert(result, u) end
    end
    return result
end

--- Pick a leader, avoiding already-defeated ones
-- defeated_list is a comma-separated string of defeated leader names
function EP.pick_leader(faction, battle_number, defeated_csv)
    local defeated = {}
    if defeated_csv and defeated_csv ~= "" then
        for name in defeated_csv:gmatch("[^,]+") do
            defeated[name:match("^%s*(.-)%s*$")] = true
        end
    end

    -- Pick L2 for battles 1-9, L3 for 11-14, special for 15
    local tier = "l2"
    if battle_number >= 11 then tier = "l3" end

    local candidates = EP.leaders[faction] and EP.leaders[faction][tier]
    if not candidates then return {type="Orcish Warrior", name="Unknown Warlord"} end

    -- Filter out defeated
    local available = {}
    for _, ldr in ipairs(candidates) do
        if not defeated[ldr.name] then
            table.insert(available, ldr)
        end
    end

    -- If all defeated, allow repeats (shouldn't happen with enough leaders)
    if #available == 0 then available = candidates end

    return available[wesnoth.random(1, #available)]
end

--- Calculate enemy starting gold based on battle number
function EP.enemy_gold(battle_number, is_boss)
    local base = 100
    local per_battle = 20
    local gold = base + (battle_number - 1) * per_battle
    if is_boss then gold = gold + 80 end
    return gold
end

--- Calculate enemy base income (scales like player)
function EP.enemy_income(battle_number)
    return math.floor(1.5 * (battle_number - 1))
end

return EP
