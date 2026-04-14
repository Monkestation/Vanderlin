/datum/migrant_role/ratcatcher
	name = "Ratcatcher"
	greet_text = "You've been on the street for as long as you can remember. Still are, and you still will be so long as \
	you live in this shitpit. Regrettably, the universe sought to make your life a divine comedy. Instead of begging for \
	coin, the nobility sought it grand to give you a royal title - Ratcatcher. Please, for the love of Necra, just LET IT END!"
	migrant_job = /datum/job/migrant/ratcatcher

/datum/attribute_holder/sheet/job/migrant/ratcatcher
	raw_attribute_list = list(
		STAT_SPEED = -2,
		STAT_ENDURANCE = 2,
		STAT_CONSTITUTION = 1,
		STAT_INTELLIGENCE = -3,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/polearms = 20,
		/datum/attribute/skill/combat/shields = 30,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/swimming = 30,
		/datum/attribute/skill/misc/sewing = 20,
		/datum/attribute/skill/misc/medicine = 20,
	)

/datum/job/migrant/ratcatcher
	title = "Ratcatcher"
	tutorial = "You've been on the street for as long as you can remember. Still are, and you still will be so long as \
	you live in this shitpit. Regrettably, the universe sought to make your life a divine comedy. Instead of begging for \
	coin, the nobility sought it grand to give you a royal title - Ratcatcher. Please, for the love of Necra, just LET IT END!"
	outfit = /datum/outfit/ratcatcher
	is_recognized = TRUE

	attribute_sheet = /datum/attribute_holder/sheet/job/migrant/ratcatcher

	traits = list(TRAIT_STEELHEARTED)
	cmode_music = 'sound/music/cmode/towner/CombatTowner2.ogg'

/datum/outfit/ratcatcher
	name = "Ratcatcher (Migrant Wave)"
	r_hand = /obj/item/weapon/pitchfork
	l_hand = /obj/item/flint
	armor = /obj/item/clothing/armor/gambeson/light
	shirt = /obj/item/clothing/shirt/undershirt/colored/vagrant
	neck = /obj/item/clothing/neck/coif/cloth
	head = /obj/item/clothing/head/helmet/leather
	gloves = /obj/item/clothing/gloves/fingerless
	pants = /obj/item/clothing/pants/tights/colored/vagrant
	shoes = /obj/item/clothing/shoes/boots
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/flashlight/flare/torch/lantern
	beltl = /obj/item/storage/belt/pouch/coins/poor

/datum/migrant_wave/ratcatcher
	name = "The Ratcatcher"
	max_spawns = 1
	shared_wave_type = /datum/migrant_wave/ratcatcher
	weight = 10
	roles = list(
		/datum/migrant_role/ratcatcher = 1,
	)
	greet_text = "A peasant comes in to sit at the table. He looks depressed, horribly depressed."
