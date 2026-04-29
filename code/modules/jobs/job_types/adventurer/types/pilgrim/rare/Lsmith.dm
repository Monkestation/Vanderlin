/datum/attribute_holder/sheet/job/pilgrim/masterblacksmith
	attribute_variance = list(
		/datum/attribute/skill/misc/swimming = list(0, 10),
		/datum/attribute/skill/misc/climbing = list(10, 40),
		/datum/attribute/skill/craft/crafting = list(20, 40),
		/datum/attribute/skill/craft/carpentry = list(10, 20),
		/datum/attribute/skill/craft/cooking = list(0, 10),
		/datum/attribute/skill/misc/reading = list(10, 20)
	)
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_ENDURANCE = 1,
		STAT_CONSTITUTION = 1,
		STAT_SPEED = -1,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/swords = 10,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/craft/masonry = 20,
		/datum/attribute/skill/craft/engineering = 40,
		/datum/attribute/skill/misc/sewing = 10,
		/datum/attribute/skill/craft/traps = 30,
		/datum/attribute/skill/misc/lockpicking = 10,
		/datum/attribute/skill/craft/blacksmithing = 60,
		/datum/attribute/skill/craft/armorsmithing = 60,
		/datum/attribute/skill/craft/weaponsmithing = 60,
		/datum/attribute/skill/craft/smelting = 60,
		/datum/attribute/skill/labor/mathematics = 20,
	)

/datum/attribute_holder/sheet/job/pilgrim/masterblacksmith/old
	attribute_variance = list(
		/datum/attribute/skill/misc/swimming = list(0, 10),
		/datum/attribute/skill/misc/climbing = list(10, 40),
		/datum/attribute/skill/craft/crafting = list(20, 40),
		/datum/attribute/skill/craft/carpentry = list(10, 20),
		/datum/attribute/skill/craft/cooking = list(0, 10),
		/datum/attribute/skill/misc/reading = list(10, 20)
	)
	raw_attribute_list = list(
		STAT_ENDURANCE = -1,
		STAT_CONSTITUTION = -1,
		STAT_SPEED = -1,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/swords = 10,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/craft/masonry = 20,
		/datum/attribute/skill/craft/engineering = 50,
		/datum/attribute/skill/misc/sewing = 10,
		/datum/attribute/skill/craft/traps = 30,
		/datum/attribute/skill/misc/lockpicking = 10,
		/datum/attribute/skill/craft/blacksmithing = 60,
		/datum/attribute/skill/craft/armorsmithing = 60,
		/datum/attribute/skill/craft/weaponsmithing = 60,
		/datum/attribute/skill/craft/smelting = 60,
		/datum/attribute/skill/labor/mathematics = 20,
	)

/datum/job/advclass/pilgrim/rare/masterblacksmith
	title = "Master Blacksmith"
	tutorial = "Dwarves, and humen who trained extensively under them in the art of smithing, \
	become the most legendary smiths at their craft, gaining reputation beyond compare."
	allowed_races = list(\
		SPEC_ID_HUMEN,\
		SPEC_ID_DWARF,\
	)
	outfit = /datum/outfit/pilgrim/masterblacksmith
	total_positions = 1
	roll_chance = 0
	category_tags = list(CTAG_PILGRIM)
	cmode_music = 'sound/music/cmode/towner/CombatTowner2.ogg'
	is_recognized = TRUE

	attribute_sheet = /datum/attribute_holder/sheet/job/pilgrim/masterblacksmith
	attribute_sheet_old = /datum/attribute_holder/sheet/job/pilgrim/masterblacksmith/old

	traits = list(
		TRAIT_MALUMFIRE
	)

/datum/outfit/pilgrim/masterblacksmith
	name = "Master Blacksmith (Pilgrim)"
	beltr = /obj/item/weapon/hammer/iron
	backl = /obj/item/storage/backpack/backpack
	backr = /obj/item/weapon/hammer/sledgehammer
	pants = /obj/item/clothing/pants/trou
	shoes = /obj/item/clothing/shoes/boots/leather
	shirt = /obj/item/clothing/shirt/shortshirt
	neck = /obj/item/storage/belt/pouch/coins/mid
	belt = /obj/item/storage/belt/leather
	beltl = /obj/item/weapon/knife/hunting
	cloak = /obj/item/clothing/cloak/apron/brown
	gloves = /obj/item/clothing/gloves/leather
	backpack_contents = list(
		/obj/item/flint = 1,
		/obj/item/weapon/tongs = 1,
		/obj/item/ore/coal = 1,
		/obj/item/ore/iron = 1,
		/obj/item/mould/ingot = 1,
		/obj/item/storage/crucible/random = 1
	)

/datum/outfit/pilgrim/masterblacksmith/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(equipped_human.gender == FEMALE)
		shoes = /obj/item/clothing/shoes/shortboots
		armor = /obj/item/clothing/shirt/dress/gen/colored/random
		shirt = /obj/item/clothing/shirt/undershirt
