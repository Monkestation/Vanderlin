/datum/job/advclass/combat/rogue
	title = "Thief"
	tutorial = "A wandering thief, capable of breaking in and out of just about any secure location, and born to meet the sharp end of the guillotine. Just remember, murder is the mark of an amateur."
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/adventurer/rogue
	category_tags = list(CTAG_ADVENTURER)
	cmode_music = 'sound/music/cmode/adventurer/CombatRogue.ogg'
	exp_types_granted = list(EXP_TYPE_ADVENTURER, EXP_TYPE_COMBAT, EXP_TYPE_THIEF)

	skills = list(
		/datum/skill/combat/axesmaces = 2,
		/datum/skill/combat/bows = 2,
		/datum/skill/combat/knives = 3,
		/datum/skill/combat/wrestling = 1,
		/datum/skill/combat/unarmed = 1,
		/datum/skill/misc/athletics = 3,
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/climbing = 5,
		/datum/skill/misc/sewing = 1,
		/datum/skill/misc/sneaking = 5,
		/datum/skill/misc/stealing = 5,
		/datum/skill/misc/lockpicking = 4,
		/datum/skill/craft/traps = 3,
	)

	jobstats = list(
		STATKEY_STR = -2,
		STATKEY_PER = 2,
		STATKEY_END = 1,
		STATKEY_SPD = 2,
	)

	traits = list(
		TRAIT_THIEVESGUILD,
		TRAIT_DODGEEXPERT,
		TRAIT_LIGHT_STEP,
	)

	languages = list(/datum/language/thievescant)

/datum/job/advclass/combat/rogue/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.adjust_skillrank(/datum/skill/combat/swords, pick(0,0,1), TRUE)
	spawned.adjust_skillrank(/datum/skill/misc/reading, pick(0,1,1), TRUE)

	var/obj/item/clothing/cloak/raincloak = spawned.get_item_by_slot(ITEM_SLOT_CLOAK)
	if(!raincloak)
		return

	var/static/list/thiefcloak_colors = list(
		"Fyritius Dye" = "#b47011",
		"Winestain Red"	= "#6b3737",
		"Maroon" = "#672c0d",
		"Blood Red" = "#770d0d",
		"Forest Green" = "#3f8b24",
		"Bog Green" = "#58793f",
		"Spring Green"  ="#435436",
		"Royal Teal" = "#249589",
		"Mana Blue" = "#1b3c7a",
		"Berry" = "#38455b",
		"Lavender" = "#865c9c",
		"Majenta" = "#822b52",
		"Bark Brown" = "#685542",
		"Russet" = "#685542",
		"Chestnut" = "#5f3d21",
		"Old Leather" = "#473a30",
		"Ashen Black" = "#2f352f",
	)

	var/choice = browser_input_list(spawned, "What color was I?", "TOOLS OF THE TRADE", thiefcloak_colors)

	if(!choice || !raincloak.loc == spawned)
		return

	raincloak.color = thiefcloak_colors[choice]

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
	cloak = /obj/item/clothing/cloak/raincloak
	backpack_contents = list(
		/obj/item/lockpick = 1,
		/obj/item/weapon/knife/dagger/steel = 1,
		/obj/item/clothing/face/shepherd/rag = 1,
	)

/datum/outfit/adventurer/rogue/post_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	. = ..()

	var/static/list/thiefcloak_colors = list(
		"Fyritius Dye" = "#b47011",
		"Winestain Red"	= "#6b3737",
		"Maroon" = "#672c0d",
		"Blood Red" = "#770d0d",
		"Forest Green" = "#3f8b24",
		"Bog Green" = "#58793f",
		"Spring Green"  ="#435436",
		"Royal Teal" = "#249589",
		"Mana Blue" = "#1b3c7a",
		"Berry" = "#38455b",
		"Lavender" = "#865c9c",
		"Majenta" = "#822b52",
		"Bark Brown" = "#685542",
		"Russet" = "#685542",
		"Chestnut" = "#5f3d21",
		"Old Leather" = "#473a30",
		"Ashen Black" = "#2f352f",
	)

	var/obj/item/clothing/cloak/raincloak = H.get_item_by_slot(ITEM_SLOT_CLOAK)
	if(raincloak)
		raincloak.color = pick_assoc(thiefcloak_colors)
