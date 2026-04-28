-- boss_rewards.lua — Boss reward definitions and application
local T = wml.tag
local BR = {}

-- Reward pools: composition (slot 1) + amplifier (slots 2-3, merged build amp + strategic)
-- Pick logic: 1 composition, 2 from amplifier pool. One amplifier slot has 50% boss override.
BR.rewards = {
    [1] = {
        composition = {
            {id="unlock_l2", flavor="Word of your conquest has reached experienced fighters. New soldiers offer their services.",
                label="Unlock Level 2 Recruit", description="A new L2 unit type is added to your recruit list.",
                image="icons/amla-default.png", target="auto", pre_reveal=true, confirm="New recruit unlocked"},
            {id="loyal_champion_l2", flavor="A seasoned fighter pledges their blade to your cause. They ask for no pay — only a place in your ranks.",
                label="Loyal Champion", description="A loyal L2 unit joins your warband (no upkeep, auto-deploys).",
                image="icons/breastplate2.png", target="auto", pre_reveal=true, confirm="has joined your warband as a loyal champion"},
            {id="veterans_boon", flavor="Stories of victory spread through camp. Every soldier stands a little taller.",
                label="Veteran's Boon", description="All units on your recall list gain 25% bonus XP.",
                image="icons/helmet_shiny.png", target="auto", confirm="All recall units gained bonus XP"},
        },
        amplifier = {
            {id="virulent_strain", flavor="Your alchemists study the battlefield dead. The poison can be made stronger — much stronger.",
                label="Virulent Strain", description="Poison now deals 12 damage per turn instead of 8.",
                image="icons/potion_green_small.png", target="auto", confirm="Poison damage increased to 12/turn"},
            {id="cutthroat_doctrine", flavor="Your assassins have learned to exploit every opening. A blade in the back hits harder than ever.",
                label="Cutthroat Doctrine", description="Backstab now deals triple damage instead of double.",
                image="attacks/dagger-human.png", target="auto", confirm="Backstab damage tripled"},
            {id="arcane_mastery", flavor="Your mages push the boundaries of what's possible. Their spells find their mark with uncanny precision.",
                label="Arcane Mastery", description="Magical attacks now have 90% chance to hit instead of 70%.",
                image="icons/book.png", target="auto", confirm="Magical accuracy increased to 90%"},
            {id="steady_aim", flavor="Hours of target practice pay off. Every arrow flies truer, every bolt hits harder.",
                label="Steady Aim", description="All pierce ranged attacks gain +1 damage per strike.",
                image="attacks/bow-short.png", target="auto", confirm="Pierce ranged damage increased"},
            {id="blood_harvest", flavor="The battlefield teaches its own lessons. Every kill feeds the hunger.",
                label="Blood Harvest", description="Choose 3 units to gain Feeding. All Feeding units gain +2 HP per kill instead of +1.",
                image="attacks/fangs.png", target="pick", pick_count=3, confirm="received Blood Harvest"},
            {id="thundering_charge", flavor="Your cavalry trains for the decisive charge. Hooves thunder, lances lower, the line breaks.",
                label="Thundering Charge", description="All mounted units gain +1 movement and Charge on melee.",
                image="attacks/lance.png", target="auto", confirm="Mounted units gained Charge and +1 movement"},
            {id="drakefire_doctrine", flavor="Your troops learn to harness fire. Every flame burns hotter, every ember bites deeper.",
                label="Drakefire Doctrine", description="All fire attacks (melee + ranged) deal +2 damage per strike.",
                image="attacks/fire-breath-drake.png", target="auto", confirm="Fire damage increased by +2 per strike"},
            {id="shatterpoint", flavor="Your warriors learn to read the fractures in armor and bone. One more swing is all it takes.",
                label="Shatterpoint", description="All impact melee attacks gain +1 extra strike.",
                image="attacks/hammer-dwarven.png", target="auto", confirm="Impact melee attacks gained +1 strike"},
            {id="frostbite", flavor="The cold seeps deeper now. Every frozen strike leaves the enemy sluggish and slow.",
                label="Frostbite", description="All cold attacks also Slow the target.",
                image="attacks/iceball.png", target="auto", confirm="Cold attacks now slow targets"},
            {id="spear_wall", flavor="Your spearmen drill until the formation is second nature. The first strike hits like a battering ram.",
                label="Spear Wall", description="All firststrike melee attacks gain +2 damage per strike.",
                image="attacks/pike.png", target="auto", confirm="Firststrike damage increased by +2 per strike"},
            {id="double_loot", flavor="Your scouts learn to read the battlefield for hidden caches. Twice the salvage, twice the opportunity.",
                label="Scavenger's Instinct", description="2 loot chests spawn per battle for the rest of the run.",
                image="icons/key_silver.png", target="auto", confirm="Double loot enabled for the rest of the run"},
        },
    },
    [2] = {
        composition = {
            {id="unlock_l3", flavor="Your reputation precedes you. Elite warriors seek you out.",
                label="Unlock Level 3 Recruit", description="A new L3 unit type is added to your recruit list.",
                image="icons/amla-default.png", target="auto", pre_reveal=true, confirm="New recruit unlocked"},
            {id="loyal_champion", flavor="A veteran of a hundred battles pledges their sword to your cause. They fight for loyalty, not coin.",
                label="Loyal Champion", description="A powerful loyal L3 unit joins your warband (no upkeep, auto-deploys).",
                image="icons/breastplate2.png", target="auto", pre_reveal=true, confirm="has joined your warband as a loyal champion"},
            {id="legendary_hero", flavor="The battles have forged you into something more. Your presence alone turns the tide.",
                label="Legendary Hero", description="Your leader gains Regenerates + Leadership + Fearless.",
                image="icons/circlet_winged.png", target="auto", confirm="Your leader has become legendary"},
        },
        amplifier = {
            {id="the_elven_way", flavor="Your archers study elven technique. Each draw of the bow yields one more arrow in the volley.",
                label="The Elven Way", description="All pierce ranged attacks gain +1 extra strike.",
                image="attacks/bow-elven.png", target="auto", confirm="Pierce ranged attacks gained +1 strike"},
            {id="the_possessed", flavor="Dark spirits answer your call. Three of your warriors open themselves to the hunger.",
                label="The Possessed", description="Choose 3 units: gain Drain on melee. All Drain units heal 75% instead of 50%.",
                image="attacks/curse.png", target="pick", pick_count=3, confirm="received the dark gift"},
            {id="plague_lord", flavor="Death is no longer the end — it's a recruitment tool. The fallen rise to serve.",
                label="Plague Lord", description="Choose 3 units: their melee attacks gain Plague (kills become Walking Corpses on your side).",
                image="attacks/staff-plague.png", target="pick", pick_count=3, confirm="received Plague"},
            {id="deathless_march", flavor="Your warband refuses to die. Sheer will holds them together when their bodies should fail.",
                label="Deathless March", description="First time each unit would die per battle, survives at 1 HP instead.",
                image="icons/steel_armor.png", target="auto", confirm="Deathless March activated for the rest of the run"},
            {id="double_loot", flavor="Your scouts learn to read the battlefield for hidden caches. Twice the salvage, twice the opportunity.",
                label="Scavenger's Instinct", description="2 loot chests spawn per battle for the rest of the run.",
                image="icons/key_silver.png", target="auto", confirm="Double loot enabled for the rest of the run"},
        },
    },
}

