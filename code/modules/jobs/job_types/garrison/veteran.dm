/datum/job/veteran
	title = "Veteran"
	tutorial = "There isn't a way to kill a man you havent practiced in the tapestries of war itself. \
	You wouldn't call yourself a hero-- \
	those belong to the men left rotting in the fields where you honed your ancient trade. \
	Tired of senseless killing for men with crowns, you traded stability for a life of adventure. You returned a hero and savior of the lands, but those glory days with your old adventurer party are long gone. \
	The honor has faded, your weary body aches, and your weapons gather dust. Sometimes you wonder how your old friends are doing."
	department_flag = GARRISON
	display_order = JDO_VET
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	faction = FACTION_TOWN
	total_positions = 1
	spawn_positions = 1
	bypass_lastclass = TRUE
	spells = list(/datum/action/cooldown/spell/undirected/list_target/convert_role/militia)
	allowed_sexes = list(MALE, FEMALE)
	allowed_ages = list(AGE_OLD, AGE_IMMORTAL)
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	blacklisted_species = list(SPEC_ID_HALFLING)
	cmode_music = "sound/music/cmode/towner/CombatVeteran.ogg"
	advclass_cat_rolls = list(CTAG_VETERAN = 20)
	give_bank_account = 35
	can_have_apprentices = FALSE
	job_bitflag = BITFLAG_GARRISON
	exp_type = list(EXP_TYPE_ADVENTURER, EXP_TYPE_COMBAT)
	exp_types_granted = list(EXP_TYPE_ADVENTURER, EXP_TYPE_COMBAT)
	exp_requirements = list(
		EXP_TYPE_ADVENTURER = 300,
		EXP_TYPE_COMBAT = 1500
	)

	traits = list(
		TRAIT_OLDPARTY
	)


/datum/job/veteran/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(istype(spawned.cloak, /obj/item/clothing/cloak/half/vet))
		var/obj/item/clothing/S = spawned.cloak
		var/index = findtext(spawned.real_name, " ")
		if(index)
			index = copytext(spawned.real_name, 1, index)
		if(!index)
			index = spawned.real_name
		S.name = "veteran cloak ([index])"

	add_verb(spawned, /mob/proc/haltyell)
	spawned.add_quirk(/datum/quirk/boon/folk_hero)

/datum/job/advclass/veteran
	inherit_parent_title = TRUE
	exp_types_granted = list(EXP_TYPE_ADVENTURER, EXP_TYPE_COMBAT)

/datum/attribute_holder/sheet/job/veteran/battlemaster
	raw_attribute_list = list(
		STAT_PERCEPTION = 1,
		STAT_INTELLIGENCE = 2,
		STAT_ENDURANCE = 1,
		STAT_CONSTITUTION = 1,
		STAT_SPEED = 1,
		STAT_STRENGTH = 1,
		/datum/attribute/skill/combat/swords = 50,
		/datum/attribute/skill/combat/axesmaces = 50,
		/datum/attribute/skill/combat/shields = 40,
		/datum/attribute/skill/combat/wrestling = 40,
		/datum/attribute/skill/combat/unarmed = 40,
		/datum/attribute/skill/combat/polearms = 40,
		/datum/attribute/skill/combat/bows = 40,
		/datum/attribute/skill/combat/crossbows = 30,
		/datum/attribute/skill/combat/whipsflails = 30,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/medicine = 30
	)

/datum/attribute_holder/sheet/job/veteran/battlemaster/old
	raw_attribute_list = list(
		STAT_PERCEPTION = 1,
		STAT_INTELLIGENCE = 2,
		STAT_ENDURANCE = 2,
		STAT_CONSTITUTION = 1,
		STAT_SPEED = 1,
		STAT_STRENGTH = 1,
		/datum/attribute/skill/combat/swords = 60,
		/datum/attribute/skill/combat/axesmaces = 60,
		/datum/attribute/skill/combat/shields = 40,
		/datum/attribute/skill/combat/wrestling = 50,
		/datum/attribute/skill/combat/unarmed = 40,
		/datum/attribute/skill/combat/polearms = 40,
		/datum/attribute/skill/combat/bows = 40,
		/datum/attribute/skill/combat/crossbows = 30,
		/datum/attribute/skill/combat/whipsflails = 30,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/medicine = 30
	)

