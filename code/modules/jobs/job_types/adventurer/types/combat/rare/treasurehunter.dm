/datum/job/advclass/combat/gravedigger
	title = "Treasure Hunter"
	tutorial = "Grave robbers sell themselves as treasure hunters, but be sure to wipe that \
	necrotic flesh off of that trinket you found."
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/adventurer/gravedigger
	category_tags = list(CTAG_ADVENTURER)
	cmode_music = 'sound/music/cmode/church/CombatGravekeeper.ogg'

	skills = list(
		/datum/skill/misc/medicine = 1,
		/datum/skill/combat/whipsflails = 3,
		/datum/skill/combat/wrestling = 1,
		/datum/skill/combat/knives = 2,
		/datum/skill/combat/unarmed = 1,
		/datum/skill/craft/crafting = 1,
		/datum/skill/craft/cooking = 1,
		/datum/skill/misc/swimming = 3,
		/datum/skill/misc/climbing = 5,
		/datum/skill/misc/sewing = 1,
		/datum/skill/misc/lockpicking = 2,
		/datum/skill/misc/athletics = 4,
		/datum/skill/misc/reading = 1,
	)

	jobstats = list(
		STATKEY_STR = 1,
		STATKEY_PER = 2,
		STATKEY_INT = 1,
		STATKEY_END = 2,
		STATKEY_SPD = 1,
		STATKEY_LCK = -1,
	)

	traits = list(
		TRAIT_DEADNOSE,
		TRAIT_DODGEEXPERT,
		TRAIT_GRAVEROBBER,
	)

/datum/outfit/adventurer/gravedigger
	name = "Treasure Hunter (Adventurer)"
	pants = /obj/item/clothing/pants/tights/colored/black
	armor = /obj/item/clothing/armor/leather/vest/colored/black
	shirt = /obj/item/clothing/shirt/undershirt/colored/black
	backl = /obj/item/storage/backpack/satchel
	belt = /obj/item/storage/belt/leather/rope
	backpack_contents = list(
		/obj/item/weapon/pick = 1,
		/obj/item/weapon/knife/dagger = 1,
		/obj/item/lockpickring/mundane = 1
	)
	gloves = /obj/item/clothing/gloves/fingerless
	cloak = /obj/item/clothing/cloak/raincloak/colored/mortus
	shoes = /obj/item/clothing/shoes/boots/leather
	beltr = /obj/item/flashlight/flare/torch/lantern
	beltl = /obj/item/weapon/whip // You know why.
	backr = /obj/item/weapon/shovel
	head = /obj/item/clothing/head/helmet/leather/inquisitor
	neck = /obj/item/storage/belt/pouch