-- Boss-specific rewards (50% chance to replace one amplifier slot)
BR.boss_rewards = {
    greyhelm = {id="greyhelm_formation", flavor="You study the dead commander's formation. His stubbornness was a weapon — now it's yours.",
        label="Greyhelm's Formation", description="Choose 3 units: gain Steadfast + Heals +4.",
        image="icons/shield_tower.png", target="pick", pick_count=3, confirm="received Greyhelm's Formation"},
    briarwen = {id="briarwen_roothold", flavor="A living broach, pulsing with green light, pulled from the druid's staff. The forest's magic lingers.",
        label="Briarwen's Blessing", description="Choose 2 units: gain Regenerates (+8 HP/turn) + Ambush (hide in forest).",
        image="icons/jewelry_butterfly_pin.png", target="pick", pick_count=2, confirm="received Briarwen's Blessing"},
    maggash = {id="maggash_frenzy", flavor="Something changed in the soldiers who survived the horde. They fight like cornered animals now.",
        label="Maggash's Frenzy", description="Choose 3 units: gain Berserk on melee + 8 max HP.",
        image="attacks/frenzy.png", target="pick", pick_count=3, confirm="received Maggash's Frenzy"},
    pale_conductor = {id="conductor_baton", flavor="The necromancer's staff hums with dark energy. In the right hands, it could raise an army.",
        label="The Conductor's Baton", description="Choose 1 unit: gains 7×3 arcane melee with Drain + Plague.",
        image="attacks/curse.png", target="pick", pick_count=1, confirm="received the Conductor's Baton"},
    sithrak = {id="sithrak_flamebreath", flavor="Alchemists salvage the drake's fire glands. The flames can be harnessed — and the heat endured.",
        label="Sithrak's Flamebreath", description="Choose 3 units: each gains 8×2 fire ranged + 30% fire resistance.",
        image="attacks/ember.png", target="pick", pick_count=3, confirm="equipped with Sithrak's Flamebreath"},
    ironband = {id="ironband_oath", flavor="You study how five fighters held a pass against an army. Their discipline becomes your doctrine.",
        label="Ironband's Oath", description="Choose 3 units: gain Leadership + Skirmisher + 4 max HP.",
        image="icons/circlet_winged.png", target="pick", pick_count=3, confirm="received Ironband's Oath"},
}

