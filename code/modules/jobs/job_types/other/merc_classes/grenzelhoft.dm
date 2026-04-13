/datum/attribute_holder/sheet/job/grenzelhoft
	raw_attribute_list = list(
		STAT_CONSTITUTION = 2,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/sneaking = 30,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/swords = 20,
		/datum/attribute/skill/combat/whipsflails = 10,
		/datum/attribute/skill/combat/shields = 10,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/craft/cooking = 10,
	)

/datum/attribute_holder/sheet/job/grenzelhoft/zwei
	attribute_variance = list(
		/datum/attribute/skill/combat/axesmaces = list(20, 30)
	)
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		/datum/attribute/skill/combat/swords = 10,
	)

/datum/attribute_holder/sheet/job/grenzelhoft/halberd
	attribute_variance = list(
		/datum/attribute/skill/combat/axesmaces = list(20, 30)
	)
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		/datum/attribute/skill/combat/polearms = 30,
	)

/datum/attribute_holder/sheet/job/grenzelhoft/musket
	raw_attribute_list = list(
		/datum/attribute/skill/combat/firearms = 30,
		/datum/attribute/skill/combat/polearms = 30,
	)

/datum/job/advclass/mercenary/grenzelhoft
	title = "Grenzelhoft Mercenary"
	tutorial = "A mercenary from the Grenzelhoft Empire's Mercenary Guild. Their only care is coin, and the procurement of coin."
	allowed_races = list(SPEC_ID_HUMEN, SPEC_ID_DWARF, SPEC_ID_AASIMAR)
	outfit = /datum/outfit/mercenary/grenzelhoft

	attribute_sheet = /datum/attribute_holder/sheet/job/grenzelhoft

	traits = list(TRAIT_MEDIUMARMOR)
	languages = list(/datum/language/newpsydonic)
	category_tags = list(CTAG_MERCENARY)
	total_positions = 2

	cmode_music = 'sound/music/cmode/combat_grenzelhoft.ogg'

/datum/outfit/mercenary/grenzelhoft
	name = "Grenzelhoft (Mercenary)"
	neck = /obj/item/clothing/neck/chaincoif
	pants = /obj/item/clothing/pants/grenzelpants
	shoes = /obj/item/clothing/shoes/rare/grenzelhoft
	gloves = /obj/item/clothing/gloves/angle/grenzel
	belt = /obj/item/storage/belt/leather/mercenary
	shirt = /obj/item/clothing/shirt/grenzelhoft
	head = /obj/item/clothing/head/helmet/skullcap/grenzelhoft
	armor = /obj/item/clothing/armor/cuirass/grenzelhoft

/datum/outfit/mercenary/grenzelhoft/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(H.gender == FEMALE)
		H.underwear = "Femleotard"
		H.underwear_color = CLOTHING_SOOT_BLACK
		H.update_body()

/datum/job/advclass/mercenary/grenzelhoft/after_spawn(mob/living/carbon/human/H)
	. = ..()
	H.merctype = 2
	if(H.dna?.species.id == SPEC_ID_HUMEN)
		H.dna.species.native_language = "Old Psydonic"
		H.dna.species.accent_language = H.dna.species.get_accent(H.dna.species.native_language)

/datum/job/advclass/mercenary/grenzelhoft/on_roundstart(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/static/list/weapons = list("Zweihander", "Musket", "Halberd")
	var/weapon_choice = tgui_input_list(player_client,"CHOOSE YOUR WEAPON.", "GO EARN SOME COIN.", weapons)
	switch(weapon_choice)
		if("Zweihander")
			spawned.equip_to_slot_or_del(new /obj/item/weapon/sword/long/greatsword/zwei, ITEM_SLOT_BACK_R, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel, ITEM_SLOT_BACK_L, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/storage/belt/pouch/coins/poor, ITEM_SLOT_BELT_R, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/weapon/mace/cudgel, ITEM_SLOT_BELT_L, TRUE)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/grenzelhoft/zwei)
		if("Musket")
			spawned.equip_to_slot_or_del(new /obj/item/gun/ballistic/powder/musket, ITEM_SLOT_BACK_R, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/ammo_holder/bullet/bullets, ITEM_SLOT_BELT_R, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/musketeer, ITEM_SLOT_BACK_L, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/weapon/sword/sabre/dec, ITEM_SLOT_BELT_L, TRUE)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/grenzelhoft/musket)
		if("Halberd")
			spawned.equip_to_slot_or_del(new /obj/item/weapon/polearm/halberd, ITEM_SLOT_BACK_R, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel, ITEM_SLOT_BACK_L, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/storage/belt/pouch/coins/poor, ITEM_SLOT_BELT_R, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/weapon/mace/cudgel, ITEM_SLOT_BELT_L, TRUE)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/grenzelhoft/halberd)
