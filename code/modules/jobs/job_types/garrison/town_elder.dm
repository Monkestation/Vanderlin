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

	allowed_ages = list(AGE_MIDDLEAGED, AGE_OLD, AGE_IMMORTAL)
	allowed_races = RACES_PLAYER_NONHERETICAL
	blacklisted_species = list(SPEC_ID_HALFLING)
	cmode_music = "sound/music/cmode/towner/CombatElder.ogg"
	advclass_cat_rolls = list(CTAG_TOWN_ELDER = 20)
	give_bank_account = 50
	can_have_apprentices = FALSE

	exp_type = list(EXP_TYPE_BARD, EXP_TYPE_LIVING)
	exp_types_granted = list(EXP_TYPE_LEADERSHIP, EXP_TYPE_BARD)
	exp_requirements = list(
		EXP_TYPE_LIVING = 1200,
		EXP_TYPE_BARD = 300
	)

	traits = list(
		TRAIT_OLDPARTY
	)

	spells = list(
		/datum/action/cooldown/spell/undirected/list_target/convert_role/militia
	)

/datum/job/town_elder/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	add_verb(spawned, /mob/living/carbon/human/proc/townannouncement)
	var/instruments = list(
		"Harp" = /obj/item/instrument/harp,
		"Lute" = /obj/item/instrument/lute,
		"Accordion" = /obj/item/instrument/accord,
		"Guitar" = /obj/item/instrument/guitar,
		"Flute" = /obj/item/instrument/flute,
		"Drum" = /obj/item/instrument/drum,
		"Hurdy-Gurdy" = /obj/item/instrument/hurdygurdy,
		"Viola" = /obj/item/instrument/viola)

	var/instrument_choice = input(spawned, "Choose your instrument.", "XYLIX") as anything in instruments
	var/spawn_instrument = instruments[instrument_choice]
	if(!spawn_instrument)
		spawn_instrument = /obj/item/instrument/lute
	spawned.equip_to_slot_or_del(new spawn_instrument(spawned), ITEM_SLOT_BACK_R, TRUE)
	spawned.add_quirk(/datum/quirk/boon/folk_hero)

/mob/living/carbon/human/proc/townannouncement()
	set name = "Elder Announcement"
	set category = "RoleUnique.Elder"
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

/datum/job/advclass/town_elder
	exp_types_granted = list(EXP_TYPE_LEADERSHIP, EXP_TYPE_BARD)

/datum/job/advclass/town_elder/mayor
	title = "Mayor"
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	tutorial = "Before politics, you were a bard, your voice stirred hearts, your tales traveled farther than your feet ever could. You carved your name in history not with steel, but with stories that moved kings and commoners alike. In time, your charisma became counsel, your songs gave way to speeches. Decades later, your skill in diplomacy and trade earned you nobility, and with it, the title of Mayor. Now, you lead not from a stage, but from the heart of the people you once sang for."
	outfit = /datum/outfit/town_elder/mayor
	category_tags = list(CTAG_TOWN_ELDER)

	spells = list(
		/datum/action/cooldown/spell/vicious_mockery,
		// /datum/action/cooldown/spell/bardic_inspiration
	)

	jobstats = list(
		STATKEY_STR = -1,
		STATKEY_END = 1,
		STATKEY_PER = 2,
		STATKEY_INT = 2
	)

	skills = list(
		/datum/skill/craft/crafting = 2,
		/datum/skill/misc/reading = 4,
		/datum/skill/misc/climbing = 2,
		/datum/skill/combat/unarmed = 1,
		/datum/skill/combat/wrestling = 1,
		/datum/skill/misc/athletics = 2,
		/datum/skill/misc/riding = 3,
		/datum/skill/labor/mathematics = 4,
		/datum/skill/combat/polearms = 2,
		/datum/skill/misc/music = 5
	)

	traits = list(
		TRAIT_NOBLE,
		TRAIT_SEEPRICES,
		TRAIT_BARDIC_TRAINING
	)

