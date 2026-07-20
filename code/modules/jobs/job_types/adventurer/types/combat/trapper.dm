/datum/attribute_holder/sheet/job/trapper
	raw_attribute_list = list(
		STAT_PERCEPTION = 1,
		STAT_ENDURANCE = 1,
		STAT_SPEED = 1, // +3 statline
		/datum/attribute/skill/combat/swords = 30,
		/datum/attribute/skill/combat/bows = 20,
		/datum/attribute/skill/combat/knives = 10,
		/datum/attribute/skill/combat/wrestling = 20, // some wrestling for trying to shoe people into your traps
		/datum/attribute/skill/combat/unarmed = 10,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/craft/crafting = 20, // for making traps
		/datum/attribute/skill/misc/sneaking = 30,
		/datum/attribute/skill/misc/lockpicking = 20, // they can lock pick basic doors to set traps in funny spots
		/datum/attribute/skill/craft/traps = 40, // rogue gets 3 master skills but this cant even have master in a non-combat skill? smh
		/datum/attribute/skill/misc/reading = 10,
	)

/datum/job/advclass/combat/trapper
	title = "Trapper"
	tutorial = "Honor is a dead man's virtue. Lure those foolish enough to fight you into a trap, and all it will take from there is a slit to the throat or a arrow to the heart."
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/adventurer/trapper
	category_tags = list(CTAG_ADVENTURER)
	cmode_music = 'sound/music/cmode/adventurer/CombatRogue.ogg'
	exp_types_granted = list(EXP_TYPE_ADVENTURER, EXP_TYPE_COMBAT)

	attribute_sheet = /datum/attribute_holder/sheet/job/trapper

	traits = list(
		TRAIT_DODGEEXPERT,
		TRAIT_LIGHT_STEP,
	)

/datum/outfit/adventurer/trapper
	name = "Trapper (Adventurer)"
	shirt = /obj/item/clothing/shirt/undershirt/colored/blue
	gloves = /obj/item/clothing/gloves/fingerless
	pants = /obj/item/clothing/pants/trou/leather
	shoes = /obj/item/clothing/shoes/boots
	cloak = /obj/item/clothing/cloak/raincloak
	backl = /obj/item/storage/backpack/satchel
	backr = /obj/item/gun/ballistic/bow/short
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/ammo_holder/quiver/arrows
	beltl = /obj/item/weapon/sword/short/iron
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/poor = 1,
    	/obj/item/weapon/knife/dagger = 1,
   		/obj/item/restraints/legcuffs/beartrap/crafted = 1
	)
