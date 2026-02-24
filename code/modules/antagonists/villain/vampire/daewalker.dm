/datum/antagonist/vampire/lord/daewalker
	name = "The Daewalker"
	antag_hud_type = null
	antag_hud_name = null
	confess_lines = list(
		"BLOODSUCKERS GAVE ME MY POWERS, I MAKE THEM REGRET IT!!",
		"MOTHERFUCKER, ARE YOU OUTTA YOUR DAMN MIND?!!",
		"YOU'RE A THRALL OF THRONLEER, INQUISITOR!!",
	)
	isgoodguy = TRUE
	chooses_name = FALSE
	ascended = 4
	outfit = /datum/outfit/daewalker
	patron = /datum/patron/divine/astrata
	innate_traits = list(
		TRAIT_SILVER_BLESSED,
		TRAIT_HARDDISMEMBER,
		TRAIT_CRITICAL_RESISTANCE,
		TRAIT_DODGEEXPERT,
		TRAIT_MEDIUMARMOR,
		TRAIT_FEARLESS,
	)
	forced = TRUE


/datum/antagonist/vampire/lord/daewalker/on_gain()
	var/mob/living/carbon/human/blade = owner.current
	blade.gender = MALE
	blade.age = AGE_ADULT
	blade.clear_quirks()
	blade.set_species(/datum/species/human/northern)

	blade.skin_tone = SKIN_COLOR_CRIMSONLANDS
	blade.set_eye_color("#ffff00")
	blade.set_hair_color("#181a1d", FALSE)
	blade.set_facial_hair_color("#181a1d", FALSE)
	blade.set_hair_style(/datum/sprite_accessory/hair/head/hunter, FALSE)
	blade.set_facial_hair_style(/datum/sprite_accessory/hair/facial/shaved, FALSE)
	blade.fully_replace_character_name(blade.real_name, "\improper Daewalker")
	blade.article = "the"
	blade.dna?.update_dna_identity()

	forcing_clan = new /datum/clan/daewalker()
	. = ..()

	blade.modifier_set_stat_to("[type]", STATKEY_STR, 15)
	blade.modifier_set_stat_to("[type]", STATKEY_PER, 15)
	blade.modifier_set_stat_to("[type]", STATKEY_INT, 15)
	blade.modifier_set_stat_to("[type]", STATKEY_CON, 15)
	blade.modifier_set_stat_to("[type]", STATKEY_END, 15)
	blade.modifier_set_stat_to("[type]", STATKEY_SPD, 15)
	blade.modifier_set_stat_to("[type]", STATKEY_LCK, 13)

	blade.adjust_skillrank(/datum/skill/combat/swords, 6, TRUE)
	blade.adjust_skillrank(/datum/skill/combat/firearms, 6, TRUE)
	blade.adjust_skillrank(/datum/skill/combat/knives, 5, TRUE)
	blade.adjust_skillrank(/datum/skill/combat/axesmaces, 3, TRUE)
	blade.adjust_skillrank(/datum/skill/combat/bows, 4, TRUE)
	blade.adjust_skillrank(/datum/skill/combat/crossbows, 4, TRUE)
	blade.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
	blade.adjust_skillrank(/datum/skill/combat/unarmed, 5, TRUE)
	blade.adjust_skillrank(/datum/skill/combat/wrestling, 5, TRUE)
	blade.adjust_skillrank(/datum/skill/combat/whipsflails, 2, TRUE)

	blade.adjust_skillrank(/datum/skill/craft/armorsmithing, 1, TRUE)
	blade.adjust_skillrank(/datum/skill/craft/weaponsmithing, 2, TRUE)
	blade.adjust_skillrank(/datum/skill/craft/bombs, 2, TRUE)
	blade.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	blade.adjust_skillrank(/datum/skill/craft/traps, 4, TRUE)
	blade.adjust_skillrank(/datum/skill/labor/mathematics, 3, TRUE)

	blade.adjust_skillrank(/datum/skill/misc/athletics, 6, TRUE)
	blade.adjust_skillrank(/datum/skill/misc/lockpicking, 3, TRUE)
	blade.adjust_skillrank(/datum/skill/misc/climbing, 5, TRUE)
	blade.adjust_skillrank(/datum/skill/misc/medicine, 3, TRUE)
	blade.adjust_skillrank(/datum/skill/misc/riding, 4, TRUE)
	blade.adjust_skillrank(/datum/skill/misc/swimming, 5, TRUE)
	blade.adjust_skillrank(/datum/skill/misc/sneaking, 5, TRUE)
	blade.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)

	blade.maxbloodpool = 5000
	blade.set_bloodpool(5000)
	blade.cmode_music ='sound/music/cmode/antag/CombatDaywalker.ogg'

/datum/antagonist/vampire/lord/daewalker/get_thralls()
	return

/datum/antagonist/vampire/lord/daewalker/greet()
	to_chat(owner.current, span_userdanger("todo"))


/datum/antagonist/vampire/lord/daewalker/equip()
	. = ..()
	return TRUE

/datum/antagonist/vampire/lord/daewalker/move_to_spawnpoint()
	return

/datum/outfit/daewalker
	mask = /obj/item/clothing/face/spectacles/sglasses
	neck = /obj/item/clothing/neck/psycross/silver/astrata
	armor = /obj/item/clothing/armor/medium/scale/inqcoat/armored/daewalker
	shirt = /obj/item/clothing/armor/gambeson/heavy/inq/daewalker
	pants = /obj/item/clothing/pants/trou/formal
	shoes = /obj/item/clothing/shoes/boots/leather/advanced/daewalker
	gloves = /obj/item/clothing/gloves/eastgloves2
	ring =  /obj/item/clothing/ring/active/nomag

	scabbards = list(/obj/item/weapon/scabbard/sword/noble)
	belt = /obj/item/storage/belt/leather/knifebelt/black/psydon
	beltl = /obj/item/gun/ballistic/revolver/grenadelauncher/pistol
	beltr = /obj/item/ammo_holder/bullet/bullets
	backl = /obj/item/storage/backpack/satchel/otavan
	backr = /obj/item/weapon/sword/long/daewalker
	wrists = /obj/item/weapon/scabbard/knife/hand/daewalker
	backpack_contents = list(/obj/item/reagent_containers/glass/bottle/aflask = 1, /obj/item/smokebomb = 2, /obj/item/needle/blessed = 1)

/datum/outfit/daewalker/post_equip(mob/living/carbon/human/H)
	..()
	if(istype(H.wear_wrists, /obj/item/weapon/scabbard/knife/hand/daewalker))
		new /obj/item/weapon/knife/dagger/silver/psydon(H.wear_wrists)
		H.wear_wrists.update_appearance(UPDATE_ICON_STATE)
	H.wear_mask?.color = "#1E1E1E"
