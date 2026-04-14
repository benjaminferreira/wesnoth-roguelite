-- boss_rewards.lua — Boss reward definitions and application
local T = wml.tag
local BR = {}

-- Reward pools organized by tier and category
-- Categories: recruit (unlock/champion), weapon (caches/weapon traits), stat (buffs/abilities)
-- Each tier picks 1 from each category = 3 choices always
BR.rewards = {
    [1] = {
        recruit = {
            {id="unlock_l2", flavor="Word of your conquest has reached experienced fighters. New soldiers offer their services.",
                label="Unlock Level 2 Recruit", description="A new L2 unit type is added to your recruit list.",
                image="icons/amla-default.png", target="auto", pre_reveal=true, confirm="New recruit unlocked"},
            {id="veterans_boon", flavor="Stories of victory spread through camp. Every soldier stands a little taller.",
                label="Veteran's Boon", description="All units on your recall list gain bonus XP.",
                image="icons/book.png", target="auto", confirm="All recall units gained bonus XP"},
        },
        weapon = {
            {id="weapon_spears", flavor="Salvaged spears from the conquered stronghold. Long reach, sharp tips, and the advantage of striking first.",
                label="Weapon Cache — Spears", description="Choose 3 units to equip with a spear (7×3 pierce melee, firststrike).",
                image="attacks/spear.png", target="pick", pick_count=3, confirm="equipped with spears"},
            {id="weapon_bows", flavor="A crate of shortbows from the armory. Now your front line can fight back at range.",
                label="Weapon Cache — Bows", description="Choose 3 units to equip with a shortbow (5×3 pierce ranged).",
                image="attacks/bow-short.png", target="pick", pick_count=3, confirm="equipped with shortbows"},
            {id="weapon_knives", flavor="A crate of balanced knives. Not elegant, but they stick where they land.",
                label="Weapon Cache — Throwing Knives", description="Choose 3 units to equip with throwing knives (4×3 blade ranged).",
                image="attacks/dagger-thrown-human.png", target="pick", pick_count=3, confirm="equipped with throwing knives"},
            {id="weapon_maces", flavor="Crude but effective. Armor means nothing when the bones break underneath.",
                label="Weapon Cache — Maces", description="Choose 3 units to equip with a mace (7×3 impact melee).",
                image="attacks/hammer.png", target="pick", pick_count=3, confirm="equipped with maces"},
            {id="poisoned_blades", flavor="A trader sells you vials of something foul. Your blades drip with it now.",
                label="Poisoned Blades", description="Choose 3 units. Adds poison to their melee attack.",
                image="attacks/dagger-thrown-poison-human.png", target="pick", pick_count=3, confirm="received poisoned blades"},
        },
        stat = {
            {id="sharpened_blades", flavor="Your smiths work through the night. By morning, every edge could split a hair.",
                label="Sharpened Blades", description="Choose 4 units. Each gains +2 melee damage.",
                image="attacks/greatsword-human.png", target="pick", pick_count=4, confirm="received sharpened blades"},
            {id="hardened_tips", flavor="Arrowheads reforged with scavenged steel. They punch deeper now.",
                label="Hardened Tips", description="Choose 4 units. Each gains +2 ranged damage.",
                image="attacks/bow.png", target="pick", pick_count=4, confirm="received hardened tips"},
            {id="ironblood", flavor="Hard marching and harder fighting. Your troops are tougher than they were.",
                label="Ironblood", description="Choose 4 units. Each gains +6 max HP.",
                image="icons/potion_red_small.png", target="pick", pick_count=4, confirm="received Ironblood"},
            {id="battle_drills", flavor="Hours of sparring in camp. Your troops read attacks before they land.",
                label="Battle Drills", description="Choose 4 units. Each gains +10% defense on all terrain.",
                image="attacks/heater-shield.png", target="pick", pick_count=4, confirm="received battle drills"},
            {id="fieldcraft", flavor="Your veterans share what they know — how to use the land itself as a shield.",
                label="Fieldcraft", description="Choose 4 units. Each gains +10% fire/cold/arcane resistance.",
                image="attacks/bow-elven.png", target="pick", pick_count=4, confirm="received fieldcraft training"},
        },
    },
    [2] = {
        recruit = {
            {id="unlock_l3", flavor="Your reputation precedes you. Elite warriors seek you out.",
                label="Unlock Level 3 Recruit", description="A new L3 unit type is added to your recruit list.",
                image="icons/amla-default.png", target="auto", pre_reveal=true, confirm="New recruit unlocked"},
            {id="loyal_champion", flavor="A veteran of a hundred battles pledges their sword to your cause. They fight for loyalty, not coin.",
                label="Loyal Champion", description="A powerful loyal unit joins your warband (no upkeep).",
                image="icons/breastplate.png", target="auto", confirm="A loyal champion has joined your warband"},
        },
        weapon = {
            {id="weapon_axes", flavor="Heavy axes forged for war. One swing can cleave through shield and bone alike.",
                label="Weapon Cache — War Axes", description="Choose 5 units to equip with a war axe (9×3 blade melee).",
                image="attacks/axe.png", target="pick", pick_count=5, confirm="equipped with war axes"},
            {id="weapon_crossbows", flavor="Heavy crossbows. Slow to reload, but one bolt punches through anything.",
                label="Weapon Cache — Crossbows", description="Choose 4 units to equip with a crossbow (8×2 pierce ranged).",
                image="attacks/crossbow-human.png", target="pick", pick_count=4, confirm="equipped with crossbows"},
            {id="weapon_javelins", flavor="Salvaged javelins. One good throw can end a fight before it starts.",
                label="Weapon Cache — Javelins", description="Choose 4 units to equip with javelins (6×3 pierce ranged).",
                image="attacks/javelin-human.png", target="pick", pick_count=4, confirm="equipped with javelins"},
        },
        stat = {
            {id="forced_march", flavor="Lighter packs, better boots. Your troops cover ground faster.",
                label="Forced March", description="Choose 3 units. Each gains +1 movement permanently.",
                image="attacks/foot-boot.png", target="pick", pick_count=3, confirm="received forced march training"},
            {id="shield_wall", flavor="Salvaged shields, reinforced and fitted. Your front line holds firmer.",
                label="Shield Wall", description="Choose 5 units. Each gains +10% blade/pierce/impact resistance.",
                image="attacks/heater-shield.png", target="pick", pick_count=5, confirm="received shield wall training"},
            {id="leadership_training", flavor="You promote a veteran to field officer. Nearby troops fight harder under their command.",
                label="Leadership Training", description="Choose 1 unit. Grants Leadership (+25% damage to adjacent allies).",
                image="icons/circlet_winged.png", target="pick", pick_count=1, confirm="promoted to field officer"},
            {id="skirmisher_training", flavor="Your scouts teach the art of slipping past enemy lines.",
                label="Skirmisher Training", description="Choose 3 units. Grants Skirmisher (ignore enemy ZOC).",
                image="icons/cloak_leather_brown.png", target="pick", pick_count=3, confirm="received skirmisher training"},
            {id="healers_knowledge", flavor="A field medic joins your warband and trains one of your soldiers in the healing arts.",
                label="Healer's Knowledge", description="Choose 1 unit. Grants Heals +4 ability.",
                image="icons/potion_green_small.png", target="pick", pick_count=1, confirm="trained in the healing arts"},
        },
    },
}

