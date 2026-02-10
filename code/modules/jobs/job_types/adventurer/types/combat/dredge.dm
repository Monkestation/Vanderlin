/datum/job/advclass/combat/dredge
	title = "Dredge"
	tutorial = "Peasants and nobles. Saints, sinners, madmen and thieves - who you once were is now irrelevant. \
	Cast from your home for what is undoubtedly a heinous act of violence, your travels have washed you up upon this \
	shiteheap. All you have are your possessions from your former life. Make some coin for yourself, lest you end up dead and gone."
	outfit = /datum/outfit/adventurer/dredge
	category_tags = list(CTAG_ADVENTURER)
	total_positions = 7
	var/armortype
	var/weapontype
	var/randomjob
	var/randomperk
	var/randomtarot

/datum/job/advclass/combat/dredge/New()
	. = ..()
	roll_vars()

/datum/job/advclass/combat/dredge/proc/roll_vars()
	armortype = pickweight(list("Warrior" = 4, "Splint" = 4, "HeavyG" = 4, "Hide" = 3, "Jacket" = 3, "Sailor" = 3, "Peon" = 3, "Ironplate" = 2, "Freak" = 3, "Psy" = 2, "Destitute" = 2, "Berserker" = 2, "Copper" = 1, "Noble" = 1, "BKnight" = 1)) // Armor / Armortype roll. It varies heavily. The more gimmicky / best stuff is generally the rarest
	weapontype = pickweight(list("Axe" = 4, "BigAxe" = 3, "Mace" = 4, "Mage" = 1, "Shield" = 2, "BigMace" = 3, "Spear" = 3, "Messer" = 3, "LSword" = 3, "GSword" = 1, "Shovel" = 3, "Scythe" = 2, "Cutlass" = 3, "Falx" = 3, "Rapier" = 2, "Sword" = 4, "Sword2" = 3, "Flail" = 2, "Bow" = 1, "Fist" = 2, "Daggers" = 3, "MFlail" = 3, "Gun" = 1,)) // Weapon roll
	randomjob = pickweight (list("Farmer" = 3, "Sailor" = 2, "Pickpocket" = 2, "Smith" = 2, "Fisher" = 3, "Doctor" = 2, "Steppes" = 2, "Smart" = 1, "Grappler" = 1, "Lumber" = 2, "Guard" = 2, "Bard" = 2, "Paranoiac" = 1, "Alch" = 2, "Torturer" = 1,)) // 'Job' roll, gives small skill benefits
	randomperk = pickweight (list("Fat" = 3, "Normal" = 3, "Smartish" = 3, "Speedy" = 3, "Lucky" = 3, "Abyssor" = 2, "Packrat" = 2, "Strong" = 1, "Zizo" = 2, "Atheist" = 1, "Graggar" = 1, "Stupid" = 1, "Lockpicks" = 2, "Traps" = 2, "Ring" = 2, "Knives" = 2, "Heel" = 1, "Meek" = 2, "Invisible" = 2, "Zigs" = 2, "Ozium" = 2, "Bomb" = 1,)) // A random trait or a couple of items
	randomtarot = pickweight (list("TFool" = 2, "TMagician" = 2, "THP" = 2, "TEmpress" = 2, "TEmperor" = 2, "THiero" = 2, "TLovers" = 2, "TChariot" = 2, "TStrength" = 2, "THermit" = 2, "JUSTICE" = 2, "THang" = 2, "TDeath" = 2, "TTemperance" = 2, "TDevil" = 2, "TTower" = 2, "TStar" = 2, "TMoon" = 2, "TSun" = 2, "TJudge" = 2, "TWorld" = 2,))

