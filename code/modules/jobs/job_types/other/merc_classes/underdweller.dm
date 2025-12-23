/datum/job/advclass/mercenary/underdweller
	title = "Underdweller"
	tutorial = "A member of the Underdwellers, you've taken many of the deadliest contracts known to man in literal underground circles. Drow or Dwarf, you've put your differences aside for coin and adventure."
	allowed_races = list(\
		SPEC_ID_DWARF,\
		SPEC_ID_DROW,\
		SPEC_ID_HALF_DROW,\
		SPEC_ID_KOBOLD,\
	)
	outfit = /datum/outfit/mercenary/underdweller
	category_tags = list(CTAG_MERCENARY)
	total_positions = 5

	jobstats = list(
		STATKEY_LCK = 1,
		STATKEY_END = 2,
		STATKEY_STR = 1,
		STATKEY_INT = 1
	)

	skills = list(
		/datum/skill/labor/mining = 3,
		/datum/skill/combat/wrestling = 3,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/combat/knives = 2,
		/datum/skill/craft/crafting = 2,
		/datum/skill/craft/engineering = 1,
		/datum/skill/misc/lockpicking = 2,
		/datum/skill/misc/reading = 1,
		/datum/skill/misc/swimming = 1,
		/datum/skill/misc/climbing = 4,
		/datum/skill/misc/medicine = 1,
		/datum/skill/misc/sewing = 1,
		/datum/skill/misc/athletics = 3
	)

	traits = list(
		TRAIT_MEDIUMARMOR
	)

/datum/job/advclass/mercenary/underdweller/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.merctype = 3

	// Species-specific adjustments
	if(spawned.dna?.species?.id == SPEC_ID_DWARF)
		spawned.cmode_music = 'sound/music/cmode/adventurer/CombatOutlander2.ogg'

		// Dwarf-specific skill adjustments
		spawned.adjust_skillrank(/datum/skill/combat/axesmaces, 4)
		spawned.adjust_skillrank(/datum/skill/combat/shields, 2)
		spawned.adjust_skillrank(/datum/skill/craft/bombs, 4) // Dwarves get to make bombs.
	else
		// Non-dwarf skill adjustment
		spawned.adjust_skillrank(/datum/skill/combat/swords, 4)

/datum/outfit/mercenary/underdweller
	name = "Underdweller (Mercenary)"
	pants = /obj/item/clothing/pants/trou/leather
	armor = /obj/item/clothing/armor/cuirass/iron
	shoes = /obj/item/clothing/shoes/boots/armor/light
	belt = /obj/item/storage/belt/leather/mercenary
	beltr = /obj/item/weapon/knife/hunting
	neck = /obj/item/clothing/neck/chaincoif/iron
	backl = /obj/item/storage/backpack/backpack
	scabbards = list(/obj/item/weapon/scabbard/knife)
	backpack_contents = list(/obj/item/storage/belt/pouch/coins/poor = 1)

/datum/outfit/mercenary/underdweller/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	var/shirt_type = pickweight(list(
		/obj/item/clothing/armor/chainmail/iron = 1, // iron maille
		/obj/item/clothing/armor/gambeson = 4, // gambeson
		/obj/item/clothing/armor/gambeson/light = 4, // light gambeson
		/obj/item/clothing/shirt/undershirt/sailor/red = 1 // sailor shirt
	))
	shirt = shirt_type

	// Species-specific equipment (visual equipment)
	if(equipped_human.dna?.species?.id == SPEC_ID_DWARF)
		head = /obj/item/clothing/head/helmet/leather/minershelm
		beltl = /obj/item/weapon/pick/paxe // Dorfs get a pick as their primary weapon and axes/maces to use it
		backr = /obj/item/weapon/shield/wood
	else
		// No miner's helm for Delves or kobolds as they have nitevision now.
		beltl = /obj/item/weapon/sword/sabre // Dark elves get a sabre as their primary weapon and swords skill, who woulda thought
		head = /obj/item/clothing/head/helmet/leather // similar to the miner helm, except not as cool of course