/datum/job/monk
	title = "Acolyte"
	tutorial = "Chores, exercise, prayer... and more chores. \
	You are a humble acolyte at the temple in Vanderlin, \
	not yet a trained guardian or an ordained priest. \
	But who else would keep the fires lit and the floors clean?"
	department_flag = CHURCHMEN
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_MONK
	faction = FACTION_TOWN
	total_positions = 4
	spawn_positions = 4
	bypass_lastclass = TRUE

	allowed_races = RACES_PLAYER_NONHERETICAL
	allowed_patrons = ALL_TEMPLE_PATRONS

	outfit = /datum/outfit/monk
	give_bank_account = TRUE
	job_bitflag = BITFLAG_CHURCH

	exp_types_granted = list(EXP_TYPE_CHURCH, EXP_TYPE_CLERIC)

	jobstats = list(
		STATKEY_INT = 1,
		STATKEY_END = 2,
		STATKEY_PER = -1
	)

	skills = list(
		/datum/skill/misc/sewing = 2,
		/datum/skill/misc/medicine = 3,
		/datum/skill/combat/polearms = 2,
		/datum/skill/combat/unarmed = 1,
		/datum/skill/combat/wrestling = 1,
		/datum/skill/combat/axesmaces = 1,
		/datum/skill/misc/athletics = 2,
		/datum/skill/misc/reading = 3,
		/datum/skill/magic/holy = 3,
		/datum/skill/craft/cooking = 2
	)

	languages = list(/datum/language/celestial)

/datum/job/monk/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(spawned.age == AGE_OLD)
		spawned.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)

	spawned.virginity = TRUE
	switch(spawned.patron?.type)
		if(/datum/patron/divine/astrata)
			spawned.cmode_music = 'sound/music/cmode/adventurer/CombatMonk.ogg'
		if(/datum/patron/divine/necra)
			spawned.cmode_music = 'sound/music/cmode/church/CombatGravekeeper.ogg'
			ADD_TRAIT(spawned, TRAIT_DEADNOSE, TRAIT_GENERIC)
			ADD_TRAIT(spawned, TRAIT_GRAVEROBBER, TRAIT_GENERIC)
		if(/datum/patron/divine/eora)
			ADD_TRAIT(spawned, TRAIT_BEAUTIFUL, TRAIT_GENERIC)
			ADD_TRAIT(spawned, TRAIT_EMPATH, TRAIT_GENERIC)
			spawned.virginity = FALSE
			spawned.adjust_skillrank(/datum/skill/misc/music, 2, TRUE)
			spawned.cmode_music = 'sound/music/cmode/church/CombatEora.ogg'
		if(/datum/patron/divine/noc)
			spawned.adjust_skillrank(/datum/skill/labor/mathematics, 2, TRUE)
			var/language = pickweight(list("Dwarvish" = 1, "Elvish" = 1, "Hellspeak" = 1, "Zaladin" = 1, "Orcish" = 1,))
			switch(language)
				if("Dwarvish")
					spawned.grant_language(/datum/language/dwarvish)
					to_chat(spawned,span_info("\
					I learned the tongue of the mountain dwellers.")
					)
				if("Elvish")
					spawned.grant_language(/datum/language/elvish)
					to_chat(spawned,span_info("\
					I learned the tongue of the primordial species.")
					)
				if("Hellspeak")
					spawned.grant_language(/datum/language/hellspeak)
					to_chat(spawned,span_info("\
					I learned the tongue of the hellspawn.")
					)
				if("Zaladin")
					spawned.grant_language(/datum/language/zalad)
					to_chat(spawned,span_info("\
					I learned the tongue of Zaladin.")
					)
				if("Orcish")
					spawned.grant_language(/datum/language/orcish)
					to_chat(spawned,span_info("\
					I learned the tongue of the savages in my time.")
					)
			spawned.cmode_music = 'sound/music/cmode/church/CombatNoc.ogg'
		if(/datum/patron/divine/pestra)
			spawned.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
			spawned.adjust_skillrank(/datum/skill/craft/alchemy, 1, TRUE)
			spawned.cmode_music = 'sound/music/cmode/adventurer/CombatMonk.ogg'
		if(/datum/patron/divine/dendor)
			spawned.adjust_skillrank(/datum/skill/labor/farming, 2, TRUE)
			spawned.adjust_skillrank(/datum/skill/labor/taming, 1, TRUE)
			ADD_TRAIT(spawned, TRAIT_SEEDKNOW, TRAIT_GENERIC)
			spawned.cmode_music = 'sound/music/cmode/garrison/CombatForestGarrison.ogg'
		if(/datum/patron/divine/abyssor)
			spawned.adjust_skillrank(/datum/skill/labor/fishing, 2, TRUE)
			spawned.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
			spawned.cmode_music = 'sound/music/cmode/church/CombatAbyssor.ogg'
		if(/datum/patron/divine/ravox)
			spawned.adjust_skillrank(/datum/skill/combat/polearms, 1, TRUE)
			var/sword_skill = rand(1,2)
			var/whip_skill = rand(1,2)
			var/axe_skill = rand(0,1)
			spawned.adjust_skillrank(/datum/skill/combat/swords, sword_skill, TRUE)
			spawned.adjust_skillrank(/datum/skill/combat/whipsflails, whip_skill, TRUE)
			spawned.adjust_skillrank(/datum/skill/combat/axesmaces, axe_skill, TRUE)
			spawned.cmode_music = 'sound/music/cmode/church/CombatRavox.ogg'
		if(/datum/patron/divine/xylix)
			spawned.adjust_skillrank(/datum/skill/misc/stealing, 2, TRUE)
			spawned.adjust_skillrank(/datum/skill/misc/music, 3, TRUE)
			spawned.cmode_music = 'sound/music/cmode/church/CombatXylix.ogg'
		if(/datum/patron/divine/malum)
			spawned.adjust_skillrank(/datum/skill/craft/blacksmithing, 2, TRUE)
			spawned.adjust_skillrank(/datum/skill/craft/smelting, 2, TRUE)
			spawned.adjust_skillrank(/datum/skill/craft/armorsmithing, 1, TRUE)
			spawned.adjust_skillrank(/datum/skill/craft/weaponsmithing, 1, TRUE)
			spawned.adjust_skillrank(/datum/skill/craft/engineering, 1, TRUE)
			spawned.adjust_skillrank(/datum/skill/craft/carpentry, 1, TRUE)
			spawned.adjust_skillrank(/datum/skill/craft/masonry, 1, TRUE)
			spawned.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
			ADD_TRAIT(spawned, TRAIT_MALUMFIRE, TRAIT_GENERIC)
			spawned.cmode_music = 'sound/music/cmode/adventurer/CombatMonk.ogg'

	var/holder = spawned.patron?.devotion_holder
	if(holder)
		var/datum/devotion/devotion = new holder()
		devotion.make_acolyte()
		devotion.grant_to(spawned)

