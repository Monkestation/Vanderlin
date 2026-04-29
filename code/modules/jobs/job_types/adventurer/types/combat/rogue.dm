/datum/attribute_holder/sheet/job/rogue
	attribute_variance = list(
		/datum/attribute/skill/combat/swords = list(0, 10)
	)
	raw_attribute_list = list(
		STAT_STRENGTH = -2,
		STAT_PERCEPTION = 2,
		STAT_ENDURANCE = 1,
		STAT_SPEED = 2,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/bows = 20,
		/datum/attribute/skill/combat/knives = 30,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/combat/unarmed = 10,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 50,
		/datum/attribute/skill/misc/sewing = 10,
		/datum/attribute/skill/misc/sneaking = 50,
		/datum/attribute/skill/misc/stealing = 50,
		/datum/attribute/skill/misc/lockpicking = 40,
		/datum/attribute/skill/craft/traps = 30,
		/datum/attribute/skill/misc/reading = 10,
	)

/datum/job/advclass/combat/rogue
	title = "Thief"
	tutorial = "A wandering thief, capable of breaking in and out of just about any secure location, and born to meet the sharp end of the guillotine. Just remember, murder is the mark of an amateur."
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/adventurer/rogue
	category_tags = list(CTAG_ADVENTURER)
	cmode_music = 'sound/music/cmode/adventurer/CombatRogue.ogg'
	exp_types_granted = list(EXP_TYPE_ADVENTURER, EXP_TYPE_COMBAT, EXP_TYPE_THIEF)

	attribute_sheet = /datum/attribute_holder/sheet/job/rogue

	traits = list(
		TRAIT_THIEVESGUILD,
		TRAIT_DODGEEXPERT,
		TRAIT_LIGHT_STEP,
	)

	languages = list(/datum/language/thievescant)

/datum/outfit/adventurer/rogue
	name = "Thief (Adventurer)"
	shirt = /obj/item/clothing/shirt/undershirt/colored/black
	gloves = /obj/item/clothing/gloves/fingerless
	pants = /obj/item/clothing/pants/trou/leather
	shoes = /obj/item/clothing/shoes/boots
	backl = /obj/item/storage/backpack/satchel
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/weapon/mace/cudgel // TEMP until I make a blackjack- for now though this will do.
	beltl = /obj/item/storage/belt/pouch/coins/poor
	backpack_contents = list(
		/obj/item/lockpick = 1,
		/obj/item/weapon/knife/dagger/steel = 1,
		/obj/item/clothing/face/shepherd/rag = 1,
	)

/datum/outfit/adventurer/rogue/post_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	. = ..()

	if(visuals_only)
		return

	var/list/thiefcloak_colors = list(\
		// Red Colors
		"Fyritius Dye"	="#b47011",\
		"Winestain Red"	="#6b3737",\
		"Maroon"		="#672c0d",\
		"Blood Red"		="#770d0d",\
		// Green Colors
		"Forest Green"	="#3f8b24",\
		"Bog Green"		="#58793f",\
		"Spring Green"	="#435436",\
		// Blue Colors
		"Royal Teal"	="#249589",\
		"Mana Blue"		="#1b3c7a",\
		"Berry"			="#38455b",\
		"Lavender"		="#865c9c",\
		"Majenta"		="#822b52",\
		// Brown Colors
		"Bark Brown"	="#685542",\
		"Russet"		="#685542",\
		"Chestnut"		="#5f3d21",\
		"Old Leather"	="#473a30",\
		"Ashen Black"	="#2f352f",\
	)

	var/thiefcloak_color_selection = input(H, "What color was I again?", "The Cloak", "Ashen Black") in thiefcloak_colors
	var/obj/item/clothing/cloak/raincloak/thiefcloak = new()
	thiefcloak.color = thiefcloak_colors[thiefcloak_color_selection]
	H.equip_to_slot(thiefcloak, ITEM_SLOT_CLOAK, TRUE)
