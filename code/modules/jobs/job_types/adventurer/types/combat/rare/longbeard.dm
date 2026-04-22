/datum/attribute_holder/sheet/job/longbeard
	raw_attribute_list = list(
		STAT_STRENGTH = 2, // Same stat spread as lancer/swordmaster, but no -1 speed at the cost of 1 point of endurance. A very powerful dwarf indeed
		STAT_CONSTITUTION = 2,
		STAT_ENDURANCE = 1,
		/datum/attribute/skill/combat/axesmaces = 40,
		/datum/attribute/skill/combat/polearms = 30,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/craft/blacksmithing = 20,
		/datum/attribute/skill/craft/armorsmithing = 20,
		/datum/attribute/skill/craft/weaponsmithing = 20,
		/datum/attribute/skill/misc/reading = 20,
	)

/datum/job/advclass/combat/longbeard
	title = "Longbeard"
	tutorial = "You've earned your place as one of the old grumblers, a pinnacle of tradition, justice, and willpower. You've come to establish order in these lands, and with your hammer of grudges you'll see it through."
	allowed_ages = list(AGE_MIDDLEAGED, AGE_OLD)
	allowed_races = list(SPEC_ID_DWARF)
	outfit = /datum/outfit/longbeard
	total_positions = 1
	category_tags = list(CTAG_ADVENTURER)
	roll_chance = 6
	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander2.ogg'

	attribute_sheet = /datum/attribute_holder/sheet/job/longbeard

	traits = list(
		TRAIT_HEAVYARMOR,
		TRAIT_STEELHEARTED, // Nothing fazes a longbeard
	)

/datum/outfit/longbeard
	name = "Longbeard"
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