/datum/job/advclass/veteran/battlemaster
	title = "Veteran Battlemaster"
	tutorial = "You have served under a hundred masters, some good, some bad. You were a general once. A marshal, a captain. To some a hero, others a monster. Something of the sorts. You made strategies, tactics, new innovations of war. A thousand new ways for one man to kill another. It still keeps you up at night."
	outfit = /datum/outfit/vet/battlemaster
	category_tags = list(CTAG_VETERAN)

	attribute_sheet = /datum/attribute_holder/sheet/job/veteran/battlemaster
	attribute_sheet_old = /datum/attribute_holder/sheet/job/veteran/battlemaster/old

	traits = list(
		TRAIT_HEAVYARMOR,
		TRAIT_MEDIUMARMOR,
		TRAIT_STEELHEARTED
	)

	cmode_music = 'sound/music/cmode/adventurer/CombatWarrior.ogg'

/datum/outfit/vet/battlemaster
	name = "Veteran Battlemaster"
	neck = /obj/item/clothing/neck/bevor
	armor = /obj/item/clothing/armor/plate
	shirt = /obj/item/clothing/armor/chainmail
	pants = /obj/item/clothing/pants/chainlegs
	shoes = /obj/item/clothing/shoes/boots/armor
	beltl = /obj/item/weapon/sword/sabre
	beltr = /obj/item/storage/keyring/veteran
	backr = /obj/item/storage/backpack/satchel/black
	scabbards = list(/obj/item/weapon/scabbard/sword)
	cloak = /obj/item/clothing/cloak/half/vet
	belt = /obj/item/storage/belt/leather/black
	backpack_contents = list(/obj/item/weapon/knife/dagger/steel/special = 1)

/datum/attribute_holder/sheet/job/veteran/footman
	raw_attribute_list = list(
		STAT_PERCEPTION = 1,
		STAT_INTELLIGENCE = 2,
		STAT_ENDURANCE = 1,
		STAT_CONSTITUTION = 2,
		STAT_STRENGTH = 1,
		/datum/attribute/skill/combat/swords = 40,
		/datum/attribute/skill/combat/axesmaces = 40,
		/datum/attribute/skill/combat/shields = 40,
		/datum/attribute/skill/combat/wrestling = 40,
		/datum/attribute/skill/combat/unarmed = 40,
		/datum/attribute/skill/combat/polearms = 50,
		/datum/attribute/skill/combat/bows = 40,
		/datum/attribute/skill/combat/crossbows = 40,
		/datum/attribute/skill/combat/whipsflails = 20,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/medicine = 20
	)

/datum/attribute_holder/sheet/job/veteran/footman/old
	raw_attribute_list = list(
		STAT_PERCEPTION = 1,
		STAT_INTELLIGENCE = 2,
		STAT_ENDURANCE = 1,
		STAT_CONSTITUTION = 2,
		STAT_STRENGTH = 1,
		/datum/attribute/skill/combat/swords = 50,
		/datum/attribute/skill/combat/axesmaces = 50,
		/datum/attribute/skill/combat/shields = 60,
		/datum/attribute/skill/combat/wrestling = 50,
		/datum/attribute/skill/combat/unarmed = 40,
		/datum/attribute/skill/combat/polearms = 60,
		/datum/attribute/skill/combat/bows = 40,
		/datum/attribute/skill/combat/crossbows = 40,
		/datum/attribute/skill/combat/whipsflails = 20,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/medicine = 20
	)

/datum/job/advclass/veteran/footman
	title = "Retired Footman"
	tutorial = "You served on the fields of battle as no heroic knight steadfast in shining armor, but a mere mortal clad in whatever cheap armor coin could buy. You fought in formation as a member of a unit, and through discipline, have won numerous battles. Maybe one day you even served as the captain of your unit. You specialize in polearms and bows."
	outfit = /datum/outfit/vet/footman
	category_tags = list(CTAG_VETERAN)

	attribute_sheet = /datum/attribute_holder/sheet/job/veteran/footman
	attribute_sheet_old = /datum/attribute_holder/sheet/job/veteran/footman/old

	traits = list(
		TRAIT_MEDIUMARMOR,
		TRAIT_STEELHEARTED
	)
	cmode_music = 'sound/music/cmode/garrison/CombatGarrison.ogg'