-- Boss-specific rewards (50% chance to override the random pick in their category)
BR.boss_rewards = {
    greyhelm    = {cat="stat",   id="greyhelm_steadfast", flavor="You study the dead commander's formation notes. His stubbornness was a weapon — now it's yours.",
        label="Greyhelm's Steadfast", description="Choose 2 units. Grants Steadfast (double resist when defending, max 50%).",
        image="attacks/heater-shield.png", target="pick", pick_count=2, confirm="received Greyhelm's Steadfast"},
    briarwen    = {cat="stat",   id="briarwen_regen", flavor="A living amulet, pulsing with green light, pulled from the druid's staff. The forest's magic lingers.",
        label="Thornweave Amulet", description="Choose 1 unit. Grants Regenerates +4 HP/turn.",
        image="icons/jewelry_necklace_amber.png", target="pick", pick_count=1, confirm="received the Thornweave Amulet"},
    maggash     = {cat="weapon", id="maggash_berserk", flavor="Something changed in the soldiers who survived the horde. They fight like cornered animals now.",
        label="Berserker's Fury", description="Choose 2 units. Adds Berserk to their melee attack.",
        image="attacks/frenzy.png", target="pick", pick_count=2, confirm="received Berserker's Fury"},
    pale_conductor = {cat="weapon", id="conductor_drain", flavor="The necromancer's staff hums with dark energy. Those who wield it feel their wounds close with every strike.",
        label="Conductor's Baton", description="Choose 2 units. Grants Drain on melee attacks.",
        image="attacks/curse.png", target="pick", pick_count=2, confirm="received the Conductor's Baton"},
    sithrak     = {cat="weapon", id="sithrak_fire", flavor="Alchemists salvage the drake's fire glands and distill them into throwable flasks. They burn hot and fast.",
        label="Drakefire Flasks", description="Choose 3 units. Adds a 6×2 fire ranged attack.",
        image="attacks/ember.png", target="pick", pick_count=3, confirm="equipped with drakefire flasks"},
    ironband    = {cat="stat",   id="ironband_discipline", flavor="You study how five fighters held a pass against an army. Their discipline becomes your doctrine.",
        label="Ironband's Discipline", description="Choose 3 units. Each gains +1 movement AND +10% physical resistance.",
        image="icons/breastplate2.png", target="pick", pick_count=3, confirm="received Ironband's Discipline"},
}

