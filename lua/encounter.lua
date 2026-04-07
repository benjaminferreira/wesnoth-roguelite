-- encounter.lua — Mid-battle encounter system
-- 25% chance per map. Village hex trigger. Level-scaled unit. 70/30 friend/foe.

local ENC = {}

-- Encounter dialogue per unit type
-- Each entry: {greeting, player_response, friendly_resolve, hostile_resolve}
-- greeting: what the encounter unit says when discovered
-- player_response: what the player's hero says back
-- friendly_resolve: unit decides to join (70%)
-- hostile_resolve: unit decides to fight (30%)
ENC.dialogue = {
    -- === BATS ===
    ["Blood Bat"] = {
        "*Screeeech!*",
        "Easy now... easy...",
        "*The bat circles once, then settles on your shoulder. It seems... tame.*",
        "*The bat lunges for your throat!*",
    },
    ["Dread Bat"] = {
        "*A terrible shriek echoes from the rafters.*",
        "Steady, everyone.",
        "*The creature descends and perches nearby, watching with unsettling intelligence.*",
        "*It dives at you with fangs bared!*",
    },
    -- === DRAKES ===
    ["Drake Burner"] = {
        "You walk through my territory, warm-blood. Explain yourself.",
        "We fight a common enemy. Your flame would serve well.",
        "Hmph. Fine. But I lead the charge when there is burning to do.",
        "Territory is territory. You should not have come here.",
    },
    ["Fire Drake"] = {
        "I smell battle on you. Good. I was getting bored.",
        "There's plenty more where that came from. Join us.",
        "At last, someone worth following into a fight.",
        "Or perhaps I will take your supplies and find my own fight.",
    },
    -- === DWARVES ===
    ["Dwarvish Berserker"] = {
        "RAAAAGH! Oh. You're not orcs.",
        "No, we're not. But we know where some are.",
        "Well why didn't you say so! Lead the way!",
        "Doesn't matter. I need to hit SOMETHING!",
    },
    ["Dwarvish Runesmith"] = {
        "Careful where you step. These runes are delicate work.",
        "A runesmith? We could use your craft.",
        "My forge was destroyed. Yours will do. Show me to it.",
        "You've already ruined three hours of inscriptions. Pay for them. With blood.",
    },
    ["Dwarvish Ulfserker"] = {
        "*Heavy breathing* ...Who dares?",
        "A friend, if you'll have one.",
        "*The wild-eyed dwarf grins* Friends don't last long around me. But sure.",
        "*He raises his axes* Neither do enemies!",
    },
    -- === ELVES ===
    ["Elvish Captain"] = {
        "Halt. State your purpose in these lands.",
        "We march against the Corrupted King. Will you stand with us?",
        "The corruption spreads to our forests too. I will join your cause.",
        "I have heard such promises before. Draw your weapon.",
    },
    ["Elvish Champion"] = {
        "You fight well. I watched your last engagement from the treeline.",
        "Then you know we could use a blade like yours.",
        "I have been without purpose since my lord fell. Perhaps this is fate.",
        "I watched you fight. I was not impressed.",
    },
    ["Elvish Druid"] = {
        "The trees whisper of your coming. They are... uncertain.",
        "We mean no harm to the forest.",
        "The trees have decided. I will walk with you, for now.",
        "The trees have decided. You should not be here.",
    },
    ["Elvish Hero"] = {
        "Another warband. This land grows crowded with them.",
        "Crowded with enemies, yes. We aim to thin them out.",
        "Ha! Direct. I like that. Count me in.",
        "And how do I know you won't be next?",
    },
    ["Elvish Lord"] = {
        "I am the last of my court. The rest fell to the corruption.",
        "Then fight with us. We will see it ended.",
        "What choice do I have? My people need vengeance. Lead on.",
        "I trusted outsiders once. My court paid the price.",
    },
    ["Elvish Marshal"] = {
        "Your formation is sloppy. Who trained you?",
        "War trained us. Care to improve our odds?",
        "Someone has to keep you alive long enough to win. Fine.",
        "I don't follow amateurs. Defend yourself.",
    },
    ["Elvish Shyde"] = {
        "The light here is wounded. Can you feel it?",
        "We feel it. We fight to heal it.",
        "Then I will lend what light I have left.",
        "You carry too much darkness with you. Stay back.",
    },
    ["Elvish Sorceress"] = {
        "Interesting. Your aura is... complicated.",
        "Is that good or bad?",
        "It means you attract trouble. I find that entertaining. I'm in.",
        "It means you attract trouble. And I don't need more of it.",
    },
    -- === GRYPHONS ===
    ["Gryphon Rider"] = {
        "Ho there! Saw your banners from above. Quite the mess you're in.",
        "Could use eyes in the sky. Interested?",
        "Been flying solo too long anyway. Let's ride!",
        "Actually, I was thinking about those supply wagons of yours...",
    },
    ["Gryphon Master"] = {
        "My gryphon and I have been patrolling these skies for weeks. Alone.",
        "You don't have to be alone anymore.",
        "No. I suppose I don't. We'll fly with you.",
        "Alone is safer. Especially from people like you.",
    },
    -- === HUMANS ===
    ["Arch Mage"] = {
        "Do you have any idea how rare a quiet place to study is these days?",
        "My apologies. But we need someone of your talent.",
        "*Sigh* Fine. But I'm bringing my books.",
        "You've interrupted my research for the last time.",
    },
    ["Dark Sorcerer"] = {
        "Don't look at me like that. Not all of us serve the darkness willingly.",
        "Then serve the light. Fight with us.",
        "The light? Ha. But I'll fight beside you. The enemy of my enemy.",
        "Serve the light? You're as naive as you look.",
    },
    ["Duelist"] = {
        "You there. You look like you know which end of a sword to hold.",
        "I've had some practice. Join us and you'll get plenty more.",
        "Practice makes perfect. And I do love perfection.",
        "Let's test that practice, shall we?",
    },
    ["General"] = {
        "I commanded a garrison of two hundred. Now it's just me.",
        "Command our forces instead. We need leadership.",
        "A smaller army, but at least this one's still breathing. I accept.",
        "I lost two hundred men following orders. I won't follow yours.",
    },
    ["Heavy Infantryman"] = {
        "*Clank clank clank* ...Oh. People.",
        "Need a wall of steel? We've got a spot for you.",
        "Point me at something to stand in front of. That's what I do.",
        "I've been walking for three days in this armor. I'm in a bad mood.",
    },
    ["Lieutenant"] = {
        "I deserted my post when the corruption took our commander. No regrets.",
        "No judgment here. We need officers.",
        "Then I'll earn my rank properly this time.",
        "Deserter once, deserter always? Maybe. But I won't desert my own skin.",
    },
    ["Mage"] = {
        "Who goes there? This is my home, don't think I won't defend myself!",
        "Quiet your worries. We're here in peace.",
        "Peace? In these times? ...Fine. But you're buying me dinner after this.",
        "Peace? With that army? Taste my fireball!",
    },
    ["Mage of Light"] = {
        "The corruption is strong here. I've been holding it back alone.",
        "You don't have to hold it alone anymore.",
        "Thank the light. I was running out of strength. Let us go together.",
        "And let strangers into my sanctum? I think not.",
    },
    ["Red Mage"] = {
        "Ah, visitors! I was just experimenting with a new combustion spell.",
        "We could use that kind of firepower.",
        "Finally, someone who appreciates applied pyromancy! When do we start?",
        "Actually, I need test subjects. Hold still.",
    },
    ["Sergeant"] = {
        "Lost my whole unit in the last ambush. Been surviving on scraps.",
        "Fall in with us. We'll get you back on your feet.",
        "Yes sir. Feels good to have a chain of command again.",
        "Last time I followed someone's orders, my unit died. No thanks.",
    },
    ["Silver Mage"] = {
        "The ley lines here are disrupted. Something terrible is coming.",
        "We know. We're marching to stop it.",
        "Then you'll need someone who can read the currents. I'm coming.",
        "You're marching toward it? You're mad. Stay away from me.",
    },
    ["White Mage"] = {
        "Are any of your soldiers wounded? I can help.",
        "A healer! We'd be grateful for your aid.",
        "Healing is my calling. I'll tend to your wounded and fight beside you.",
        "I said I can help. I didn't say I would. Not for free.",
    },
    -- === MERFOLK ===
    ["Mermaid Enchantress"] = {
        "The waters here carry strange songs. Dark ones.",
        "We're trying to silence the source.",
        "Then our melodies are aligned. I will sing with you.",
        "Your kind brings only discord. Begone from these shores.",
    },
    ["Mermaid Initiate"] = {
        "Oh! Surface dwellers! I've read about you!",
        "And we could use friends from the deep.",
        "This is so exciting! I've never been on an adventure before!",
        "Wait... the books said you were dangerous. Stay back!",
    },
    ["Mermaid Priestess"] = {
        "The tides brought you here. That is no coincidence.",
        "Then perhaps the tides mean for us to fight together.",
        "The currents do not lie. I will follow where they lead.",
        "The tides brought you here to be judged. And you are found wanting.",
    },
    ["Mermaid Siren"] = {
        "Your soldiers seem tired. I could sing them to rest... or to war.",
        "War. Definitely war.",
        "A wise choice. My voice will carry your banners forward.",
        "Then let me sing you a different kind of lullaby.",
    },
    -- === ORCS ===
    ["Orcish Assassin"] = {
        "...You almost walked past me. Almost.",
        "A shadow like you could be useful.",
        "I go where the killing is good. Looks like that's with you.",
        "The killing is good right here.",
    },
    ["Orcish Leader"] = {
        "My clan was scattered. I am chief of nothing now.",
        "Lead under our banner. Rebuild.",
        "Hmph. Better than wandering. But I give orders, not take them.",
        "I'd rather die a chief than serve as a dog.",
    },
    ["Orcish Slayer"] = {
        "*Sharpening blade* ...What do you want?",
        "Someone who's good with that blade.",
        "*Grins* I'm better than good. Point me at something.",
        "*Stands up slowly* You'll do for practice.",
    },
    -- === SAURIANS ===
    ["Saurian Oracle"] = {
        "Yesss... the starsss foretold your arrival.",
        "What else do the stars say?",
        "They say I should follow you. The starsss are rarely wrong.",
        "They say you will die here. The starsss are rarely wrong.",
    },
    ["Saurian Prophet"] = {
        "I have ssseen the future. It is... unpleasant for everyone.",
        "Help us change it.",
        "Change it? Hmm. That would be a first. Very well, let usss try.",
        "Change it? No. I intend to be on the winning ssside.",
    },
    ["Saurian Seer"] = {
        "The cold-bloodsss gather for war. I can feel it in the earth.",
        "Then warm-bloods and cold-bloods should stand together.",
        "An unusual alliance. But these are unusual timesss.",
        "Ssstand together? With mammalss? I think not.",
    },
    ["Saurian Soothsayer"] = {
        "Crosss my palm with gold and I will tell your fortune.",
        "How about you join us and make your own fortune?",
        "Hah! A practical one. I like that. Lead on, warm-blood.",
        "Your fortune isss... bad. Very bad. Starting now.",
    },
    -- === TROLLS ===
    ["Troll Hero"] = {
        "ME STRONGEST! YOU... also strong?",
        "Strong enough. Want to smash things together?",
        "SMASH TOGETHER! YES! You smart for tiny person.",
        "ME SMASH YOU FIRST! THEN SMASH OTHER THINGS!",
    },
    ["Troll Shaman"] = {
        "Hrrm. The spirits are restless. They speak of a great darkness.",
        "We fight that darkness. Your spirits could guide us.",
        "The spirits say... yes. But they also say bring food. Lots of food.",
        "The spirits say you ARE the darkness. BEGONE!",
    },
    -- === UNDEAD ===
    ["Chocobone"] = {
        "*The skeletal horse stamps and snorts ethereal mist.*",
        "Easy there... can you be ridden?",
        "*The chocobone lowers its head and kneels, as if remembering an old master.*",
        "*It charges with hollow eyes blazing!*",
    },
    ["Ghost"] = {
        "*A translucent figure drifts through the wall, moaning softly.*",
        "Spirit, are you friend or foe?",
        "*The ghost gestures toward the enemy lines and begins to drift that way. It seems... helpful.*",
        "*The temperature drops. The ghost's moan becomes a scream.*",
    },
    ["Soulless"] = {
        "*A hulking corpse stumbles out of the treeline. Its eyes are empty, but it turns toward you with something like recognition.*",
        "Can it understand us? Is there anything left in there?",
        "*The soulless groans and falls into step behind your troops. It follows orders, after a fashion.*",
        "*The corpse lurches forward, arms swinging. Whatever was left inside is gone.*",
    },
    -- === WOSES ===
    ["Ancient Wose"] = {
        "...You are small. And loud. And you trample the roots.",
        "We mean no disrespect to the forest.",
        "...The forest is dying. Perhaps your war can save what remains. I will walk with you.",
        "...The forest remembers your kind. It does not forgive.",
    },
    ["Elder Wose"] = {
        "The corruption seeps into the soil. I can feel it in my bark.",
        "Help us root it out.",
        "Root it out. Heh. Tree humor. Yes, I will help.",
        "You cannot root out what you do not understand. Leave.",
    },
    ["Wose"] = {
        "*Creaaaak* ...Oh. I thought you were woodcutters.",
        "Definitely not. We need the forest's help.",
        "*Slow nod* ...The forest... agrees. For now.",
        "*The wose's eyes narrow* ...Woodcutters lie too.",
    },
    ["Wose Sapling"] = {
        "*A tiny tree shuffles nervously behind a boulder.*",
        "It's alright, little one. We won't hurt you.",
        "*The sapling peeks out and toddles after you, rustling happily.*",
        "*The sapling hurls a surprisingly painful acorn at your head!*",
    },
    -- === UNLOCKABLE ENCOUNTERS ===
    ["Wose Shaman"] = {
        "The old magic stirs. Someone has been meddling with forces they do not understand.",
        "We're trying to stop whoever that is.",
        "Then you will need the old magic on your side. I will come.",
        "Perhaps YOU are the ones meddling. The forest will judge.",
    },
    ["Wraith"] = {
        "*An icy wind cuts through you as a spectral form materializes.*",
        "Spirit! We are not your enemy.",
        "*The wraith turns toward the enemy lines and drifts forward. It remembers who wronged it.*",
        "*The wraith's hollow eyes fix on you. It remembers nothing but rage.*",
    },
    ["Death Squire"] = {
        "I served a lord once. He is dust now. But my oath remains.",
        "Serve a new cause. One worth dying for. Again.",
        "An oath is an oath. I will serve until I am released.",
        "My oath was to destroy the living. You qualify.",
    },
    ["Shadow"] = {
        "*The shadows in the corner move wrong. Something is watching.*",
        "Show yourself.",
        "*A dark shape detaches from the wall and glides to your side. Silent. Waiting.*",
        "*The shadow lunges from the darkness!*",
    },
    ["Orcish Ruler"] = {
        "You stand before Ruler of the Broken Tusk clan. Kneel.",
        "I kneel to no one. But I could use an ally.",
        "Hah! Spine. I respect that. The Broken Tusk will march with you.",
        "Then you will break like the rest.",
    },
    ["Mermaid Diviner"] = {
        "I have seen your path in the deep waters. It is... treacherous.",
        "All the more reason to have a diviner at our side.",
        "The waters agree. My sight is yours.",
        "The waters show me your defeat. I will not share in it.",
    },
    ["Dwarvish Runemaster"] = {
        "These runes I've carved will outlast every kingdom on this continent.",
        "Help us make sure there's a continent left for them to outlast.",
        "A fair point. My hammer is yours. Mind the inscriptions.",
        "My runes need no kingdom. But they do need silence. Leave.",
    },
    ["Inferno Drake"] = {
        "The ground here is scorched. My doing. I was... practicing.",
        "Practice on our enemies instead.",
        "Bigger targets. Better practice. I accept.",
        "You look flammable enough for practice.",
    },
    ["Drake Flameheart"] = {
        "I carry the eternal flame of my clutch. It must not go out.",
        "We'll keep it burning. Fight with us.",
        "The flame burns brightest in battle. Lead me to one.",
        "The flame says you are fuel, not friend.",
    },
    ["Elvish Enchantress"] = {
        "The weave of magic here is torn. I have been trying to mend it.",
        "We're fighting the ones who tore it.",
        "Then our purposes align. My enchantments are at your disposal.",
        "You carry weapons of iron and war. You are part of the tearing.",
    },
    ["Elvish High Lord"] = {
        "I ruled a kingdom of ten thousand. Now I wander alone.",
        "Rule beside us. Help us build something worth defending.",
        "I have lost everything once. Perhaps that makes me the right one to fight for it.",
        "I lost my kingdom trusting outsiders. Never again.",
    },
    ["Great Troll"] = {
        "*The ground shakes. A massive shape blocks out the sun.*",
        "We... come in peace?",
        "*GRUNT* ...Tiny things bring food? Then tiny things are friends.",
        "*ROAR* TINY THINGS IN GREAT TROLL'S CAVE!",
    },
    ["Death Knight"] = {
        "I have ridden since before your grandfather's grandfather drew breath.",
        "Ride with us. One last campaign.",
        "One last campaign. Yes. That has a ring to it.",
        "I have ridden down better armies than yours.",
    },
    ["Orcish Sovereign"] = {
        "Three clans answer to me. Or they did, before the corruption.",
        "Unite them under our banner. Together we can push it back.",
        "My clans are scattered but not broken. We will fight.",
        "I unite clans by conquest. Starting with yours.",
    },
    ["Lich"] = {
        "Do not be alarmed. I chose this form willingly. The research demanded it.",
        "Your research can wait. The world needs saving first.",
        "Saving the world IS my research. The data will be magnificent.",
        "You interrupted my work. The penalty is death. Yours, specifically.",
    },
    ["Necromancer"] = {
        "Before you judge — I raise the dead to PROTECT the living.",
        "We're not here to judge. We need every advantage we can get.",
        "Finally, someone practical. My servants and I are at your command.",
        "Protect the living? Starting with myself. From you.",
    },
    ["Dwarvish Arcanister"] = {
        "The runes speak of a convergence. All paths lead to the same battle.",
        "Then walk our path. Your knowledge is invaluable.",
        "Knowledge is meant to be applied. Let us apply it violently.",
        "The runes also speak of fools who meddle. That would be you.",
    },
    ["Grand Marshal"] = {
        "I've commanded armies across three kingdoms. All of them fell.",
        "Command ours. We intend to be the last ones standing.",
        "Fourth time's the charm, they say. Nobody says that. But let's try.",
        "Every army I've led has fallen. Yours will be no different.",
    },
    ["Great Mage"] = {
        "The arcane currents are in chaos. Someone is channeling enormous power.",
        "The Corrupted King. Help us stop him.",
        "Stopping a magical catastrophe? That's literally what I trained for.",
        "Enormous power, you say? Perhaps I should be channeling it instead.",
    },
    ["Armageddon Drake"] = {
        "*The air itself ignites as a massive drake lands before you.*",
        "We could use that kind of firepower on our side.",
        "*A deep rumble that might be laughter* Small creatures, big ambitions. I like it.",
        "*The drake inhales deeply. This is going to hurt.*",
    },
    ["Elvish Sylph"] = {
        "The wind carries so much sorrow. I have not heard it this heavy in centuries.",
        "Help us lift it.",
        "A sylph does not fight. But for this... I will make an exception.",
        "The wind says you bring more sorrow, not less. Away with you.",
    },
    ["Ancient Lich"] = {
        "I have watched empires rise and crumble for a thousand years. This one is no different.",
        "Help us make sure it doesn't crumble.",
        "A thousand years of watching. Perhaps it is time to act. Very well.",
        "A thousand years, and mortals still haven't learned. Allow me to teach you.",
    },
}

