-- loot.lua — In-match loot item definitions, spawning, and application
local T = wml.tag
local LOOT = {}

-- Loot tiers: battles 1-4 = tier 1, battles 6-9 = tier 2, battles 11-14 = tier 3
LOOT.items = {
    [1] = {
        {id="loot_crossbow", name="Crossbow",
            find_flavor="A heavy crossbow lies propped against a rock, a bolt still loaded in the groove.",
            equip_flavor="The mechanism clicks smoothly. This will punch through armor at range.",
            desc="Crossbow — 12×1 pierce ranged",
            map_image="items/crossbow.png", dialog_image="attacks/crossbow-human.png",
            apply=function(u)
                u:add_modification("object", {id="loot_crossbow", name="Crossbow",
                    T.effect{apply_to="new_attack", name="crossbow", description="crossbow",
                        icon="attacks/crossbow-human.png", type="pierce", range="ranged", damage=12, number=1}})
            end},
        {id="loot_healthy", name="Healthy Smoothie",
            find_flavor="A strange green concoction in a clay jar, still warm. It smells like moss and vitality.",
            equip_flavor="The liquid goes down thick and warm. A surge of energy spreads through every limb.",
            desc="Grants Healthy trait — +1 HP per level, always rest-heals",
            map_image="items/potion-green.png", dialog_image="icons/potion_green_medium.png",
            apply=function(u)
                u:add_modification("trait", {id="healthy", name="healthy",
                    description="Rest-heals even when moving or fighting. +1 HP per level.",
                    T.effect{apply_to="hitpoints", increase_total=1},
                    T.effect{apply_to="healthy", set="yes"}})
            end},
        {id="loot_quick", name="Scout's Boots",
            find_flavor="Light leather boots tucked beneath a fallen log. The soles are barely worn.",
            equip_flavor="They fit perfectly. Every step feels lighter, faster.",
            desc="Grants Quick trait — +1 movement, -5% HP",
            map_image="items/leather-pack.png", dialog_image="icons/boots_elven.png",
            apply=function(u)
                u:add_modification("trait", {id="quick", name="quick",
                    description="+1 movement, -5% HP.",
                    T.effect{apply_to="movement", increase=1},
                    T.effect{apply_to="hitpoints", increase_total="-5%"}})
            end},
        {id="loot_buckler", name="Iron Buckler",
            find_flavor="A dented shield half-buried in the dirt. The arm strap is stiff but holds.",
            equip_flavor="It's heavier than it looks. A solid bash with this would stagger anyone.",
            desc="Shield Bash — 4×2 impact melee, slow",
            map_image="items/buckler.png", dialog_image="icons/rusty_targ.png",
            apply=function(u)
                u:add_modification("object", {id="loot_buckler", name="Iron Buckler",
                    T.effect{apply_to="new_attack", name="shield bash", description="shield bash",
                        icon="attacks/heater-shield.png", type="impact", range="melee", damage=4, number=2,
                        T.specials{T.slow{id="slow", name="slow",
                            description="This attack slows the target."}}}})
            end},
        {id="loot_poison_knives", name="Poisoned Throwing Knives",
            find_flavor="A bundle of knives wrapped in oilcloth. The blades glisten with something foul.",
            equip_flavor="Handle with care. Whatever coats these blades, it isn't coming off.",
            desc="Poisoned Knives — 4×3 blade ranged, poison",
            map_image="items/dagger-poison.png", dialog_image="attacks/dagger-thrown-poison-human.png",
            apply=function(u)
                u:add_modification("object", {id="loot_poison_knives", name="Poisoned Throwing Knives",
                    T.effect{apply_to="new_attack", name="poisoned knives", description="poisoned knives",
                        icon="attacks/dagger-thrown-poison-human.png", type="blade", range="ranged", damage=4, number=3,
                        T.specials{T.poison{id="poison", name="poison",
                            description="This attack poisons living targets."}}}})
            end},
        {id="loot_resilient", name="Troll Charm",
            find_flavor="A crude stone talisman on a leather cord, half-hidden in the rubble. It pulses faintly.",
            equip_flavor="The stone settles against the chest with a strange warmth. Tougher already.",
            desc="Grants Resilient trait — +4 HP, +1 HP per level",
            map_image="items/talisman-stone.png", dialog_image="icons/stone_ring.png",
            apply=function(u)
                u:add_modification("trait", {id="resilient", name="resilient",
                    description="+4 HP, +1 HP per level.",
                    T.effect{apply_to="hitpoints", increase_total=4},
                    T.effect{apply_to="hitpoints", increase_total=1}})
            end},
        {id="loot_ambush", name="Elven Cloak",
            find_flavor="A cloak draped over a low branch. The fabric shifts color with the light.",
            equip_flavor="In the trees, you'd never see it coming. Perfect for an ambush.",
            desc="Grants Ambush — hide in forest, undetected by enemies",
            map_image="items/cloak-green.png", dialog_image="icons/cloak_leather_brown.png",
            apply=function(u)
                u:add_modification("object", {id="loot_ambush", name="Elven Cloak",
                    T.effect{apply_to="new_ability",
                        T.abilities{T.hides{id="ambush", name="ambush",
                            description="This unit can hide in forest and remain undetected by enemies.",
                            affect_self="yes",
                            T.filter_self{T.filter_location{terrain="*^F*"}}}}}})
            end},
        {id="loot_leadership", name="Royal Ring",
            find_flavor="A gold band engraved with a crown, resting on a flat stone. It catches the light.",
            equip_flavor="Those nearby stand straighter. Something about the ring commands respect.",
            desc="Grants Leadership — adjacent lower-level allies deal +25% damage",
            map_image="items/ring-gold.png", dialog_image="icons/ring_gold.png",
            apply=function(u)
                u:add_modification("object", {id="loot_leadership", name="Royal Ring",
                    T.effect{apply_to="new_ability",
                        T.abilities{T.leadership{id="leadership", name="leadership",
                            description="Adjacent units of lower level will do more damage in combat.",
                            value=25, cumulative="no", affect_self="no"}}}})
            end},
        {id="loot_throwing_axes", name="Throwing Axes",
            find_flavor="Heavy hand axes wedged into a tree stump. Balanced for throwing.",
            equip_flavor="They spin true. One good throw can end a fight before it starts.",
            desc="Throwing Axes — 7×2 blade ranged",
            map_image="items/axe-throwing.png", dialog_image="attacks/axe.png",
            apply=function(u)
                u:add_modification("object", {id="loot_throwing_axes", name="Throwing Axes",
                    T.effect{apply_to="new_attack", name="throwing axe", description="throwing axe",
                        icon="attacks/hatchet.png", type="blade", range="ranged", damage=7, number=2}})
            end},
        {id="loot_heal_potion", name="Healing Potion",
            find_flavor="A glass vial of warm red liquid, nestled in a leather pouch. It smells like copper.",
            equip_flavor="The potion goes down smooth. Wounds close, bruises fade. Good as new.",
            desc="Fully restores health — immediate one-time use",
            map_image="items/potion-red.png", dialog_image="icons/potion_red_medium.png",
            apply=function(u)
                u.hitpoints = u.max_hitpoints
            end},
        {id="loot_orcish_blade", name="Orcish Blade",
            find_flavor="A brutal cleaver driven into the ground. Chipped but sharp.",
            equip_flavor="It was made to hurt, not to last. But right now, it'll do both.",
            desc="Orcish Blade — 9×2 blade melee",
            map_image="items/sword.png", dialog_image="attacks/sword-orcish.png",
            apply=function(u)
                u:add_modification("object", {id="loot_orcish_blade", name="Orcish Blade",
                    T.effect{apply_to="new_attack", name="orcish blade", description="orcish blade",
                        icon="attacks/sword-orcish.png", type="blade", range="melee", damage=9, number=2}})
            end},
    },
    [2] = {
        {id="loot_vampiric", name="Vampiric Blade",
            find_flavor="A dark steel blade rests against a crumbling wall. The metal seems to drink the light.",
            equip_flavor="With every cut, strength flows back. The blade feeds — and so does its wielder.",
            desc="Vampiric Blade — 7×3 blade melee, drains",
            map_image="items/sword-wraith.png", dialog_image="attacks/baneblade.png",
            apply=function(u)
                u:add_modification("object", {id="loot_vampiric", name="Vampiric Blade",
                    T.effect{apply_to="new_attack", name="vampiric blade", description="vampiric blade",
                        icon="attacks/baneblade.png", type="blade", range="melee", damage=7, number=3,
                        T.specials{T.drains{id="drains", name="drains",
                            description="This unit drains health from living units, healing itself for half the damage dealt."}}}})
            end},
        {id="loot_marksman", name="Marksman's Eye",
            find_flavor="A crystal lens set in silver wire, tucked inside a leather case. The world sharpens through it.",
            equip_flavor="Distance means nothing now. Every shot finds its mark.",
            desc="Adds Marksman to ranged — always at least 60% chance to hit",
            map_image="items/bow-crystal.png", dialog_image="attacks/bow-elven.png",
            apply=function(u)
                u:add_modification("object", {id="loot_marksman", name="Marksman's Eye",
                    T.effect{apply_to="attack", range="ranged",
                        T.set_specials{T.chance_to_hit{id="marksman", name="marksman",
                            description="When used offensively, this attack always has at least a 60% chance to hit.",
                            value=60, cumulative="no", active_on="offense"}}}})
            end},
        {id="loot_nightstalk", name="Dark Ring",
            find_flavor="A black iron ring on the ground, barely visible. It seems to swallow the light around it.",
            equip_flavor="At night, the shadows cling like a second skin. Invisible.",
            desc="Grants Nightstalk — invisible during night",
            map_image="items/ring-red.png", dialog_image="attacks/gaze.png",
            apply=function(u)
                u:add_modification("object", {id="loot_nightstalk", name="Dark Ring",
                    T.effect{apply_to="new_ability",
                        T.abilities{T.hides{id="nightstalk", name="nightstalk",
                            description="This unit becomes invisible during night.",
                            affect_self="yes",
                            T.filter_self{T.filter_location{time_of_day="chaotic"}}}}}})
            end},
        {id="loot_sandals", name="Sandals of the Wind",
            find_flavor="Impossibly light footwear resting on a flat stone. The ground barely notices their presence.",
            equip_flavor="Every step covers more ground. The world feels smaller.",
            desc="Grants +1 movement permanently",
            map_image="items/leather-pack.png", dialog_image="icons/sandals.png",
            apply=function(u)
                u:add_modification("object", {id="loot_sandals", name="Sandals of the Wind",
                    T.effect{apply_to="movement", increase=1}})
            end},
        {id="loot_fearless", name="Ring of Fearlessness",
            find_flavor="An ancient ring inscribed with runes of courage, resting in a patch of dry grass.",
            equip_flavor="Fear drains away like water. Day or night, it makes no difference now.",
            desc="Grants Fearless — no Time of Day combat penalty",
            map_image="items/ring-white.png", dialog_image="icons/jewelry_ring_prismatic.png",
            apply=function(u)
                u:add_modification("trait", {id="fearless", name="fearless",
                    description="Fights normally during unfavorable time of day.",
                    T.effect{apply_to="fearless", set="yes"}})
            end},
        {id="loot_slow_venom", name="Slow Venom",
            find_flavor="A stoppered vial of thick, viscous poison. The label reads: 'Apply to arrowheads.'",
            equip_flavor="The coating goes on smooth. Anything hit by these will be sluggish for a while.",
            desc="Adds Slow to ranged attacks — halves target's damage and movement",
            map_image="items/potion-poison.png", dialog_image="attacks/entangle.png",
            apply=function(u)
                u:add_modification("object", {id="loot_slow_venom", name="Slow Venom",
                    T.effect{apply_to="attack", range="ranged",
                        T.set_specials{T.slow{id="slow", name="slow",
                            description="This attack slows the target."}}}})
            end},
        {id="loot_wizard_staff", name="Wizard's Staff",
            find_flavor="A gnarled staff propped against a stone pillar. Fire dances at its tip without burning.",
            equip_flavor="The wood is warm to the touch. Flames leap forth at a thought.",
            desc="Fireball — 8×4 fire ranged, magical (always 70% to hit)",
            map_image="items/staff-plain.png", dialog_image="attacks/fireball.png",
            apply=function(u)
                u:add_modification("object", {id="loot_wizard_staff", name="Wizard's Staff",
                    T.effect{apply_to="new_attack", name="fireball", description="fireball",
                        icon="attacks/fireball.png", type="fire", range="ranged", damage=8, number=4,
                        T.specials{T.chance_to_hit{id="magical", name="magical",
                            description="This attack always has a 70% chance to hit.",
                            value=70, cumulative="no"}}}})
            end},
        {id="loot_warhammer", name="Warhammer",
            find_flavor="A massive hammer embedded in the earth. Too heavy for most — but devastating in the right hands.",
            equip_flavor="The weight is immense, but the balance is perfect. One swing shatters bone.",
            desc="Warhammer — 12×2 impact melee",
            map_image="items/hammer-runic.png", dialog_image="attacks/hammer.png",
            apply=function(u)
                u:add_modification("object", {id="loot_warhammer", name="Warhammer",
                    T.effect{apply_to="new_attack", name="warhammer", description="warhammer",
                        icon="attacks/hammer.png", type="impact", range="melee", damage=12, number=2}})
            end},
    },
    [3] = {
        {id="loot_dragonscale", name="Dragonscale Armor",
            find_flavor="Armor forged from drake scales, gleaming gold beneath a layer of ash.",
            equip_flavor="Fire slides off it like water. Blades barely scratch the surface.",
            desc="Grants +20% fire resistance, +20% blade resistance",
            map_image="items/armor-golden.png", dialog_image="icons/steel_armor.png",
            apply=function(u)
                u:add_modification("object", {id="loot_dragonscale", name="Dragonscale Armor",
                    T.effect{apply_to="resistance", replace=false,
                        T.resistance{fire=-20, blade=-20}}})
            end},
        {id="loot_teleport", name="Teleportation Staff",
            find_flavor="The air crackles around a staff lodged upright in the ground. Reality bends near it.",
            equip_flavor="Step into a village, and step out of another. The staff bends space itself.",
            desc="Grants Teleport — move between any two friendly villages",
            map_image="items/staff-magic.png", dialog_image="attacks/staff-magic.png",
            apply=function(u)
                u:add_modification("object", {id="loot_teleport", name="Teleportation Staff",
                    T.effect{apply_to="new_ability",
                        T.abilities{T.teleport{id="teleport", name="teleport",
                            description="This unit may teleport between any two friendly villages."}}}})
            end},
        {id="loot_crown", name="Crown of Command",
            find_flavor="A crown of tarnished gold resting on a broken throne. It still radiates authority.",
            equip_flavor="The crown settles heavy on the brow. Allies rally. Enemies hesitate.",
            desc="Grants Leadership (+25% ally damage) and Steadfast (double resist defending)",
            map_image="items/talisman-ankh.png", dialog_image="icons/circlet_winged.png",
            apply=function(u)
                u:add_modification("object", {id="loot_crown", name="Crown of Command",
                    T.effect{apply_to="new_ability",
                        T.abilities{
                            T.leadership{id="leadership", name="leadership",
                                description="Adjacent units of lower level will do more damage in combat.",
                                value=25, cumulative="no", affect_self="no"},
                            T.resistance{id="steadfast", name="steadfast",
                                description="This unit's resistances are doubled when defending.",
                                multiply=2, max_value=50, active_on="defense"}}}})
            end},
        {id="loot_berserk_torc", name="Berserker's Torc",
            find_flavor="A twisted iron necklace on the ground, still warm. It hums with barely contained fury.",
            equip_flavor="Rage fills every fiber. Caution is a memory. The fight doesn't end until someone falls.",
            desc="Adds Berserk to melee, grants Strong (+1 melee damage, +1 HP), but -10% all resistances",
            map_image="items/necklace-stone.png", dialog_image="attacks/frenzy.png",
            apply=function(u)
                u:add_modification("object", {id="loot_berserk_torc", name="Berserker's Torc",
                    T.effect{apply_to="attack", range="melee",
                        T.set_specials{T.berserk{id="berserk", name="berserk",
                            description="This unit fights until one side is dead.", value=30}}},
                    T.effect{apply_to="attack", range="melee", increase_damage=1},
                    T.effect{apply_to="hitpoints", increase_total=1},
                    T.effect{apply_to="resistance", replace=false,
                        T.resistance{blade=10, pierce=10, impact=10, fire=10, cold=10, arcane=10}}})
            end},
        {id="loot_flaming_sword", name="Flaming Longsword",
            find_flavor="A longsword wreathed in fire that never dies, embedded in scorched earth.",
            equip_flavor="The flames lick up the blade but never burn the hand. It cuts and sears in equal measure.",
            desc="Flaming Longsword — 10×3 fire melee",
            map_image="items/flame-sword.png", dialog_image="attacks/sword-flaming.png",
            apply=function(u)
                u:add_modification("object", {id="loot_flaming_sword", name="Flaming Longsword",
                    T.effect{apply_to="new_attack", name="flaming sword", description="flaming sword",
                        icon="attacks/sword-flaming.png", type="fire", range="melee", damage=10, number=3}})
            end},
        {id="loot_plague_staff", name="Plague Staff",
            find_flavor="A gnarled staff that reeks of death, leaning against a pile of bones.",
            equip_flavor="The fallen rise again — but they serve a new master now.",
            desc="Adds Plague to melee — kills become Walking Corpses on your side",
            map_image="items/staff-druid.png", dialog_image="attacks/staff-plague.png",
            apply=function(u)
                u:add_modification("object", {id="loot_plague_staff", name="Plague Staff",
                    T.effect{apply_to="attack", range="melee",
                        T.set_specials{T.plague{id="plague", name="plague",
                            description="When a unit is killed by this attack, it is replaced with a Walking Corpse.",
                            type="Walking Corpse"}}}})
            end},
        {id="loot_holy_sword", name="Holy Sword",
            find_flavor="Light pours from a blade half-buried in sacred ground. The undead would recoil at its presence.",
            equip_flavor="The sword hums with divine power. Every strike carries the weight of judgment.",
            desc="Holy Sword — 12×4 arcane melee",
            map_image="items/sword-holy.png", dialog_image="attacks/sword-holy.png",
            apply=function(u)
                u:add_modification("object", {id="loot_holy_sword", name="Holy Sword",
                    T.effect{apply_to="new_attack", name="holy sword", description="holy sword",
                        icon="attacks/sword-holy.png", type="arcane", range="melee", damage=12, number=4}})
            end},
    },
}

