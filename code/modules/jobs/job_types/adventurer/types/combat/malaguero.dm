/datum/attribute_holder/sheet/job/malaguero
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_CONSTITUTION = 2,
		STAT_INTELLIGENCE = 1,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/sneaking = 30,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/swords = 20,
		/datum/attribute/skill/combat/whipsflails = 10,
		/datum/attribute/skill/combat/shields = 30,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/combat/axesmaces = 30,
	)

/datum/job/advclass/combat/malaguero
	title = "Malaguero Deserter"
	tutorial = "A former soldier fighting against the forces of Zizo, something drove you to flee your post. Now, you fight for coin, rather than for the authority and command of generals you would never meet."
	allowed_races = list(SPEC_ID_TIEFLING)
	outfit = /datum/outfit/malaguero
	attribute_sheet = /datum/attribute_holder/sheet/job/malaguero

	traits = list(TRAIT_MEDIUMARMOR)
	languages = list(/datum/language/newpsydonic)
	category_tags = list(CTAG_ADVENTURER)
	total_positions = 2

	cmode_music = 'sound/music/cmode/combat_grenzelhoft.ogg'

/datum/outfit/malaguero
	name = "Malaguero (Mercenary)"
	neck = /obj/item/clothing/neck/coif
	pants = /obj/item/clothing/pants/trou/leather
	shoes = /obj/item/clothing/shoes/boots
	gloves = /obj/item/clothing/gloves/angle/grenzel
	belt = /obj/item/storage/belt/leather
	shirt = /obj/item/clothing/armor/gambeson
	head = /obj/item/clothing/head/helmet/visored/sallet/iron
	armor = /obj/item/clothing/armor/cuirass/iron
	beltr = /obj/item/weapon/mace/spiked
	backl = /obj/item/weapon/shield/tower/buckleriron
	backr = /obj/item/storage/backpack/satchel
	beltl = /obj/item/storage/belt/pouch/coins/poor

/datum/outfit/malaguero/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(H.gender == FEMALE)
		H.underwear = "Femleotard"
		H.underwear_color = CLOTHING_SOOT_BLACK
		H.update_body()
