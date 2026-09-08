/datum/attribute_holder/sheet/job/courtagent/quack
	raw_attribute_list = list(
		STAT_STRENGTH = -1,
		STAT_INTELLIGENCE = 2,
		STAT_PERCEPTION = 1,
		/datum/attribute/skill/misc/reading = 30,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/combat/knives = 30,
		/datum/attribute/skill/misc/sewing = 20,
		/datum/attribute/skill/craft/alchemy = 20,
		/datum/attribute/skill/labor/mathematics = 20,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/craft/engineering = 20,
		/datum/attribute/skill/labor/farming = 20,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/sneaking = 30,
		/datum/attribute/skill/misc/lockpicking = 30,
		/datum/attribute/skill/misc/stealing = 30,
	)
	attribute_variance = list(
		/datum/attribute/skill/misc/medicine = list(30, 40),
	)

/datum/job/advclass/courtagent/quack
	title = "Quack"
	tutorial = "You are one of the Hand's loyal Agents. \
	Sometimes your colleagues go a little too far trying to get answers and the Court Physician probably shouldn't know about it. \
	That's where you come in. Skilled in medicine and equipped for the worst, you keep the servants of the Hand alive, and their enemies <i>alive enough</i>."
	outfit = /datum/outfit/courtagent/quack
	category_tags = list(CTAG_COURTAGENT)

	attribute_sheet = /datum/attribute_holder/sheet/job/courtagent/quack
	traits = list(
		TRAIT_EMPATH,
		TRAIT_DEADNOSE
	)

	spells = list(
		/datum/action/cooldown/spell/diagnose
	)
	cmode_music = 'sound/music/cmode/nobility/combat_physician.ogg'
	book_type = /obj/item/recipe_book/medical
	allowed_races = list(SPEC_ID_MEDICATOR)

/datum/outfit/courtagent/quack
	name = "Quack (Court Agent)"
	head = /obj/item/clothing/head/roguehood/phys
	mask = /obj/item/clothing/face/phys
	shoes = /obj/item/clothing/shoes/boots/leather
	shirt = /obj/item/clothing/shirt/undershirt/colored/black
	backl = /obj/item/storage/backpack/satchel/surgbag
	backr = /obj/item/storage/backpack/satchel/black
	pants = /obj/item/clothing/pants/tights/colored/random
	gloves = /obj/item/clothing/gloves/leather/phys
	armor = /obj/item/clothing/shirt/robe/phys
	neck = /obj/item/clothing/neck/phys
	wrists = /obj/item/weapon/scabbard/knife/hidden/stiletto
	belt = /obj/item/storage/belt/leather/black/courtagent
	beltl = /obj/item/storage/fancy/ifak

	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/poor = 1,
		/obj/item/reagent_containers/glass/bottle/healthpot/labelled = 2,
	)
