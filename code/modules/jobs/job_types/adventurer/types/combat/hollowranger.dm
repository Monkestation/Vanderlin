/datum/attribute_holder/sheet/job/hollowranger
	raw_attribute_list = list(
		STAT_PERCEPTION = 1,
		STAT_SPEED = 2, // Speedy out of necessity! Get the hell outta there
		/datum/attribute/skill/combat/knives = 30, // Knives are gonna be a rough backup, but should be one anyway
		/datum/attribute/skill/misc/sneaking = 40,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 50, // Same climbing as Thieves, but without lockpicking
		/datum/attribute/skill/misc/stealing = 40, // Worse than a Thief, but still very possible to pickpocket
		/datum/attribute/skill/combat/bows = 30,
		/datum/attribute/skill/craft/tanning = 20, // Dendor asks us to use every part of the beast
		/datum/attribute/skill/misc/sewing = 20,
		/datum/attribute/skill/misc/medicine = 20,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/craft/carpentry = 10, // Can upgrade to Longbow if they desire to
		/datum/attribute/skill/craft/traps = 30,
		/datum/attribute/skill/misc/athletics = 20,
	)

/datum/job/advclass/combat/hollowranger
	title = "Hollow Ranger"
	tutorial = "While Rangers are seen often amongst Humen and Elves, Amber Hollow's Rangers are hardly seen at all. \
	Acting mostly as scouts for groups of 'supply liberation' militia around their home, \
	stealth is a virtue for a Hollow Ranger."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(\
		SPEC_ID_HOLLOWKIN,\
		SPEC_ID_HUMEN,\
		SPEC_ID_HARPY,\
	)
	outfit = /datum/outfit/adventurer/hollowranger
	category_tags = list(CTAG_ADVENTURER)
	cmode_music = 'sound/music/cmode/adventurer/CombatIntense.ogg'
	exp_types_granted = list(EXP_TYPE_ADVENTURER, EXP_TYPE_COMBAT, EXP_TYPE_RANGER)

	attribute_sheet = /datum/attribute_holder/sheet/job/hollowranger

	traits = list(
		TRAIT_BESTIALSENSE, // Dendor influence in nature blesses them with the Eyes of the Zad
	)

/datum/job/advclass/combat/hollowranger/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	// Update sight for TRAIT_BESTIALSENSE
	spawned.update_sight()

/datum/outfit/adventurer/hollowranger
	name = "Hollow Ranger (Adventurer)"
	head = /obj/item/clothing/head/roguehood/colored/red
	mask = /obj/item/clothing/face/shepherd/rag
	pants = /obj/item/clothing/pants/tights/colored/black
	shirt = /obj/item/clothing/shirt/tunic/colored/black
	shoes = /obj/item/clothing/shoes/boots
	belt = /obj/item/storage/belt/leather
	backr = /obj/item/gun/ballistic/bow/short
	backl = /obj/item/storage/backpack/satchel
	beltl = /obj/item/ammo_holder/quiver/arrows
	beltr = /obj/item/weapon/knife/cleaver/combat
	armor = /obj/item/clothing/armor/leather/jacket
	wrists = /obj/item/clothing/neck/psycross/silver/divine/dendor
	gloves = /obj/item/clothing/gloves/fingerless
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/colored/black

	backpack_contents = list(
		/obj/item/weapon/knife/hunting = 1,
	)
