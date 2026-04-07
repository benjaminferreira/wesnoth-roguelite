-- boss1_dialog.lua — Pre-battle dialog between player faction and each boss
-- Returns a table of {boss_id → {faction → {boss_lines, hero_lines}}}
-- Each entry is an array of alternating lines: boss speaks, hero speaks, boss speaks...

local D = {}

-- Format: {speaker, line} where speaker is "boss" or "hero"
D.dialog = {
    greyhelm = {
        loyalist = {
            {"boss", "Another sellsword with delusions of grandeur. I've buried a dozen like you."},
            {"hero", "And yet the kingdom still burns. Some guardian you are."},
            {"boss", "I guard this crossroads. That's more than your king ever did."},
        },
        elf = {
            {"boss", "Elves? This far from the forest? You're lost."},
            {"hero", "We go where the fighting takes us. Today it takes us through you."},
        },
        orc = {
            {"boss", "Orcs at my gate. How original."},
            {"hero", "Open the gate or we open you. Your choice."},
            {"boss", "...I admire the directness, at least."},
        },
        undead = {
            {"boss", "The dead walk. I've seen worse."},
            {"hero", "You will see worse. You will see the last thing you ever see."},
        },
        drake = {
            {"boss", "Dragons. My men trained for this."},
            {"hero", "Your men trained to die, then. We are not dragons. We are worse."},
        },
        knalgan = {
            {"boss", "Dwarves and thieves. What do you want?"},
            {"hero", "What's in your vault, mostly."},
            {"boss", "At least you're honest about it."},
        },
    },
    thornweaver = {
        loyalist = {
            {"boss", "Steel and banners. The forest has no use for either."},
            {"hero", "We're passing through. Step aside or be cut down."},
            {"boss", "No one passes through. The forest decides who enters."},
        },
        elf = {
            {"boss", "Kin. You should know better than to trespass here."},
            {"hero", "This is not your forest alone, Thornweaver. The elders sent us."},
            {"boss", "The elders are fools. The forest speaks to me, not them."},
        },
        orc = {
            {"boss", "Orcs. The forest will swallow you whole."},
            {"hero", "We've eaten worse than trees. Let's go, boys."},
        },
        undead = {
            {"boss", "You bring death into a place of life. The forest rejects you."},
            {"hero", "The forest will learn to accept us. Everything does, eventually."},
        },
        drake = {
            {"boss", "Fire-breathers in a forest. You'll burn yourselves before you burn me."},
            {"hero", "We've burned forests before. Yours is no different."},
            {"boss", "This one is."},
        },
        knalgan = {
            {"boss", "Axes. You brought axes into my forest."},
            {"hero", "Seemed practical."},
        },
    },
    gutripper = {
        loyalist = {
            {"boss", "WAAAGH! Humans! Get 'em, boys!"},
            {"hero", "Form ranks! Hold the line!"},
        },
        elf = {
            {"boss", "Pointy-ears! Hah! Snap 'em off!"},
            {"hero", "Charming. Archers, ready."},
        },
        orc = {
            {"boss", "Another warchief? This land ain't big enough for two of us!"},
            {"hero", "Agreed. One of us leaves. It won't be me."},
            {"boss", "HAH! I like you! I'll kill you last!"},
        },
        undead = {
            {"boss", "Bones! Can't eat bones! Useless!"},
            {"hero", "You won't need to eat where you're going."},
        },
        drake = {
            {"boss", "Big lizards! The boys want dragon steaks tonight!"},
            {"hero", "Your boys will be ash before dinner."},
        },
        knalgan = {
            {"boss", "Short ones! And sneaky ones! CRUSH 'EM!"},
            {"hero", "He's loud. Take out the loud one first."},
        },
    },
    pale_conductor = {
        loyalist = {
            {"narrator", "The necromancer regards you in silence. The dead begin to stir."},
            {"hero", "No words? Fine. Steel speaks louder."},
        },
        elf = {
            {"narrator", "The necromancer's gaze passes over you like a cold wind. The ground shifts."},
            {"hero", "This corruption ends here. Ready yourselves."},
        },
        orc = {
            {"narrator", "The necromancer raises one hand. The earth splits. Bones emerge."},
            {"hero", "Bah. Dead things. Hit 'em till they stop moving."},
        },
        undead = {
            {"narrator", "The necromancer tilts his head, studying you. A rival. An anomaly."},
            {"hero", "You are not the only one who commands the dead."},
        },
        drake = {
            {"narrator", "The necromancer's hollow eyes fix on the flight. He gestures. The ground erupts."},
            {"hero", "Burn the corpses. Burn everything. Leave nothing for him to raise."},
        },
        knalgan = {
            {"narrator", "The necromancer says nothing. The silence is worse than any threat."},
            {"hero", "Creepy. Very creepy. Let's get this over with."},
        },
    },
    embercrest = {
        loyalist = {
            {"boss", "Humans. You build with stone and wonder why it crumbles. We build with fire."},
            {"hero", "Fire dies. Stone endures. We'll see which lasts longer."},
        },
        elf = {
            {"boss", "Wood-dwellers. Your forests burn so beautifully."},
            {"hero", "And your kind falls so quietly. Archers — aim for the wings."},
        },
        orc = {
            {"boss", "Orcs! You have spirit. I'll enjoy this."},
            {"hero", "Less talking, more fighting. That's our way."},
            {"boss", "Ha! A drake could learn to like you."},
        },
        undead = {
            {"boss", "The dead don't burn well. Disappointing."},
            {"hero", "We don't need to burn. We just need to outlast you."},
        },
        drake = {
            {"boss", "Another flight? This territory is claimed."},
            {"hero", "Not anymore. The strongest flight rules. Prove yourself."},
            {"boss", "With pleasure."},
        },
        knalgan = {
            {"boss", "Dwarves. You hide in mountains. We ARE the mountain's fire."},
            {"hero", "Mountains don't burn, lizard. And neither do we."},
        },
    },
    ironband = {
        loyalist = {
            {"boss", "Five of us. However many of you. Seems fair."},
            {"hero", "You're outnumbered and you know it."},
            {"boss", "Numbers aren't everything. Ask the last army that tried this."},
        },
        elf = {
            {"boss", "Elves. Graceful. Fragile. This won't take long."},
            {"hero", "You've never fought elves before, have you?"},
            {"boss", "...fair point. Lads, stay sharp."},
        },
        orc = {
            {"boss", "Orcs. Loud, clumsy, predictable."},
            {"hero", "Predictable? We'll show you predictable."},
            {"boss", "That's... exactly what I expected you to say."},
        },
        undead = {
            {"boss", "The dead. Can't bribe the dead. Can't scare them either. Annoying."},
            {"hero", "You cannot buy your way out of this."},
            {"boss", "Wasn't planning to. Lads — earn your pay."},
        },
        drake = {
            {"boss", "Drakes. Big targets. Thunderguard, you're up."},
            {"hero", "Your thunder won't reach us in the sky."},
            {"boss", "You have to land sometime."},
        },
        knalgan = {
            {"boss", "Well well. Dwarves fighting dwarves. The mountain weeps."},
            {"hero", "The mountain doesn't care. And neither do we. Hand over the passes."},
            {"boss", "Come and take them."},
        },
    },
}

return D
