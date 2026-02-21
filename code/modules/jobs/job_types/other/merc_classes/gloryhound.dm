/datum/job/advclass/mercenary/gloryhound
	title = "Gloryhound"
	tutorial = "Once nothing but a unskilled adventurer, you found yourself in the spotlight after saving a noble from a ambush with nothing but your sword and shield. You yearn for this fame again."
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/mercenary/gloryhound
	category_tags = list(CTAG_MERCENARY)
	cmode_music = 'sound/music/cmode/adventurer/CombatWarrior.ogg'
	total_positions = 5

	jobstats = list(
		STATKEY_CON = 1,
		STATKEY_END = 2,
		STATKEY_STR = 2, 
		STATKEY_INT = -1
	)

	skills = list(
		/datum/skill/combat/swords = 3,
		/datum/skill/combat/shields = 3,
		/datum/skill/combat/axesmaces = 2, //for bashing people with a cudgel
		/datum/skill/misc/riding = 2, 
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/craft/crafting = 1,
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/climbing = 2,
		/datum/skill/misc/medicine = 1,
		/datum/skill/craft/cooking = 1,
		/datum/skill/misc/reading = 1,
		/datum/skill/misc/athletics = 3
	)

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
