/datum/job/advclass/combat/dranger
	title = "Dwarf Ranger"
	tutorial = "Dwarfish rangers, much like their humen counterparts, \
	live outside of society and explore the far corners of the creation. They \
	protect dwarfish settlements from wild beasts and sell their notes to the cartographers."
	allowed_races = list(SPEC_ID_DWARF)
	outfit = /datum/outfit/adventurer/dranger
	category_tags = list(CTAG_ADVENTURER)

	exp_types_granted = list(EXP_TYPE_ADVENTURER, EXP_TYPE_COMBAT, EXP_TYPE_RANGER)

	skills = list(
		/datum/skill/combat/swords = 3, // In line with basic combat classes
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/craft/crafting = 2,
		/datum/skill/misc/swimming = 1,
		/datum/skill/misc/climbing = 3,
		/datum/skill/combat/crossbows = 3,
		/datum/skill/craft/tanning = 2,
		/datum/skill/misc/sewing = 3,
		/datum/skill/misc/medicine = 2,
		/datum/skill/craft/cooking = 1,
		/datum/skill/misc/athletics = 2,
		/datum/skill/misc/reading = 2,
	)

	jobstats = list(
		STATKEY_PER = 3,
		STATKEY_SPD = 1, // Fast... for a dwarf
	)

	traits = list(
		TRAIT_MEDIUMARMOR, // Dwarf rangers are no good at dodging, but can wear heavier armor than typical rangers
	)

/datum/outfit/adventurer/dranger
	name = "Dwarf Ranger (Adventurer)"
	head = /obj/item/clothing/head/roguehood/colored/uncolored
	pants = /obj/item/clothing/pants/trou/leather
	shirt = /obj/item/clothing/shirt/undershirt/colored/random
	shoes = /obj/item/clothing/shoes/simpleshoes
	belt = /obj/item/storage/belt/leather
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	backl = /obj/item/storage/backpack/satchel
	beltl = /obj/item/ammo_holder/quiver/bolts
	beltr = /obj/item/flashlight/flare/torch/lantern
	armor = /obj/item/clothing/armor/chainmail/iron // Starts with better armor than a typical ranger (iron chainmail) but has no dodge expert or sneaking skill
	wrists = /obj/item/clothing/wrists/bracers/leather
	r_hand = /obj/item/weapon/sword/scimitar/falchion
	cloak = /obj/item/clothing/cloak/raincloak/colored/brown

	backpack_contents = list(
		/obj/item/bait = 1,
	)

/datum/outfit/adventurer/dranger/pre_equip(mob/living/carbon/human/H, visuals_only)
	. = ..()
	var/shoe_roll = prob(23)
	if(shoe_roll)
		shoes = /obj/item/clothing/shoes/boots
	else if(prob(23))
		shoes = /obj/item/clothing/shoes/boots/leather