/datum/job/advclass/combat/dredge/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.adjust_skillrank(/datum/skill/combat/wrestling, pick (1,2), TRUE)
	spawned.adjust_skillrank(/datum/skill/combat/unarmed, pick (1,2), TRUE)
	spawned.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
	spawned.adjust_skillrank(/datum/skill/combat/knives, pick(0,0,0,0,0,1,1,1,1,2,), TRUE)
	spawned.adjust_skillrank(/datum/skill/combat/shields, pick(1,2,3), TRUE)
	spawned.adjust_skillrank(/datum/skill/misc/swimming, pick(0,1,2), TRUE)
	spawned.adjust_skillrank(/datum/skill/misc/climbing, pick(0,0,1,2,3), TRUE)
	spawned.adjust_skillrank(/datum/skill/misc/riding, pick(0,1,1,2), TRUE)
	spawned.adjust_skillrank(/datum/skill/misc/reading, pick(0,0,1), TRUE)
	spawned.adjust_skillrank(/datum/skill/combat/polearms, pick(0,0,0,0,0,0,0,1,1,1,1,2,), TRUE) // Weapon rolls include the relevant skill. Rolling 'expert' or 'master' should be rare.
	spawned.adjust_skillrank(/datum/skill/combat/swords, pick(0,0,0,0,0,0,0,1,1,1,1,2,), TRUE)
	spawned.adjust_skillrank(/datum/skill/combat/whipsflails, pick(0,0,0,0,0,0,0,1,1,1,1,2,), TRUE)
	spawned.adjust_skillrank(/datum/skill/combat/axesmaces, pick(0,0,0,0,0,0,0,1,1,1,1,2,), TRUE)

	if(ishumanspecies(spawned)) // This statblock serves to smooth out racial stat-bonuses slightly. Makes room for the RNG to do its shitty work.
		spawned.change_stat(STATKEY_END, -1)
	else if(isdwarf(spawned))
		spawned.change_stat(STATKEY_CON, -1)
		spawned.change_stat(STATKEY_END, -1)
	else if(iself(spawned))
		spawned.change_stat(STATKEY_SPD, -1)
	else if(isaasimar(spawned))
		spawned.change_stat(STATKEY_INT, -1)
	else if(istiefling(spawned))
		spawned.change_stat(STATKEY_PER, -1)
	else if(ishalforc(spawned)) // Get Fucked.
		spawned.change_stat(STATKEY_STR, -1)
		spawned.change_stat(STATKEY_CON, -1)
	else if(israkshari(spawned))
		spawned.change_stat(STATKEY_SPD, -1)
	else if(iskobold(spawned)) // They have it bad enough as is... Oh my sweet lord do they have it bad.
		spawned.change_stat(STATKEY_CON, 1)
		spawned.change_stat(STATKEY_STR, 1)

	switch(armortype)
		if("Warrior")
			spawned.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
			ADD_TRAIT(spawned, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
			to_chat(spawned,span_info("\
			I am a sellsword. A greenhorn, but a sellsword nonetheless.")
			)
		if("Ironplate")
			spawned.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
			spawned.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
			spawned.change_stat(STATKEY_END, -1)
			ADD_TRAIT(spawned, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
			to_chat(spawned,span_info("\
			I am a sellsword by trade. I've held a weapon in my hand for longer than I can remember.")
			)
		if("Splint")
			spawned.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
			spawned.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
			spawned.change_stat(STATKEY_END, 1)
			to_chat(spawned,span_info("\
			I am a sellsword. Heavier armors do not suit my line of work.")
			)
		if("Jacket")
			spawned.change_stat(STATKEY_LCK, 1)
			spawned.change_stat(STATKEY_SPD, 1)
			spawned.change_stat(STATKEY_STR, -1)
			ADD_TRAIT(spawned, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
			ADD_TRAIT(spawned, TRAIT_STEELHEARTED, TRAIT_GENERIC)
			to_chat(spawned,span_info("\
			I'm a stone-cold motherfucker, nothing fazes me anymore.")
			)
		if("Sailor")
			spawned.change_stat(STATKEY_LCK, 1)
			spawned.change_stat(STATKEY_SPD, 2)
			spawned.change_stat(STATKEY_STR, -2)
			ADD_TRAIT(spawned, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
			to_chat(spawned,span_info("\
			I'm used to the wooden floorboards of ships. Long stretches of road grant me boundless energy.")
			)
		if("HeavyG")
			spawned.change_stat(STATKEY_STR, -1)
			ADD_TRAIT(spawned, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
			to_chat(spawned,span_info("\
			I'm light on my feet, I dare somebody try and hit me.")
			)
		if("Peon")
			spawned.change_stat(STATKEY_STR, 1)
			spawned.change_stat(STATKEY_END, 1)
			ADD_TRAIT(spawned, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
			to_chat(spawned,span_info("\
			I'm just a humble peasant. My upbringing has left me ill-equipped for the journey ahead, but sturdier than most.")
			)
		if("Berserker")
			spawned.change_stat(STATKEY_STR, -1)
			spawned.change_stat(STATKEY_END, 1)
			spawned.change_stat(STATKEY_SPD, 1)
			ADD_TRAIT(spawned, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
			ADD_TRAIT(spawned, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
			to_chat(spawned,span_info("\
			Like a raging current, I am unrelenting. My attacks will chip at my enemy until their skin sloughs, and their bones litter the dry, sandy shores.")
			)
		if("Psy")
			spawned.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
			ADD_TRAIT(spawned, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
			ADD_TRAIT(spawned, TRAIT_STEELHEARTED, TRAIT_GENERIC)
			if(!spawned.has_language(/datum/language/oldpsydonic))
				spawned.grant_language(/datum/language/oldpsydonic)
				to_chat(spawned, "<span class='info'>I can speak Old Psydonic with ,m before my speech.</span>")
			if(!istype(spawned.patron, /datum/patron/psydon)) // don't overwrite extremist psydon
				spawned.set_patron(/datum/patron/psydon, TRUE)
			to_chat(spawned,span_info("\
			The Ten are false gods, and I loathe those that worship the true corpse god, Necra. Psydon lives, my life for Psydon.")
			)
		if("Hide")
			spawned.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
			spawned.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
			spawned.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
			ADD_TRAIT(spawned, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
			spawned.change_stat(STATKEY_SPD, 1)
			spawned.change_stat(STATKEY_CON, 1)
			to_chat(spawned,span_info("\
			Dendor provides. The only armor I need are hides taken from the backs of his beasts.")
			)
		if("Freak")
			ADD_TRAIT(spawned, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
			ADD_TRAIT(spawned, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
			spawned.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
			spawned.adjust_skillrank(/datum/skill/labor/butchering, 3, TRUE)
			spawned.change_stat(STATKEY_CON, 2)
			spawned.change_stat(STATKEY_INT, -2)
			spawned.change_stat(STATKEY_SPD, -2)
			to_chat(spawned,span_info("\
			I like the pain. My calloused hide protects me from critical strikes.")
			)
		if("Destitute") // Fuck you, die. Welcome to Heartcrit. Dark souls challenge run.
			ADD_TRAIT(spawned, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
			ADD_TRAIT(spawned, TRAIT_DEADNOSE, TRAIT_GENERIC)
			spawned.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
			spawned.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
			spawned.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
			spawned.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
			spawned.adjust_skillrank(/datum/skill/labor/butchering, 2, TRUE)
			spawned.adjust_skillrank(/datum/skill/craft/tanning, 1, TRUE)
			spawned.change_stat(STATKEY_CON, -2)
			spawned.change_stat(STATKEY_STR, 1)
			spawned.change_stat(STATKEY_END, -2)
			spawned.change_stat(STATKEY_INT, -3)
			spawned.change_stat(STATKEY_PER, -2)
			spawned.change_stat(STATKEY_SPD, 2)
			spawned.change_stat(STATKEY_LCK, -1)
			to_chat(spawned,span_info("\
			God won't let me die. My life is a momentary lapse of reason. All will fall to ruin, even me.")
			)
		if("Noble") // Congratulations, you're important! Or were, rather.
			spawned.adjust_skillrank(/datum/skill/misc/reading, pick(2,3), TRUE)
			spawned.adjust_skillrank(/datum/skill/misc/music, 2, TRUE)
			spawned.change_stat(STATKEY_INT, 2)
			spawned.change_stat(STATKEY_END, -1)
			spawned.change_stat(STATKEY_CON, -1)
			spawned.change_stat(STATKEY_SPD, 1)
			ADD_TRAIT(spawned, TRAIT_NOBLE, TRAIT_GENERIC)
			ADD_TRAIT(spawned, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
			to_chat(spawned,span_info("\
			I'm an unloved bastard child. Calloused hands do not suit me.")
			)
		if("Copper") // Heavy Copper Armor. The fattest fuck.
			ADD_TRAIT(spawned, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
			spawned.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
			spawned.adjust_skillrank(/datum/skill/craft/cooking, 2, TRUE) // fat
			spawned.change_stat(STATKEY_CON, 1)
			spawned.change_stat(STATKEY_STR, 1)
			spawned.change_stat(STATKEY_PER, -2)
			spawned.change_stat(STATKEY_SPD, -3)
			to_chat(spawned,span_info("\
			I'm a champion amongst my people. Grab me, see what happens.")
			)
		if("BKnight") // RARE. DO NOT GIVE THEM BLACKSTEEL SHIT.
			spawned.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE) // heavy armor user
			ADD_TRAIT(spawned, TRAIT_HEAVYARMOR, TRAIT_GENERIC) // Keep this rare. Only a handful of armor users get this.
			ADD_TRAIT(spawned, TRAIT_NOBLE, TRAIT_GENERIC)
			spawned.change_stat(STATKEY_CON, 3)
			spawned.change_stat(STATKEY_PER, -3)
			spawned.change_stat(STATKEY_STR, 2)
			spawned.change_stat(STATKEY_END, 2)
			spawned.change_stat(STATKEY_SPD, -5)
			var/prev_real_name = spawned.real_name
			var/prev_name = spawned.name
			var/honorary = "Black Knight"
			spawned.real_name = "[honorary] [prev_real_name]"
			spawned.name = "[honorary] [prev_name]"
			to_chat(spawned,span_info("\
			Forgive me majesty for intruding unannounced. Todae I tilted with a Black Knight from a far land, and unseated him roundly with my lances' blow. I take no credit, because I was sneakily attacked by his ally, and soon dumped in the dirt myself.")
			)
	switch(weapontype)
		if("Axe")
			spawned.adjust_skillrank(/datum/skill/combat/axesmaces, 3, TRUE)
			spawned.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
			spawned.cmode_music = 'sound/music/cmode/adventurer/CombatOutlander2.ogg'
			to_chat(spawned,span_info("\
			I prefer a practical instrument of war.")
			)
		if("BigAxe")
			spawned.adjust_skillrank(/datum/skill/combat/axesmaces, 3, TRUE)
			spawned.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
			spawned.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
			spawned.change_stat(STATKEY_SPD, -1) // big boy
			spawned.cmode_music = 'sound/music/cmode/adventurer/CombatIntense.ogg'
			to_chat(spawned,span_info("\
			Only the strong can survive in the wilds, Dendor fears my axe.")
			)
		if("Mace")
			spawned.adjust_skillrank(/datum/skill/combat/axesmaces, 3, TRUE)
			spawned.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
			spawned.cmode_music = 'sound/music/cmode/adventurer/CombatWarrior.ogg'
			to_chat(spawned,span_info("\
			I do not need skill to win a fight, only raw strength. Clubs are my tool of war.")
			)
		if("Shovel") // Rare roll, might as well get some stat benefits
			spawned.adjust_skillrank(/datum/skill/combat/axesmaces, 3, TRUE)
			spawned.adjust_skillrank(/datum/skill/misc/lockpicking, 2, TRUE)
			spawned.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
			spawned.change_stat(STATKEY_LCK, 1)
			spawned.change_stat(STATKEY_SPD, 1)
			spawned.change_stat(STATKEY_END, 2)
			spawned.cmode_music = 'sound/music/cmode/church/CombatGravekeeper.ogg'
			to_chat(spawned,span_info("\
			Fools underestimate the might of the shovel, for it is the great communicator, and shepherd of the dead.")
			)
		if("BigMace")
			spawned.adjust_skillrank(/datum/skill/combat/axesmaces, 3, TRUE)
			spawned.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
			spawned.change_stat(STATKEY_SPD, -1) // big boy
			spawned.cmode_music = 'sound/music/cmode/nobility/CombatKnight.ogg'
			to_chat(spawned,span_info("\
			I've known nobody who can stop the might of my hammer. My might shall carve mountains in twain.")
			)
		if("Messer") // Nobody uses these goddamn things.
			spawned.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
			spawned.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
			spawned.change_stat(STATKEY_STR, 1)
			spawned.change_stat(STATKEY_SPD, -2)
			spawned.cmode_music = 'sound/music/cmode/adventurer/CombatOutlander.ogg'
			to_chat(spawned,span_info("\
			I dare a motherfucker try and disarm me.")
			)
		if("Daggers")
			spawned.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
			spawned.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
			spawned.change_stat(STATKEY_STR, -1)
			spawned.change_stat(STATKEY_SPD, 2)
			spawned.cmode_music = 'sound/music/cmode/nobility/CombatSpymaster.ogg'
			to_chat(spawned,span_info("\
			I'm a whirlwind of chaos. Walk into me and die.")
			)
		if("Scythe")
			spawned.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
			spawned.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
			spawned.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
			spawned.change_stat(STATKEY_END, 1)
			spawned.cmode_music = 'sound/music/cmode/adventurer/CombatMonk.ogg'
			to_chat(spawned,span_info("\
			I'm the lord of the harvest. I will shepherd the damned to Necra herself.")
			)
		if("MFlail")
			spawned.adjust_skillrank(/datum/skill/combat/whipsflails, 3, TRUE)
			spawned.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
			spawned.change_stat(STATKEY_STR, 1)
			spawned.change_stat(STATKEY_END, 1)
			spawned.cmode_music = 'sound/music/cmode/adventurer/CombatOutlander.ogg'
			to_chat(spawned,span_info("\
			The flail is an ancient weapon. If it's good enough for my ancestors, it's good enough for me.")
			)
		if("Shield") // THE WALL
			spawned.adjust_skillrank(/datum/skill/combat/shields, pick(2,2,3), TRUE)
			spawned.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
			spawned.change_stat(STATKEY_CON, 2)
			spawned.change_stat(STATKEY_SPD, -3)
			spawned.change_stat(STATKEY_PER, -3)
			spawned.change_stat(STATKEY_END, 4)
			spawned.cmode_music = 'sound/music/cmode/church/CombatAstrata.ogg'
			to_chat(spawned,span_info("\
			No man on earth can make me fall. I am a bulwark, my offense is my defense.")
			)
		if("Spear")
			spawned.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
			spawned.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
			spawned.cmode_music = 'sound/music/cmode/towner/CombatInn.ogg'
			to_chat(spawned,span_info("\
			I'm a cautious sort, I prefer to keep my enemies at range.")
			)
		if("Rapier")
			spawned.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
			spawned.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
			spawned.cmode_music = 'sound/music/cmode/church/CombatInquisitor.ogg'
			to_chat(spawned,span_info("\
			Fighting is an art, and I am an artist.")
			)
		if("Cutlass")
			spawned.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
			spawned.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
			spawned.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
			spawned.cmode_music = 'sound/music/cmode/antag/CombatLich.ogg'
			to_chat(spawned,span_info("\
			There's nothing more intimidating than someone with a weapon in each hand.")
			)
		if("Falx")
			spawned.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
			spawned.adjust_skillrank(/datum/skill/combat/axesmaces, 3, TRUE)
			spawned.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
			spawned.cmode_music = 'sound/music/cmode/church/CombatInquisitor.ogg'
			to_chat(spawned,span_info("\
			I prefer the weaponry of a bygone age.")
			)
		if("Sword")
			spawned.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
			spawned.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
			spawned.cmode_music = 'sound/music/cmode/adventurer/CombatWarrior.ogg'
			to_chat(spawned,span_info("\
			I'm a practical person, the sword is my weapon of choice.")
			)
		if("LSword")
			spawned.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
			spawned.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
			spawned.cmode_music = 'sound/music/cmode/antag/combat_cult.ogg'
			to_chat(spawned,span_info("\
			I've brought my father's sword with me on my journey to the grave. Come forth and die.")
			)
		if("GSword")
			spawned.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
			spawned.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
			spawned.change_stat(STATKEY_SPD, -1)
			spawned.cmode_music = 'sound/music/cmode/antag/combat_werewolf.ogg'
			to_chat(spawned,span_info("\
			Like a wounded bird, I endure the rain with grace. With my sword I take fate into my own hands and strangle it.")
			)
		if("Mage")
			spawned.mana_pool?.set_intrinsic_recharge(MANA_ALL_LEYLINES)
			if(!(spawned.patron == /datum/patron/divine/noc || /datum/patron/inhumen/zizo))	//Magicians must follow Noc or Zizo to have access to magic.
				spawned.set_patron(/datum/patron/divine/noc, TRUE)
			spawned.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
			spawned.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
			spawned.adjust_skillrank(/datum/skill/craft/alchemy, 2, TRUE)
			spawned.adjust_skillrank(/datum/skill/magic/arcane, 3, TRUE)
			spawned.change_stat(STATKEY_INT, 3)
			spawned.change_stat(STATKEY_CON, -2)
			spawned.change_stat(STATKEY_SPD, -2)
			spawned.adjust_spell_points(6)
			spawned.cmode_music = 'sound/music/cmode/adventurer/CombatSorcerer.ogg'
			to_chat(spawned,span_info("\
			I've studied the arcyne, those who step to me shall perish.")
			)
		if("Sword2")
			spawned.change_stat(STATKEY_END, 1)
			spawned.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
			spawned.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
			spawned.cmode_music = 'sound/music/cmode/adventurer/CombatWarrior.ogg'
			to_chat(spawned,span_info("\
			Two swords, nothing beats that!")
			)
		if("Flail")
			spawned.adjust_skillrank(/datum/skill/combat/whipsflails, 3, TRUE)
			spawned.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
			spawned.change_stat(STATKEY_CON, 1)
			spawned.change_stat(STATKEY_END, 2)
			spawned.change_stat(STATKEY_SPD, -1)
			spawned.change_stat(STATKEY_PER, -2)
			spawned.cmode_music = 'sound/music/cmode/towner/CombatInn.ogg'
			to_chat(spawned,span_info("\
			I am an instrument of pain. The humen body is my canvas.")
			)
		if("Fist")
			spawned.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
			spawned.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
			spawned.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
			spawned.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
			spawned.change_stat(STATKEY_SPD, 1)
			spawned.change_stat(STATKEY_STR, 1)
			spawned.cmode_music = 'sound/music/cmode/Adventurer/CombatMonk.ogg'
			to_chat(spawned,span_info("\
			My mind is a temple, and my body is a weapon of war. I can parry any attack sent my way.")
			)
		if("Gun")
			spawned.adjust_skillrank(/datum/skill/combat/firearms, 3, TRUE)
			spawned.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
			spawned.cmode_music = 'sound/music/cmode/church/CombatInquisitor.ogg'
			spawned.change_stat(STATKEY_PER, 3)
			ADD_TRAIT(spawned, TRAIT_LIGHT_STEP, TRAIT_GENERIC)
			to_chat(spawned,span_info("\
			In this world, there are two kinds of people. Those with loaded guns, and those who dig.")
			)
	switch(randomjob)
		if("Farmer")
			spawned.adjust_skillrank(/datum/skill/labor/farming, 2, TRUE)
			spawned.adjust_skillrank(/datum/skill/labor/taming, 1, TRUE)
			ADD_TRAIT(spawned, TRAIT_SEEDKNOW, TRAIT_GENERIC)
			to_chat(spawned,span_info("\
			I toiled the fields in my youth. Farmwork makes me hungry.")
			)
		if("Sailor")
			spawned.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
			spawned.adjust_skillrank(/datum/skill/labor/fishing, 1, TRUE)
			spawned.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
			spawned.change_stat(STATKEY_STR, -1)
			to_chat(spawned,span_info("\
			I've worked on ships defending their cargo. I am no stranger to Abyssor's wrath.")
			)
		if("Pickpocket")
			spawned.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
			spawned.adjust_skillrank(/datum/skill/misc/stealing, 3, TRUE)
			spawned.adjust_skillrank(/datum/skill/misc/lockpicking, 2, TRUE)
			spawned.change_stat(STATKEY_STR, -2)
			to_chat(spawned,span_info("\
			Some people in this city are too rich for their own good. Luckily they have me to give them a hand.")
			)
		if("Smith")
			spawned.adjust_skillrank(/datum/skill/labor/mining, 2, TRUE)
			spawned.adjust_skillrank(/datum/skill/craft/smelting, 1, TRUE)
			spawned.adjust_skillrank(/datum/skill/craft/blacksmithing, 2, TRUE)
			spawned.change_stat(STATKEY_INT, -1)
			spawned.change_stat(STATKEY_CON, 1)
			to_chat(spawned,span_info("\
			The heat of the forge yet warms my body. I yearn for the mines.")
			)
		if("Cook")
			spawned.adjust_skillrank(/datum/skill/labor/butchering, 1, TRUE)
			spawned.adjust_skillrank(/datum/skill/craft/cooking, 2, TRUE)
			to_chat(spawned,span_info("\
			I'm a natural in the kitchen!")
			)
		if("Fisher")
			spawned.adjust_skillrank(/datum/skill/labor/fishing, 2, TRUE)
			spawned.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
			spawned.change_stat(STATKEY_PER, 2)
			to_chat(spawned,span_info("\
			Fish fear me. I've lived off Abyssor's bounty, both salt-and-freshwater.")
			)
		if("Doctor")
			spawned.adjust_skillrank(/datum/skill/misc/sewing, 2, TRUE)
			spawned.adjust_skillrank(/datum/skill/misc/medicine, 2, TRUE)
			spawned.change_stat(STATKEY_INT, 1)
			ADD_TRAIT(spawned, TRAIT_DEADNOSE, TRAIT_GENERIC)
			to_chat(spawned,span_info("\
			I've studied anatomy, and used to practice medicine.")
			)
		if("Grappler")
			spawned.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
			spawned.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
			spawned.change_stat(STATKEY_INT, -1)
			to_chat(spawned,span_info("\
			I'm a professional grappler. I made money beating the snot out of idiots.")
			)
		if("Guard")
			spawned.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
			spawned.change_stat(STATKEY_INT, -1)
			add_verb(spawned, /mob/proc/haltyell)
			to_chat(spawned,span_info("\
			I was once part of a town militia. I'm used to apprehending unsavory sorts.")
			)
		if("Lumber")
			spawned.adjust_skillrank(/datum/skill/labor/lumberjacking, 3, TRUE)
			spawned.adjust_skillrank(/datum/skill/craft/carpentry, 2, TRUE)
			spawned.change_stat(STATKEY_INT, 1)
			to_chat(spawned,span_info("\
			I was a lumberjack once, wise as an oak too.")
			)
		if("Paranoiac")
			spawned.change_stat(STATKEY_PER, 3)
			spawned.change_stat(STATKEY_CON, -2)
			ADD_TRAIT(spawned, TRAIT_FASTSLEEP, TRAIT_GENERIC)
			to_chat(spawned,span_info("\
			In the dark corners of every room I see him. I can't sleep without a light-source.")
			)
		if("Bard")
			spawned.inspiration = new /datum/inspiration(spawned)
			spawned.adjust_skillrank(/datum/skill/misc/music, 3, TRUE)
			spawned.change_stat(STATKEY_INT, 1)
			spawned.change_stat(STATKEY_END, 1)
			ADD_TRAIT(spawned, TRAIT_BARDIC_TRAINING, TRAIT_GENERIC)
			to_chat(spawned,span_info("\
			I used to be a bard, the skills never left me. I'm a silver-tongued devil!")
			)
		if("Smart")
			spawned.adjust_skillrank(/datum/skill/misc/reading, 4, TRUE)
			spawned.adjust_skillrank(/datum/skill/misc/music, rand(2,3), TRUE)
			spawned.adjust_skillrank(/datum/skill/craft/alchemy, 1, TRUE)
			spawned.change_stat(STATKEY_INT, 3)
			spawned.change_stat(STATKEY_CON, -1)
			spawned.change_stat(STATKEY_PER, -2)
			spawned.virginity = TRUE
			spawned.grant_language(/datum/language/elvish)
			spawned.grant_language(/datum/language/celestial)
			spawned.grant_language(/datum/language/oldpsydonic)
			to_chat(spawned,span_info("\
			I was a scribe in my former years. I'm well-educated and can speak a couple languages.")
			)
		if("Steppes")
			spawned.adjust_skillrank(/datum/skill/labor/taming, 2, TRUE)
			spawned.adjust_skillrank(/datum/skill/craft/tanning, 2, TRUE)
			spawned.adjust_skillrank(/datum/skill/misc/riding, 2, TRUE)
			spawned.change_stat(STATKEY_PER, 1)
			spawned.change_stat(STATKEY_INT, -2)
			spawned.change_stat(STATKEY_END, 1)
			to_chat(spawned,span_info("\
			I'm from the steppes. Civilized society is unbeknownst to me.")
			)
		if("Alch")
			spawned.adjust_skillrank(/datum/skill/craft/alchemy, 2, TRUE)
			spawned.adjust_skillrank(/datum/skill/magic/arcane, pick(1,2), TRUE)
			spawned.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
			spawned.change_stat(STATKEY_PER, 1)
			spawned.change_stat(STATKEY_INT, 1)
			spawned.change_stat(STATKEY_END, -1)
			to_chat(spawned,span_info("\
			I'm knowledgeable about potions. Concoctions and tinctures were once my livelihood.")
			)
		if("Torturer")
			spawned.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
			spawned.adjust_skillrank(/datum/skill/craft/traps, 2, TRUE)
			add_verb(spawned, /mob/living/carbon/human/proc/torture_victim)
			spawned.change_stat(STATKEY_INT, -1)
			to_chat(spawned,span_info("\
			I like to collect teeth. Torturing people was once my livelihood.")
			)
	switch(randomperk)
		if("Fat")
			spawned.change_stat(STATKEY_SPD, -1)
			to_chat(spawned,span_info("\
			I packed enough supplies to last the week. I like to eat well.")
			)
		if("Lockpicks")
			spawned.adjust_skillrank(/datum/skill/misc/lockpicking, 1, TRUE)
			to_chat(spawned,span_info("\
			Who am I, and how did I get here? Well, I'm a locksmith, and I'm a locksmith, that's how.")
			)
		if("Traps")
			spawned.adjust_skillrank(/datum/skill/craft/traps, 3, TRUE)
			to_chat(spawned,span_info("\
			I'm paranoid. I don't leave home without some traps, and I never sleep without a knife on my person.")
			)
		if("Ring")
			spawned.adjust_skillrank(/datum/skill/craft/traps, 3, TRUE)
			to_chat(spawned,span_info("\
			I was married once. I don't want to talk about it. There's a hole in my heart even the gods cannot mend.")
			)
		if("Knives")
			spawned.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
			spawned.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
			spawned.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
			to_chat(spawned,span_info("\
			You want my weapons? Go on, take them from me.")
			)
		if("Normal")
			to_chat(spawned,span_info("\
			There's nothing too odd with me. I'm mostly normal... Mostly.")
			)
		if("Packrat")
			ADD_TRAIT(spawned, TRAIT_SEEPRICES, TRAIT_GENERIC)
			to_chat(spawned,span_info("\
			I'll sell anything not nailed down. Anything that's nailed down is still being sold, even the floorboards, even the nails.")
			)
		if("Strong")
			spawned.change_stat(STATKEY_STR, 4)
			spawned.change_stat(STATKEY_SPD, -3)
			spawned.change_stat(STATKEY_INT, -2)
			to_chat(spawned,span_info("\
			YOU ARE UP AGAINST THE WALL, AND I AM THE FUCKING WALL!")
			)
		if("Zizo")
			spawned.change_stat(STATKEY_INT, 1)
			spawned.set_patron(/datum/patron/inhumen/zizo, TRUE)
			to_chat(spawned,span_info("\
			CHAOS REIGNS! HAIL ZIZO!")
			)
		if("Abyssor")
			spawned.change_stat(STATKEY_END, 1)
			spawned.set_patron(/datum/patron/divine/abyssor, TRUE)
			to_chat(spawned,span_info("\
			Abyssor swallows my soul, his wrath will never be quenched!")
			)
		if("Graggar")
			spawned.change_stat(STATKEY_END, 1)
			spawned.change_stat(STATKEY_CON, 1)
			spawned.set_patron(/datum/patron/inhumen/graggar, TRUE)
			to_chat(spawned,span_info("\
			FOR ALL WHO DENY THE STRUGGLE, THE TRIUMPHANT OVERCOME! GRAGGAR IS THE BEAST I WORSHIP!")
			)
		if("Speedy")
			spawned.change_stat(STATKEY_SPD, 2)
			to_chat(spawned,span_info("\
			I'm quick on my feet! I move slightly faster than others.")
			)
		if("Lucky")
			spawned.change_stat(STATKEY_LCK, 1)
			to_chat(spawned,span_info("\
			I'm naturally lucky. Things just seem to go my way!")
			)
		if("Smartish")
			spawned.change_stat(STATKEY_INT, 2)
			to_chat(spawned,span_info("\
			I'm a little smarter than other folks, but not by much.")
			)
		if("Atheist")
			spawned.change_stat(STATKEY_INT, 4)
			spawned.change_stat(STATKEY_END, -2)
			spawned.change_stat(STATKEY_STR, -1)
			spawned.set_patron(/datum/faith/godless, TRUE)
			to_chat(spawned,span_info("\
			In this moment, I am euphoric. Not because of any phony god's blessing, but because I am englightened by my intelligence. No gods, no masters.")
			)
		if("Stupid")
			spawned.change_stat(STATKEY_INT, -4)
			spawned.change_stat(STATKEY_CON, 4)
			spawned.change_stat(STATKEY_SPD, -4)
			spawned.set_patron(/datum/faith/godless, TRUE)
			to_chat(spawned,span_info("\
			If I'm going to be dumb, I'm going to be tough. I dare a motherfucker try to end my life.")
			)
		if("Heel")
			spawned.change_stat(STATKEY_CON, 3)
			spawned.change_stat(STATKEY_STR, 2)
			ADD_TRAIT(spawned, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC)
			to_chat(spawned,span_info("\
			I was born under a dark star. Any victory of mine shall be pyrrhic. Todae marks the last week of my life.")
			)
		if("Meek")
			spawned.change_stat(STATKEY_LCK, -1)
			spawned.change_stat(STATKEY_END, 1)
			ADD_TRAIT(spawned, TRAIT_DECEIVING_MEEKNESS, TRAIT_GENERIC)
			to_chat(spawned,span_info("\
			Nobody knows how capable I am of great violence. Anyone who accosts me shall regret it.")
			)
		if("Invisible") // METAL GEAR SOLID V?!!
			spawned.change_stat(STATKEY_LCK, -1)
			spawned.change_stat(STATKEY_CON, -2)
			spawned.adjust_skillrank(/datum/skill/misc/sneaking, 3, TRUE)
			ADD_TRAIT(spawned, TRAIT_DISFIGURED, TRAIT_GENERIC)
			to_chat(spawned,span_info("\
			I forgot to remember to forget. I don't know who I am anymore.")
			)
		if("Bomb")
			to_chat(spawned,span_info("\
			If ever I am struck down, my last act of defiance shall be sending me and my enemy straight to the depths of hell.")
			)
		if("Zigs")
			to_chat(spawned,span_info("\
			I like to relax with the puff of a zig.")
			)
		if("Ozium")
			to_chat(spawned,span_info("\
			I smoke ozium.")
			)
	switch(randomtarot)
		if("TFool")
			spawned.change_stat(STATKEY_SPD, 1)
			to_chat(spawned,span_info("\
			THE FOOL: This is a chance for a new beginning. Starry-eyed, you are willing to brave the road of life.")
			)
		if("TMagician")
			spawned.change_stat(STATKEY_INT, 1)
			to_chat(spawned,span_info("\
			THE MAGICIAN: Nothing in this life will hold you back. You have all the tools you need for victory, all you must do is reach out and grasp it.")
			)
		if("THP")
			spawned.change_stat(STATKEY_PER, 1)
			to_chat(spawned,span_info("\
			THE HIGH PRIESTESS: Look inside, listen to yourself. The answers you seek already lie within. Seek not others, for they shall seek you.")
			)
		if("TEmpress")
			spawned.change_stat(STATKEY_SPD, -1)
			to_chat(spawned,span_info("\
			THE EMPRESS: Around and within, you see and understand everything. Breathe, intake, exhale - you are one, and one is all.")
			)
		if("TEmperor")
			spawned.change_stat(STATKEY_END, -1)
			spawned.change_stat(STATKEY_CON, -1)
			spawned.change_stat(STATKEY_STR, -1)
			spawned.change_stat(STATKEY_INT, 1)
			to_chat(spawned,span_info("\
			THE EMPEROR: You know how much a life may cost, and thusly, you are the judge of it. Other men trust the little voice that chimes in your head.")
			)
		if("THiero")
			spawned.change_stat(STATKEY_PER, -1)
			to_chat(spawned,span_info("\
			THE HIEROPHANT: From one source all things depend. And as such, you raise your head to the heavens, and soon know your next steps. One after the other.")
			)
		if("TLovers")
			spawned.change_stat(STATKEY_END, -1)
			to_chat(spawned,span_info("\
			THE LOVERS: You are in a new place, you are a stranger in a strange land - you are at a crossroads, consider your destiny. Life is strengthened by the bonds we make.")
			)
		if("TChariot")
			spawned.change_stat(STATKEY_SPD, 1)
			spawned.change_stat(STATKEY_CON, -1)
			to_chat(spawned,span_info("\
			THE CHARIOT: Knowledge and mind, spirit and heart. Victory does not come only from meticulous planning, only through wisdom and purpose may you cleave a path forward.")
			)
		if("TStrength")
			spawned.change_stat(STATKEY_STR, -1)
			spawned.change_stat(STATKEY_CON, 1)
			to_chat(spawned,span_info("\
			STRENGTH: Two is one, and one is none. Even if you are alone, you will always have yourself. Whatever life throws at you, know that you will weather the storm.")
			)
		if("THermit")
			spawned.change_stat(STATKEY_INT, 2)
			spawned.change_stat(STATKEY_END, -2)
			to_chat(spawned,span_info("\
			THE HERMIT: Decisions must age like wine. Sometimes it is best to seal yourself away, and allow yourself to ruminate upon your thoughts. Your mind is your library.")
			)
		if("TWOF")
			spawned.change_stat(STATKEY_LCK, 1)
			to_chat(spawned,span_info("\
			THE WHEEL OF FORTUNE: All castles made of sand fall into the sea. The only thing that matters is what is in the now. Heed the call of the game of life.")
			)
		if("JUSTICE")
			spawned.change_stat(STATKEY_END, -2)
			spawned.change_stat(STATKEY_SPD, 1)
			to_chat(spawned,span_info("\
			JUSTICE: Everything is a linear consequence, nothing is a momentary lapse of reason. Take heed and remember that every foul act is a dagger poised behind your back.")
			)
		if("THang")
			spawned.change_stat(STATKEY_END, 1)
			spawned.change_stat(STATKEY_LCK, -1)
			to_chat(spawned,span_info("\
			THE HANGED MAN: Sometimes great feats require small sacrifices.")
			)
		if("TDeath")
			spawned.change_stat(STATKEY_CON, 1)
			spawned.change_stat(STATKEY_STR, -1)
			to_chat(spawned,span_info("\
			DEATH: Leaving this world is not as scary as it sounds. Every ending is a new beginning. Leave not a cliffhanger.")
			)
		if("TTemperance")
			spawned.change_stat(STATKEY_CON, -1)
			spawned.change_stat(STATKEY_END, -1)
			to_chat(spawned,span_info("\
			TEMPERANCE: To live is to be in a raging current. Stay calm, await the branch that is encroaching. Not all are lucky enough to end up in this moment.")
			)
		if("TDevil")
			spawned.change_stat(STATKEY_SPD, -1)
			spawned.change_stat(STATKEY_LCK, -1)
			spawned.change_stat(STATKEY_INT, 1)
			to_chat(spawned,span_info("\
			THE DEVIL: You are locked in the box of your own heart. Unbeknownst to you, the key lies in your own hands. All you need to do is open the door.")
			)
		if("TTower")
			spawned.change_stat(STATKEY_CON, 1)
			spawned.change_stat(STATKEY_STR, 1)
			spawned.change_stat(STATKEY_INT, -2)
			spawned.change_stat(STATKEY_SPD, -1)
			to_chat(spawned,span_info("\
			THE TOWER: To make a strong man, muscles must be broken, time must be made to allow the body to reform. The man dies, the idea does not.")
			)
		if("TStar")
			spawned.change_stat(STATKEY_CON, 1)
			spawned.change_stat(STATKEY_END, -1)
			to_chat(spawned,span_info("\
			THE STAR: Something out there is looking at your journey with hope. If your adventure truly was hopeless, you would be given a sign. Journey forward.")
			)
		if("TMoon")
			spawned.change_stat(STATKEY_STR, 1)
			spawned.change_stat(STATKEY_INT, -1)
			to_chat(spawned,span_info("\
			THE MOON: Inside is the doubt in your gut. Scream, let the world hear it - stoke the fire forth, and let your worries melt away.")
			)
		if("TSun")
			spawned.change_stat(STATKEY_CON, -1)
			spawned.change_stat(STATKEY_SPD, 1)
			to_chat(spawned,span_info("\
			THE SUN: Things will be good, now and forever. Wipe the dirt from your eyes and realize how good life truly is.")
			)
		if("TJudge")
			spawned.change_stat(STATKEY_CON, 1)
			spawned.change_stat(STATKEY_SPD, -1)
			to_chat(spawned,span_info("\
			JUDGEMENT: Infront of you are two roads, one leads to hell, and the other worse - nothing stops you from stepping off of it, and changing the direction of your life.")
			)
		if("TWorld")
			spawned.change_stat(STATKEY_LCK, 1) // Used to be 3, probably unwise. Blame me for writing all of these while I was listening to someone ramble in a VC.
			spawned.change_stat(STATKEY_PER, 1)
			spawned.change_stat(STATKEY_INT, 1)
			spawned.change_stat(STATKEY_SPD, -1)
			to_chat(spawned,span_info("\
			THE WORLD: This is where you are meant to be, what you are meant to do. Whatever happens, happens. You have lived an entire life, and yet you are hungry for the next chapter.")
			)
	roll_vars()

/datum/outfit/adventurer/dredge
	name = "Dredge (Adventurer)"
	shoes = /obj/item/clothing/shoes/boots
	belt = /obj/item/storage/belt/leather
	pants = /obj/item/clothing/pants/tights/colored/black
	backl = /obj/item/storage/backpack/satchel

/datum/outfit/adventurer/dredge/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(equipped_human.mind?.assigned_role.type == /datum/job/advclass/combat/dredge)
		var/datum/job/advclass/combat/dredge/dredge = equipped_human.mind.assigned_role

		switch(dredge.armortype)
			if("Warrior")
				armor = /obj/item/clothing/armor/chainmail/iron
				shirt = /obj/item/clothing/armor/gambeson
				gloves = /obj/item/clothing/gloves/leather
				pants = /obj/item/clothing/pants/tights/colored/uncolored
				head = /obj/item/clothing/head/roguehood
			if("Ironplate")
				armor = /obj/item/clothing/armor/cuirass/iron
				shirt = /obj/item/clothing/armor/gambeson/heavy
				neck = /obj/item/clothing/neck/gorget
				pants = /obj/item/clothing/pants/tights/colored/black
				head = /obj/item/clothing/head/roguehood
			if("Splint")
				armor = /obj/item/clothing/armor/leather/splint
				shirt = /obj/item/clothing/shirt/tunic/colored/black
				wrists = /obj/item/clothing/wrists/bracers/leather
				pants = /obj/item/clothing/pants/tights/colored/uncolored
			if("Jacket")
				armor = /obj/item/clothing/armor/leather/vest/winterjacket
				neck = /obj/item/clothing/neck/coif
				shirt = /obj/item/clothing/shirt/tunic/colored/red
				wrists = /obj/item/clothing/wrists/bracers/leather
				gloves = /obj/item/clothing/gloves/angle
				head = /obj/item/clothing/head/roguehood
				pants = /obj/item/clothing/pants/trou/leather
			if("Sailor")
				armor = /obj/item/clothing/armor/leather/jacket/sea
				shirt = /obj/item/clothing/shirt/tunic/colored/red
				head = /obj/item/clothing/head/helmet/leather/headscarf
				mask = /obj/item/clothing/face/shepherd/clothmask
				pants = /obj/item/clothing/pants/tights/sailor
			if("HeavyG")
				shirt = /obj/item/clothing/armor/gambeson/heavy
				neck = /obj/item/clothing/neck/chaincoif/iron
				gloves = /obj/item/clothing/gloves/leather/advanced
				wrists = /obj/item/clothing/wrists/bracers/leather
				pants = /obj/item/clothing/pants/trou/leather
			if("Peon")
				head = /obj/item/clothing/head/armingcap
				shirt = /obj/item/clothing/shirt/undershirt/colored/random
				armor = /obj/item/clothing/armor/gambeson/light/striped
				gloves = /obj/item/clothing/gloves/leather/advanced
				wrists = /obj/item/clothing/wrists/bracers/leather
				pants = /obj/item/clothing/pants/trou/leather
			if("Berserker")
				head = /obj/item/clothing/head/helmet/leather/headscarf
				gloves = /obj/item/clothing/gloves/leather/advanced
				wrists = /obj/item/clothing/wrists/bracers/leather
				pants = /obj/item/clothing/pants/tights/colored/black
			if("Psy")
				neck = /obj/item/clothing/neck/psycross
				head = /obj/item/clothing/head/brimmed
				shirt = /obj/item/clothing/shirt/undershirt/puritan
				gloves = /obj/item/clothing/gloves/leather/advanced
				wrists = /obj/item/clothing/wrists/bracers/leather
				armor = /obj/item/clothing/armor/leather/vest
				cloak = /obj/item/clothing/cloak/raincloak/colored/mortus
				pants = /obj/item/clothing/pants/tights/colored/black
			if("Hide")
				shirt = /obj/item/clothing/shirt/undershirt/colored/uncolored
				armor = /obj/item/clothing/armor/leather/hide
				cloak = /obj/item/clothing/cloak/raincloak/colored/brown
				gloves = /obj/item/clothing/gloves/leather/advanced
				pants = /obj/item/clothing/pants/tights/colored/black
			if("Freak")
				head = /obj/item/clothing/head/menacing
				neck = /obj/item/clothing/neck/chaincoif/iron
				pants = /obj/item/clothing/pants/tights/colored/black
			if("Destitute") // Fuck you, die. Welcome to Heartcrit. Dark souls challenge run.
				neck = /obj/item/clothing/neck/gorget
				mask = /obj/item/clothing/face/facemask
				pants = /obj/item/clothing/pants/loincloth/colored/black
			if("Noble") // Congratulations, you're important! Or were, rather.
				armor = /obj/item/clothing/armor/cuirass/iron
				shirt = /obj/item/clothing/shirt/tunic/colored
				cloak = /obj/item/clothing/cloak/raincloak/furcloak
				pants = /obj/item/clothing/pants/tights/colored/black
				neck = /obj/item/clothing/neck/chaincoif/iron
				head = /obj/item/clothing/head/fancyhat
				ring = /obj/item/clothing/ring/silver
			if("Copper") // Heavy Copper Armor. The fattest fuck.
				head = /obj/item/clothing/head/helmet/coppercap
				neck = /obj/item/clothing/neck/gorget/copper
				armor = /obj/item/clothing/armor/cuirass/copperchest
				mask = /obj/item/clothing/face/facemask/copper
				wrists = /obj/item/clothing/wrists/bracers/copper
				neck = /obj/item/clothing/neck/gorget/copper
				shirt = /obj/item/clothing/armor/gambeson
				pants = /obj/item/clothing/pants/chainlegs
			if("BKnight") // RARE. DO NOT GIVE THEM BLACKSTEEL SHIT.
				head = /obj/item/clothing/head/menacing
				armor = /obj/item/clothing/armor/cuirass/grenzelhoft
				wrists = /obj/item/clothing/wrists/bracers
				neck = /obj/item/clothing/neck/chaincoif
				shirt = /obj/item/clothing/armor/gambeson
				pants = /obj/item/clothing/pants/tights/colored/black
				backpack_contents = list(/obj/item/clothing/gloves/rare/grenzelplate = 1, /obj/item/clothing/shoes/boots/rare/grenzelplate = 1)
		switch(dredge.weapontype)
			if("Axe")
				beltl = /obj/item/weapon/axe/iron
				beltr = /obj/item/weapon/knife/dagger
			if("BigAxe")
				backr = /obj/item/weapon/polearm/halberd/bardiche/woodcutter
			if("Mace")
				beltl = /obj/item/weapon/mace
				beltr = /obj/item/weapon/knife/dagger
				wrists = /obj/item/rope/chain
			if("Shovel") // Rare roll, might as well get some stat benefits
				beltr = /obj/item/flashlight/flare/torch/lantern
				backr = /obj/item/weapon/shovel
				cloak = /obj/item/clothing/cloak/raincloak/colored/mortus
			if("BigMace")
				backr =	/obj/item/weapon/hammer/sledgehammer
				beltl = /obj/item/weapon/knife/dagger
			if("Messer") // Nobody uses these goddamn things.
				beltl = /obj/item/weapon/sword/scimitar/messer
				beltr = /obj/item/weapon/sword/scimitar/messer
				r_hand = /obj/item/weapon/sword/scimitar/messer
				l_hand = /obj/item/weapon/sword/scimitar/messer
			if("Daggers")
				beltl = /obj/item/weapon/knife/dagger
				beltr = /obj/item/weapon/knife/dagger
			if("Scythe")
				beltl = /obj/item/weapon/knife/dagger
				backr = /obj/item/weapon/sickle/scythe
			if("MFlail")
				r_hand = /obj/item/weapon/flail/towner
			if("Shield") // THE WALL
				beltl = /obj/item/weapon/shield/tower/buckleriron
				r_hand = /obj/item/weapon/shield/tower
			if("Spear")
				backr = /obj/item/weapon/polearm/spear
				beltr = /obj/item/weapon/shield/tower/buckleriron
			if("Rapier")
				beltl = /obj/item/weapon/sword/rapier
				beltr = /obj/item/weapon/shield/tower/buckleriron
			if("Cutlass")
				beltl = /obj/item/weapon/sword/sabre/cutlass
				beltr = /obj/item/weapon/knife/dagger/steel
			if("Falx")
				backr = /obj/item/weapon/sword/coppermesser
				beltl = /obj/item/weapon/mace/bludgeon/copper
				beltr = /obj/item/flashlight/flare/torch/lantern
			if("Sword")
				beltl = /obj/item/weapon/sword/iron
				backr = /obj/item/weapon/shield/wood
			if("LSword")
				backr = /obj/item/weapon/sword/long
			if("GSword")
				backr = /obj/item/weapon/sword/long/greatsword
			if("Mage")
				r_hand = /obj/item/weapon/polearm/woodstaff
				head = /obj/item/clothing/head/roguehood/colored/mage
				armor = /obj/item/clothing/shirt/robe/colored/mage
				beltl = /obj/item/reagent_containers/glass/bottle/manapot
				beltr = /obj/item/book/granter/spellbook/apprentice
			if("Sword2")
				beltl = /obj/item/weapon/sword/short/iron
				beltr = /obj/item/weapon/sword/short/iron
			if("Flail")
				beltl = /obj/item/weapon/flail/militia
				beltr = /obj/item/weapon/whip
				wrists = /obj/item/rope/chain
				armor = /obj/item/clothing/armor/leather/vest
				shirt = /obj/item/clothing/shirt/undershirt/colored/black
				head = /obj/item/clothing/head/menacing
			if("Fist")
				wrists = /obj/item/clothing/wrists/bracers/leather
			if("Gun")
				beltl = /obj/item/gun/ballistic/revolver/grenadelauncher/pistol
				beltr = /obj/item/storage/belt/pouch/bullets
				r_hand = /obj/item/reagent_containers/glass/bottle/aflask
				backpack_contents = list(/obj/item/reagent_containers/glass/bottle/aflask = 2)
		switch(dredge.randomjob)
			if("Cook")
				r_hand = /obj/item/reagent_containers/glass/bucket/pot
				l_hand = /obj/item/cooking/pan
			if("Paranoiac")
				l_hand = /obj/item/flashlight/flare/torch/lantern
			if("Bard")
				l_hand = /obj/item/instrument/guitar
			if("Smart")
				l_hand = /obj/item/clothing/face/spectacles
		switch(dredge.randomperk)
			if("Fat")
				backpack_contents = list(/obj/item/reagent_containers/glass/bottle/wine = 1, /obj/item/reagent_containers/food/snacks/hardtack = 2)
			if("Lockpicks")
				backpack_contents = list(/obj/item/lockpick = 2, /obj/item/weapon/knife/dagger = 1)
			if("Traps")
				backpack_contents = list(/obj/item/restraints/legcuffs/beartrap/crafted = 2)
			if("Ring")
				backpack_contents = list(/obj/item/clothing/ring/gold = 1)
			if("Knives")
				backpack_contents = list(/obj/item/weapon/knife/dagger= 6)
			if("Graggar")
				l_hand = /obj/item/clothing/head/helmet/heavy/sinistar
			if("Invisible") // METAL GEAR SOLID V?!!
				r_hand = /obj/item/clothing/face/facemask
				backpack_contents = list(/obj/item/explosive/bottle = 1, /obj/item/flint = 1)
			if("Zigs")
				backpack_contents = list(/obj/item/storage/fancy/cigarettes/zig = 1, /obj/item/flint = 1)
			if("Ozium")
				backpack_contents = list(/obj/item/reagent_containers/powder/ozium = 2, /obj/item/clothing/face/cigarette/pipe/westman = 1, /obj/item/flint = 1)

