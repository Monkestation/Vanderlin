/datum/attribute_holder/sheet/job/amazon
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_INTELLIGENCE = -1,
		STAT_ENDURANCE = 2,
		STAT_CONSTITUTION = 1,
		STAT_SPEED = 1,
		/datum/attribute/skill/combat/polearms = 30,
		/datum/attribute/skill/combat/bows = 30,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/reading = 40,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/medicine = 30,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/riding = 20,
		/datum/attribute/skill/misc/sewing = 20,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/craft/tanning = 10
	)

/datum/job/advclass/combat/amazon
	title = "Amazon"
	tutorial = "A savage and deft warrior-women. In your youth you learned to partake in hunts amid the treetops and proved your worth through countless bouts."
	allowed_sexes = list(FEMALE)
	allowed_races = list(SPEC_ID_HUMEN, SPEC_ID_DROW, SPEC_ID_HALF_DROW, SPEC_ID_TRITON)
	outfit = /datum/outfit/adventurer/amazon
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED)
	category_tags = list(CTAG_ADVENTURER)
	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander.ogg'

	attribute_sheet = /datum/attribute_holder/sheet/job/amazon

	traits = list(
		TRAIT_STEELHEARTED,
		TRAIT_DEADNOSE,
		TRAIT_CRITICAL_RESISTANCE,
		TRAIT_NOPAINSTUN
	)

/datum/outfit/adventurer/amazon
	name = "Amazon (Adventurer)"
	neck = /obj/item/ammo_holder/dartpouch/poisondarts
	backl = /obj/item/weapon/polearm/spear
	backr = /obj/item/gun/ballistic/bow/short
	belt = /obj/item/storage/belt/leather/rope
	beltl = /obj/item/gun/ballistic/blowgun
	beltr = /obj/item/ammo_holder/quiver/arrows
	shoes = /obj/item/clothing/shoes/gladiator
	wrists = /obj/item/clothing/wrists/bracers/leather
	armor = /obj/item/clothing/armor/amazon_chainkini
	shoes = /obj/item/clothing/shoes/boots
