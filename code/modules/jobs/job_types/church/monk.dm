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
	min_pq = -10
	bypass_lastclass = TRUE

	allowed_races = RACES_PLAYER_NONHERETICAL
	allowed_patrons = ALL_TEMPLE_PATRONS

	outfit = /datum/outfit/monk
	give_bank_account = TRUE
	allowed_patrons = ALL_TEMPLE_PATRONS
	job_bitflag = BITFLAG_CHURCH

/datum/outfit/monk
	name = "Acolyte"

/datum/outfit/monk/pre_equip(mob/living/carbon/human/H)
	..()
	H.virginity = TRUE
	belt = /obj/item/storage/belt/leather/rope
	beltr = /obj/item/storage/belt/pouch/coins/poor
	beltl = /obj/item/key/church
	backl = /obj/item/weapon/polearm/woodstaff/quarterstaff
	backpack_contents = list(/obj/item/needle)
	switch(H.patron?.type)
		if(/datum/patron/divine/astrata)
			head = /obj/item/clothing/head/roguehood/astrata
			neck = /obj/item/clothing/neck/psycross/silver/astrata
			wrists = /obj/item/clothing/wrists/wrappings
			shoes = /obj/item/clothing/shoes/sandals
			armor = /obj/item/clothing/shirt/robe/astrata
			H.cmode_music = 'sound/music/cmode/adventurer/CombatMonk.ogg'
		if(/datum/patron/divine/necra) //Necra acolytes are now gravetenders
			head = /obj/item/clothing/head/padded/deathshroud
			neck = /obj/item/clothing/neck/psycross/silver/necra
			shoes = /obj/item/clothing/shoes/boots
			pants = /obj/item/clothing/pants/trou/leather/mourning
			armor = /obj/item/clothing/shirt/robe/necra
			H.cmode_music = 'sound/music/cmode/church/CombatGravekeeper.ogg'
			ADD_TRAIT(H, TRAIT_DEADNOSE, TRAIT_GENERIC)//accustomed to death
		if(/datum/patron/divine/eora)
			mask = /obj/item/clothing/face/operavisage
			neck = /obj/item/clothing/neck/psycross/silver/eora
			shoes = /obj/item/clothing/shoes/sandals
			armor = /obj/item/clothing/shirt/robe/eora
			H.cmode_music = 'sound/music/cmode/church/CombatEora.ogg'
			ADD_TRAIT(H, TRAIT_BEAUTIFUL, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_EMPATH, TRAIT_GENERIC)
			H.virginity = FALSE
			H.adjust_skillrank(/datum/skill/misc/music, 2, TRUE)
		if(/datum/patron/divine/noc)
			head = /obj/item/clothing/head/roguehood/nochood
			neck = /obj/item/clothing/neck/psycross/silver/noc
			wrists = /obj/item/clothing/wrists/nocwrappings
			shoes = /obj/item/clothing/shoes/sandals
			armor = /obj/item/clothing/shirt/robe/noc
			H.cmode_music = 'sound/music/cmode/adventurer/CombatMonk.ogg'
			H.adjust_skillrank(/datum/skill/labor/mathematics, 2, TRUE)
			var/language = pickweight(list("Dwarvish" = 1, "Elvish" = 1, "Hellspeak" = 1, "Zaladin" = 1, "Orcish" = 1,))
			switch(language)
				if("Dwarvish")
					H.grant_language(/datum/language/dwarvish)
					to_chat(H,span_info("\
					I learned the tongue of the mountain dwellers.")
					)
				if("Elvish")
					H.grant_language(/datum/language/elvish)
					to_chat(H,span_info("\
					I learned the tongue of the primordial race.")
					)
				if("Hellspeak")
					H.grant_language(/datum/language/hellspeak)
					to_chat(H,span_info("\
					I learned the tongue of the hellspawn.")
					)
				if("Zaladin")
					H.grant_language(/datum/language/zalad)
					to_chat(H,span_info("\
					I learned the tongue of Zaladin.")
					)
				if("Orcish")
					H.grant_language(/datum/language/orcish)
					to_chat(H,span_info("\
					I learned the tongue of the Orcs in my time.")
					)
		if(/datum/patron/divine/pestra)
			head = /obj/item/clothing/head/padded/pestra
			neck = /obj/item/clothing/neck/psycross/silver/pestra
			shoes = /obj/item/clothing/shoes/sandals
			armor = /obj/item/clothing/shirt/robe/pestra
			H.cmode_music = 'sound/music/cmode/adventurer/CombatMonk.ogg'
			H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
			H.adjust_skillrank(/datum/skill/craft/alchemy, 1, TRUE)
			backpack_contents = list(/obj/item/needle/blessed)
		if(/datum/patron/divine/dendor)
			head = /obj/item/clothing/head/padded/briarthorns
			neck = /obj/item/clothing/neck/psycross/silver/dendor
			shoes = /obj/item/clothing/shoes/sandals
			armor = /obj/item/clothing/shirt/robe/dendor
			H.cmode_music = 'sound/music/cmode/garrison/CombatForestGarrison.ogg'
			H.adjust_skillrank(/datum/skill/labor/farming, 2, TRUE)
			H.adjust_skillrank(/datum/skill/labor/taming, 1, TRUE)
			ADD_TRAIT(H, TRAIT_SEEDKNOW, TRAIT_GENERIC)
		if(/datum/patron/divine/abyssor)
			head = /obj/item/clothing/head/padded/abyssor
			neck = /obj/item/clothing/neck/psycross/silver/abyssor
			shoes = /obj/item/clothing/shoes/boots
			armor = /obj/item/clothing/shirt/robe/abyssor
			H.cmode_music = 'sound/music/cmode/adventurer/CombatMonk.ogg'
			H.adjust_skillrank(/datum/skill/labor/fishing, 2, TRUE)
			H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		if(/datum/patron/divine/ravox)
			head = /obj/item/clothing/head/helmet/leather/headscarf
			neck = /obj/item/clothing/neck/psycross/silver/ravox
			shoes = /obj/item/clothing/shoes/boots
			shirt = /obj/item/clothing/armor/gambeson/light
			armor = /obj/item/clothing/armor/leather
			cloak = /obj/item/clothing/cloak/stabard/templar/ravox
			H.cmode_music = 'sound/music/cmode/church/CombatRavox.ogg'
			H.adjust_skillrank(/datum/skill/combat/polearms, 1, TRUE)
			H.adjust_skillrank(/datum/skill/combat/swords, pick(1,3), TRUE)
			H.adjust_skillrank(/datum/skill/combat/whipsflails, pick(1,3), TRUE)
			H.adjust_skillrank(/datum/skill/combat/axesmaces, pick(0,1), TRUE)
		if(/datum/patron/divine/xylix)
			head = /obj/item/clothing/head/roguehood/colored/random
			neck = /obj/item/clothing/neck/psycross/silver/xylix
			shoes = /obj/item/clothing/shoes/boots
			armor = /obj/item/clothing/shirt/robe/colored/purple
			H.cmode_music = 'sound/music/cmode/church/CombatXylix.ogg'
			H.adjust_skillrank(/datum/skill/misc/stealing, 2, TRUE)
			H.adjust_skillrank(/datum/skill/misc/music, 3, TRUE)
		if(/datum/patron/divine/malum)
			head = /obj/item/clothing/head/headband/colored/red
			neck = /obj/item/clothing/neck/psycross/silver/malum
			shoes = /obj/item/clothing/shoes/boots
			armor = /obj/item/clothing/shirt/robe/colored/red
			backpack_contents += /obj/item/weapon/hammer/iron
			H.cmode_music = 'sound/music/cmode/adventurer/CombatMonk.ogg'
			H.adjust_skillrank(/datum/skill/craft/blacksmithing, 2, TRUE)
			H.adjust_skillrank(/datum/skill/craft/smelting, 2, TRUE)
			H.adjust_skillrank(/datum/skill/craft/armorsmithing, 1, TRUE)
			H.adjust_skillrank(/datum/skill/craft/weaponsmithing, 1, TRUE)
			H.adjust_skillrank(/datum/skill/craft/engineering, 1, TRUE)
			H.adjust_skillrank(/datum/skill/craft/carpentry, 1, TRUE)
			H.adjust_skillrank(/datum/skill/craft/masonry, 1, TRUE)
			H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
			ADD_TRAIT(H, TRAIT_MALUMFIRE, TRAIT_GENERIC)
		else // Failsafe
			head = /obj/item/clothing/head/roguehood/colored/random
			neck = /obj/item/clothing/neck/psycross/silver
			shoes = /obj/item/clothing/shoes/boots
			armor = /obj/item/clothing/shirt/robe/colored/plain
			H.cmode_music = 'sound/music/cmode/adventurer/CombatMonk.ogg'


	H.adjust_skillrank(/datum/skill/misc/sewing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE) // They get this and a wooden staff to defend themselves
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axesmaces, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
	H.adjust_skillrank(/datum/skill/magic/holy, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 2, TRUE)
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
	H.change_stat(STATKEY_INT, 1)
	H.change_stat(STATKEY_END, 2) // For casting lots of spells, and working long hours without sleep at the church
	H.change_stat(STATKEY_PER, -1)
	if(!H.has_language(/datum/language/celestial)) // For discussing church matters with the other Clergy
		H.grant_language(/datum/language/celestial)
		to_chat(H, "<span class='info'>I can speak Celestial with ,c before my speech.</span>")

	var/holder = H.patron.devotion_holder
	if(holder)
		var/datum/devotion/devotion = new holder()
		devotion.make_acolyte()
		devotion.grant_to(H)