-- Helper: pick 1 random from a category pool
local function pick_one(pool)
    if not pool or #pool == 0 then return nil end
    return pool[wesnoth.random(1, #pool)]
end

-- Pre-reveal: resolve which unit the L2/L3 unlock or loyal champion would give
function BR._resolve_unlock(reward)
    if not reward.pre_reveal then return reward end

    local r = {}
    for k, v in pairs(reward) do r[k] = v end

    if reward.id == "unlock_l2" or reward.id == "unlock_l3" then
        local level = reward.id == "unlock_l2" and 2 or 3
        local faction = wesnoth.get_variable("chosen_faction") or "loyalist"
        local pool = BR._get_unlock_pool(faction, level)
        if #pool == 0 then return reward end
        local pick = pool[wesnoth.random(1, #pool)]
        local utype = wesnoth.unit_types[pick]
        local img = utype and utype.image or "icons/amla-default.png"
        r.label = "Unlock " .. pick
        r.description = "Add " .. pick .. " (L" .. level .. ") to your recruit list."
        r.image = img
        r._resolved_unit = pick
        r.confirm = pick .. " added to your recruit list"
    elseif reward.id == "loyal_champion" or reward.id == "loyal_champion_l2" then
        local level = reward.id == "loyal_champion" and 3 or 2
        local champions_l3 = {
            "Ancient Wose","Arch Mage","Assassin","Banebow","Cavalier",
            "Death Knight","Direwolf Rider","Draug","Drake Blademaster",
            "Drake Enforcer","Drake Flameheart","Drake Warden",
            "Dwarvish Dragonguard","Dwarvish Explorer","Dwarvish Lord",
            "Dwarvish Runemaster","Dwarvish Sentinel",
            "Elvish Avenger","Elvish Champion","Elvish Enchantress",
            "Elvish High Lord","Elvish Marshal","Elvish Outrider",
            "Elvish Sharpshooter","Elvish Shyde",
            "Fugitive","General","Ghast","Grand Knight","Great Troll",
            "Halberdier","Highwayman","Huntsman","Hurricane Drake",
            "Inferno Drake","Iron Mauler","Lich",
            "Mage of Light","Master Bowman","Master at Arms",
            "Mermaid Diviner","Mermaid Siren","Merman Entangler",
            "Merman Hoplite","Merman Javelineer","Merman Triton",
            "Naga Myrmidon","Necromancer","Nightgaunt",
            "Orcish Nightblade","Orcish Slurbow","Orcish Sovereign","Orcish Warlord",
            "Paladin","Ranger","Royal Guard","Royal Warrior",
            "Saurian Flanker","Saurian Javelineer","Saurian Prophet","Saurian Seer",
            "Silver Mage","Spectre","Troll Warrior",
        }
        local champions_l2 = {
            "Bandit","Bone Knight","Bone Shooter","Chocobone","Dark Sorcerer",
            "Death Squire","Deathblade","Dragoon","Drake Arbiter","Drake Flare",
            "Drake Thrasher","Drake Warrior","Dread Bat","Duelist",
            "Dwarvish Berserker","Dwarvish Pathfinder","Dwarvish Runesmith",
            "Dwarvish Stalwart","Dwarvish Steelclad","Dwarvish Thunderguard",
            "Elder Wose","Elvish Captain","Elvish Druid","Elvish Hero",
            "Elvish Lord","Elvish Marksman","Elvish Ranger","Elvish Rider",
            "Elvish Sorceress","Fire Drake","Goblin Knight","Goblin Pillager",
            "Gryphon Master","Javelineer","Knight","Lancer","Lieutenant",
            "Longbowman","Mermaid Enchantress","Mermaid Priestess",
            "Merman Netcaster","Merman Spearman","Merman Warrior",
            "Naga Warrior","Necrophage","Orcish Crossbowman","Orcish Ruler",
            "Orcish Slayer","Orcish Warrior","Outlaw","Pikeman","Red Mage",
            "Revenant","Rogue","Saurian Ambusher","Saurian Oracle",
            "Saurian Soothsayer","Saurian Spearthrower","Shadow","Shock Trooper",
            "Sky Drake","Swordsman","Trapper","Troll","Troll Hero",
            "Troll Rocklobber","Troll Shaman","White Mage","Wose Shaman","Wraith",
        }
        local pool = level == 3 and champions_l3 or champions_l2
        local pick = pool[wesnoth.random(1, #pool)]
        local utype = wesnoth.unit_types[pick]
        local img = utype and utype.image or "icons/breastplate.png"
        r.label = "Loyal Champion — " .. pick
        r.description = pick .. " (L" .. level .. ") joins your warband. Loyal (no upkeep), auto-deploys each battle."
        r.image = img
        r._resolved_unit = pick
        r.confirm = pick .. " has joined your warband as a loyal champion"
    end

    return r
end

-- Pick 3 rewards: 1 composition + 2 from amplifier pool.
-- One amplifier slot has 50% chance to be replaced by boss-specific reward.
function BR.pick_options(tier, boss_id)
    local tier_data = BR.rewards[tier]
    if not tier_data then return {} end

    local picks = {}

    -- Slot 1: composition
    local comp = tier_data.composition
    if comp and #comp > 0 then
        picks[#picks+1] = BR._resolve_unlock(comp[wesnoth.random(1, #comp)])
    end

    -- Slots 2-3: from amplifier pool
    local amp_pool = tier_data.amplifier
    if not amp_pool or #amp_pool == 0 then return picks end

    -- Copy pool so we can remove picks without mutating
    local available = {}
    for _, r in ipairs(amp_pool) do available[#available+1] = r end

    local boss_reward = boss_id and BR.boss_rewards[boss_id] or nil
    local boss_used = false

    for slot = 1, 2 do
        -- 50% chance for boss reward to replace the FIRST amplifier slot
        if not boss_used and boss_reward and slot == 1 and wesnoth.random(1, 2) == 1 then
            picks[#picks+1] = boss_reward
            boss_used = true
        else
            if #available > 0 then
                local idx = wesnoth.random(1, #available)
                picks[#picks+1] = available[idx]
                table.remove(available, idx)
            end
        end
    end

    return picks
end

-- Apply a reward
function BR.apply(reward_id, units, reward)
    -- === COMPOSITION REWARDS ===
    if reward_id == "unlock_l2" then
        BR._unlock_recruit(2, reward and reward._resolved_unit)
    elseif reward_id == "unlock_l3" then
        BR._unlock_recruit(3, reward and reward._resolved_unit)
    elseif reward_id == "veterans_boon" then
        for _, u in ipairs(wesnoth.units.find_on_recall{side=1}) do
            u.experience = u.experience + math.floor(u.max_experience * 0.25)
            if u.experience >= u.max_experience then u.experience = u.max_experience - 1 end
        end
    elseif reward_id == "loyal_champion" or reward_id == "loyal_champion_l2" then
        local pick = reward._resolved_unit
        if not pick then
            local pool = reward_id == "loyal_champion"
                and {"Royal Guard","Arch Mage","Elvish Champion","Orcish Warlord","Drake Blademaster","Dwarvish Explorer","Troll Warrior"}
                or {"Swordsman","Pikeman","Knight","Elvish Ranger","Orcish Warrior","Troll","Bone Shooter","Fire Drake","Dwarvish Steelclad"}
            pick = pool[wesnoth.random(1, #pool)]
        end
        local u = wesnoth.units.create{type=pick, side=1, generate_name=true, random_traits=true, random_gender=true}
        u:add_modification("trait", {id="loyal", name="loyal", description="Zero upkeep",
            T.effect{apply_to="loyal"}, T.effect{apply_to="overlay", add="misc/loyal-icon.png"}})
        u:to_recall()
        wesnoth.set_variable("loyal_champion_id", u.id)
    elseif reward_id == "legendary_hero" then
        local hero = wesnoth.units.find_on_map{id="hero"}[1]
        if not hero then hero = wesnoth.units.find_on_recall{id="hero"}[1] end
        if hero then
            hero:add_modification("object", {id="legendary_hero", name="Legendary Hero",
                T.effect{apply_to="new_ability", T.abilities{
                    T.regenerate{id="regenerates", name="regenerates",
                        description="The unit will heal itself 8 HP per turn.", value=8},
                    T.leadership{id="leadership", name="leadership",
                        description="Adjacent units of lower level will do more damage in combat.",
                        value="(25 * (level - other.level))", cumulative="no", affect_self="no",
                        T.affect_adjacent{T.filter{formula="level < other.level"}}}}},
                T.effect{apply_to="fearless", set="yes"}})
        end

    -- === BUILD AMPLIFIER REWARDS ===
    elseif reward_id == "virulent_strain" then
        wesnoth.set_variable("buff_virulent_strain", "yes")
    elseif reward_id == "cutthroat_doctrine" then
        wesnoth.set_variable("buff_cutthroat_doctrine", "yes")
    elseif reward_id == "arcane_mastery" then
        wesnoth.set_variable("buff_arcane_mastery", "yes")
    elseif reward_id == "steady_aim" then
        -- +1 damage to all pierce ranged attacks on all side 1 units
        for _, u in ipairs(wesnoth.units.find_on_map{side=1}) do
            u:add_modification("object", {id="buff_steady_aim", name="Steady Aim",
                T.effect{apply_to="attack", range="ranged", type="pierce", increase_damage=1}})
        end
        for _, u in ipairs(wesnoth.units.find_on_recall{side=1}) do
            u:add_modification("object", {id="buff_steady_aim", name="Steady Aim",
                T.effect{apply_to="attack", range="ranged", type="pierce", increase_damage=1}})
        end
        wesnoth.set_variable("buff_steady_aim", "yes")
    elseif reward_id == "blood_harvest" then
        for _, u in ipairs(units) do
            u:add_modification("object", {id="buff_blood_harvest", name="Blood Harvest",
                T.effect{apply_to="new_ability",
                    T.abilities{T.feeding{id="feeding", name="feeding",
                        description="This unit gains 1 hitpoint added to its maximum whenever it kills a unit."}}}})
        end
        wesnoth.set_variable("buff_blood_harvest", "yes")
    elseif reward_id == "thundering_charge" then
        local mounted = {
            ["Elvish Scout"]=true,["Elvish Rider"]=true,["Elvish Outrider"]=true,
            ["Gryphon Rider"]=true,["Gryphon Master"]=true,
            ["Cavalryman"]=true,["Dragoon"]=true,["Cavalier"]=true,
            ["Horseman"]=true,["Knight"]=true,["Lancer"]=true,["Paladin"]=true,["Grand Knight"]=true,
            ["Skeleton Rider"]=true,["Bone Knight"]=true,
            ["Wolf Rider"]=true,["Goblin Knight"]=true,["Goblin Pillager"]=true,["Direwolf Rider"]=true,
        }
        local function apply_charge(u)
            if mounted[u.type] then
                u:add_modification("object", {id="buff_thundering_charge", name="Thundering Charge",
                    T.effect{apply_to="movement", increase=1},
                    T.effect{apply_to="attack", range="melee",
                        T.set_specials{T.damage{id="charge", name="charge",
                            description="This attack deals double damage when used offensively, but the attacker also takes double damage.",
                            multiply=2, active_on="offense", T.filter_opponent{}}}}})
            end
        end
        for _, u in ipairs(wesnoth.units.find_on_map{side=1}) do apply_charge(u) end
        for _, u in ipairs(wesnoth.units.find_on_recall{side=1}) do apply_charge(u) end
        wesnoth.set_variable("buff_thundering_charge", "yes")
    elseif reward_id == "drakefire_doctrine" then
        local function apply_fire(u)
            u:add_modification("object", {id="buff_drakefire", name="Drakefire Doctrine",
                T.effect{apply_to="attack", type="fire", increase_damage=2}})
        end
        for _, u in ipairs(wesnoth.units.find_on_map{side=1}) do apply_fire(u) end
        for _, u in ipairs(wesnoth.units.find_on_recall{side=1}) do apply_fire(u) end
        wesnoth.set_variable("buff_drakefire_doctrine", "yes")
    elseif reward_id == "shatterpoint" then
        local function apply_shatter(u)
            u:add_modification("object", {id="buff_shatterpoint", name="Shatterpoint",
                T.effect{apply_to="attack", range="melee", type="impact", increase_attacks=1}})
        end
        for _, u in ipairs(wesnoth.units.find_on_map{side=1}) do apply_shatter(u) end
        for _, u in ipairs(wesnoth.units.find_on_recall{side=1}) do apply_shatter(u) end
        wesnoth.set_variable("buff_shatterpoint", "yes")
    elseif reward_id == "frostbite" then
        wesnoth.set_variable("buff_frostbite", "yes")
    elseif reward_id == "spear_wall" then
        local function apply_spear(u)
            u:add_modification("object", {id="buff_spear_wall", name="Spear Wall",
                T.effect{apply_to="attack", specials="firststrike", increase_damage=2}})
        end
        for _, u in ipairs(wesnoth.units.find_on_map{side=1}) do apply_spear(u) end
        for _, u in ipairs(wesnoth.units.find_on_recall{side=1}) do apply_spear(u) end
        wesnoth.set_variable("buff_spear_wall", "yes")
    elseif reward_id == "double_loot" then
        wesnoth.set_variable("buff_double_loot", "yes")
    elseif reward_id == "the_elven_way" then
        local function apply_elven(u)
            u:add_modification("object", {id="buff_elven_way", name="The Elven Way",
                T.effect{apply_to="attack", range="ranged", type="pierce", increase_attacks=1}})
        end
        for _, u in ipairs(wesnoth.units.find_on_map{side=1}) do apply_elven(u) end
        for _, u in ipairs(wesnoth.units.find_on_recall{side=1}) do apply_elven(u) end
        wesnoth.set_variable("buff_the_elven_way", "yes")
    elseif reward_id == "the_possessed" then
        for _, u in ipairs(units) do
            u:add_modification("object", {id="buff_possessed", name="The Possessed",
                T.effect{apply_to="attack", range="melee",
                    T.set_specials{T.drains{id="drains", name="drains",
                        description="This unit drains health from living units, healing itself for half the damage dealt."}}}})
        end
        wesnoth.set_variable("buff_the_possessed", "yes")
    elseif reward_id == "plague_lord" then
        for _, u in ipairs(units) do
            u:add_modification("object", {id="buff_plague_lord", name="Plague Lord",
                T.effect{apply_to="attack", range="melee",
                    T.set_specials{T.plague{id="plague", name="plague",
                        description="When a unit is killed by this attack, it is replaced with a Walking Corpse.",
                        type="Walking Corpse"}}}})
        end
    elseif reward_id == "deathless_march" then
        wesnoth.set_variable("buff_deathless_march", "yes")

    -- === BOSS-SPECIFIC REWARDS ===
    elseif reward_id == "greyhelm_formation" then
        for _, u in ipairs(units) do
            u:add_modification("object", {id="boss_greyhelm", name="Greyhelm's Formation",
                T.effect{apply_to="new_ability", T.abilities{
                    T.resistance{id="steadfast", name="steadfast",
                        description="This unit's resistances are doubled when defending. (Capped at 50%)",
                        multiply=2, max_value=50, active_on="defense"},
                    T.heals{id="healing", name="heals +4",
                        description="Allows the unit to heal adjacent allied units at the beginning of each turn.",
                        value=4, affect_self="no", affect_allies="yes",
                        T.affect_adjacent{}}}}})
        end
    elseif reward_id == "briarwen_roothold" then
        for _, u in ipairs(units) do
            u:add_modification("object", {id="boss_briarwen", name="Briarwen's Blessing",
                T.effect{apply_to="new_ability", T.abilities{
                    T.regenerate{id="regenerates", name="regenerates",
                        description="The unit will heal itself 8 HP per turn.", value=8},
                    T.hides{id="ambush", name="ambush",
                        description="This unit can hide in forest and remain undetected by enemies.",
                        affect_self="yes",
                        T.filter_self{T.filter_location{terrain="*^F*"}}}}}})
        end
    elseif reward_id == "maggash_frenzy" then
        for _, u in ipairs(units) do
            u:add_modification("object", {id="boss_maggash", name="Maggash's Frenzy",
                T.effect{apply_to="attack", range="melee",
                    T.set_specials{T.berserk{id="berserk", name="berserk",
                        description="Whether attacking or defending, this unit will fight until either it or its enemy lies dead.",
                        value=30}}},
                T.effect{apply_to="hitpoints", increase_total=8}})
        end
    elseif reward_id == "conductor_baton" then
        for _, u in ipairs(units) do
            u:add_modification("object", {id="boss_conductor", name="The Conductor's Baton",
                T.effect{apply_to="new_attack", name="baton", description="baton",
                    icon="attacks/curse.png", type="arcane", range="melee", damage=7, number=3,
                    T.specials{
                        T.drains{id="drains", name="drains",
                            description="This unit drains health from living units, healing itself for half the damage dealt."},
                        T.plague{id="plague", name="plague",
                            description="When a unit is killed by this attack, it is replaced with a Walking Corpse.",
                            type="Walking Corpse"}}}})
        end
    elseif reward_id == "sithrak_flamebreath" then
        for _, u in ipairs(units) do
            u:add_modification("object", {id="boss_sithrak", name="Sithrak's Flamebreath",
                T.effect{apply_to="new_attack", name="flamebreath", description="flamebreath",
                    icon="attacks/ember.png", type="fire", range="ranged", damage=8, number=2},
                T.effect{apply_to="resistance", replace=false, T.resistance{fire=-30}}})
        end
    elseif reward_id == "ironband_oath" then
        for _, u in ipairs(units) do
            u:add_modification("object", {id="boss_ironband", name="Ironband's Oath",
                T.effect{apply_to="new_ability", T.abilities{
                    T.leadership{id="leadership", name="leadership",
                        description="Adjacent units of lower level will do more damage in combat.",
                        value="(25 * (level - other.level))", cumulative="no", affect_self="no",
                        T.affect_adjacent{T.filter{formula="level < other.level"}}},
                    T.skirmisher{id="skirmisher", name="skirmisher",
                        description="This unit can move through enemy zones of control without being slowed."}}},
                T.effect{apply_to="hitpoints", increase_total=4}})
        end
    end
end

-- Unit pools by faction and level
BR._pools = {
    [2] = {
        loyalist = {"Swordsman","Pikeman","Javelineer","Longbowman","Shock Trooper","Knight","Lancer","White Mage","Red Mage","Dragoon","Duelist"},
        elf = {"Elvish Hero","Elvish Captain","Elvish Ranger","Elvish Marksman","Elvish Druid","Elvish Sorceress","Elvish Rider"},
        orc = {"Orcish Warrior","Orcish Crossbowman","Orcish Slayer","Troll","Troll Rocklobber","Goblin Pillager","Goblin Knight","Naga Warrior"},
        undead = {"Revenant","Deathblade","Bone Shooter","Bone Knight","Chocobone","Necrophage","Dark Sorcerer"},
        drake = {"Drake Warrior","Drake Flare","Fire Drake","Sky Drake","Drake Thrasher","Drake Arbiter","Saurian Spearthrower","Saurian Oracle"},
        knalgan = {"Dwarvish Steelclad","Dwarvish Thunderguard","Dwarvish Pathfinder","Dwarvish Stalwart","Rogue","Bandit","Outlaw","Trapper"},
    },
    [3] = {
        loyalist = {"Royal Guard","Halberdier","General","Master Bowman","Iron Mauler","Paladin","Grand Knight","Mage of Light","Arch Mage","Silver Mage","Master at Arms"},
        elf = {"Elvish Marshal","Elvish Champion","Elvish Avenger","Elvish Sharpshooter","Elvish Shyde","Elvish Outrider"},
        orc = {"Orcish Warlord","Orcish Slurbow","Direwolf Rider","Troll Warrior","Naga Myrmidon"},
        undead = {"Draug","Banebow","Nightgaunt","Spectre","Lich","Ghast","Death Knight"},
        drake = {"Drake Blademaster","Drake Flameheart","Inferno Drake","Hurricane Drake","Drake Enforcer","Drake Warden","Saurian Flanker","Saurian Javelineer"},
        knalgan = {"Dwarvish Lord","Dwarvish Dragonguard","Dwarvish Explorer","Dwarvish Sentinel","Assassin","Huntsman","Fugitive","Highwayman"},
    },
}

function BR._get_unlock_pool(faction, level)
    local pool = (BR._pools[level] or {})[faction] or {}
    local current = wesnoth.get_variable("unlocked_recruits") or ""
    local available = {}
    for _, utype in ipairs(pool) do
        if not current:find(utype, 1, true) then
            available[#available+1] = utype
        end
    end
    return #available > 0 and available or pool
end

function BR._unlock_recruit(level, resolved_unit)
    local faction = wesnoth.get_variable("chosen_faction") or "loyalist"
    local pick = resolved_unit
    if not pick then
        local pool = BR._get_unlock_pool(faction, level)
        if #pool == 0 then return end
        pick = pool[wesnoth.random(1, #pool)]
    end
    local current = wesnoth.get_variable("unlocked_recruits") or ""
    if current == "" then
        wesnoth.set_variable("unlocked_recruits", pick)
    else
        wesnoth.set_variable("unlocked_recruits", current .. "," .. pick)
    end
    local utype = wesnoth.unit_types[pick]
    local img = utype and utype.image or "wesnoth-icon.png"
end

-- Add a loyal high-level unit to recall
return BR