/datum/job/advclass/town_elder/mayor/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.inspiration = new /datum/inspiration(spawned)
	if(spawned.age == AGE_OLD)
		spawned.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		spawned.adjust_skillrank(/datum/skill/labor/mathematics, 1, TRUE)
		spawned.adjust_skillrank(/datum/skill/misc/riding, 1, TRUE)
		spawned.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
		spawned.adjust_skillrank(/datum/skill/combat/polearms, 1, TRUE)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_STR, -1)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_PER, 1)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_INT, 1)

/datum/outfit/town_elder/mayor
	name = "Mayor (Town Elder)"
	head = /obj/item/clothing/head/tophat
	armor = /obj/item/clothing/armor/leather/vest/winterjacket
	shirt = /obj/item/clothing/shirt/undershirt/fancy
	pants = /obj/item/clothing/pants/trou/leather
	shoes = /obj/item/clothing/shoes/boots
	gloves = /obj/item/clothing/gloves/leather/black
	ring = /obj/item/clothing/ring/gold/toper
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/colored/black
	neck = /obj/item/storage/belt/pouch/coins/veryrich
	belt = /obj/item/storage/belt/leather/plaquesilver
	beltr = /obj/item/storage/keyring/elder
	beltl = /obj/item/flashlight/flare/torch/lantern
	backl = /obj/item/storage/backpack/satchel
	r_hand = /obj/item/weapon/polearm/woodstaff/quarterstaff

/datum/job/advclass/town_elder/master_of_crafts_and_labor //A Job meant to guide and help new players in multiple areas heavy RNG so it can range from Average to Master.
	title = "Master of Crafts and Labor"
	tutorial = "You were one of the hardest-working individuals in the city, there isn't a single job you haven't done. From farming and butchery to alchemy, blacksmithing, cooking, and even medicine, your vast knowledge made you a guiding light for the people. Yet amid your labors, it was your songs that bound the workers together: rhythmic chants in the forge, lullabies in the sick wards, ballads hummed in the fields. Your voice became a beacon of focus and unity. Recognizing both your wisdom and your spirit, the townsfolk turned to you for guidance. Now, as the Master of Crafts and Labor, you oversee and uplift all who contribute to the city's survival. Lead them well."
	outfit = /datum/outfit/town_elder/master_of_crafts_and_labor
	category_tags = list(CTAG_TOWN_ELDER)
	jobstats = list(
		STATKEY_STR = 1,
		STATKEY_END = 2,
		STATKEY_INT = 2
	)

	skills = list(
		/datum/skill/misc/reading = 1,
		/datum/skill/labor/mathematics = 1,
		/datum/skill/misc/athletics = 3,
		/datum/skill/combat/axesmaces = 2,
		/datum/skill/combat/wrestling = 1,
		/datum/skill/combat/unarmed = 1,
		/datum/skill/misc/swimming = 3,
		/datum/skill/misc/climbing = 3,
		/datum/skill/misc/music = 3
	)

	traits = list(
		TRAIT_DEADNOSE,
		TRAIT_SEEDKNOW,
		TRAIT_MALUMFIRE
	)

/datum/job/advclass/town_elder/master_of_crafts_and_labor/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/list/craft_skills = list(
		/datum/skill/labor/mining,
		/datum/skill/labor/lumberjacking,
		/datum/skill/craft/masonry,
		/datum/skill/craft/crafting,
		/datum/skill/craft/carpentry,
		/datum/skill/craft/engineering,
		/datum/skill/craft/smelting,
		/datum/skill/misc/sewing,
		/datum/skill/labor/farming,
		/datum/skill/misc/medicine,
		/datum/skill/craft/tanning,
		/datum/skill/labor/butchering,
		/datum/skill/labor/taming,
		/datum/skill/craft/alchemy,
		/datum/skill/craft/blacksmithing,
		/datum/skill/craft/armorsmithing,
		/datum/skill/craft/weaponsmithing,
		/datum/skill/craft/cooking
	)

	for(var/skill_type in craft_skills)
		spawned.adjust_skillrank(skill_type, pick(2,3,4), TRUE)

	if(spawned.age == AGE_OLD)
		for(var/skill_type in craft_skills)
			spawned.adjust_skillrank(skill_type, pick(0,0,1), TRUE)

		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_END, 1)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_INT, 1)

