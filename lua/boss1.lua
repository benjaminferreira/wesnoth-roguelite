-- boss1.lua — Boss 1 encounter data and setup
-- Battle 5: one of 6 bosses picked at random

local B = {}

B.bosses = {
    {
        id = "greyhelm",
        name = "Greyhelm",
        type = "General",
        faction = "loyalists",
        gold = 200,
        recruits = {"Spearman","Heavy Infantryman"},
        map = "boss1_greyhelm.map",
        ai = "guardian", -- leader doesn't move
        pre_placed = {
            {type="Pikeman", x="keep_offset", y="keep_offset"},
            {type="Pikeman", x="keep_offset", y="keep_offset"},
            {type="White Mage", x="keep_offset", y="keep_offset"},
        },
        pre_battle = "You want this crossroads? Come and take it.",
    },
    {
        id = "thornweaver",
        name = "Thornweaver",
        type = "Elvish Druid",
        faction = "rebels",
        gold = 150,
        recruits = {"Elvish Archer","Elvish Shaman"},
        map = "boss1_thornweaver.map",
        abilities = {"regenerate"},
        mechanic = "forest_growth", -- custom event: path shrinks + wose spawns
        pre_battle = "The forest grew here long before you. It will be here long after.",
    },
    {
        id = "gutripper",
        name = "Gutripper",
        type = "Orcish Warrior",
        faction = "northerners",
        gold = 0, -- no recruiting, pre-placed horde
        recruits = {},
        map = "boss1_gutripper.map",
        attack_mods = {berserk = true},
        ai = "aggressive", -- charges when gold=0
        pre_placed_horde = true, -- special: mass goblin spawn
        pre_battle = "More skulls for the pile!",
    },
    {
        id = "pale_conductor",
        name = "The Pale Conductor",
        type = "Dark Sorcerer",
        faction = "undead",
        gold = 120,
        recruits = {"Skeleton","Skeleton Archer","Walking Corpse","Soulless","Ghoul","Skeleton Rider"},
        map = "boss1_pale_conductor.map",
        mechanic = "corpse_spawn", -- every 2 turns, corpse on each village
        pre_battle = nil, -- silent; narrator speaks instead
        narrator_line = "The necromancer regards you in silence. The dead begin to stir.",
    },
    {
        id = "embercrest",
        name = "Embercrest",
        type = "Fire Drake",
        faction = "drakes",
        gold = 150,
        recruits = {"Drake Fighter","Drake Clasher","Drake Burner","Drake Glider"},
        map = "boss1_embercrest.map",
        mechanic = "fire_aura", -- 4 dmg to adjacent enemies on side 2 turn
        pre_battle = "You fight well, for something that can't fly.",
    },
    {
        id = "ironband",
        name = "Ironband",
        type = "Dwarvish Steelclad",
        faction = "knalgan",
        gold = 0,
        recruits = {},
        map = "boss1_ironband.map",
        pre_placed = {
            {type="Dwarvish Thunderguard"},
            {type="Rogue"},
            {type="Dwarvish Stalwart"},
            {type="Gryphon Master"},
        },
        pre_battle = "Five of us. However many of you. Seems fair.",
    },
}

--- Pick a random boss (avoiding repeat if possible)
function B.pick_boss()
    -- For now, pure random. Later could weight by player faction or track seen bosses.
    return B.bosses[wesnoth.random(1, #B.bosses)]
end

return B
