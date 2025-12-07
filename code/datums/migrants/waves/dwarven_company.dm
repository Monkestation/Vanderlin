/datum/migrant_role/dwarven_company/captain
	name = "Dwarven Captain"
	greet_text = "You are the captain of a dwarven's expedition, following the tracks of Matthios's influence you shall lead your party in Malum's name."
	migrant_job = /datum/job/migrant/dwarven_company/captain

/datum/job/migrant/dwarven_company
	allowed_races = list(SPEC_ID_DWARF)

/datum/job/migrant/dwarven_company/captain
	title = "Dwarven Captain"
	tutorial = "You are the captain of a dwarven's expedition, following the tracks of Matthios's influence you shall lead your party in Malum's name."
	outfit = /datum/outfit/dwarven_company/captain

	jobstats = list(
		STATKEY_STR = 3,
		STATKEY_PER = 2,
		STATKEY_INT = 1,
		STATKEY_CON = 2,
		STATKEY_END = 2,
		STATKEY_SPD = 1,
	)

	skills = list(
		/datum/skill/combat/shields = 4,
		/datum/skill/combat/axesmaces = 4,
		/datum/skill/combat/swords = 2,
		/datum/skill/combat/knives = 2,
		/datum/skill/combat/wrestling = 3,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/misc/swimming = 1,
		/datum/skill/misc/climbing = 4,
		/datum/skill/misc/athletics = 3,
		/datum/skill/craft/crafting = 3,
		/datum/skill/craft/blacksmithing = 2,
		/datum/skill/craft/armorsmithing = 2,
		/datum/skill/craft/weaponsmithing = 2,
		/datum/skill/craft/smelting = 2,
		/datum/skill/craft/engineering = 1,
		/datum/skill/craft/traps = 2,
		/datum/skill/misc/reading = 2,
	)

	traits = list(
		TRAIT_MALUMFIRE,
		TRAIT_HEAVYARMOR,
		TRAIT_MEDIUMARMOR,
	)

/datum/outfit/dwarven_company/captain
	name = "Dwarven Captain"
	armor = /obj/item/clothing/armor/cuirass
	cloak = /obj/item/clothing/cloak/raincloak/furcloak
	shirt = /obj/item/clothing/armor/chainmail
	neck = /obj/item/clothing/neck/gorget
	head = /obj/item/clothing/head/helmet/coppercap
	backr = /obj/item/weapon/shield/wood
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/flashlight/flare/torch/lantern
	beltl = /obj/item/weapon/pick/paxe
	pants = /obj/item/clothing/pants/trou
	shoes = /obj/item/clothing/shoes/simpleshoes/buckle
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/storage/belt/pouch/coins/poor)

/datum/migrant_role/dwarven_company/weaponsmith
	name = "Dwarven Weaponsmith"
	greet_text = " You are the weaponsmith of a dwarven expedition, obey your foreman as they lead you in Malum's name into the tomb of Matthios."
	migrant_job = /datum/job/migrant/dwarven_company/weaponsmith

/datum/job/migrant/dwarven_company/weaponsmith
	title = "Dwarven Weaponsmith"
	tutorial = " You are the weaponsmith of a dwarven expedition, obey your foreman as they lead you in Malum's name into the tomb of Matthios."
	outfit = /datum/outfit/dwarven_company/weaponsmith

	jobstats = list(
		STATKEY_STR = 1,
		STATKEY_END = 2,
		STATKEY_SPD = -1,
	)

	skills = list(
		/datum/skill/combat/axesmaces = 2,
		/datum/skill/misc/athletics = 3,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/craft/crafting = 3,
		/datum/skill/craft/blacksmithing = 4,
		/datum/skill/craft/armorsmithing = 2,
		/datum/skill/craft/weaponsmithing = 4,
		/datum/skill/craft/smelting = 3,
		/datum/skill/craft/engineering = 3,
		/datum/skill/craft/traps = 2,
		/datum/skill/misc/reading = 2,
	)

	traits = list(
		TRAIT_MALUMFIRE,
		TRAIT_MEDIUMARMOR,
	)

/datum/job/migrant/dwarven_company/weaponsmith/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(spawned.age == AGE_OLD)
		spawned.adjust_skillrank(/datum/skill/craft/blacksmithing, pick(1, 2))
		spawned.adjust_skillrank(/datum/skill/craft/weaponsmithing, pick(1, 2))

/datum/outfit/dwarven_company/weaponsmith
	name = "Dwarven Weaponsmith"
	ring = /obj/item/clothing/ring/silver/makers_guild
	head = /obj/item/clothing/head/hatfur
	cloak = /obj/item/clothing/cloak/apron/brown
	beltl = /obj/item/storage/belt/pouch/coins/poor
	armor = /obj/item/clothing/armor/leather/splint
	belt = /obj/item/storage/belt/leather
	pants = /obj/item/clothing/pants/trou
	backr = /obj/item/weapon/axe/steel