/datum/outfit/town_elder/master_of_crafts_and_labor
	name = "Master of Crafts and Labor (Town Elder)"
	head = /obj/item/clothing/head/hatblu
	armor = /obj/item/clothing/armor/leather/vest/colored/random
	shirt = /obj/item/clothing/shirt/undershirt/colored/random
	pants = /obj/item/clothing/pants/trou
	shoes = /obj/item/clothing/shoes/boots/leather
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/weapon/pick/paxe
	beltl = /obj/item/flashlight/flare/torch/lantern
	backl = /obj/item/storage/backpack/backpack
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/mid = 1,
		/obj/item/weapon/knife/hunting = 1,
		/obj/item/storage/keyring/master_of_crafts_and_labor = 1,
		/obj/item/weapon/hammer/steel = 1
	)

/datum/job/advclass/town_elder/hearth_acolyte //An acolyte that left the church and now serve and help the town people.
	title = "Hearth Acolyte"
	tutorial = "As an Acolyte, you dedicated your life to faith and service, expecting nothing in return. When you saved a noble, they repaid you with a home and gold, but you accepted it as the will of the Ten. Though you stepped away from the Church, you found a new purpose, not in grand temples, but in the rhythm of the streets. Your voice, once raised in hymns and prayers, now carries through alleyways and taverns, offering solace in melody and verse. Whether through healing, wisdom, or song, your faith endures. Only now, your congregation is the town itself."
	outfit = /datum/outfit/town_elder/hearth_acolyte
	category_tags = list(CTAG_TOWN_ELDER)
	allowed_patrons = ALL_TEMPLE_PATRONS

	jobstats = list(
		STATKEY_STR = 2,
		STATKEY_INT = 1,
		STATKEY_END = 2
	)

	skills = list(
		/datum/skill/misc/sewing = 2,
		/datum/skill/misc/medicine = 3,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/misc/athletics = 2,
		/datum/skill/misc/reading = 3,
		/datum/skill/magic/holy = 3,
		/datum/skill/misc/music = 4
	)

	traits = list(
		TRAIT_OLDPARTY
	)

	languages = list(/datum/language/celestial)

/datum/job/advclass/town_elder/hearth_acolyte/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	spawned.virginity = TRUE
	switch(spawned.patron?.type)
		if(/datum/patron/divine/astrata)
			spawned.cmode_music = 'sound/music/cmode/adventurer/CombatMonk.ogg'
		if(/datum/patron/divine/necra)
			spawned.cmode_music = 'sound/music/cmode/church/CombatGravekeeper.ogg'
			ADD_TRAIT(spawned, TRAIT_DEADNOSE, TRAIT_GENERIC)
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

	if(spawned.age == AGE_OLD)
		spawned.adjust_skillrank(/datum/skill/magic/holy, 2, TRUE)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_END, 1)

	var/holder = spawned.patron?.devotion_holder
	if(holder)
		var/datum/devotion/devotion = new holder()
		devotion.make_acolyte()
		devotion.grant_to(spawned)

/datum/outfit/town_elder/hearth_acolyte
	name = "Hearth Acolyte (Town Elder)"
	head = /obj/item/clothing/head/roguehood/colored/random
	armor = /obj/item/clothing/shirt/robe
	shoes = /obj/item/clothing/shoes/sandals
	belt = /obj/item/storage/belt/leather/rope
	beltr = /obj/item/storage/keyring/elder
	beltl = /obj/item/flashlight/flare/torch/lantern
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/mid = 1,
		/obj/item/needle = 1
	)

