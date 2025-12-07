/datum/job/advclass/mercenary/spellsword
	title = "Spellsword"
	tutorial = "A warrior who has dabbled in the arts of magic, you blend swordplay and spellcraft to earn your keep."
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/mercenary/spellsword
	category_tags = list(CTAG_MERCENARY)
	total_positions = 5

	cmode_music = 'sound/music/cmode/adventurer/CombatSorcerer.ogg'
	allowed_patrons = list(/datum/patron/divine/noc, /datum/patron/inhumen/zizo)
	blacklisted_species = list(SPEC_ID_HALFLING)
	exp_types_granted  = list(EXP_TYPE_MERCENARY, EXP_TYPE_COMBAT, EXP_TYPE_MAGICK)

/datum/outfit/mercenary/spellsword
	armor = /obj/item/clothing/armor/cuirass/iron
	neck = /obj/item/clothing/neck/gorget
	wrists = /obj/item/clothing/wrists/bracers/leather
	shirt = /obj/item/clothing/shirt/tunic
	gloves = /obj/item/clothing/gloves/leather
	pants = /obj/item/clothing/pants/trou/leather
	shoes = /obj/item/clothing/shoes/boots/leather
	belt = /obj/item/storage/belt/leather/mercenary
	beltr = /obj/item/weapon/sword
	beltl = /obj/item/storage/magebag/poor
	backl = /obj/item/storage/backpack/satchel
	scabbards = list(/obj/item/weapon/scabbard/sword)
	backpack_contents = list(/obj/item/storage/belt/pouch/coins/poor, /obj/item/weapon/knife/dagger, /obj/item/reagent_containers/glass/bottle/manapot, /obj/item/book/granter/spellbook/apprentice, /obj/item/chalk)

// Just a better adventurer warrior
/datum/outfit/mercenary/spellsword/pre_equip(mob/living/carbon/human/H)
	..()
	H.mana_pool?.set_intrinsic_recharge(MANA_ALL_LEYLINES)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
	H.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/alchemy, 1, TRUE)

	H.merctype = 9

	H.change_stat(STATKEY_STR, 2)
	H.change_stat(STATKEY_INT, 1)
	H.change_stat(STATKEY_SPD, -1)
	H.adjust_spell_points(5)
	H.add_spell(/datum/action/cooldown/spell/undirected/touch/prestidigitation)

	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
