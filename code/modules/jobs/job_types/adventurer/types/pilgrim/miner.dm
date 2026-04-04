/datum/attribute_holder/sheet/job/pilgrim/pilgrimminer
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_INTELLIGENCE = -2,
		STAT_ENDURANCE = 1,
		STAT_CONSTITUTION = 1,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/labor/mining = 40,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/misc/swimming = 10,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/craft/traps = 10,
		/datum/attribute/skill/craft/engineering = 20,
		/datum/attribute/skill/craft/smelting = 40,
		/datum/attribute/skill/misc/reading = 10,
	)

/datum/job/advclass/pilgrim/pilgrimminer
	title = "Miner"
	tutorial = "Hardy people who ceaselessly toil at the mines for ores and salt, \
				who will ever know what they'll find beneath?"
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/pilgrim/miner
	category_tags = list(CTAG_PILGRIM)
	apprentice_name = "Miner Apprentice"
	cmode_music = 'sound/music/cmode/towner/CombatBeggar.ogg'

	attribute_sheet = /datum/attribute_holder/sheet/job/pilgrim/pilgrimminer

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