-- Get the loot tier for a given battle number
function LOOT.get_tier(bn)
    if bn <= 4 then return 1
    elseif bn >= 6 and bn <= 9 then return 2
    elseif bn >= 11 and bn <= 14 then return 3
    end
    return nil -- boss battles or invalid
end

-- Pick N random items from the appropriate tier
function LOOT.pick_items(bn, count)
    local tier = LOOT.get_tier(bn)
    if not tier then return {} end
    local pool = LOOT.items[tier]
    if not pool or #pool == 0 then return {} end

    local picks = {}
    local used = {}
    for _ = 1, math.min(count, #pool) do
        local idx
        repeat idx = wesnoth.random(1, #pool) until not used[idx]
        used[idx] = true
        picks[#picks + 1] = pool[idx]
    end
    return picks
end

-- Find valid hex for loot placement
-- Prefers fixture-like terrain, avoids castles/keeps/water/mountains
-- Must be at least 50% of map diagonal from player keep
-- Hex distance between two points (offset coordinates)
local function hex_dist(x1, y1, x2, y2)
    -- Convert offset to cube coordinates
    local function to_cube(x, y)
        local cx = x - math.floor(y / 2)
        local cz = y
        local cy = -cx - cz
        return cx, cy, cz
    end
    local ax, ay, az = to_cube(x1, y1)
    local bx, by, bz = to_cube(x2, y2)
    return math.max(math.abs(ax - bx), math.abs(ay - by), math.abs(az - bz))
end

function LOOT.find_loot_hex(info)
    local p1x, p1y = info.p1x, info.p1y
    local p2x, p2y = info.p2x, info.p2y
    local keep_dist = hex_dist(p1x, p1y, p2x, p2y)
    local min_dist = math.max(3, math.floor(keep_dist * 0.5))
    local used = info.used or {}

    local preferred = {}
    local fallback = {}

    for x, y, terr_obj in wesnoth.current.map:iter() do
        local hdist_p1 = hex_dist(x, y, p1x, p1y)
        local hdist_p2 = hex_dist(x, y, p2x, p2y)

        if hdist_p1 >= min_dist and hdist_p1 > 3 and hdist_p2 > 3 then
            local terr = tostring(terr_obj)

            -- Skip impassable, wall, chasm/lava, water, swamp, volcano
            local dominated = terr:find("^X") or terr:find("^Q") or terr:find("^Ww") or terr:find("^Ss") or terr:find("^Mv")
            -- Skip animated overlays
            local animated = terr:find("%^Ebn") or terr:find("%^Ecf") or terr:find("%^Efs") or terr:find("%^Eb$") or terr:find("%^Wm")
            -- Skip villages, gates/doors, impassable/unwalkable overlays
            local blocked = terr:find("%^V") or terr:find("%^Xo") or terr:find("%^Qov") or terr:find("%^Pr") or terr:find("%^Pw")

            if not dominated and not animated and not blocked and not wesnoth.units.get(x, y) and not used[x .. "," .. y] then
                local off_path = (hdist_p1 + hdist_p2) - keep_dist

                local is_fixture = terr:find("%^E") or terr:find("%^I") or terr:find("%^T")
                    or terr:find("Gd") or terr:find("Dd") or terr:find("Hd")
                    or terr:find("^C") or terr:find("^K")

                local entry = {x, y, off_path=off_path}
                if is_fixture then
                    preferred[#preferred + 1] = entry
                else
                    fallback[#fallback + 1] = entry
                end
            end
        end
    end

    local function pick_from(pool)
        if #pool == 0 then return nil end
        table.sort(pool, function(a, b) return a.off_path > b.off_path end)
        local top = math.max(1, math.floor(#pool * 0.4))
        local pick = pool[wesnoth.random(1, top)]
        return {pick[1], pick[2]}
    end

    return pick_from(preferred) or pick_from(fallback)
end

return LOOT
