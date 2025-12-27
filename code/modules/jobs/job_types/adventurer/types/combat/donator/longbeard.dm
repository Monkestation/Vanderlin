/datum/job/advclass/combat/longbeard
	title = "Longbeard"
	tutorial = "You've earned your place as one of the old grumblers, a pinnacle of tradition, justice, and willpower. You've come to establish order in these lands, and with your hammer of grudges you'll see it through."
	allowed_ages = list(AGE_MIDDLEAGED, AGE_OLD)
	allowed_races = list(SPEC_ID_DWARF)
	outfit = /datum/outfit/adventurer/longbeard
	total_positions = 1
	roll_chance = 15
	category_tags = list(CTAG_ADVENTURER)
	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander2.ogg'

	skills = list(
		/datum/skill/combat/axesmaces = 4,
		/datum/skill/combat/polearms = 3,
		/datum/skill/combat/wrestling = 3,
		/datum/skill/craft/crafting = 2,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/climbing = 2,
		/datum/skill/misc/athletics = 3,
		/datum/skill/craft/blacksmithing = 2,
		/datum/skill/craft/armorsmithing = 2,
		/datum/skill/craft/weaponsmithing = 2,
		/datum/skill/misc/reading = 2,
	)

	jobstats = list(
		STATKEY_STR = 2, // Same stat spread as lancer/swordmaster, but no -1 speed at the cost of 1 point of endurance. A very powerful dwarf indeed
		STATKEY_CON = 2,
		STATKEY_END = 1,
	)

	traits = list(
		TRAIT_HEAVYARMOR,
		TRAIT_STEELHEARTED, // Nothing fazes a longbeard
	)

/datum/outfit/adventurer/longbeard
	name = "Longbeard (Adventurer)"
	pants = /obj/item/clothing/pants/tights/colored/black
	backr = /obj/item/weapon/mace/goden/steel/warhammer
	beltl = /obj/item/storage/belt/pouch/coins/mid
	shoes = /obj/item/clothing/shoes/boots/rare/dwarfplate
	gloves = /obj/item/clothing/gloves/rare/dwarfplate
	belt = /obj/item/storage/belt/leather
	shirt = /obj/item/clothing/shirt/undershirt/colored/black
	armor = /obj/item/clothing/armor/rare/dwarfplate
	backl = /obj/item/storage/backpack/satchel
	head = /obj/item/clothing/head/rare/dwarfplate
	neck = /obj/item/clothing/neck/chaincoif
