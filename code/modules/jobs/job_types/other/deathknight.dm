/datum/job/skeleton/knight
	title = "Death Knight"

	outfit = /datum/outfit/deathknight
	cmode_music = 'sound/music/cmode/combat_weird.ogg'

/datum/job/skeleton/knight/after_spawn(mob/living/carbon/spawned, client/player_client)
	SSmapping.find_and_remove_world_trait(/datum/world_trait/death_knight)
	SSmapping.retainer.death_knights |= spawned.mind
	..()
	spawned.name = "Death Knight"
	spawned.real_name = "Death Knight"

	ADD_TRAIT(spawned, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(spawned, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC)

/datum/outfit/deathknight/pre_equip(mob/living/carbon/human/H)
	..()	//Magic MUST be Noc or Zizo. Probably unneeded here, but better to be sure.
	H.set_patron(/datum/patron/inhumen/zizo)
	H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axesmaces, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)


	belt = /obj/item/storage/belt/leather
	pants = /obj/item/clothing/pants/platelegs/ancient
	shoes = /obj/item/clothing/shoes/boots/armor/vampire
	armor = /obj/item/clothing/armor/plate/ancient
	gloves = /obj/item/clothing/gloves/plate/ancient
	backl = /obj/item/weapon/polearm/halberd/bardiche/ancient
	backr = /obj/item/weapon/shield/tower/metal/ancient
	beltr = /obj/item/weapon/flail/sflail/ancient
	shirt = /obj/item/clothing/armor/chainmail/hauberk/ancient
	head = /obj/item/clothing/head/helmet/heavy/ancient
	wrists = /obj/item/clothing/wrists/bracers/ancient
	neck = /obj/item/clothing/neck/gorget/ancient

	H.change_stat(STATKEY_INT, 3)
	H.change_stat(STATKEY_STR, 3)
	H.change_stat(STATKEY_END, 2)
	H.change_stat(STATKEY_CON, 2)
	H.change_stat(STATKEY_PER, 2)

	var/datum/antagonist/new_antag = new /datum/antagonist/skeleton/knight()
	H.mind.add_antag_datum(new_antag)

/obj/item/clothing/armor/plate/blkknight/death
	color = CLOTHING_SOOT_BLACK

/obj/item/clothing/shoes/boots/armor/blkknight/death
	color = CLOTHING_SOOT_BLACK

/obj/item/clothing/gloves/plate/blk/death
	color = CLOTHING_SOOT_BLACK

/obj/item/clothing/pants/platelegs/blk/death
	color = CLOTHING_SOOT_BLACK
