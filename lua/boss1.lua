-- boss1.lua — Boss 1 encounter data and setup
-- Battle 5: one of 6 bosses picked at random

local B = {}

B.bosses = {
    {
        id = "greyhelm",
        name = "Greyhelm the Unmovable",
        type = "Shock Trooper",
        faction = "loyalists",
        gold = 80,
        base_income = 20,
        village_gold = 2,
        recruits = {"Spearman","Heavy Infantryman"},
        map = "boss1_greyhelm.map",
        ai = "guardian",
        pre_placed = {
            {type="White Mage"},
            {type="Pikeman"},
            {type="Pikeman"},
        },
    },
    {
        id = "briarwen",
        name = "Briarwen",
        type = "Elvish Druid",
        faction = "rebels",
        gold = 150,
        base_income = 6,
        village_gold = 2,
        recruits = {"Elvish Archer","Elvish Shaman","Elvish Druid","Elvish Ranger"},
        map = "boss1_thornweaver.map",
        abilities = {"regenerate"},
        mechanic = "forest_growth",
    },
    {
        id = "maggash",
        name = "Maggash",
        title = "Maggash and the Horde",
        type = "Orcish Warrior",
        faction = "northerners",
        gold = 0,
        base_income = 0,
        village_gold = 0,
        recruits = {},
        map = "boss1_gutripper.map",
        attack_mods = {berserk = true},
        ai = "aggressive",
        pre_placed_horde = true,
    },
    {
        id = "pale_conductor",
        name = "The Pale Conductor",
        type = "Dark Sorcerer",
        faction = "undead",
        gold = 200,
        base_income = 8,
        village_gold = 2,
        recruits = {"Skeleton","Skeleton Archer","Walking Corpse","Soulless","Ghoul","Skeleton Rider","Revenant","Deathblade","Bone Shooter","Necrophage","Bone Knight"},
        map = "boss1_pale_conductor.map",
        mechanic = "corpse_spawn",
    },
    {
        id = "sithrak",
        name = "Sithrak the Exile",
        type = "Fire Drake",
        faction = "drakes",
        gold = 100,
        base_income = 14,
        village_gold = 2,
        recruits = {"Drake Fighter","Drake Burner","Drake Glider","Fire Drake","Drake Warrior","Sky Drake"},
        map = "boss1_embercrest.map",
        mechanic = "fire_aura",
    },
    {
        id = "ironband",
        name = "Halvard Ironband",
        title = "The Ironband",
        type = "Dwarvish Steelclad",
        faction = "knalgan",
        gold = 0,
        base_income = 0,
        village_gold = 0,
        recruits = {},
        map = "boss1_ironband.map",
        pre_placed = {
            {type="Dwarvish Thunderguard", name="Brokk"},
            {type="Rogue", name="Nessa"},
            {type="Dwarvish Stalwart", name="Durgan"},
            {type="Gryphon Master", name="Skye"},
        },
    },
}

function B.pick_boss()
    return B.bosses[wesnoth.random(1, #B.bosses)]
end

return B
