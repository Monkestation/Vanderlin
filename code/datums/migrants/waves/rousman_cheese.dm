/datum/migrant_role/rousman_cheese/captain
	name = "Rousman Captain"
	greet_text = "You are the captain of a dwarven's expedition, following the tracks of Matthios's influence you shall lead your party in Malum's name."
	migrant_job = /datum/job/migrant/rousman_cheese/captain

/datum/job/migrant/rousman_cheese
	allowed_races = RACES_PLAYER_ALL
	spawn_type = /mob/living/carbon/human/species/rousman/random_name

/datum/job/migrant/rousman_cheese/captain
	title = "Rousman Captain"
	tutorial = "You are the captain of a dwarven's expedition, following the tracks of Matthios's influence you shall lead your party in Malum's name."
	outfit = /datum/outfit/rousman_cheese/captain
	jobstats = list(
		STATKEY_STR = 3,
		STATKEY_PER = 2,
		STATKEY_INT = 1,
		STATKEY_CON = 2,
		STATKEY_END = 2,
		STATKEY_SPD = 1,
	)

	skills = list(
		/datum/skill/combat/knives = 2,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/misc/climbing = 3,
		/datum/skill/misc/athletics = 3,
		/datum/skill/craft/cooking = 3,
		/datum/skill/craft/crafting = 3,
		/datum/skill/craft/traps = 2,
	)

/datum/outfit/rousman_cheese/captain
	name = "Rousman Captain (Migrant Wave)"
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

/datum/migrant_role/rousman_cheese/weaponsmith
	name = "Rousman Weaponsmith"
	greet_text = " You are the weaponsmith of a dwarven expedition, obey your foreman as they lead you in Malum's name into the tomb of Matthios."
	migrant_job = /datum/job/migrant/rousman_cheese/weaponsmith

/datum/job/migrant/rousman_cheese/weaponsmith
	title = "Rousman Weaponsmith"
	tutorial = " You are the weaponsmith of a dwarven expedition, obey your foreman as they lead you in Malum's name into the tomb of Matthios."
	outfit = /datum/outfit/rousman_cheese/weaponsmith

	jobstats = list(
		STATKEY_STR = 1,
		STATKEY_END = 2,
		STATKEY_SPD = -1,
	)

	skills = list(
		/datum/skill/combat/knives = 2,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/misc/climbing = 3,
		/datum/skill/misc/athletics = 3,
		/datum/skill/craft/cooking = 3,
		/datum/skill/craft/crafting = 3,
		/datum/skill/craft/traps = 2,
	)

/datum/outfit/rousman_cheese/weaponsmith
	name = "Rousman Weaponsmith (Migrant Wave)"
	ring = /obj/item/clothing/ring/silver/makers_guild
	head = /obj/item/clothing/head/hatfur
	cloak = /obj/item/clothing/cloak/apron/brown
	beltl = /obj/item/storage/belt/pouch/coins/poor
	armor = /obj/item/clothing/armor/leather/splint
	belt = /obj/item/storage/belt/leather
	pants = /obj/item/clothing/pants/trou
	backr = /obj/item/weapon/axe/steel

/datum/outfit/rousman_cheese/weaponsmith/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
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

/datum/migrant_role/rousman_cheese/armorsmith
	name = "Rousman Armorsmith"
	greet_text = " You are the armorsmith of a dwarven expedition, obey your foreman as they lead you in Malum's name into the tomb of Matthios."
	migrant_job = /datum/job/migrant/rousman_cheese/armorsmith

/datum/job/migrant/rousman_cheese/armorsmith
	title = "Rousman Armorsmith"
	tutorial = " You are the armorsmith of a dwarven expedition, obey your foreman as they lead you in Malum's name into the tomb of Matthios."
	outfit = /datum/outfit/rousman_cheese/armorsmith

	jobstats = list(
		STATKEY_STR = 1,
		STATKEY_END = 2,
		STATKEY_SPD = -1,
	)

	skills = list(
		/datum/skill/combat/knives = 2,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/misc/climbing = 3,
		/datum/skill/misc/athletics = 3,
		/datum/skill/craft/cooking = 3,
		/datum/skill/craft/crafting = 3,
		/datum/skill/craft/traps = 2,
	)

/datum/outfit/rousman_cheese/armorsmith
	name = "Rousman Armorsmith"
	ring = /obj/item/clothing/ring/silver/makers_guild
	head = /obj/item/clothing/head/hatfur
	pants = /obj/item/clothing/pants/trou
	belt = /obj/item/storage/belt/leather
	beltl = /obj/item/storage/belt/pouch/coins/poor
	cloak = /obj/item/clothing/cloak/apron/brown
	armor = /obj/item/clothing/armor/chainmail
	backr = /obj/item/weapon/axe/steel

/datum/outfit/rousman_cheese/armorsmith/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
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

/datum/migrant_wave/rousman_cheese
	name = "Rousman Expedition"
	max_spawns = 4
	shared_wave_type = /datum/migrant_wave/rousman_cheese
	downgrade_wave = /datum/migrant_wave/rousman_cheese_down
	can_roll = TRUE
	weight = 0
	triumph_threshold = 50
	roles = list(
		/datum/migrant_role/rousman_cheese/captain = 1,
		/datum/migrant_role/rousman_cheese/weaponsmith = 2,
		/datum/migrant_role/rousman_cheese/armorsmith = 2
	)
	greet_text = "The way to Matthios's tomb is opened. Malum has called for all dwarves bold enough to go in, and we shall answer."

/datum/migrant_wave/rousman_cheese_down
	name = "Rousman Expedition"
	max_spawns = 4
	shared_wave_type = /datum/migrant_wave/rousman_cheese
	downgrade_wave = /datum/migrant_wave/rousman_cheese_down_one
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/rousman_cheese/captain = 1,
		/datum/migrant_role/rousman_cheese/armorsmith = 1,
		/datum/migrant_role/rousman_cheese/weaponsmith = 1
	)
	greet_text = "The way to Matthios's tomb is opened. Malum has called for all dwarves bold enough to go in, and we shall answer."

/datum/migrant_wave/rousman_cheese_down_one
	name = "Rousman Expedition"
	max_spawns = 4
	shared_wave_type = /datum/migrant_wave/rousman_cheese
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/rousman_cheese/captain = 1,
	)
	greet_text = "The way to Matthios's tomb is opened. Malum has called for all dwarves bold enough to go in, and we shall answer."


