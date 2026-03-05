/datum/job/advclass/mercenary/malaguero
	title = "Malaguero Deserter"
	tutorial = "A former soldier fighting against the forces of Zizo, something drove you to flee your post. Now, you fight for coin, rather than for the authority and command of generals you would never meet."
	allowed_races = list(SPEC_ID_TIEFLING)
	outfit = /datum/outfit/mercenary/malaguero
	jobstats = list(
		STATKEY_CON = 2,
		STATKEY_STR = 2,
		STATKEY_END = 1
		)
	skills = list(
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/climbing = 3,
		/datum/skill/misc/sneaking = 3,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/misc/athletics = 3,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/combat/swords = 2,
		/datum/skill/combat/whipsflails = 1,
		/datum/skill/combat/shields = 3,
		/datum/skill/misc/reading = 1,
		/datum/skill/craft/cooking = 1,
		/datum/skill/combat/axesmaces = 3,
	)
	traits = list(TRAIT_MEDIUMARMOR)
	languages = list(/datum/language/newpsydonic)
	category_tags = list(CTAG_MERCENARY)
	total_positions = 2

	cmode_music = 'sound/music/cmode/combat_grenzelhoft.ogg'

/datum/outfit/mercenary/malaguero
	name = "Malaguero (Mercenary)"
	neck = /obj/item/clothing/neck/chaincoif
	pants = /obj/item/clothing/pants/trou/leather
	shoes = /obj/item/clothing/shoes/boots
	gloves = /obj/item/clothing/gloves/angle/grenzel
	belt = /obj/item/storage/belt/leather/mercenary
	shirt = /obj/item/clothing/armor/gambeson/heavy
	head = /obj/item/clothing/head/helmet/visored/sallet/iron
	armor = /obj/item/clothing/armor/cuirass/grenzelhoft
	beltr = /obj/item/weapon/mace/steel
	backl = /obj/item/weapon/shield/tower/buckleriron
	backr = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/storage/belt/pouch/coins/poor = 1)

/datum/outfit/mercenary/malaguero/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(H.gender == FEMALE)
		H.underwear = "Femleotard"
		H.underwear_color = CLOTHING_SOOT_BLACK
		H.update_body()