/datum/outfit/town_elder/hearth_acolyte/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	switch(equipped_human.patron?.type)
		if(/datum/patron/divine/astrata)
			neck = /obj/item/clothing/neck/psycross/silver/astrata
		if(/datum/patron/divine/necra)
			neck = /obj/item/clothing/neck/psycross/silver/necra
		if(/datum/patron/divine/eora)
			neck = /obj/item/clothing/neck/psycross/silver/eora
		if(/datum/patron/divine/noc)
			neck = /obj/item/clothing/neck/psycross/silver/noc
		if(/datum/patron/divine/pestra)
			neck = /obj/item/clothing/neck/psycross/silver/pestra
			backpack_contents += /obj/item/needle/blessed
		if(/datum/patron/divine/dendor)
			neck = /obj/item/clothing/neck/psycross/silver/dendor
		if(/datum/patron/divine/abyssor)
			neck = /obj/item/clothing/neck/psycross/silver/abyssor
		if(/datum/patron/divine/ravox)
			neck = /obj/item/clothing/neck/psycross/silver/ravox
		if(/datum/patron/divine/xylix)
			neck = /obj/item/clothing/neck/psycross/silver/xylix
		if(/datum/patron/divine/malum)
			neck = /obj/item/clothing/neck/psycross/silver/malum
			backpack_contents += /obj/item/weapon/hammer/iron
		else
			neck = /obj/item/clothing/neck/psycross/silver

/datum/job/advclass/town_elder/lorekeeper
	title = "Lorekeeper"
	tutorial = "Your tales once lit up taverns, your ballads echoed through cities, and your curiosity led you across kingdoms. But the stage grows quiet, and your thirst for stories has shifted. Now, you collect history instead of applause, recording the town's past, preserving its legends, and guiding the present with the wisdom of ages. In a world where memory is power, you are its guardian."
	outfit = /datum/outfit/town_elder/lorekeeper
	category_tags = list(CTAG_TOWN_ELDER)

	jobstats = list(
		STATKEY_INT = 2,
		STATKEY_SPD = 1,
		STATKEY_STR = 1
	)

	skills = list(
		/datum/skill/combat/unarmed = 1,
		/datum/skill/combat/wrestling = 1,
		/datum/skill/combat/swords = 2,
		/datum/skill/craft/crafting = 2,
		/datum/skill/misc/swimming = 3,
		/datum/skill/misc/climbing = 2,
		/datum/skill/misc/riding = 4,
		/datum/skill/misc/sewing = 1,
		/datum/skill/misc/reading = 4,
		/datum/skill/craft/cooking = 1,
		/datum/skill/misc/music = 6,
		/datum/skill/misc/athletics = 2
	)

	traits = list(
		TRAIT_DODGEEXPERT,
		TRAIT_BARDIC_TRAINING
	)

	spells = list(
		/datum/action/cooldown/spell/vicious_mockery,
		// /datum/action/cooldown/spell/bardic_inspiration
	)

/datum/job/advclass/town_elder/lorekeeper/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.inspiration = new /datum/inspiration(spawned)

	if(spawned.age == AGE_OLD)
		spawned.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
		spawned.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_END, 1)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_INT, 1)

/datum/outfit/town_elder/lorekeeper
	name = "Lorekeeper (Town Elder)"
	head = /obj/item/clothing/head/bardhat
	armor = /obj/item/clothing/armor/leather/jacket/silk_coat
	shirt = /obj/item/clothing/shirt/tunic/noblecoat
	pants = /obj/item/clothing/pants/trou/leather
	shoes = /obj/item/clothing/shoes/boots
	gloves = /obj/item/clothing/gloves/leather
	wrists = /obj/item/clothing/wrists/bracers/leather
	cloak = /obj/item/clothing/cloak/half
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/weapon/sword/arming
	beltl = /obj/item/flashlight/flare/torch/lantern
	scabbards = list(/obj/item/weapon/scabbard/sword)
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/mid = 1,
		/obj/item/storage/keyring/elder = 1,
		/obj/item/paper/scroll = 5,
		/obj/item/natural/feather = 1
	)
