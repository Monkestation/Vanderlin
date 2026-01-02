/datum/job/advclass/wretch/plaguebearer
	title = "Plaguebearer"
	tutorial = "A disgraced physician forced into exile and years of hardship, you have turned to a private practice surrounding the only things you've ever known - poisons and plague. Revel in the spreading of blight, and unleash craven pestilence."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/wretch/plaguebearer
	total_positions = 2

	jobstats = list(
		STATKEY_INT = 3,
		STATKEY_PER = 3,
		STATKEY_CON = 3
	)

	skills = list(
		/datum/skill/combat/bows = 3,
		/datum/skill/combat/knives = 4,
		/datum/skill/misc/swimming = 2,
		/datum/skill/combat/wrestling = 4,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/misc/climbing = 4,
		/datum/skill/craft/crafting = 3,
		/datum/skill/craft/carpentry = 3,
		/datum/skill/misc/athletics = 3,
		/datum/skill/misc/reading = 3,
		/datum/skill/misc/medicine = 4,
		/datum/skill/misc/sewing = 3,
		/datum/skill/craft/alchemy = 5,
		/datum/skill/labor/farming = 3,
		/datum/skill/craft/bombs = 3
	)

	traits = list(
		TRAIT_LEGENDARY_ALCHEMIST,
		TRAIT_FORAGER,
		TRAIT_EMPATH,
		TRAIT_DEADNOSE
	)

	spells = list(
		/datum/action/cooldown/spell/diagnose,
		/datum/action/cooldown/spell/undirected/conjure_item/poison_bomb
	)


/datum/job/advclass/wretch/plaguebearer/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	wretch_select_bounty(spawned)

/datum/outfit/wretch/plaguebearer
	name = "Plaguebearer (Wretch)"
	mask = /obj/item/clothing/face/phys/plaguebearer
	head = /obj/item/clothing/head/roguehood/phys
	shoes = /obj/item/clothing/shoes/boots/leather
	shirt = /obj/item/clothing/shirt/undershirt/colored/black
	backl = /obj/item/storage/backpack/satchel/surgbag
	backr = /obj/item/storage/backpack/satchel
	pants = /obj/item/clothing/pants/tights/colored/random
	gloves = /obj/item/clothing/gloves/leather/phys
	armor = /obj/item/clothing/shirt/robe/phys
	neck = /obj/item/clothing/neck/phys
	belt = /obj/item/storage/belt/leather/black
	beltl = /obj/item/gun/ballistic/revolver/grenadelauncher/blowgun
	beltr = /obj/item/ammo_holder/dartpouch/poisondarts
	backpack_contents = list(
		/obj/item/reagent_containers/glass/bottle/poison = 1,
		/obj/item/reagent_containers/glass/bottle/strongstampoison = 1,
		/obj/item/storage/belt/pouch/coins/poor = 1,
		/obj/item/rope/chain = 1,
		/obj/item/flint = 1,
		/obj/item/reagent_containers/glass/bottle/stronghealthpot = 1,
	)