/datum/outfit/monk
	name = "Acolyte"
	belt = /obj/item/storage/belt/leather/rope
	beltr = /obj/item/storage/belt/pouch/coins/poor
	beltl = /obj/item/key/church
	backl = /obj/item/weapon/polearm/woodstaff/quarterstaff
	backpack_contents = list(
		/obj/item/needle = 1
	)

/datum/outfit/monk/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	switch(equipped_human.patron?.type)
		if(/datum/patron/divine/astrata)
			head = /obj/item/clothing/head/roguehood/astrata
			neck = /obj/item/clothing/neck/psycross/silver/astrata
			wrists = /obj/item/clothing/wrists/wrappings
			shoes = /obj/item/clothing/shoes/sandals
			armor = /obj/item/clothing/shirt/robe/astrata
		if(/datum/patron/divine/necra)
			head = /obj/item/clothing/head/padded/deathshroud
			neck = /obj/item/clothing/neck/psycross/silver/necra
			shoes = /obj/item/clothing/shoes/boots
			pants = /obj/item/clothing/pants/trou/leather/mourning
			armor = /obj/item/clothing/shirt/robe/necra
			backpack_contents = list(/obj/item/inqarticles/tallowpot, /obj/item/reagent_containers/food/snacks/tallow/red) // Needed for coffin sanctification, they get enough for one, the rest they must source themselves.
			if(equipped_human.age == AGE_OLD)
				l_hand = /obj/item/weapon/mace/cane/necran
			else
				backl = /obj/item/weapon/polearm/woodstaff/quarterstaff
		if(/datum/patron/divine/eora)
			mask = /obj/item/clothing/face/operavisage
			neck = /obj/item/clothing/neck/psycross/silver/eora
			shoes = /obj/item/clothing/shoes/sandals
			armor = /obj/item/clothing/shirt/robe/eora
		if(/datum/patron/divine/noc)
			head = /obj/item/clothing/head/roguehood/nochood
			neck = /obj/item/clothing/neck/psycross/silver/noc
			wrists = /obj/item/clothing/wrists/nocwrappings
			shoes = /obj/item/clothing/shoes/sandals
			armor = /obj/item/clothing/shirt/robe/noc
		if(/datum/patron/divine/pestra)
			head = /obj/item/clothing/head/padded/pestra
			neck = /obj/item/clothing/neck/psycross/silver/pestra
			shoes = /obj/item/clothing/shoes/sandals
			armor = /obj/item/clothing/shirt/robe/pestra
			backpack_contents += /obj/item/needle/blessed
		if(/datum/patron/divine/dendor)
			head = /obj/item/clothing/head/padded/briarthorns
			neck = /obj/item/clothing/neck/psycross/silver/dendor
			shoes = /obj/item/clothing/shoes/sandals
			armor = /obj/item/clothing/shirt/robe/dendor
		if(/datum/patron/divine/abyssor)
			head = /obj/item/clothing/head/padded/abyssor
			neck = /obj/item/clothing/neck/psycross/silver/abyssor
			shoes = /obj/item/clothing/shoes/boots
			armor = /obj/item/clothing/shirt/robe/abyssor
		if(/datum/patron/divine/ravox)
			head = /obj/item/clothing/head/helmet/leather/headscarf
			neck = /obj/item/clothing/neck/psycross/silver/ravox
			shoes = /obj/item/clothing/shoes/boots
			shirt = /obj/item/clothing/armor/gambeson/light
			armor = /obj/item/clothing/armor/leather
			cloak = /obj/item/clothing/cloak/stabard/templar/ravox
		if(/datum/patron/divine/xylix)
			head = /obj/item/clothing/head/roguehood/colored/random
			neck = /obj/item/clothing/neck/psycross/silver/xylix
			shoes = /obj/item/clothing/shoes/boots
			armor = /obj/item/clothing/shirt/robe/colored/purple
		if(/datum/patron/divine/malum)
			head = /obj/item/clothing/head/headband/colored/red
			neck = /obj/item/clothing/neck/psycross/silver/malum
			shoes = /obj/item/clothing/shoes/boots
			armor = /obj/item/clothing/shirt/robe/colored/red
			backl = /obj/item/weapon/polearm/woodstaff/quarterstaff
			backpack_contents += /obj/item/weapon/hammer/iron
		else
			head = /obj/item/clothing/head/roguehood/colored/random
			neck = /obj/item/clothing/neck/psycross/silver
			shoes = /obj/item/clothing/shoes/boots
			armor = /obj/item/clothing/shirt/robe/colored/plain