--- Pick an encounter unit, excluding types already encountered this run
function ENC.pick_unit(battle_number, encounter_pool_unlocked, encountered_csv)
    local min_lvl, max_lvl
    if battle_number <= 5 then
        min_lvl, max_lvl = 0, 1
    elseif battle_number <= 10 then
        min_lvl, max_lvl = 2, 2
    else
        min_lvl, max_lvl = 3, 4
    end

    -- Build set of already-encountered types
    local seen = {}
    if encountered_csv and encountered_csv ~= "" then
        for t in encountered_csv:gmatch("[^,]+") do
            seen[t:match("^%s*(.-)%s*$")] = true
        end
    end

    local candidates = {}
    for _, u in ipairs(ENC.initial_pool) do
        if u.lvl >= min_lvl and u.lvl <= max_lvl and not seen[u.type] then
            table.insert(candidates, u)
        end
    end

    if encounter_pool_unlocked and encounter_pool_unlocked ~= "" then
        for id in encounter_pool_unlocked:gmatch("[^,]+") do
            local uid = id:match("^%s*(.-)%s*$")
            for _, u in ipairs(ENC.unlockable_pool) do
                if u.id == uid and u.lvl >= min_lvl and u.lvl <= max_lvl and not seen[u.type] then
                    table.insert(candidates, u)
                end
            end
        end
    end

    if #candidates == 0 then return nil end
    return candidates[wesnoth.random(1, #candidates)]
end

--- Get dialogue for a unit type
function ENC.get_dialogue(unit_type)
    return ENC.dialogue[unit_type] or {
        "...",
        "Who are you?",
        "*They nod and fall in beside you.*",
        "*They draw their weapon!*",
    }
end

-- Initial encounter pool (available from run 1)
ENC.initial_pool = {
    {id="BloodBat",type="Blood Bat",lvl=1},
    {id="DreadBat",type="Dread Bat",lvl=2},
    {id="DrakeBurner",type="Drake Burner",lvl=1},
    {id="FireDrake",type="Fire Drake",lvl=2},
    {id="DwarvishBerserker",type="Dwarvish Berserker",lvl=2},
    {id="DwarvishRunesmith",type="Dwarvish Runesmith",lvl=2},
    {id="DwarvishUlfserker",type="Dwarvish Ulfserker",lvl=1},
    {id="ElvishCaptain",type="Elvish Captain",lvl=2},
    {id="ElvishChampion",type="Elvish Champion",lvl=3},
    {id="ElvishDruid",type="Elvish Druid",lvl=2},
    {id="ElvishHero",type="Elvish Hero",lvl=2},
    {id="ElvishLord",type="Elvish Lord",lvl=2},
    {id="ElvishMarshal",type="Elvish Marshal",lvl=3},
    {id="ElvishShyde",type="Elvish Shyde",lvl=3},
    {id="ElvishSorceress",type="Elvish Sorceress",lvl=2},
    {id="GryphonMaster",type="Gryphon Master",lvl=2},
    {id="GryphonRider",type="Gryphon Rider",lvl=1},
    {id="ArchMage",type="Arch Mage",lvl=3},
    {id="DarkSorcerer",type="Dark Sorcerer",lvl=2},
    {id="Duelist",type="Duelist",lvl=2},
    {id="General",type="General",lvl=3},
    {id="HeavyInfantryman",type="Heavy Infantryman",lvl=1},
    {id="Lieutenant",type="Lieutenant",lvl=2},
    {id="Mage",type="Mage",lvl=1},
    {id="MageofLight",type="Mage of Light",lvl=3},
    {id="RedMage",type="Red Mage",lvl=2},
    {id="Sergeant",type="Sergeant",lvl=1},
    {id="SilverMage",type="Silver Mage",lvl=3},
    {id="WhiteMage",type="White Mage",lvl=2},
    {id="MermaidEnchantress",type="Mermaid Enchantress",lvl=2},
    {id="MermaidInitiate",type="Mermaid Initiate",lvl=1},
    {id="MermaidPriestess",type="Mermaid Priestess",lvl=2},
    {id="MermaidSiren",type="Mermaid Siren",lvl=3},
    {id="OrcishAssassin",type="Orcish Assassin",lvl=1},
    {id="OrcishLeader",type="Orcish Leader",lvl=1},
    {id="OrcishSlayer",type="Orcish Slayer",lvl=2},
    {id="SaurianOracle",type="Saurian Oracle",lvl=2},
    {id="SaurianProphet",type="Saurian Prophet",lvl=3},
    {id="SaurianSeer",type="Saurian Seer",lvl=3},
    {id="SaurianSoothsayer",type="Saurian Soothsayer",lvl=2},
    {id="TrollHero",type="Troll Hero",lvl=2},
    {id="TrollShaman",type="Troll Shaman",lvl=2},
    {id="Chocobone",type="Chocobone",lvl=2},
    {id="Ghost",type="Ghost",lvl=1},
    {id="Soulless",type="Soulless",lvl=1},
    {id="AncientWose",type="Ancient Wose",lvl=3},
    {id="ElderWose",type="Elder Wose",lvl=2},
    {id="Wose",type="Wose",lvl=1},
    {id="WoseSapling",type="Wose Sapling",lvl=0},
}

-- Unlockable encounter pool (ordered by unlock priority)
ENC.unlockable_pool = {
    {id="WoseShaman",type="Wose Shaman",lvl=2,order=1},
    {id="Wraith",type="Wraith",lvl=2,order=2},
    {id="DeathSquire",type="Death Squire",lvl=2,order=3},
    {id="Shadow",type="Shadow",lvl=2,order=4},
    {id="OrcishRuler",type="Orcish Ruler",lvl=2,order=5},
    {id="MermaidDiviner",type="Mermaid Diviner",lvl=3,order=6},
    {id="DwarvishRunemaster",type="Dwarvish Runemaster",lvl=3,order=7},
    {id="InfernoDrake",type="Inferno Drake",lvl=3,order=8},
    {id="DrakeFlameheart",type="Drake Flameheart",lvl=3,order=9},
    {id="ElvishEnchantress",type="Elvish Enchantress",lvl=3,order=10},
    {id="ElvishHighLord",type="Elvish High Lord",lvl=3,order=11},
    {id="GreatTroll",type="Great Troll",lvl=3,order=12},
    {id="DeathKnight",type="Death Knight",lvl=3,order=13},
    {id="OrcishSovereign",type="Orcish Sovereign",lvl=3,order=14},
    {id="Lich",type="Lich",lvl=3,order=15},
    {id="Necromancer",type="Necromancer",lvl=3,order=16},
    {id="DwarvishArcanister",type="Dwarvish Arcanister",lvl=4,order=17},
    {id="GrandMarshal",type="Grand Marshal",lvl=4,order=18},
    {id="GreatMage",type="Great Mage",lvl=4,order=19},
    {id="ArmageddonDrake",type="Armageddon Drake",lvl=4,order=20},
    {id="ElvishSylph",type="Elvish Sylph",lvl=4,order=21},
    {id="AncientLich",type="Ancient Lich",lvl=4,order=22},
}

return ENC
