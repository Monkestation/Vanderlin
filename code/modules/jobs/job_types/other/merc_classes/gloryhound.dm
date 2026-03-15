/datum/attribute_holder/sheet/job/gloryhound
	raw_attribute_list = list(
		STAT_CONSTITUTION = 1,
		STAT_ENDURANCE = 2,
		STAT_STRENGTH = 2,
		STAT_INTELLIGENCE = -1,
		/datum/attribute/skill/combat/swords = 30,
		/datum/attribute/skill/combat/shields = 30,
		/datum/attribute/skill/combat/axesmaces = 20, //for bashing people with a cudgel
		/datum/attribute/skill/misc/riding = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/athletics = 30
	)

/datum/job/advclass/mercenary/gloryhound
	title = "Gloryhound"
	tutorial = "Once nothing but a unskilled adventurer, you found yourself in the spotlight after saving a noble from a ambush with nothing but your sword and shield. You yearn for this fame again."
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/mercenary/gloryhound
	category_tags = list(CTAG_MERCENARY)
	cmode_music = 'sound/music/cmode/adventurer/CombatWarrior.ogg'
	total_positions = 5

	attribute_sheet = /datum/attribute_holder/sheet/job/gloryhound

	traits = list(
		TRAIT_MEDIUMARMOR
	)


/datum/outfit/mercenary/gloryhound
	name = "Gloryhound (Mercenary)"
	shoes = /obj/item/clothing/shoes/boots/furlinedboots
	cloak = /obj/item/clothing/cloak/raincloak/furcloak
	head = /obj/item/clothing/head/helmet/visored/sallet
	wrists = /obj/item/clothing/wrists/bracers/leather/advanced
	gloves = /obj/item/clothing/gloves/leather/advanced
	belt = /obj/item/storage/belt/leather/mercenary
	armor = /obj/item/clothing/armor/cuirass
	backl = /obj/item/storage/backpack/satchel
	backr = /obj/item/weapon/shield/heater
	shirt = /obj/item/clothing/armor/gambeson
	pants = /obj/item/clothing/pants/trou/leather/splint
	neck = /obj/item/clothing/neck/gorget
	scabbards = list(/obj/item/weapon/scabbard/sword)
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/poor = 1,
		/obj/item/weapon/knife/hunting = 1
	)

/datum/outfit/mercenary/gloryhound/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(iskobold(equipped_human))
		beltl = /obj/item/weapon/sword/short //kobolds get a short sword due to their lack of strength
	else
		beltl = /obj/item/weapon/sword
