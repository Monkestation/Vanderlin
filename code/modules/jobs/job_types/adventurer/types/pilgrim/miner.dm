/datum/job/advclass/pilgrim/pilgrimminer
	title = "Miner"
	tutorial = "Hardy people who ceaselessly toil at the mines for ores and salt, \
				who will ever know what they'll find beneath?"
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/pilgrim/miner
	category_tags = list(CTAG_PILGRIM)
	apprentice_name = "Miner Apprentice"
	cmode_music = 'sound/music/cmode/towner/CombatBeggar.ogg'

	jobstats = list(
		STATKEY_STR = 1,
		STATKEY_INT = -2,
		STATKEY_END = 1,
		STATKEY_CON = 1
	)

	skills = list(
		/datum/skill/combat/axesmaces = 2,
		/datum/skill/labor/mining = 4,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/craft/crafting = 2,
		/datum/skill/misc/swimming = 1,
		/datum/skill/misc/climbing = 2,
		/datum/skill/misc/medicine = 1,
		/datum/skill/misc/athletics = 3,
		/datum/skill/craft/traps = 1,
		/datum/skill/craft/engineering = 2,
		/datum/skill/craft/smelting = 4,
		/datum/skill/misc/reading = 1
	)

/datum/job/advclass/pilgrimminer/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(spawned.dna?.species.id == SPEC_ID_DWARF)
		spawned.cmode_music = 'sound/music/cmode/combat_dwarf.ogg'

/datum/outfit/pilgrim/miner
	name = "Miner (Pilgrim)"
	pants = /obj/item/clothing/pants/trou
	armor = /obj/item/clothing/armor/gambeson/light/striped
	shoes = /obj/item/clothing/shoes/boots/leather
	belt = /obj/item/storage/belt/leather
	neck = /obj/item/storage/belt/pouch/coins/poor
	beltl = /obj/item/weapon/pick
	backr = /obj/item/weapon/shovel
	backl = /obj/item/storage/backpack/backpack
	backpack_contents = list(
		/obj/item/flint = 1,
		/obj/item/weapon/knife/villager = 1
	)

/datum/outfit/pilgrim/miner/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	head = pick(/obj/item/clothing/head/armingcap, /obj/item/clothing/head/headband/colored/red, /obj/item/clothing/head/roguehood/colored/random)
	shirt = pick(/obj/item/clothing/shirt/undershirt/colored/random, /obj/item/clothing/shirt/shortshirt/colored/random)

	if(equipped_human.dna.species.id == SPEC_ID_DWARF)
		head = /obj/item/clothing/head/helmet/leather/minershelm
	else
		beltr = /obj/item/flashlight/flare/torch/lantern
