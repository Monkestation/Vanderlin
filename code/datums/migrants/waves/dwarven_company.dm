/datum/migrant_role/dwarven_company/captain
	name = "Dwarven Captain"
	greet_text = "You are the captain of a dwarven's expedition, following the tracks of Matthios's influence you shall lead your party in Malum's name."
	migrant_job = /datum/job/migrant/dwarven_company/captain

/datum/job/migrant/dwarven_company
	allowed_races = list(SPEC_ID_DWARF)

/datum/attribute_holder/sheet/job/migrant/captain
	raw_attribute_list = list(
		STAT_STRENGTH = 3,
		STAT_PERCEPTION = 2,
		STAT_INTELLIGENCE = 1,
		STAT_CONSTITUTION = 2,
		STAT_ENDURANCE = 2,
		STAT_SPEED = 1,
		/datum/attribute/skill/combat/shields = 40,
		/datum/attribute/skill/combat/axesmaces = 40,
		/datum/attribute/skill/combat/swords = 20,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/misc/swimming = 10,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/craft/crafting = 30,
		/datum/attribute/skill/craft/blacksmithing = 20,
		/datum/attribute/skill/craft/armorsmithing = 20,
		/datum/attribute/skill/craft/weaponsmithing = 20,
		/datum/attribute/skill/craft/smelting = 20,
		/datum/attribute/skill/craft/engineering = 10,
		/datum/attribute/skill/craft/traps = 20,
		/datum/attribute/skill/misc/reading = 20,
	)

/datum/job/migrant/dwarven_company/captain
	title = "Dwarven Captain"
	tutorial = "You are the captain of a dwarven's expedition, following the tracks of Matthios's influence you shall lead your party in Malum's name."
	outfit = /datum/outfit/dwarven_company/captain
	exp_types_granted  = list(EXP_TYPE_COMBAT)
	attribute_sheet = /datum/attribute_holder/sheet/job/migrant/captain

	traits = list(
		TRAIT_MALUMFIRE,
		TRAIT_HEAVYARMOR,
		TRAIT_MEDIUMARMOR,
	)

/datum/outfit/dwarven_company/captain
	name = "Dwarven Captain (Migrant Wave)"
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

/datum/attribute_holder/sheet/job/migrant/weaponsmith
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_ENDURANCE = 2,
		STAT_SPEED = -1,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/craft/crafting = 30,
		/datum/attribute/skill/craft/blacksmithing = 40,
		/datum/attribute/skill/craft/armorsmithing = 20,
		/datum/attribute/skill/craft/weaponsmithing = 40,
		/datum/attribute/skill/craft/smelting = 30,
		/datum/attribute/skill/craft/engineering = 30,
		/datum/attribute/skill/craft/traps = 20,
		/datum/attribute/skill/misc/reading = 20,
	)

/datum/attribute_holder/sheet/job/migrant/weaponsmith/old
	attribute_variance = list(
		/datum/attribute/skill/craft/blacksmithing = list(10, 20),
		/datum/attribute/skill/craft/weaponsmithing = list(10, 20),
	)
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_ENDURANCE = 2,
		STAT_SPEED = -1,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/craft/crafting = 30,
		/datum/attribute/skill/craft/blacksmithing = 40,
		/datum/attribute/skill/craft/armorsmithing = 20,
		/datum/attribute/skill/craft/weaponsmithing = 40,
		/datum/attribute/skill/craft/smelting = 30,
		/datum/attribute/skill/craft/engineering = 30,
		/datum/attribute/skill/craft/traps = 20,
		/datum/attribute/skill/misc/reading = 20,
	)

/datum/job/migrant/dwarven_company/weaponsmith
	title = "Dwarven Weaponsmith"
	tutorial = " You are the weaponsmith of a dwarven expedition, obey your foreman as they lead you in Malum's name into the tomb of Matthios."
	outfit = /datum/outfit/dwarven_company/weaponsmith

	attribute_sheet = /datum/attribute_holder/sheet/job/migrant/weaponsmith
	attribute_sheet_old = /datum/attribute_holder/sheet/job/migrant/weaponsmith/old

	traits = list(
		TRAIT_MALUMFIRE,
		TRAIT_MEDIUMARMOR,
	)

/datum/outfit/dwarven_company/weaponsmith
	name = "Dwarven Weaponsmith (Migrant Wave)"
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

/datum/attribute_holder/sheet/job/migrant/armorsmith
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_ENDURANCE = 2,
		STAT_SPEED = -1,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/craft/crafting = 30,
		/datum/attribute/skill/craft/blacksmithing = 40,
		/datum/attribute/skill/craft/armorsmithing = 40,
		/datum/attribute/skill/craft/weaponsmithing = 20,
		/datum/attribute/skill/craft/smelting = 30,
		/datum/attribute/skill/craft/engineering = 30,
		/datum/attribute/skill/craft/traps = 20,
		/datum/attribute/skill/misc/reading = 20,
	)

/datum/attribute_holder/sheet/job/migrant/armorsmith/old
	attribute_variance = list(
		/datum/attribute/skill/craft/blacksmithing = list(10, 20),
		/datum/attribute/skill/craft/armorsmithing = list(10, 20)
	)
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_ENDURANCE = 2,
		STAT_SPEED = -1,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/craft/crafting = 30,
		/datum/attribute/skill/craft/blacksmithing = 40,
		/datum/attribute/skill/craft/armorsmithing = 40,
		/datum/attribute/skill/craft/weaponsmithing = 20,
		/datum/attribute/skill/craft/smelting = 30,
		/datum/attribute/skill/craft/engineering = 30,
		/datum/attribute/skill/craft/traps = 20,
		/datum/attribute/skill/misc/reading = 20,
	)

/datum/job/migrant/dwarven_company/armorsmith
	title = "Dwarven Armorsmith"
	tutorial = " You are the armorsmith of a dwarven expedition, obey your foreman as they lead you in Malum's name into the tomb of Matthios."
	outfit = /datum/outfit/dwarven_company/armorsmith

	attribute_sheet = /datum/attribute_holder/sheet/job/migrant/armorsmith
	attribute_sheet_old = /datum/attribute_holder/sheet/job/migrant/armorsmith/old

	traits = list(
		TRAIT_MALUMFIRE,
		TRAIT_MEDIUMARMOR,
	)

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


