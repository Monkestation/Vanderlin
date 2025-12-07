
/datum/job/advclass/pilgrim/bard
	title = "Bard"
	tutorial = "Bards make up one of the largest populations of \
	registered adventurers in Vanderlin, mostly because they are \
	the last ones in a party to die. Their wish is to experience \
	the greatest adventures of the age and write amazing songs about them."
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/adventurer/bard
	category_tags = list(CTAG_PILGRIM)
	apprentice_name = "Aspiring Bard"
	cmode_music = 'sound/music/cmode/adventurer/CombatIntense.ogg'

	exp_types_granted  = list(EXP_TYPE_BARD)

/datum/outfit/adventurer/bard/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/stealing, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/lockpicking, 1, TRUE)
	H.clamped_adjust_skillrank(/datum/skill/misc/music, 4, 4, TRUE) //Due to Harpy's innate music skill giving them legendary
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.add_spell(/datum/action/cooldown/spell/vicious_mockery)
	H.add_spell(/datum/action/cooldown/spell/bardic_inspiration)
	head = /obj/item/clothing/head/bardhat
	shoes = /obj/item/clothing/shoes/boots
	pants = /obj/item/clothing/pants/tights/colored/random
	shirt = /obj/item/clothing/shirt/tunic/noblecoat
	if(prob(30))
		gloves = /obj/item/clothing/gloves/fingerless
	belt = /obj/item/storage/belt/leather
	armor = /obj/item/clothing/armor/leather/vest
	cloak = /obj/item/clothing/cloak/raincloak/colored/blue
	if(prob(50))
		cloak = /obj/item/clothing/cloak/raincloak/colored/red
	backl = /obj/item/storage/backpack/satchel
	beltr = /obj/item/weapon/knife/dagger/steel/special
	beltl = /obj/item/storage/belt/pouch/coins/poor
	backpack_contents = list(/obj/item/flint)

	var/instruments = list(
		"Harp" = /obj/item/instrument/harp,
		"Lute" = /obj/item/instrument/lute,
		"Accordion" = /obj/item/instrument/accord,
		"Guitar" = /obj/item/instrument/guitar,
		"Flute" = /obj/item/instrument/flute,
		"Drum" = /obj/item/instrument/drum,
		"Hurdy-Gurdy" = /obj/item/instrument/hurdygurdy,
		"Viola" = /obj/item/instrument/viola)
	var/instrument_choice = input("Choose your instrument.", "XYLIX") as anything in instruments
	H.set_blindness(0)
	if(instrument_choice && instruments[instrument_choice])
		backr = instruments[instrument_choice]
	else
		backr = /obj/item/instrument/lute
	if(H.dna?.species?.id == SPEC_ID_DWARF)
		H.cmode_music = 'sound/music/cmode/combat_dwarf.ogg'
	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_BARDIC_TRAINING, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_FOREIGNER, TRAIT_GENERIC)
	var/datum/inspiration/I = new /datum/inspiration(H)
	I.grant_inspiration(H, bard_tier = BARD_T3)
	H.change_stat(STATKEY_PER, 1)
	H.change_stat(STATKEY_SPD, 2)
	H.change_stat(STATKEY_STR, -1)
