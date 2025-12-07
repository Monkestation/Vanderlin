/datum/job/town_elder
	title = "Town Elder"

	tutorial = "You were once a wanderer, an unremarkable soul who, alongside your old adventuring party, carved your name into history.\
	Now, the days of adventure are long past. You sit as the town's beloved elder; while the crown may rule from afar, the people\
	look to you to settle disputes, mend rifts, and keep the true peace in town. Not every conflict must end in bloodshed,\
	but when it must, you will do what is necessary, as you always have."
	department_flag = GARRISON
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_CHIEF
	faction = FACTION_TOWN
	total_positions = 1
	spawn_positions = 1
	bypass_lastclass = TRUE
	spells = list(/datum/action/cooldown/spell/undirected/list_target/convert_role/militia)
	allowed_ages = list(AGE_MIDDLEAGED, AGE_OLD, AGE_IMMORTAL)
	allowed_races = RACES_PLAYER_NONHERETICAL
	blacklisted_species = list(SPEC_ID_HALFLING)
	cmode_music = "sound/music/cmode/towner/CombatElder.ogg"
	advclass_cat_rolls = list(CTAG_TOWN_ELDER = 20)
	give_bank_account = 50
	can_have_apprentices = FALSE

	exp_type = list(EXP_TYPE_BARD, EXP_TYPE_LIVING)
	exp_types_granted  = list(EXP_TYPE_LEADERSHIP, EXP_TYPE_BARD)
	exp_requirements = list(
		EXP_TYPE_LIVING = 1200,
		EXP_TYPE_BARD = 300
	)


/mob/living/carbon/human/proc/townannouncement()
	set name = "Announcement"
	set category = "Town Elder"
	if(stat)
		return

	var/static/last_announcement_time = 0

	if(world.time < last_announcement_time + 1 MINUTES)
		var/time_left = round((last_announcement_time + 1 MINUTES - world.time) / 10)
		to_chat(src, "<span class='warning'>You must wait [time_left] more seconds before making another announcement.</span>")
		return

	var/inputty = input("Make an announcement", "VANDERLIN") as text|null
	if(inputty)
		if(!istype(get_area(src), /area/indoors/town/tavern))
			to_chat(src, "<span class='warning'>I need to do this from the tavern.</span>")
			return FALSE
		priority_announce("[inputty]", title = "[src.real_name], The Town Elder Speaks", sound = 'sound/misc/bell.ogg')
		src.log_talk("[TIMETOTEXT4LOGS] [inputty]", LOG_SAY, tag="Town Elder announcement")

		last_announcement_time = world.time

/datum/job/town_elder/after_spawn(mob/living/spawned, client/player_client)
	. = ..()
	var/mob/living/carbon/human/H = spawned
	ADD_TRAIT(H, TRAIT_OLDPARTY, TRAIT_GENERIC)
	H.verbs |= /mob/living/carbon/human/proc/townannouncement

/datum/outfit/town_elder/post_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	. = ..()
	var/instruments = list(
		"Harp" = /obj/item/instrument/harp,
		"Lute" = /obj/item/instrument/lute,
		"Accordion" = /obj/item/instrument/accord,
		"Guitar" = /obj/item/instrument/guitar,
		"Flute" = /obj/item/instrument/flute,
		"Drum" = /obj/item/instrument/drum,
		"Hurdy-Gurdy" = /obj/item/instrument/hurdygurdy,
		"Viola" = /obj/item/instrument/viola)
	var/instrument_choice = input(usr, "Choose your instrument.", "XYLIX") as anything in instruments
	var/spawn_instrument = instruments[instrument_choice]
	if(!spawn_instrument)
		spawn_instrument = /obj/item/instrument/lute
	H.equip_to_slot_or_del(new spawn_instrument(H),ITEM_SLOT_BACK_R, TRUE)

/datum/job/advclass/town_elder
	exp_types_granted  = list(EXP_TYPE_LEADERSHIP, EXP_TYPE_BARD)

