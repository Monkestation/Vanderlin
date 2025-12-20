/datum/job/advclass/mercenary/grenzelhoft
	title = "Grenzelhoft Mercenary"
	tutorial = "A mercenary from the Grenzelhoft Empire's Mercenary Guild. Their only care is coin, and the procurement of coin."
	allowed_races = RACES_PLAYER_GRENZ
	outfit = /datum/outfit/mercenary/grenzelhoft
	jobstats = list(STATKEY_CON = 2)
	skills = list(
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/climbing = 3,
		/datum/skill/misc/sneaking = 3,
		/datum/skill/combat/wrestling = 3,
		/datum/skill/misc/athletics = 4,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/combat/swords = 2,
		/datum/skill/combat/whipsflails = 1,
		/datum/skill/combat/shields = 1,
		/datum/skill/misc/reading = 1,
		/datum/skill/craft/cooking = 1,
	)
	traits = list(TRAIT_MEDIUMARMOR)
	languages = list(/datum/language/oldpsydonic)
	category_tags = list(CTAG_MERCENARY)
	total_positions = 2

	cmode_music = 'sound/music/cmode/combat_grenzelhoft.ogg'

/datum/outfit/mercenary/grenzelhoft
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
	var/weapons = list("Zweihander", "Musket",)
	var/weapon_choice = input(H,"CHOOSE YOUR WEAPON.", "GO EARN SOME COIN.") as anything in weapons
	switch(weapon_choice)
		if("Zweihander")
			H.equip_to_slot_or_del(new /obj/item/weapon/sword/long/greatsword/zwei, ITEM_SLOT_BACK_R, TRUE)
			H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel, ITEM_SLOT_BACK_L, TRUE)
			H.equip_to_slot_or_del(new /obj/item/storage/belt/pouch/coins/poor, ITEM_SLOT_BELT_R, TRUE)
			H.equip_to_slot_or_del(new /obj/item/weapon/mace/cudgel, ITEM_SLOT_BELT_L, TRUE)
			H.adjust_stat_modifier(STATMOD_JOB, STATKEY_STR, 2) // They need this to roll at least min STR for the Zwei.
			H.adjust_skillrank(/datum/skill/combat/axesmaces, pick(2,3), TRUE) // Equal chance between skilled and average, can use a cudgel to beat less dangerous targets into submission
			H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
		if("Musket")
			H.equip_to_slot_or_del(new /obj/item/gun/ballistic/revolver/grenadelauncher/pistol/musket, ITEM_SLOT_BACK_R, TRUE)
			H.equip_to_slot_or_del(new /obj/item/ammo_holder/bullet, ITEM_SLOT_BELT_R, TRUE)
			H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/musketeer, ITEM_SLOT_BACK_L, TRUE)
			H.equip_to_slot_or_del(new /obj/item/weapon/sword/sabre/dec, ITEM_SLOT_BELT_L, TRUE)
			H.adjust_skillrank(/datum/skill/combat/firearms, 4, TRUE)
			H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
			if(H.age == AGE_OLD)
				H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