/datum/outfit/vet/footman
	name = "Retired Footman (Veteran)"
	neck = /obj/item/clothing/neck/gorget
	armor = /obj/item/clothing/armor/plate
	shirt = /obj/item/clothing/armor/gambeson/heavy
	head = /obj/item/clothing/head/helmet/sargebarbute
	pants = /obj/item/clothing/pants/chainlegs
	gloves = /obj/item/clothing/gloves/plate
	wrists = /obj/item/clothing/wrists/bracers
	shoes = /obj/item/clothing/shoes/boots/armor
	beltl = /obj/item/weapon/sword
	beltr = /obj/item/storage/keyring/veteran
	backr = /obj/item/storage/backpack/satchel/black
	backl = /obj/item/weapon/shield/tower/metal
	r_hand = /obj/item/weapon/polearm/spear/billhook
	belt = /obj/item/storage/belt/leather/black
	cloak = /obj/item/clothing/cloak/half/vet
	backpack_contents = list(
		/obj/item/weapon/knife/dagger/steel/special = 1,
		/obj/item/rope/chain = 1
	)

/datum/attribute_holder/sheet/job/veteran/calvaryman
	raw_attribute_list = list(
		STAT_PERCEPTION = 1,
		STAT_INTELLIGENCE = 1,
		STAT_ENDURANCE = 2,
		STAT_CONSTITUTION = 2,
		STAT_SPEED = -1,
		STAT_STRENGTH = 1,
		/datum/attribute/skill/combat/swords = 40,
		/datum/attribute/skill/combat/axesmaces = 30,
		/datum/attribute/skill/combat/shields = 40,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/polearms = 40,
		/datum/attribute/skill/combat/bows = 30,
		/datum/attribute/skill/combat/crossbows = 40,
		/datum/attribute/skill/combat/whipsflails = 40,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/medicine = 30,
		/datum/attribute/skill/misc/riding = 40,
		/datum/attribute/skill/labor/mathematics = 30
	)

/datum/attribute_holder/sheet/job/veteran/calvaryman/old
	raw_attribute_list = list(
		STAT_PERCEPTION = 1,
		STAT_INTELLIGENCE = 1,
		STAT_ENDURANCE = 2,
		STAT_CONSTITUTION = 2,
		STAT_SPEED = -1,
		STAT_STRENGTH = 1,
		/datum/attribute/skill/combat/swords = 50,
		/datum/attribute/skill/combat/axesmaces = 40,
		/datum/attribute/skill/combat/shields = 40,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/polearms = 50,
		/datum/attribute/skill/combat/bows = 40,
		/datum/attribute/skill/combat/crossbows = 50,
		/datum/attribute/skill/combat/whipsflails = 50,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/medicine = 30,
		/datum/attribute/skill/misc/riding = 40,
		/datum/attribute/skill/labor/mathematics = 30
	)

/datum/job/advclass/veteran/calvaryman
	title = "Tarnished Knight"
	tutorial = "You were once a member of a knightly calvary regiment, a prestigious title. You were ontop of the world, the townspeople rejoiced when you rode through their streets. Now, all you can hear is the screams of your brothers-in-arms as they fell. You specialize in mounted warfare."
	outfit = /datum/outfit/vet/calvaryman
	category_tags = list(CTAG_VETERAN)

	attribute_sheet = /datum/attribute_holder/sheet/job/veteran/calvaryman
	attribute_sheet_old = /datum/attribute_holder/sheet/job/veteran/calvaryman/old

	traits = list(
		TRAIT_HEAVYARMOR,
		TRAIT_MEDIUMARMOR,
		TRAIT_NOBLE_BLOOD,
		TRAIT_STEELHEARTED
	)

	cmode_music = 'sound/music/cmode/nobility/CombatDungeoneer.ogg'

/datum/job/advclass/veteran/calvaryman/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	var/weapons = list("Sword + Short Bow", "Axe + Crossbow", "Spear + Shield")
	var/weapon_choice = browser_input_list(spawned, "CHOOSE YOUR WEAPON.", "TAKE UP ARMS", weapons)

	switch(weapon_choice)
		if("Sword + Short Bow")
			spawned.put_in_hands(new /obj/item/weapon/sword/long(get_turf(spawned)), TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/ammo_holder/quiver/arrows, ITEM_SLOT_BELT_L, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/gun/ballistic/revolver/grenadelauncher/bow/short, ITEM_SLOT_BACK_L, TRUE)
		if("Axe + Crossbow")
			spawned.put_in_hands(new /obj/item/weapon/axe/steel(get_turf(spawned)), TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow, ITEM_SLOT_BACK_L, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/ammo_holder/quiver/bolts, ITEM_SLOT_BELT_L, TRUE)
		if("Spear + Shield")
			spawned.put_in_hands(new /obj/item/weapon/polearm/spear(get_turf(spawned)), TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/weapon/shield/tower/metal, ITEM_SLOT_BACK_L, TRUE)