/datum/job/advclass/town_elder/mayor
	title = "Mayor"
	allowed_races = RACES_PLAYER_NONDISCRIMINATED // Due to the inherent nobility coming from being a mayor, non-humen species are barred.
	tutorial = "Before politics, you were a bard, your voice stirred hearts, your tales traveled farther than your feet ever could. You carved your name in history not with steel, but with stories that moved kings and commoners alike. In time, your charisma became counsel, your songs gave way to speeches. Decades later, your skill in diplomacy and trade earned you nobility, and with it, the title of Mayor. Now, you lead not from a stage, but from the heart of the people you once sang for."
	outfit = /datum/outfit/town_elder/mayor

	category_tags = list(CTAG_TOWN_ELDER)

// Mayor start with slight changes, they were turned noble and got more money, also highly skilled in merchant skills.

/datum/outfit/town_elder/mayor/pre_equip(mob/living/carbon/human/H)


	pants = /obj/item/clothing/pants/trou/leather
	head = /obj/item/clothing/head/tophat
	armor = /obj/item/clothing/armor/leather/vest/winterjacket
	shirt = /obj/item/clothing/shirt/undershirt/fancy
	shoes = /obj/item/clothing/shoes/boots
	gloves = /obj/item/clothing/gloves/leather/black
	ring = /obj/item/clothing/ring/gold/toper
	backl = /obj/item/storage/backpack/satchel
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/colored/black
	neck = /obj/item/storage/belt/pouch/coins/veryrich
	belt = /obj/item/storage/belt/leather/plaquesilver
	beltr = /obj/item/storage/keyring/elder
	beltl = /obj/item/flashlight/flare/torch/lantern
	r_hand = /obj/item/weapon/polearm/woodstaff/quarterstaff
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 3, TRUE)
	H.adjust_skillrank(/datum/skill/labor/mathematics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/music, 5, TRUE)

	H.add_spell(/datum/action/cooldown/spell/vicious_mockery)
	H.add_spell(/datum/action/cooldown/spell/bardic_inspiration)
	H.change_stat(STATKEY_STR, -1)
	H.change_stat(STATKEY_PER, 2)
	H.change_stat(STATKEY_END, 1)
	H.change_stat(STATKEY_INT, 2)

	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		H.adjust_skillrank(/datum/skill/labor/mathematics, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/riding, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/polearms, 1, TRUE)
		H.change_stat(STATKEY_STR, -1)
		H.change_stat(STATKEY_PER, 1)
		H.change_stat(STATKEY_INT, 1)
	ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_SEEPRICES, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_BARDIC_TRAINING, TRAIT_GENERIC)
	var/datum/inspiration/I = new /datum/inspiration(H)
	I.grant_inspiration(H, bard_tier = BARD_T3)




/datum/job/advclass/town_elder/master_of_crafts_and_labor
	title = "Master of Crafts and Labor"

	tutorial = "You were one of the hardest-working individuals in the city, there isn’t a single job you haven’t done. From farming and butchery to alchemy, blacksmithing, cooking, and even medicine, your vast knowledge made you a guiding light for the people. Yet amid your labors, it was your songs that bound the workers together: rhythmic chants in the forge, lullabies in the sick wards, ballads hummed in the fields. Your voice became a beacon of focus and unity. Recognizing both your wisdom and your spirit, the townsfolk turned to you for guidance. Now, as the Master of Crafts and Labor, you oversee and uplift all who contribute to the city’s survival. Lead them well."
	outfit = /datum/outfit/town_elder/master_of_crafts_and_labor

	//A Job meant to guide and help new players in multiple areas heavy RNG so it can range from Average to Master.

	category_tags = list(CTAG_TOWN_ELDER)


