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

	skills = list(
		/datum/skill/combat/knives = 3, // Knives are gonna be a rough backup, but should be one anyway
		/datum/skill/misc/sneaking = 4,
		/datum/skill/craft/crafting = 2,
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/climbing = 5, // Same climbing as Thieves, but without lockpicking
		/datum/skill/misc/stealing = 4, // Worse than a Thief, but still very possible to pickpocket
		/datum/skill/combat/bows = 3,
		/datum/skill/craft/tanning = 2, // Dendor asks us to use every part of the beast
		/datum/skill/misc/sewing = 2,
		/datum/skill/misc/medicine = 2,
		/datum/skill/craft/cooking = 1,
		/datum/skill/craft/carpentry = 1, // Can upgrade to Longbow if they desire to
		/datum/skill/craft/traps = 3,
		/datum/skill/misc/athletics = 2,
	)

	jobstats = list(
		STATKEY_PER = 1,
		STATKEY_SPD = 2, // Speedy out of necessity! Get the hell outta there
	)

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
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/short
	backl = /obj/item/storage/backpack/satchel
	beltl = /obj/item/ammo_holder/quiver/arrows
	beltr = /obj/item/weapon/knife/cleaver/combat
	armor = /obj/item/clothing/armor/leather/jacket
	wrists = /obj/item/clothing/neck/psycross/silver/dendor
	gloves = /obj/item/clothing/gloves/fingerless
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/colored/black

	backpack_contents = list(
		/obj/item/weapon/knife/hunting = 1,
	)