/datum/outfit/vet/calvaryman
	name = "Tarnished Knight (Veteran)"
	neck = /obj/item/clothing/neck/chaincoif
	armor = /obj/item/clothing/armor/plate
	shirt = /obj/item/clothing/armor/chainmail
	head = /obj/item/clothing/head/helmet/heavy/decorated/knight
	pants = /obj/item/clothing/pants/chainlegs
	gloves = /obj/item/clothing/gloves/plate
	wrists = /obj/item/clothing/wrists/bracers
	shoes = /obj/item/clothing/shoes/boots/armor
	beltr = /obj/item/storage/keyring/veteran
	backr = /obj/item/storage/backpack/satchel/black
	belt = /obj/item/storage/belt/leather/black
	cloak = /obj/item/clothing/cloak/half/vet
	backpack_contents = list(/obj/item/weapon/knife/dagger/steel/special = 1)

/datum/attribute_holder/sheet/job/veteran/merc
	raw_attribute_list = list(
		STAT_INTELLIGENCE = 1,
		STAT_ENDURANCE = 3,
		STAT_CONSTITUTION = 1,
		STAT_SPEED = -1,
		STAT_STRENGTH = 2,
		/datum/attribute/skill/combat/swords = 40,
		/datum/attribute/skill/combat/axesmaces = 40,
		/datum/attribute/skill/combat/shields = 40,
		/datum/attribute/skill/combat/wrestling = 40,
		/datum/attribute/skill/combat/unarmed = 40,
		/datum/attribute/skill/combat/polearms = 40,
		/datum/attribute/skill/combat/bows = 30,
		/datum/attribute/skill/combat/crossbows = 30,
		/datum/attribute/skill/combat/whipsflails = 30,
		/datum/attribute/skill/combat/knives = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/medicine = 30
	)

/datum/attribute_holder/sheet/job/veteran/merc/old
	raw_attribute_list = list(
		STAT_INTELLIGENCE = 1,
		STAT_ENDURANCE = 3,
		STAT_CONSTITUTION = 1,
		STAT_SPEED = -1,
		STAT_STRENGTH = 2,
		/datum/attribute/skill/combat/swords = 50,
		/datum/attribute/skill/combat/axesmaces = 50,
		/datum/attribute/skill/combat/shields = 40,
		/datum/attribute/skill/combat/wrestling = 40,
		/datum/attribute/skill/combat/unarmed = 40,
		/datum/attribute/skill/combat/polearms = 50,
		/datum/attribute/skill/combat/bows = 30,
		/datum/attribute/skill/combat/crossbows = 30,
		/datum/attribute/skill/combat/whipsflails = 30,
		/datum/attribute/skill/combat/knives = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/medicine = 30
	)

/datum/attribute_holder/sheet/job/veteran/merc/zweihander
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		/datum/attribute/skill/combat/swords = 10,
		/datum/attribute/skill/combat/polearms = 10
	)

/datum/attribute_holder/sheet/job/veteran/merc/halberd
	raw_attribute_list = list(
		/datum/attribute/skill/combat/axesmaces = 10,
		/datum/attribute/skill/combat/polearms = 10
	)

/datum/job/advclass/veteran/merc
	title = "Retired Mercenary"
	tutorial = "You were a sell-sword, a warrior of coin. Your pockets were never light, you always had a warm place to stay and food in your belly, but you knew that every battle could be your last. You're the last of your unit, and you can't help but regret it. You specialize in swords and polearms, or axes and polearms."
	outfit = /datum/outfit/vet/merc
	allowed_races = RACES_PLAYER_GRENZ
	category_tags = list(CTAG_VETERAN)

	attribute_sheet = /datum/attribute_holder/sheet/job/veteran/merc
	attribute_sheet_old = /datum/attribute_holder/sheet/job/veteran/merc/old

	traits = list(
		TRAIT_HEAVYARMOR,
		TRAIT_MEDIUMARMOR,
		TRAIT_STEELHEARTED
	)

	languages = list(/datum/language/newpsydonic)
	cmode_music = 'sound/music/cmode/combat_grenzelhoft.ogg'