/datum/outfit/dwarven_company/weaponsmith/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()

	if(prob(50))
		head = /obj/item/clothing/head/hatblu

	if(equipped_human.gender == MALE)
		shoes = /obj/item/clothing/shoes/boots/leather
		shirt = /obj/item/clothing/shirt/shortshirt
		beltl = /obj/item/storage/belt/pouch/coins/poor
		backl =	/obj/item/weapon/hammer/sledgehammer
	else
		shirt = /obj/item/clothing/shirt/dress/gen/colored/random
		armor = /obj/item/clothing/armor/leather/splint
		shoes = /obj/item/clothing/shoes/shortboots
		backl = /obj/item/weapon/pick/paxe

/datum/migrant_role/dwarven_company/armorsmith
	name = "Dwarven Armorsmith"
	greet_text = " You are the armorsmith of a dwarven expedition, obey your foreman as they lead you in Malum's name into the tomb of Matthios."
	migrant_job = /datum/job/migrant/dwarven_company/armorsmith

/datum/job/migrant/dwarven_company/armorsmith
	title = "Dwarven Armorsmith"
	tutorial = " You are the armorsmith of a dwarven expedition, obey your foreman as they lead you in Malum's name into the tomb of Matthios."
	outfit = /datum/outfit/dwarven_company/armorsmith

	jobstats = list(
		STATKEY_STR = 1,
		STATKEY_END = 2,
		STATKEY_SPD = -1,
	)

	skills = list(
		/datum/skill/combat/axesmaces = 2,
		/datum/skill/misc/athletics = 3,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/craft/crafting = 3,
		/datum/skill/craft/blacksmithing = 4,
		/datum/skill/craft/armorsmithing = 4,
		/datum/skill/craft/weaponsmithing = 2,
		/datum/skill/craft/smelting = 3,
		/datum/skill/craft/engineering = 3,
		/datum/skill/craft/traps = 2,
		/datum/skill/misc/reading = 2,
	)

	traits = list(
		TRAIT_MALUMFIRE,
		TRAIT_MEDIUMARMOR,
	)

/datum/job/migrant/dwarven_company/armorsmith/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(spawned.age == AGE_OLD)
		LAZYADDASSOC(skills, /datum/skill/craft/blacksmithing, pick(1, 2))
		LAZYADDASSOC(skills, /datum/skill/craft/armorsmithing, pick(1, 2))

/datum/outfit/dwarven_company/armorsmith
	name = "Dwarven Armorsmith"
	ring = /obj/item/clothing/ring/silver/makers_guild
	head = /obj/item/clothing/head/hatfur
	pants = /obj/item/clothing/pants/trou
	belt = /obj/item/storage/belt/leather
	beltl = /obj/item/storage/belt/pouch/coins/poor
	cloak = /obj/item/clothing/cloak/apron/brown
	armor = /obj/item/clothing/armor/chainmail
	backr = /obj/item/weapon/axe/steel

/datum/outfit/dwarven_company/armorsmith/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()

	if(prob(50))
		head = /obj/item/clothing/head/hatblu

	if(equipped_human.gender == MALE)
		shoes = /obj/item/clothing/shoes/simpleshoes/buckle
		shirt = /obj/item/clothing/shirt/shortshirt
		backl = /obj/item/weapon/pick/paxe
	else
		shirt = /obj/item/clothing/shirt/dress/gen/colored/random
		shoes = /obj/item/clothing/shoes/shortboots
		backl =	/obj/item/weapon/hammer/sledgehammer

/datum/migrant_wave/dwarven_company
	name = "Dwarven Expedition"
	max_spawns = 4
	shared_wave_type = /datum/migrant_wave/dwarven_company
	downgrade_wave = /datum/migrant_wave/dwarven_company_down
	weight = 15
	roles = list(
		/datum/migrant_role/dwarven_company/captain = 1,
		/datum/migrant_role/dwarven_company/weaponsmith = 2,
		/datum/migrant_role/dwarven_company/armorsmith = 2
	)
	greet_text = "The way to Matthios's tomb is opened. Malum has called for all dwarves bold enough to go in, and we shall answer."

/datum/migrant_wave/dwarven_company_down
	name = "Dwarven Expedition"
	max_spawns = 4
	shared_wave_type = /datum/migrant_wave/dwarven_company
	downgrade_wave = /datum/migrant_wave/dwarven_company_down_one
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/dwarven_company/captain = 1,
		/datum/migrant_role/dwarven_company/armorsmith = 1,
		/datum/migrant_role/dwarven_company/weaponsmith = 1
	)
	greet_text = "The way to Matthios's tomb is opened. Malum has called for all dwarves bold enough to go in, and we shall answer."

/datum/migrant_wave/dwarven_company_down_one
	name = "Dwarven Expedition"
	max_spawns = 4
	shared_wave_type = /datum/migrant_wave/dwarven_company
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/dwarven_company/captain = 1,
	)
	greet_text = "The way to Matthios's tomb is opened. Malum has called for all dwarves bold enough to go in, and we shall answer."


