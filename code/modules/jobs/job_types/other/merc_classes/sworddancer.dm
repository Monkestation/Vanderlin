/datum/job/advclass/mercenary/sworddancer
	title = "Sword Dancer"
	tutorial = "You were a former bard, but when times got tough you picked up a blade to defend yourself. \
	Now you travel the lands of Psydonia, selling your sword and your songs to the highest bidder."
	allowed_races = list(SPEC_ID_TIEFLING)
	outfit = /datum/outfit/mercenary/sworddancer
	category_tags = list(CTAG_MERCENARY)

	total_positions = 2
	cmode_music = 'sound/music/cmode/nobility/combat_noble.ogg' // Not a noble, but it fits really well

/datum/outfit/mercenary/sworddancer
	head = /obj/item/clothing/head/bardhat
	shoes = /obj/item/clothing/shoes/boots
	pants = /obj/item/clothing/pants/tights/colored/random
	shirt = /obj/item/clothing/shirt/tunic/noblecoat
	gloves = /obj/item/clothing/gloves/fingerless
	belt = /obj/item/storage/belt/leather/mercenary
	armor = /obj/item/clothing/armor/leather/jacket
	cloak = /obj/item/clothing/cloak/cape
	backl = /obj/item/storage/backpack/satchel
	beltr = /obj/item/weapon/knife/dagger/steel/special
	beltl = /obj/item/weapon/sword/rapier
	backpack_contents = list(/obj/item/storage/belt/pouch/coins/poor)

/datum/outfit/mercenary/sworddancer/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/music, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sewing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 4, TRUE)
	H.add_spell(/datum/action/cooldown/spell/vicious_mockery)
	H.add_spell(/datum/action/cooldown/spell/bardic_inspiration)
	H.adjust_blindness(-3)
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

	if(instrument_choice && instruments[instrument_choice])
		backr = instruments[instrument_choice]
	else
		backr = /obj/item/instrument/lute

	H.adjust_blindness(0)

	H.merctype = 9

	H.change_stat(STATKEY_PER, 2)
	H.change_stat(STATKEY_SPD, 2)
	H.change_stat(STATKEY_END, -1)

	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_BARDIC_TRAINING, TRAIT_GENERIC)

	var/datum/inspiration/I = new /datum/inspiration(H)
	I.grant_inspiration(H, bard_tier = BARD_T3)


/datum/outfit/mercenary/sworddancer/post_equip(mob/living/carbon/human/H)
	..()
	var/obj/item/clothing/cloak/cape/C = H.get_item_by_slot(ITEM_SLOT_CLOAK)
	if(C)
		C.color = CLOTHING_MUSTARD_YELLOW