-- Helper: pick 1 random from a category pool
local function pick_one(pool)
    if not pool or #pool == 0 then return nil end
    return pool[wesnoth.random(1, #pool)]
end

-- Pre-reveal: resolve which unit the L2/L3 unlock would give
function BR._resolve_unlock(reward)
    if not reward.pre_reveal then return reward end
    local level = reward.id == "unlock_l2" and 2 or 3
    local faction = wesnoth.get_variable("chosen_faction") or "loyalist"
    local pool = BR._get_unlock_pool(faction, level)
    if #pool == 0 then return reward end
    local pick = pool[wesnoth.random(1, #pool)]
    local utype = wesnoth.unit_types[pick]
    local img = utype and utype.image or "icons/amla-default.png"
    local r = {}
    for k, v in pairs(reward) do r[k] = v end
    r.label = "Unlock " .. pick
    r.description = "Add " .. pick .. " (L" .. level .. ") to your recruit list."
    r.image = img
    r._resolved_unit = pick
    r.confirm = pick .. " added to your recruit list"
    return r
end

-- Pick 3 rewards: 1 per category. Boss-specific has 50% to override its category.
function BR.pick_options(tier, boss_id)
    local tier_data = BR.rewards[tier]
    if not tier_data then return {} end

    local picks = {}
    local cats = {"recruit", "weapon", "stat"}
    local boss_reward = boss_id and BR.boss_rewards[boss_id] or nil

    for _, cat in ipairs(cats) do
        local pool = tier_data[cat]
        if not pool or #pool == 0 then goto continue end

        -- Check if boss reward belongs to this category and wins the 50% roll
        if boss_reward and boss_reward.cat == cat and wesnoth.random(1, 2) == 1 then
            picks[#picks+1] = BR._resolve_unlock(boss_reward)
        else
            picks[#picks+1] = BR._resolve_unlock(pick_one(pool))
        end

        ::continue::
    end
    return picks
end

-- Apply a reward. reward = the reward table, units = list of proxy units (for pick-type)
function BR.apply(reward_id, units, reward)
    if reward_id == "unlock_l2" then
        BR._unlock_recruit(2, reward and reward._resolved_unit)
    elseif reward_id == "unlock_l3" then
        BR._unlock_recruit(3, reward and reward._resolved_unit)
    elseif reward_id == "veterans_boon" then
        for _, u in ipairs(wesnoth.units.find_on_recall{side=1}) do
            u.experience = u.experience + math.floor(u.max_experience * 0.4)
            if u.experience >= u.max_experience then
                u.experience = u.max_experience - 1
            end
        end
    elseif reward_id == "war_chest" then
        wesnoth.wml_actions.gold{side=1, amount=120}
    elseif reward_id == "massive_war_chest" then
        wesnoth.wml_actions.gold{side=1, amount=250}
    elseif reward_id == "loyal_champion" then
        BR._add_loyal_champion()
    elseif reward_id == "weapon_spears" then
        for _, u in ipairs(units) do
            u:add_modification("object", {
                id = "boss_reward_spear",
                name = "War Spear",
                T.effect{
                    apply_to = "new_attack",
                    name = "war spear",
                    description = "war spear",
                    icon = "attacks/spear.png",
                    type = "pierce",
                    range = "melee",
                    damage = 7,
                    number = 3,
                    T.specials{
                        T.chance_to_hit{
                            id = "firststrike",
                            name = "firststrike",
                            description = "This unit always strikes first, even when defending.",
                            active_on = "offense",
                        },
                    },
                },
            })
        end
    elseif reward_id == "weapon_bows" then
        for _, u in ipairs(units) do
            u:add_modification("object", {
                id = "boss_reward_bow",
                name = "Shortbow",
                T.effect{
                    apply_to = "new_attack",
                    name = "shortbow",
                    description = "shortbow",
                    icon = "attacks/bow-short.png",
                    type = "pierce",
                    range = "ranged",
                    damage = 5,
                    number = 3,
                },
            })
        end
    elseif reward_id == "weapon_axes" then
        for _, u in ipairs(units) do
            u:add_modification("object", {
                id = "boss_reward_axe",
                name = "War Axe",
                T.effect{
                    apply_to = "new_attack",
                    name = "war axe",
                    description = "war axe",
                    icon = "attacks/axe.png",
                    type = "blade",
                    range = "melee",
                    damage = 9,
                    number = 3,
                },
            })
        end
    elseif reward_id == "weapon_knives" then
        for _, u in ipairs(units) do
            u:add_modification("object", {id="boss_reward_knives", name="Throwing Knives",
                T.effect{apply_to="new_attack", name="throwing knives", description="throwing knives",
                    icon="attacks/dagger-thrown-human.png", type="blade", range="ranged", damage=4, number=3}})
        end
    elseif reward_id == "weapon_maces" then
        for _, u in ipairs(units) do
            u:add_modification("object", {id="boss_reward_mace", name="Mace",
                T.effect{apply_to="new_attack", name="mace", description="mace",
                    icon="attacks/hammer.png", type="impact", range="melee", damage=7, number=3}})
        end
    elseif reward_id == "weapon_crossbows" then
        for _, u in ipairs(units) do
            u:add_modification("object", {id="boss_reward_xbow", name="Crossbow",
                T.effect{apply_to="new_attack", name="crossbow", description="crossbow",
                    icon="attacks/crossbow-human.png", type="pierce", range="ranged", damage=8, number=2}})
        end
    elseif reward_id == "weapon_javelins" then
        for _, u in ipairs(units) do
            u:add_modification("object", {id="boss_reward_javelin", name="Javelin",
                T.effect{apply_to="new_attack", name="javelin", description="javelin",
                    icon="attacks/javelin-human.png", type="pierce", range="ranged", damage=6, number=3}})
        end
    elseif reward_id == "sharpened_blades" then
        for _, u in ipairs(units) do
            u:add_modification("object", {id="boss_reward_sharp", name="Sharpened Blades",
                T.effect{apply_to="attack", range="melee", increase_damage=2}})
        end
    elseif reward_id == "hardened_tips" then
        for _, u in ipairs(units) do
            u:add_modification("object", {id="boss_reward_tips", name="Hardened Tips",
                T.effect{apply_to="attack", range="ranged", increase_damage=2}})
        end
    elseif reward_id == "ironblood" then
        for _, u in ipairs(units) do
            u:add_modification("object", {id="boss_reward_iron", name="Ironblood",
                T.effect{apply_to="hitpoints", increase_total=6}})
        end
    elseif reward_id == "battle_drills" then
        for _, u in ipairs(units) do
            u:add_modification("object", {id="boss_reward_drills", name="Battle Drills",
                T.effect{apply_to="defense", replace=false, T.defense{
                    castle=-10, village=-10, flat=-10, forest=-10, hills=-10, mountain=-10, cave=-10, shallow_water=-10, swamp_water=-10}}})
        end
    elseif reward_id == "fieldcraft" then
        for _, u in ipairs(units) do
            u:add_modification("object", {id="boss_reward_field", name="Fieldcraft",
                T.effect{apply_to="resistance", replace=false,
                    T.resistance{fire=-10, cold=-10, arcane=-10}}})
        end
    elseif reward_id == "poisoned_blades" then
        for _, u in ipairs(units) do
            u:add_modification("object", {id="boss_reward_poison", name="Poisoned Blades",
                T.effect{apply_to="attack", range="melee",
                    T.set_specials{T.poison{id="poison", name="poison",
                        description="This attack poisons living targets."}}}})
        end
    elseif reward_id == "forced_march" then
        for _, u in ipairs(units) do
            u:add_modification("object", {id="boss_reward_march", name="Forced March",
                T.effect{apply_to="movement", increase=1}})
        end
    elseif reward_id == "shield_wall" then
        for _, u in ipairs(units) do
            u:add_modification("object", {id="boss_reward_shield", name="Shield Wall",
                T.effect{apply_to="resistance", replace=false,
                    T.resistance{blade=-10, pierce=-10, impact=-10}}})
        end
    elseif reward_id == "leadership_training" then
        for _, u in ipairs(units) do
            u:add_modification("object", {id="boss_reward_leader", name="Leadership Training",
                T.effect{apply_to="new_ability",
                    T.abilities{T.leadership{id="leadership", name="leadership",
                        description="Adjacent units of lower level will do more damage in combat.",
                        value=25, cumulative="no", affect_self="no"}}}})
        end
    elseif reward_id == "skirmisher_training" then
        for _, u in ipairs(units) do
            u:add_modification("object", {id="boss_reward_skirm", name="Skirmisher Training",
                T.effect{apply_to="new_ability",
                    T.abilities{T.skirmisher{id="skirmisher", name="skirmisher",
                        description="This unit can move through enemy zones of control without being slowed."}}}})
        end
    elseif reward_id == "healers_knowledge" then
        for _, u in ipairs(units) do
            u:add_modification("object", {id="boss_reward_heal", name="Healer's Knowledge",
                T.effect{apply_to="new_ability",
                    T.abilities{T.heals{id="healing", name="heals +4",
                        description="Allows the unit to heal adjacent allied units.",
                        value=4, affect_self="no"}}}})
        end
    -- Boss-specific rewards
    elseif reward_id == "greyhelm_steadfast" then
        for _, u in ipairs(units) do
            u:add_modification("object", {id="boss_greyhelm", name="Greyhelm's Steadfast",
                T.effect{apply_to="new_ability",
                    T.abilities{T.resistance{id="steadfast", name="steadfast",
                        description="This unit's resistances are doubled when defending. (Capped at 50%)",
                        multiply=2, max_value=50, active_on="defense"}}}})
        end
    elseif reward_id == "briarwen_regen" then
        for _, u in ipairs(units) do
            u:add_modification("object", {id="boss_briarwen", name="Thornweave Amulet",
                T.effect{apply_to="new_ability",
                    T.abilities{T.regenerate{id="regenerates", name="regenerates",
                        description="The unit will heal itself 4 HP per turn.",
                        value=4}}}})
        end
    elseif reward_id == "maggash_berserk" then
        for _, u in ipairs(units) do
            u:add_modification("object", {id="boss_maggash", name="Berserker's Fury",
                T.effect{apply_to="attack", range="melee",
                    T.set_specials{T.berserk{id="berserk", name="berserk",
                        description="Whether attacking or defending, this unit will fight until either it or its enemy lies dead.",
                        value=30}}}})
        end
    elseif reward_id == "conductor_drain" then
        for _, u in ipairs(units) do
            u:add_modification("object", {id="boss_conductor", name="Conductor's Baton",
                T.effect{apply_to="attack", range="melee",
                    T.set_specials{T.drains{id="drains", name="drains",
                        description="This unit drains health from living units, healing itself for half the amount of damage it deals."}}}})
        end
    elseif reward_id == "sithrak_fire" then
        for _, u in ipairs(units) do
            u:add_modification("object", {id="boss_sithrak", name="Drakefire Flasks",
                T.effect{apply_to="new_attack", name="drakefire flask", description="drakefire flask",
                    icon="attacks/ember.png", type="fire", range="ranged", damage=6, number=2}})
        end
    elseif reward_id == "ironband_discipline" then
        for _, u in ipairs(units) do
            u:add_modification("object", {id="boss_ironband", name="Ironband's Discipline",
                T.effect{apply_to="movement", increase=1},
                T.effect{apply_to="resistance", replace=false,
                    T.resistance{blade=-10, pierce=-10, impact=-10}}})
        end
    end
end

-- Unit pools by faction and level
BR._pools = {
    [2] = {
        loyalist = {"Swordsman","Pikeman","Javelineer","Longbowman","Heavy Infantryman","Shock Trooper","Knight","Lancer","White Mage","Red Mage"},
        elf = {"Elvish Hero","Elvish Captain","Elvish Ranger","Elvish Marksman","Elvish Druid","Elvish Sorceress","Elvish Rider","Elvish Scout"},
        orc = {"Orcish Warrior","Orcish Crossbowman","Orcish Slayer","Orcish Archer","Wolf Rider","Troll Warrior","Goblin Pillager","Goblin Knight"},
        undead = {"Revenant","Deathblade","Bone Shooter","Wraith","Shadow","Necromancer","Ghoul","Chocobone"},
        drake = {"Drake Warrior","Drake Flare","Fire Drake","Sky Drake","Drake Glider","Drake Clasher","Drake Thrasher"},
        knalgan = {"Dwarvish Steelclad","Dwarvish Thunderguard","Dwarvish Pathfinder","Rogue","Thug","Bandit","Footpad"},
    },
    [3] = {
        loyalist = {"Royal Guard","Halberdier","General","Master Bowman","Iron Mauler","Paladin","Grand Knight","Mage of Light","Arch Mage"},
        elf = {"Elvish Marshal","Elvish Champion","Elvish Avenger","Elvish Sharpshooter","Elvish Shyde","Elvish Enchantress","Elvish Outrider"},
        orc = {"Orcish Warlord","Orcish Sovereign","Orcish Slurbow","Great Troll","Direwolf Rider","Goblin Rouser"},
        undead = {"Draug","Banebow","Nightgaunt","Spectre","Lich","Ancient Lich","Ghast","Death Knight"},
        drake = {"Drake Blademaster","Drake Flameheart","Inferno Drake","Hurricane Drake","Drake Enforcer","Drake Warden"},
        knalgan = {"Dwarvish Lord","Dwarvish Dragonguard","Dwarvish Explorer","Assassin","Huntsman"},
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
function BR._add_loyal_champion()
    local champions = {
        "Royal Guard","Paladin","Elvish Champion","Orcish Warlord",
        "Revenant","Drake Blademaster","Dwarvish Lord",
    }
    local pick = champions[wesnoth.random(1, #champions)]
    local u = wesnoth.units.create{
        type=pick, side=1, generate_name=true,
        random_traits=true, random_gender=true,
    }
    u:add_modification("trait", {
        id="loyal", name="loyal",
        T.effect{apply_to="loyal"},
    })
    u:to_recall()
end

return BR
