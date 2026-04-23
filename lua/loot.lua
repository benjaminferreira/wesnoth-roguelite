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
        {id="loot_buckler", name="Iron Buckler",
            find_flavor="A dented shield half-buried in the dirt. The arm strap is stiff but holds.",
            equip_flavor="It's heavier than it looks. A solid bash with this would stagger anyone.",
            desc="Iron Buckler — 4×2 impact melee, slow",
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
        {id="loot_hunting_bow", name="Hunting Bow",
            find_flavor="A well-oiled shortbow hanging from a branch. Someone left in a hurry.",
            equip_flavor="Light, accurate, and deadly at range. A hunter's best friend.",
            desc="Hunting Bow — 5×3 pierce ranged",
            map_image="items/bow.png", dialog_image="attacks/bow.png",
            apply=function(u)
                u:add_modification("object", {id="loot_hunting_bow", name="Hunting Bow",
                    T.effect{apply_to="new_attack", name="hunting bow", description="hunting bow",
                        icon="attacks/bow.png", type="pierce", range="ranged", damage=5, number=3}})
            end},
        {id="loot_old_mace", name="Old Mace",
            find_flavor="A heavy mace half-buried in mud. Rust-spotted but solid.",
            equip_flavor="Bones break just the same whether the mace is pretty or not.",
            desc="Old Mace — 7×2 impact melee",
            map_image="items/mace.png", dialog_image="attacks/mace.png",
            apply=function(u)
                u:add_modification("object", {id="loot_old_mace", name="Old Mace",
                    T.effect{apply_to="new_attack", name="mace", description="mace",
                        icon="attacks/mace.png", type="impact", range="melee", damage=7, number=2}})
            end},
        {id="loot_torch", name="Torch",
            find_flavor="A pitch-soaked torch jammed into a crack in the rock. Still burning.",
            equip_flavor="Fire solves a surprising number of problems.",
            desc="Torch — 6×2 fire melee",
            map_image="items/torch.png", dialog_image="attacks/torch.png",
            apply=function(u)
                u:add_modification("object", {id="loot_torch", name="Torch",
                    T.effect{apply_to="new_attack", name="torch", description="torch",
                        icon="attacks/torch.png", type="fire", range="melee", damage=6, number=2}})
            end},
        {id="loot_rapier", name="Rapier",
            find_flavor="A slender blade resting across a stone. Light as a feather, sharp as spite.",
            equip_flavor="Four quick thrusts before the enemy can blink. Elegance kills.",
            desc="Rapier — 4×4 blade melee",
            map_image="items/sword-short.png", dialog_image="attacks/saber-human.png",
            apply=function(u)
                u:add_modification("object", {id="loot_rapier", name="Rapier",
                    T.effect{apply_to="new_attack", name="rapier", description="rapier",
                        icon="attacks/saber-human.png", type="blade", range="melee", damage=4, number=4}})
            end},
        {id="loot_sling", name="Sling",
            find_flavor="A leather sling and a pouch of smooth stones. Simple but effective.",
            equip_flavor="David had the right idea. A stone at speed cracks bone.",
            desc="Sling — 4×3 impact ranged",
            map_image="items/sling.png", dialog_image="attacks/sling.png",
            apply=function(u)
                u:add_modification("object", {id="loot_sling", name="Sling",
                    T.effect{apply_to="new_attack", name="sling", description="sling",
                        icon="attacks/sling.png", type="impact", range="ranged", damage=4, number=3}})
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
                            value="(25 * (level - other.level))", cumulative="no", affect_self="no",
                            T.affect_adjacent{T.filter{formula="level < other.level"}}}}}})
            end},
        {id="loot_sure_blade", name="Sure Blade",
            find_flavor="An elven short sword resting in a mossy hollow. The edge gleams unnaturally.",
            equip_flavor="Every swing finds its mark. The blade knows where to go.",
            desc="Sure Blade — 5×3 blade melee, marksman",
            map_image="items/sword-2.png", dialog_image="attacks/sword-elven.png",
            apply=function(u)
                u:add_modification("object", {id="loot_sure_blade", name="Sure Blade",
                    T.effect{apply_to="new_attack", name="sure blade", description="sure blade",
                        icon="attacks/sword-elven.png", type="blade", range="melee", damage=5, number=3,
                        T.specials{T.chance_to_hit{id="marksman", name="marksman",
                            description="When used offensively, this attack always has at least a 60% chance to hit.",
                            value=60, cumulative="no", active_on="offense"}}}})
            end},
        {id="loot_mysterious_tome", name="Mysterious Tome",
            find_flavor="A leather-bound book lies open on a stone altar. The pages glow faintly.",
            equip_flavor="Dark words pour from the pages. The air chills. Power answers.",
            desc="Mysterious Tome — 8×2 cold ranged, magical",
            map_image="items/book1.png", dialog_image="attacks/dark-missile.png",
            apply=function(u)
                u:add_modification("object", {id="loot_mysterious_tome", name="Mysterious Tome",
                    T.effect{apply_to="new_attack", name="dark bolt", description="dark bolt",
                        icon="attacks/dark-missile.png", type="cold", range="ranged", damage=8, number=2,
                        T.specials{T.chance_to_hit{id="magical", name="magical",
                            description="This attack always has a 70% chance to hit.",
                            value=70, cumulative="no"}}}})
            end},
        {id="loot_gluttony", name="Vial of Gluttony",
            find_flavor="A murky yellow potion in a cracked vial. It smells of iron and hunger.",
            equip_flavor="A gnawing hunger takes hold. Every kill feeds it. Every kill makes you stronger.",
            desc="Grants Feeding — +1 max HP per kill",
            map_image="items/potion-yellow.png", dialog_image="attacks/fangs.png",
            apply=function(u)
                u:add_modification("object", {id="loot_gluttony", name="Vial of Gluttony",
                    T.effect{apply_to="new_ability",
                        T.abilities{T.feeding{id="feeding", name="feeding",
                            description="This unit gains 1 hitpoint added to its maximum whenever it kills a unit."}}}})
            end},
        {id="loot_frozen_knife", name="Frozen Knife",
            find_flavor="A dagger coated in frost that never melts. The handle burns cold.",
            equip_flavor="The blade bites twice — once with steel, once with winter.",
            desc="Frozen Knife — 4×3 cold melee",
            map_image="items/dagger.png", dialog_image="attacks/dagger-curved.png",
            apply=function(u)
                u:add_modification("object", {id="loot_frozen_knife", name="Frozen Knife",
                    T.effect{apply_to="new_attack", name="frozen knife", description="frozen knife",
                        icon="attacks/dagger-curved.png", type="cold", range="melee", damage=4, number=3}})
            end},
        {id="loot_soldiers_spear", name="Soldier's Spear",
            find_flavor="A sturdy spear driven into the earth beside a dead campfire. Still sharp.",
            equip_flavor="Long reach and a sharp point. Strike first, ask questions never.",
            desc="Soldier's Spear — 7×3 pierce melee, firststrike",
            map_image="items/spear.png", dialog_image="attacks/spear.png",
            apply=function(u)
                u:add_modification("object", {id="loot_soldiers_spear", name="Soldier's Spear",
                    T.effect{apply_to="new_attack", name="spear", description="spear",
                        icon="attacks/spear.png", type="pierce", range="melee", damage=7, number=3,
                        T.specials{T.firststrike{id="firststrike", name="firststrike",
                            description="This unit always strikes first with this attack, even if defending."}}}})
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
        {id="loot_wizard_staff", name="Wizard's Staff",
            find_flavor="A gnarled staff propped against a stone pillar. Fire dances at its tip without burning.",
            equip_flavor="The wood is warm to the touch. Flames leap forth at a thought.",
            desc="Fireball — 8×3 fire ranged, magical",
            map_image="items/staff-plain.png", dialog_image="attacks/fireball.png",
            apply=function(u)
                u:add_modification("object", {id="loot_wizard_staff", name="Wizard's Staff",
                    T.effect{apply_to="new_attack", name="fireball", description="fireball",
                        icon="attacks/fireball.png", type="fire", range="ranged", damage=8, number=3,
                        T.specials{T.chance_to_hit{id="magical", name="magical",
                            description="This attack always has a 70% chance to hit.",
                            value=70, cumulative="no"}}}})
            end},
        {id="loot_warhammer", name="Warhammer",
            find_flavor="A massive hammer embedded in the earth. Too heavy for most — but devastating in the right hands.",
            equip_flavor="The weight is immense, but the balance is perfect. One swing shatters bone.",
            desc="Warhammer — 12×2 impact melee",
            map_image="items/hammer.png", dialog_image="attacks/hammer.png",
            apply=function(u)
                u:add_modification("object", {id="loot_warhammer", name="Warhammer",
                    T.effect{apply_to="new_attack", name="warhammer", description="warhammer",
                        icon="attacks/hammer.png", type="impact", range="melee", damage=12, number=2}})
            end},
        {id="loot_elven_longbow", name="Elven Longbow",
            find_flavor="A longbow of pale wood, strung with silver thread. It hums faintly when drawn.",
            equip_flavor="The arrows fly true and far. Elven craft at its finest.",
            desc="Elven Longbow — 8×3 pierce ranged",
            map_image="items/bow-elven.png", dialog_image="attacks/bow-elven.png",
            apply=function(u)
                u:add_modification("object", {id="loot_elven_longbow", name="Elven Longbow",
                    T.effect{apply_to="new_attack", name="elven longbow", description="elven longbow",
                        icon="attacks/bow-elven.png", type="pierce", range="ranged", damage=8, number=3}})
            end},
        {id="loot_frost_staff", name="Frost Staff",
            find_flavor="A staff of pale blue crystal, cold to the touch. Frost creeps along the ground around it.",
            equip_flavor="Winter answers your call. The air freezes at a gesture.",
            desc="Frost Staff — 7×3 cold ranged, magical",
            map_image="items/staff-plain.png", dialog_image="attacks/iceball.png",
            apply=function(u)
                u:add_modification("object", {id="loot_frost_staff", name="Frost Staff",
                    T.effect{apply_to="new_attack", name="frost bolt", description="frost bolt",
                        icon="attacks/iceball.png", type="cold", range="ranged", damage=7, number=3,
                        T.specials{T.chance_to_hit{id="magical", name="magical",
                            description="This attack always has a 70% chance to hit.",
                            value=70, cumulative="no"}}}})
            end},
        {id="loot_war_pike", name="War Pike",
            find_flavor="A long pike leaning against a ruined wall. The tip is wickedly sharp.",
            equip_flavor="Reach and speed. The enemy falls before they can swing.",
            desc="War Pike — 13×2 pierce melee, firststrike",
            map_image="items/spear-fancy.png", dialog_image="attacks/pike.png",
            apply=function(u)
                u:add_modification("object", {id="loot_war_pike", name="War Pike",
                    T.effect{apply_to="new_attack", name="war pike", description="war pike",
                        icon="attacks/pike.png", type="pierce", range="melee", damage=13, number=2,
                        T.specials{T.firststrike{id="firststrike", name="firststrike",
                            description="This unit always strikes first with this attack, even if defending."}}}})
            end},
        {id="loot_runic_axe", name="Runic Axe",
            find_flavor="A dwarven axe covered in glowing runes. The metal is warm to the touch.",
            equip_flavor="The runes pulse with each swing. Dwarven steel never dulls.",
            desc="Runic Axe — 9×3 blade melee",
            map_image="items/axe.png", dialog_image="attacks/battleaxe.png",
            apply=function(u)
                u:add_modification("object", {id="loot_runic_axe", name="Runic Axe",
                    T.effect{apply_to="new_attack", name="runic axe", description="runic axe",
                        icon="attacks/battleaxe.png", type="blade", range="melee", damage=9, number=3}})
            end},
        {id="loot_mace_disruption", name="Mace of Disruption",
            find_flavor="A mace that glows with a faint white light. The undead would recoil from it.",
            equip_flavor="Holy power courses through the weapon. Every strike dispels dark magic.",
            desc="Mace of Disruption — 7×3 arcane melee",
            map_image="items/mace.png", dialog_image="attacks/mace-spiked.png",
            apply=function(u)
                u:add_modification("object", {id="loot_mace_disruption", name="Mace of Disruption",
                    T.effect{apply_to="new_attack", name="disruption", description="disruption",
                        icon="attacks/mace-spiked.png", type="arcane", range="melee", damage=7, number=3}})
            end},
        {id="loot_javelins", name="Javelins",
            find_flavor="A bundle of javelins wrapped in leather. Balanced for distance.",
            equip_flavor="One good throw can pin an enemy before they close the gap.",
            desc="Javelins — 13×2 pierce ranged",
            map_image="items/spear.png", dialog_image="attacks/javelin-human.png",
            apply=function(u)
                u:add_modification("object", {id="loot_javelins", name="Javelins",
                    T.effect{apply_to="new_attack", name="javelin", description="javelin",
                        icon="attacks/javelin-human.png", type="pierce", range="ranged", damage=13, number=2}})
            end},
        {id="loot_serpent_whip", name="Serpent Whip",
            find_flavor="A coiled whip made from serpent hide. The tip glistens with venom.",
            equip_flavor="Four lashes, each one leaving poison in the wound. Cruel but effective.",
            desc="Serpent Whip — 5×4 blade melee, poison",
            map_image="items/ring-brown.png", dialog_image="attacks/whip.png",
            apply=function(u)
                u:add_modification("object", {id="loot_serpent_whip", name="Serpent Whip",
                    T.effect{apply_to="new_attack", name="serpent whip", description="serpent whip",
                        icon="attacks/whip.png", type="blade", range="melee", damage=5, number=4,
                        T.specials{T.poison{id="poison", name="poison",
                            description="This attack poisons living targets."}}}})
            end},
        {id="loot_chill_touch", name="Chill Touch",
            find_flavor="A ring of black ice. Wearing it makes your fingers numb — and your touch deadly.",
            equip_flavor="Cold radiates from every strike. Enemies slow to a crawl.",
            desc="Chill Touch — 6×3 cold melee, slow",
            map_image="items/ring-white.png", dialog_image="attacks/touch-undead.png",
            apply=function(u)
                u:add_modification("object", {id="loot_chill_touch", name="Chill Touch",
                    T.effect{apply_to="new_attack", name="chill touch", description="chill touch",
                        icon="attacks/touch-undead.png", type="cold", range="melee", damage=6, number=3,
                        T.specials{T.slow{id="slow", name="slow",
                            description="This attack slows the target."}}}})
            end},
        {id="loot_repeating_xbow", name="Repeating Crossbow",
            find_flavor="A mechanical crossbow with a rotating bolt magazine. Dwarven engineering.",
            equip_flavor="Four bolts in rapid succession. Reload later — if there's anyone left.",
            desc="Repeating Crossbow — 6×4 pierce ranged",
            map_image="items/crossbow.png", dialog_image="attacks/crossbow-human.png",
            apply=function(u)
                u:add_modification("object", {id="loot_repeating_xbow", name="Repeating Crossbow",
                    T.effect{apply_to="new_attack", name="repeating crossbow", description="repeating crossbow",
                        icon="attacks/crossbow-human.png", type="pierce", range="ranged", damage=6, number=4}})
            end},
        {id="loot_firebrand", name="Firebrand Sword",
            find_flavor="A sword with a blade of dark iron. Flames dance along the edge without heat.",
            equip_flavor="The fire obeys the blade. Every cut cauterizes — theirs, not yours.",
            desc="Firebrand Sword — 8×3 fire melee",
            map_image="items/flame-sword.png", dialog_image="attacks/sword-flaming.png",
            apply=function(u)
                u:add_modification("object", {id="loot_firebrand", name="Firebrand Sword",
                    T.effect{apply_to="new_attack", name="firebrand", description="firebrand",
                        icon="attacks/sword-flaming.png", type="fire", range="melee", damage=8, number=3}})
            end},
        {id="loot_marksman", name="Marksman's Eye",
            find_flavor="A crystal lens set in silver wire, tucked inside a leather case. The world sharpens through it.",
            equip_flavor="Distance means nothing now. Every shot finds its mark.",
            desc="Adds Marksman to ranged — always at least 60% chance to hit",
            map_image="items/potion-blue.png", dialog_image="attacks/bow-elven.png",
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
        {id="loot_chainmail", name="Dwarven Chainmail",
            find_flavor="A shirt of fine dwarven chain, folded neatly beside a cold forge.",
            equip_flavor="Heavy but reassuring. Blades, arrows, fire — everything hits a little softer.",
            desc="+10% resistance to all attack types",
            map_image="items/armor.png", dialog_image="icons/armor-chain.png",
            apply=function(u)
                u:add_modification("object", {id="loot_chainmail", name="Dwarven Chainmail",
                    T.effect{apply_to="resistance", replace=false,
                        T.resistance{blade=-10, pierce=-10, impact=-10, fire=-10, cold=-10, arcane=-10}}})
            end},
        {id="loot_slow_venom", name="Slow Venom",
            find_flavor="A stoppered vial of thick, viscous poison. The label reads: 'Apply to arrowheads.'",
            equip_flavor="The coating goes on smooth. Anything hit by these will be sluggish for a while.",
            desc="Adds Slow to ranged attacks",
            map_image="items/potion-poison.png", dialog_image="attacks/entangle.png",
            apply=function(u)
                u:add_modification("object", {id="loot_slow_venom", name="Slow Venom",
                    T.effect{apply_to="attack", range="ranged",
                        T.set_specials{T.slow{id="slow", name="slow",
                            description="This attack slows the target."}}}})
            end},
    },
    [3] = {
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
        {id="loot_holy_sword", name="Holy Sword",
            find_flavor="Light pours from a blade half-buried in sacred ground. The undead would recoil at its presence.",
            equip_flavor="The sword hums with divine power. Every strike carries the weight of judgment.",
            desc="Holy Sword — 10×4 arcane melee",
            map_image="items/sword-holy.png", dialog_image="attacks/sword-holy.png",
            apply=function(u)
                u:add_modification("object", {id="loot_holy_sword", name="Holy Sword",
                    T.effect{apply_to="new_attack", name="holy sword", description="holy sword",
                        icon="attacks/sword-holy.png", type="arcane", range="melee", damage=10, number=4}})
            end},
        {id="loot_thunderbolt", name="Thunderbolt Staff",
            find_flavor="A staff crackling with barely contained lightning. The air smells of ozone.",
            equip_flavor="Thunder answers your command. The bolt strikes where you will it.",
            desc="Thunderbolt Staff — 10×4 cold ranged, magical",
            map_image="items/staff-magic.png", dialog_image="attacks/lightning.png",
            apply=function(u)
                u:add_modification("object", {id="loot_thunderbolt", name="Thunderbolt Staff",
                    T.effect{apply_to="new_attack", name="thunderbolt", description="thunderbolt",
                        icon="attacks/lightning.png", type="cold", range="ranged", damage=10, number=4,
                        T.specials{T.chance_to_hit{id="magical", name="magical",
                            description="This attack always has a 70% chance to hit.",
                            value=70, cumulative="no"}}}})
            end},
        {id="loot_greatsword", name="Greatsword of Ruin",
            find_flavor="A massive two-handed blade driven into a cairn of skulls. The edge still gleams.",
            equip_flavor="It takes both hands and all your strength. But what it hits, it destroys.",
            desc="Greatsword of Ruin — 13×3 blade melee",
            map_image="items/sword.png", dialog_image="attacks/greatsword-human.png",
            apply=function(u)
                u:add_modification("object", {id="loot_greatsword", name="Greatsword of Ruin",
                    T.effect{apply_to="new_attack", name="greatsword", description="greatsword",
                        icon="attacks/greatsword-human.png", type="blade", range="melee", damage=13, number=3}})
            end},
        {id="loot_lance_dawn", name="Lance of the Dawn",
            find_flavor="A golden lance planted in the earth, catching the first light of morning.",
            equip_flavor="The charge is everything. Hit hard, hit once, and pray they don't get up.",
            desc="Lance of the Dawn — 17×2 pierce melee, charge",
            map_image="items/spear-fancy.png", dialog_image="attacks/lance.png",
            apply=function(u)
                u:add_modification("object", {id="loot_lance_dawn", name="Lance of the Dawn",
                    T.effect{apply_to="new_attack", name="lance", description="lance",
                        icon="attacks/lance.png", type="pierce", range="melee", damage=17, number=2,
                        T.specials{T.damage{id="charge", name="charge",
                            description="This attack deals double damage when used offensively, but the attacker also takes double damage from the defender's counterattack.",
                            multiply=2, active_on="offense",
                            T.filter_opponent{}}}}})
            end},
        {id="loot_arcane_bow", name="Arcane Bow",
            find_flavor="A bow strung with threads of pure light. The arrows it fires are not arrows at all.",
            equip_flavor="Each shot is a bolt of divine energy. The undead have nowhere to hide.",
            desc="Arcane Bow — 9×4 arcane ranged",
            map_image="items/bow-crystal.png", dialog_image="attacks/lightbeam.png",
            apply=function(u)
                u:add_modification("object", {id="loot_arcane_bow", name="Arcane Bow",
                    T.effect{apply_to="new_attack", name="arcane bow", description="arcane bow",
                        icon="attacks/lightbeam.png", type="arcane", range="ranged", damage=9, number=4}})
            end},
        {id="loot_trident", name="Trident of the Deep",
            find_flavor="A trident of dark coral, dripping with seawater that never dries.",
            equip_flavor="The ocean's fury in your hands. Three prongs, three wounds, one kill.",
            desc="Trident of the Deep — 13×3 pierce melee",
            map_image="items/storm-trident.png", dialog_image="attacks/trident.png",
            apply=function(u)
                u:add_modification("object", {id="loot_trident", name="Trident of the Deep",
                    T.effect{apply_to="new_attack", name="trident", description="trident",
                        icon="attacks/trident.png", type="pierce", range="melee", damage=13, number=3}})
            end},
        {id="loot_stiletto", name="Assassin's Stiletto",
            find_flavor="A thin blade hidden inside a hollow book. The edge is coated in something dark.",
            equip_flavor="Five strikes from the shadows. If they see you coming, you're doing it wrong.",
            desc="Assassin's Stiletto — 7×5 blade melee, backstab",
            map_image="items/dagger.png", dialog_image="attacks/dagger-human.png",
            apply=function(u)
                u:add_modification("object", {id="loot_stiletto", name="Assassin's Stiletto",
                    T.effect{apply_to="new_attack", name="stiletto", description="stiletto",
                        icon="attacks/dagger-human.png", type="blade", range="melee", damage=7, number=5,
                        T.specials{T.damage{id="backstab", name="backstab",
                            description="When used offensively, this attack deals double damage if there is an enemy of the target on the opposite side.",
                            multiply=2, active_on="offense",
                            T.filter_opponent{formula="enemy_of(self, flanker) and flanker.valid"}}}}})
            end},
        {id="loot_masters_staff", name="Master's Staff",
            find_flavor="A quarterstaff of ironwood, worn smooth by decades of use. It feels alive in your hands.",
            equip_flavor="Every swing carries the weight of a lifetime of training.",
            desc="Master's Staff — 10×4 impact melee",
            map_image="items/staff-plain.png", dialog_image="attacks/quarterstaff.png",
            apply=function(u)
                u:add_modification("object", {id="loot_masters_staff", name="Master's Staff",
                    T.effect{apply_to="new_attack", name="staff", description="staff",
                        icon="attacks/quarterstaff.png", type="impact", range="melee", damage=10, number=4}})
            end},
        {id="loot_inferno_staff", name="Inferno Staff",
            find_flavor="A staff of blackened bone. The skull at its tip burns with an unquenchable flame.",
            equip_flavor="The fire answers to no one but you. Point, and the world burns.",
            desc="Inferno Staff — 15×2 fire ranged",
            map_image="items/book2.png", dialog_image="attacks/fireball.png",
            apply=function(u)
                u:add_modification("object", {id="loot_inferno_staff", name="Inferno Staff",
                    T.effect{apply_to="new_attack", name="inferno", description="inferno",
                        icon="attacks/fireball.png", type="fire", range="ranged", damage=15, number=2}})
            end},
        {id="loot_lifestealer", name="Lifestealer",
            find_flavor="A cursed blade that weeps dark ichor. It whispers promises of eternal hunger.",
            equip_flavor="Every wound you inflict heals your own. The blade demands blood — and rewards it.",
            desc="Lifestealer — 9×4 blade melee, drains",
            map_image="items/sword-wraith.png", dialog_image="attacks/baneblade.png",
            apply=function(u)
                u:add_modification("object", {id="loot_lifestealer", name="Lifestealer",
                    T.effect{apply_to="new_attack", name="lifestealer", description="lifestealer",
                        icon="attacks/baneblade.png", type="blade", range="melee", damage=9, number=4,
                        T.specials{T.drains{id="drains", name="drains",
                            description="This unit drains health from living units, healing itself for half the damage dealt."}}}})
            end},
        {id="loot_wand_lightning", name="Wand of Lightning",
            find_flavor="A slender wand that crackles with static. Lightning arcs between your fingers.",
            equip_flavor="Five bolts of lightning in rapid succession. Nothing survives the storm.",
            desc="Wand of Lightning — 8×5 fire ranged",
            map_image="items/staff-magic.png", dialog_image="attacks/lightning.png",
            apply=function(u)
                u:add_modification("object", {id="loot_wand_lightning", name="Wand of Lightning",
                    T.effect{apply_to="new_attack", name="lightning", description="lightning",
                        icon="attacks/lightning.png", type="fire", range="ranged", damage=8, number=5}})
            end},
        {id="loot_dwarven_cannon", name="Dwarven Cannon",
            find_flavor="A portable cannon of dwarven make, complete with powder and shot. Absurdly heavy.",
            equip_flavor="One shot. One massive, earth-shaking, bone-shattering shot.",
            desc="Dwarven Cannon — 35×1 impact ranged",
            map_image="items/thunderstick.png", dialog_image="attacks/thunderstick.png",
            apply=function(u)
                u:add_modification("object", {id="loot_dwarven_cannon", name="Dwarven Cannon",
                    T.effect{apply_to="new_attack", name="cannon", description="cannon",
                        icon="attacks/thunderstick.png", type="impact", range="ranged", damage=35, number=1}})
            end},
        {id="loot_dragonscale", name="Dragonscale Armor",
            find_flavor="Armor forged from drake scales, gleaming gold beneath a layer of ash.",
            equip_flavor="Fire slides off it like water. Blades barely scratch the surface. Even castles feel safer.",
            desc="+20% blade resist, +20% fire resist, +10% defense on castle",
            map_image="items/armor-golden.png", dialog_image="icons/steel_armor.png",
            apply=function(u)
                u:add_modification("object", {id="loot_dragonscale", name="Dragonscale Armor",
                    T.effect{apply_to="resistance", replace=false,
                        T.resistance{fire=-20, blade=-20}},
                    T.effect{apply_to="defense", replace=false,
                        T.defense{castle=-10}}})
            end},
        {id="loot_teleport", name="Teleportation Staff",
            find_flavor="The air crackles around a staff lodged upright in the ground. Reality bends near it.",
            equip_flavor="Step into a village, and step out of another. The staff bends space — and quickens the step.",
            desc="Grants Teleport + 1 movement",
            map_image="items/staff-magic.png", dialog_image="attacks/staff-magic.png",
            apply=function(u)
                u:add_modification("object", {id="loot_teleport", name="Teleportation Staff",
                    T.effect{apply_to="new_ability",
                        T.abilities{T.teleport{id="teleport", name="teleport",
                            description="This unit may teleport between any two friendly villages."}}},
                    T.effect{apply_to="movement", increase=1}})
            end},
        {id="loot_crown", name="Crown of Command",
            find_flavor="A crown of tarnished gold resting on a broken throne. It still radiates authority.",
            equip_flavor="The crown settles heavy on the brow. Allies rally. Enemies hesitate.",
            desc="Grants Leadership + Steadfast",
            map_image="items/talisman-ankh.png", dialog_image="icons/circlet_winged.png",
            apply=function(u)
                u:add_modification("object", {id="loot_crown", name="Crown of Command",
                    T.effect{apply_to="new_ability",
                        T.abilities{
                            T.leadership{id="leadership", name="leadership",
                                description="Adjacent units of lower level will do more damage in combat.",
                                value="(25 * (level - other.level))", cumulative="no", affect_self="no",
                                T.affect_adjacent{T.filter{formula="level < other.level"}}},
                            T.resistance{id="steadfast", name="steadfast",
                                description="This unit's resistances are doubled when defending.",
                                multiply=2, max_value=50, active_on="defense"}}}})
            end},
        {id="loot_berserk_torc", name="Berserker's Torc",
            find_flavor="A twisted iron necklace on the ground, still warm. It hums with barely contained fury.",
            equip_flavor="Rage fills every fiber. Caution is a memory. The fight doesn't end until someone falls.",
            desc="Adds Berserk to melee + Strong (+1 melee dmg, +1 HP)",
            map_image="items/necklace-stone.png", dialog_image="attacks/frenzy.png",
            apply=function(u)
                u:add_modification("object", {id="loot_berserk_torc", name="Berserker's Torc",
                    T.effect{apply_to="attack", range="melee",
                        T.set_specials{T.berserk{id="berserk", name="berserk",
                            description="This unit fights until one side is dead.", value=30}}},
                    T.effect{apply_to="attack", range="melee", increase_damage=1},
                    T.effect{apply_to="hitpoints", increase_total=1}})
            end},
        {id="loot_plague_staff", name="Plague Staff",
            find_flavor="A gnarled staff that reeks of death, leaning against a pile of bones.",
            equip_flavor="The fallen rise again — but they serve a new master now.",
            desc="Adds Plague to melee — kills become Walking Corpses",
            map_image="items/staff-druid.png", dialog_image="attacks/staff-plague.png",
            apply=function(u)
                u:add_modification("object", {id="loot_plague_staff", name="Plague Staff",
                    T.effect{apply_to="attack", range="melee",
                        T.set_specials{T.plague{id="plague", name="plague",
                            description="When a unit is killed by this attack, it is replaced with a Walking Corpse.",
                            type="Walking Corpse"}}}})
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
