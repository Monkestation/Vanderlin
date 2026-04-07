/datum/attribute_holder/sheet/job/dranger
	raw_attribute_list = list(
		STAT_PERCEPTION = 3,
		STAT_SPEED = 1, // Fast... for a dwarf
		/datum/attribute/skill/combat/swords = 30, // In line with basic combat classes
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/misc/swimming = 10,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/combat/crossbows = 30,
		/datum/attribute/skill/craft/tanning = 20,
		/datum/attribute/skill/misc/sewing = 30,
		/datum/attribute/skill/misc/medicine = 20,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/reading = 20,
	)

/datum/job/advclass/combat/dranger
	title = "Dwarf Ranger"
	tutorial = "Dwarfish rangers, much like their humen counterparts, \
	live outside of society and explore the far corners of the creation. They \
	protect dwarfish settlements from wild beasts and sell their notes to the cartographers."
	allowed_races = list(SPEC_ID_DWARF)
	outfit = /datum/outfit/adventurer/dranger
	category_tags = list(CTAG_ADVENTURER)

	exp_types_granted = list(EXP_TYPE_ADVENTURER, EXP_TYPE_COMBAT, EXP_TYPE_RANGER)

	attribute_sheet = /datum/attribute_holder/sheet/job/dranger

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