/datum/outfit/town_elder/master_of_crafts_and_labor/pre_equip(mob/living/carbon/human/H)

	head = /obj/item/clothing/head/hatblu
	armor = /obj/item/clothing/armor/leather/vest/colored/random
	pants = /obj/item/clothing/pants/trou
	shirt = /obj/item/clothing/shirt/undershirt/colored/random
	shoes = /obj/item/clothing/shoes/boots/leather
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/weapon/pick/paxe
	beltl = /obj/item/flashlight/flare/torch/lantern
	backl = /obj/item/storage/backpack/backpack
	backpack_contents = list(/obj/item/storage/belt/pouch/coins/mid = 1, /obj/item/weapon/knife/hunting = 1, /obj/item/storage/keyring/master_of_crafts_and_labor = 1, /obj/item/weapon/hammer/steel = 1)

	if(H.mind)

		H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		H.adjust_skillrank(/datum/skill/labor/mathematics, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE) // Heavy worker
		H.adjust_skillrank(/datum/skill/combat/axesmaces, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/music, 3, TRUE)

		H.adjust_skillrank(/datum/skill/labor/mining, pick(2,3,4), TRUE)
		H.adjust_skillrank(/datum/skill/labor/lumberjacking,pick(2,3,4),TRUE)
		H.adjust_skillrank(/datum/skill/craft/masonry, pick(2,3,4), TRUE)
		H.adjust_skillrank(/datum/skill/craft/crafting, pick(2,3,4), TRUE)
		H.adjust_skillrank(/datum/skill/craft/carpentry, pick(2,3,4), TRUE)
		H.adjust_skillrank(/datum/skill/craft/engineering, pick(2,3,4), TRUE)
		H.adjust_skillrank(/datum/skill/craft/smelting, pick(2,3,4), TRUE)
		H.adjust_skillrank(/datum/skill/misc/sewing, pick(2,3,4), TRUE)
		H.adjust_skillrank(/datum/skill/labor/farming, pick(2,3,4), TRUE)
		H.adjust_skillrank(/datum/skill/misc/medicine, pick(2,3,4), TRUE)
		H.adjust_skillrank(/datum/skill/craft/tanning, pick(2,3,4), TRUE)
		H.adjust_skillrank(/datum/skill/labor/butchering, pick(2,3,4), TRUE)
		H.adjust_skillrank(/datum/skill/labor/taming, pick(2,3,4), TRUE)
		H.adjust_skillrank(/datum/skill/craft/alchemy, pick(2,3,4), TRUE)
		H.adjust_skillrank(/datum/skill/craft/blacksmithing, pick(2,3,4), TRUE)
		H.adjust_skillrank(/datum/skill/craft/armorsmithing, pick(2,3,4) ,TRUE)
		H.adjust_skillrank(/datum/skill/craft/weaponsmithing, pick(2,3,4) ,TRUE)
		H.adjust_skillrank(/datum/skill/craft/cooking, pick(2,3,4), TRUE)

		H.change_stat(STATKEY_STR, 1)
		H.change_stat(STATKEY_END, 2)
		H.change_stat(STATKEY_INT, 2)


		if(H.age == AGE_OLD)
			H.adjust_skillrank(/datum/skill/labor/mining, pick(0,0,1), TRUE)
			H.adjust_skillrank(/datum/skill/labor/lumberjacking,pick(0,0,1), TRUE)
			H.adjust_skillrank(/datum/skill/craft/masonry, pick(0,0,1), TRUE)
			H.adjust_skillrank(/datum/skill/craft/crafting, pick(0,0,1), TRUE)
			H.adjust_skillrank(/datum/skill/craft/carpentry, pick(0,0,1), TRUE)
			H.adjust_skillrank(/datum/skill/craft/engineering, pick(0,0,1), TRUE)
			H.adjust_skillrank(/datum/skill/craft/smelting, pick(0,0,1), TRUE)
			H.adjust_skillrank(/datum/skill/misc/sewing, pick(0,0,1), TRUE)
			H.adjust_skillrank(/datum/skill/labor/farming, pick(0,0,1), TRUE)
			H.adjust_skillrank(/datum/skill/misc/medicine, pick(0,0,1), TRUE)
			H.adjust_skillrank(/datum/skill/craft/tanning, pick(0,0,1), TRUE)
			H.adjust_skillrank(/datum/skill/labor/butchering, pick(0,0,1), TRUE)
			H.adjust_skillrank(/datum/skill/labor/taming, pick(0,0,1),TRUE)
			H.adjust_skillrank(/datum/skill/craft/alchemy, pick(0,0,1), TRUE)
			H.adjust_skillrank(/datum/skill/craft/blacksmithing, pick(0,0,1), TRUE)
			H.adjust_skillrank(/datum/skill/craft/armorsmithing, pick(0,0,1), TRUE)
			H.adjust_skillrank(/datum/skill/craft/weaponsmithing, pick(0,0,1), TRUE)
			H.adjust_skillrank(/datum/skill/craft/cooking, pick(0,0,1), TRUE)

			H.change_stat(STATKEY_END, 1)
			H.change_stat(STATKEY_INT, 1)


		ADD_TRAIT(H, TRAIT_DEADNOSE, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_SEEDKNOW, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_MALUMFIRE, TRAIT_GENERIC)