/datum/job/advclass/veteran/merc/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/static/list/weapons = list( \
		"Zweihander" = /obj/item/weapon/sword/long/greatsword/zwei, \
		"Halberd" = /obj/item/weapon/polearm/halberd \
	)
	var/weapon_choice = spawned.select_equippable(player_client, weapons, message = "CHOOSE YOUR WEAPON.", title  = "TAKE UP ARMS")
	switch(weapon_choice)
		if("Zweihander")
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/veteran/merc/zweihander)
		if("Halberd")
			spawned.put_in_hands(new /obj/item/weapon/polearm/halberd(get_turf(spawned)), TRUE)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/veteran/merc/halberd)
	if(spawned.dna?.species.id == SPEC_ID_HUMEN)
		spawned.dna.species.native_language = "Psydonic"
		spawned.dna.species.accent_language = spawned.dna.species.get_accent(spawned.dna.species.native_language)

/datum/outfit/vet/merc
	name = "Retired Mercenary (Veteran)"
	neck = /obj/item/clothing/neck/gorget
	wrists = /obj/item/clothing/wrists/bracers
	shirt = /obj/item/clothing/shirt/grenzelhoft
	head = /obj/item/clothing/head/helmet/skullcap/grenzelhoft
	armor = /obj/item/clothing/armor/cuirass/iron
	pants = /obj/item/clothing/pants/grenzelpants
	shoes = /obj/item/clothing/shoes/rare/grenzelhoft
	gloves = /obj/item/clothing/gloves/angle/grenzel
	beltl = /obj/item/weapon/sword/short/iron
	beltr = /obj/item/storage/keyring/veteran
	backr = /obj/item/storage/backpack/satchel/black
	belt = /obj/item/storage/belt/leather/black
	cloak = /obj/item/clothing/cloak/half/vet
	backpack_contents = list(/obj/item/weapon/knife/dagger/steel/special = 1)

/datum/attribute_holder/sheet/job/veteran/fist
	raw_attribute_list = list(
		STAT_ENDURANCE = 2,
		STAT_CONSTITUTION = 2,
		STAT_SPEED = -1,
		STAT_STRENGTH = 2,
		/datum/attribute/skill/combat/wrestling = 50,
		/datum/attribute/skill/combat/unarmed = 50,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/medicine = 30,
		/datum/attribute/skill/misc/swimming = 30
	)

/datum/attribute_holder/sheet/job/veteran/fist/old
	raw_attribute_list = list(
		STAT_ENDURANCE = 2,
		STAT_CONSTITUTION = 2,
		STAT_SPEED = -1,
		STAT_STRENGTH = 2,
		/datum/attribute/skill/combat/wrestling = 60,
		/datum/attribute/skill/combat/unarmed = 60,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/medicine = 30,
		/datum/attribute/skill/misc/swimming = 30
	)

/datum/job/advclass/veteran/fist
	title = "Faded Brawler (Veteran)"
	tutorial = "You needed no sword, no spear, no bow to slay your foes, your fists were enough. \
	Enemy after enemy, beast after beast, all fell to your unrelenting might. The tales once called you a walking tempest, the one who could shatter stone and silence monsters. \
	But time, the cruelest opponent, has weathered your body. The hands that once broke boulders now tremble to lift themselves. Still, deep within those aching bones, the old fire stirs... waiting for one last fight."
	category_tags = list(CTAG_VETERAN)

	attribute_sheet = /datum/attribute_holder/sheet/job/veteran/fist
	attribute_sheet_old = /datum/attribute_holder/sheet/job/veteran/fist/old

	traits = list(
		TRAIT_MEDIUMARMOR,
		TRAIT_STEELHEARTED,
	)

	outfit = /datum/outfit/vet/fist

/datum/outfit/vet/fist
	name = "Faded Brawler (Veteran)"
	head = /obj/item/clothing/head/helmet/leather/volfhelm
	neck = /obj/item/clothing/neck/bevor
	shoes = /obj/item/clothing/shoes/boots/armor/light
	armor = /obj/item/clothing/armor/gambeson/heavy
	shirt = /obj/item/clothing/armor/chainmail
	wrists = /obj/item/clothing/wrists/bracers/jackchain
	belt = /obj/item/storage/belt/leather/black
	beltr = /obj/item/storage/keyring/veteran
	beltl = /obj/item/flashlight/flare/torch/lantern
	gloves = /obj/item/clothing/gloves/bandages/pugilist
	backr = /obj/item/storage/backpack/satchel/black
	pants = /obj/item/clothing/pants/chainlegs
	cloak = /obj/item/clothing/cloak/half/vet

/datum/job/advclass/veteran/fist/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.select_equippable(player_client, list( \
		"Knuckles" = /obj/item/weapon/knuckles, \
		"Katar" = /obj/item/weapon/katar, \
		),
		message = "Choose your way.",
		title = "MY FIST IS READY."
		)