/datum/job/advclass/town_elder/hearth_acolyte
	title = "Hearth Acolyte"

	tutorial = "As an Acolyte, you dedicated your life to faith and service, expecting nothing in return. When you saved a noble, they repaid you with a home and gold, but you accepted it as the will of the Ten. Though you stepped away from the Church, you found a new purpose, not in grand temples, but in the rhythm of the streets. Your voice, once raised in hymns and prayers, now carries through alleyways and taverns, offering solace in melody and verse. Whether through healing, wisdom, or song, your faith endures. Only now, your congregation is the town itself."
	outfit = /datum/outfit/town_elder/hearth_acolyte

	//An acolyte that left the church and now serve and help the town people.

	category_tags = list(CTAG_TOWN_ELDER)

	allowed_patrons = ALL_TEMPLE_PATRONS

/datum/outfit/town_elder/hearth_acolyte/pre_equip(mob/living/carbon/human/H)
	. = ..()
	head = /obj/item/clothing/head/roguehood/colored/random
	armor = /obj/item/clothing/shirt/robe
	shoes = /obj/item/clothing/shoes/sandals
	belt = /obj/item/storage/belt/leather/rope
	beltr = /obj/item/storage/keyring/elder
	beltl = /obj/item/flashlight/flare/torch/lantern
	backl = /obj/item/storage/backpack/satchel

	backpack_contents = list(/obj/item/storage/belt/pouch/coins/mid = 1, /obj/item/needle = 1 )

	switch(H.patron?.type)
		if(/datum/patron/divine/astrata)
			neck = /obj/item/clothing/neck/psycross/silver/astrata
			H.cmode_music = 'sound/music/cmode/adventurer/CombatMonk.ogg'
		if(/datum/patron/divine/necra)
			neck = /obj/item/clothing/neck/psycross/silver/necra
			H.cmode_music = 'sound/music/cmode/church/CombatGravekeeper.ogg'
		if(/datum/patron/divine/eora)
			neck = /obj/item/clothing/neck/psycross/silver/eora
			H.cmode_music = 'sound/music/cmode/church/CombatEora.ogg'
			ADD_TRAIT(H, TRAIT_BEAUTIFUL, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_EMPATH, TRAIT_GENERIC)
			H.virginity = FALSE
		if(/datum/patron/divine/noc)
			neck = /obj/item/clothing/neck/psycross/silver/noc
			H.cmode_music = 'sound/music/cmode/church/CombatNoc.ogg'
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
					I learned the tongue of the primordial species.")
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
					I learned the tongue of the savages in my time.")
					)
		if(/datum/patron/divine/pestra)
			neck = /obj/item/clothing/neck/psycross/silver/pestra
			H.cmode_music = 'sound/music/cmode/adventurer/CombatMonk.ogg'
			backpack_contents += /obj/item/needle/blessed
		if(/datum/patron/divine/dendor)
			neck = /obj/item/clothing/neck/psycross/silver/dendor
			H.cmode_music = 'sound/music/cmode/garrison/CombatForestGarrison.ogg'
			H.adjust_skillrank(/datum/skill/labor/farming, 2, TRUE)
			H.adjust_skillrank(/datum/skill/labor/taming, 1, TRUE)
			ADD_TRAIT(H, TRAIT_SEEDKNOW, TRAIT_GENERIC)
		if(/datum/patron/divine/abyssor)
			neck = /obj/item/clothing/neck/psycross/silver/abyssor
			H.cmode_music = 'sound/music/cmode/church/CombatAbyssor.ogg'
			H.adjust_skillrank(/datum/skill/labor/fishing, 2, TRUE)
		if(/datum/patron/divine/ravox)
			neck = /obj/item/clothing/neck/psycross/silver/ravox
			H.cmode_music = 'sound/music/cmode/church/CombatRavox.ogg'
			H.adjust_skillrank(/datum/skill/combat/polearms, 1, TRUE)
		if(/datum/patron/divine/xylix)
			neck = /obj/item/clothing/neck/psycross/silver/xylix
			H.cmode_music = 'sound/music/cmode/church/CombatXylix.ogg'
			H.adjust_skillrank(/datum/skill/misc/stealing, 1, TRUE)
		if(/datum/patron/divine/malum)
			neck = /obj/item/clothing/neck/psycross/silver/malum
			H.cmode_music = 'sound/music/cmode/adventurer/CombatMonk.ogg'
			backpack_contents += /obj/item/weapon/hammer/iron
			H.adjust_skillrank(/datum/skill/craft/blacksmithing, 1, TRUE)
			H.adjust_skillrank(/datum/skill/craft/armorsmithing, 1, TRUE)
			H.adjust_skillrank(/datum/skill/craft/weaponsmithing, 1, TRUE)
			ADD_TRAIT(H, TRAIT_MALUMFIRE, TRAIT_GENERIC)
		else // Failsafe
			neck = /obj/item/clothing/neck/psycross/silver
			H.cmode_music = 'sound/music/cmode/adventurer/CombatMonk.ogg'
	if(H.mind)
		H.adjust_skillrank(/datum/skill/misc/sewing, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/medicine, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
		H.adjust_skillrank(/datum/skill/magic/holy, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/music, 4, TRUE)

		// More hand to hand focused
		H.change_stat(STATKEY_STR, 2)
		H.change_stat(STATKEY_INT, 1)
		H.change_stat(STATKEY_END, 2)

		if(H.age == AGE_OLD)
			H.adjust_skillrank(/datum/skill/magic/holy, 2, TRUE)
			H.change_stat(STATKEY_END, 1)

		if(!H.has_language(/datum/language/celestial))
			H.grant_language(/datum/language/celestial)
			to_chat(H, "<span class='info'>I can speak Celestial with ,c before my speech.</span>")

	var/holder = H.patron?.devotion_holder
	if(holder)
		var/datum/devotion/devotion = new holder()
		devotion.make_acolyte()
		devotion.grant_to(H)

/datum/job/advclass/town_elder/lorekeeper
	title = "Lorekeeper"

	tutorial = "Your tales once lit up taverns, your ballads echoed through cities, and your curiosity led you across kingdoms. But the stage grows quiet, and your thirst for stories has shifted. Now, you collect history instead of applause, recording the town’s past, preserving its legends, and guiding the present with the wisdom of ages. In a world where memory is power, you are its guardian."
	outfit = /datum/outfit/town_elder/lorekeeper

	category_tags = list(CTAG_TOWN_ELDER)

/datum/outfit/town_elder/lorekeeper/pre_equip(mob/living/carbon/human/H)
	head = /obj/item/clothing/head/bardhat
	shoes = /obj/item/clothing/shoes/boots
	pants = /obj/item/clothing/pants/trou/leather
	shirt = /obj/item/clothing/shirt/tunic/noblecoat
	gloves = /obj/item/clothing/gloves/leather
	wrists = /obj/item/clothing/wrists/bracers/leather
	belt = /obj/item/storage/belt/leather
	armor = /obj/item/clothing/armor/leather/jacket/silk_coat
	cloak = /obj/item/clothing/cloak/half
	backl = /obj/item/storage/backpack/satchel
	beltr = /obj/item/weapon/sword/arming
	scabbards = list(/obj/item/weapon/scabbard/sword)
	beltl = /obj/item/flashlight/flare/torch/lantern
	backpack_contents = list(/obj/item/storage/belt/pouch/coins/mid = 1, /obj/item/storage/keyring/elder = 1, /obj/item/paper/scroll = 5, /obj/item/natural/feather = 1)


	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/music, 6, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)


	H.change_stat(STATKEY_INT, 2)
	H.change_stat(STATKEY_SPD, 2)
	H.change_stat(STATKEY_STR, 1)

	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		H.change_stat(STATKEY_END, 1)
		H.change_stat(STATKEY_INT, 1)

	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_BARDIC_TRAINING, TRAIT_GENERIC)
	var/datum/inspiration/I = new /datum/inspiration(H)
	I.grant_inspiration(H, bard_tier = BARD_T3)
	H.add_spell(/datum/action/cooldown/spell/vicious_mockery)
	H.add_spell(/datum/action/cooldown/spell/bardic_inspiration)


/datum/job/advclass/town_elder/dreamwatcher
	title = "Dreamwatcher"

	tutorial = "Your dreams have always been vivid, filled with colors, voices, and shadows that seemed to watch. As a child, you feared them. As an adult, you began to listen. The Church speaks of Noc as the keeper of magic, but to you, he is something deeper: a silent guide whose truths are not written in scripture, but in sleep. Over time, you learned to echo those truths in your own way, through murmured lullabies, whispered verses, and songs shaped from silence. Now, as Elder of this town, you offer more than leadership. You help others find clarity in the quiet spaces of their hearts, through signs, symbols, and melodies only the soul remembers. Some call it intuition. Others call it wisdom. You know it simply as listening.(Not all your dreams are true, some may lie)"
	outfit = /datum/outfit/town_elder/dreamwatcher

	//Not a Magician nor an Acolyte, but something more, blessed by Noc since they were born, being capable of Visions and Feelings through dreams, they can feel the highest god influence or and get a hint about any of the active antags.
	category_tags = list(CTAG_TOWN_ELDER)


/datum/outfit/town_elder/dreamwatcher/pre_equip(mob/living/carbon/human/H)
	head = /obj/item/clothing/head/armingcap
	armor = /obj/item/clothing/shirt/robe/colored/black
	shoes = /obj/item/clothing/shoes/sandals
	belt = /obj/item/storage/belt/leather/rope
	beltr = /obj/item/storage/keyring/elder
	beltl = /obj/item/flashlight/flare/torch/lantern
	backl = /obj/item/storage/backpack/satchel
	wrists = /obj/item/clothing/wrists/nocwrappings
	neck = /obj/item/clothing/neck/psycross/silver/noc
	backpack_contents = list(/obj/item/storage/belt/pouch/coins/poor = 1, /obj/item/needle = 1 )

	if(H.patron != /datum/patron/divine/noc)
		H.set_patron(/datum/patron/divine/noc, TRUE)

	H.apply_status_effect(/datum/status_effect/buff/nocblessed)
	// 3 INT and 2 PER buff, stats will be lowered because of that

	H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sewing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/music, 4, TRUE)

	H.change_stat(STATKEY_INT, 2)
	H.change_stat(STATKEY_SPD, 1)
	H.change_stat(STATKEY_PER, 1)
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
		H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
		H.change_stat(STATKEY_INT, 1)
		H.change_stat(STATKEY_END, 1)

	ADD_TRAIT(H, TRAIT_DREAM_WATCHER, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_EMPATH, TRAIT_GENERIC)


