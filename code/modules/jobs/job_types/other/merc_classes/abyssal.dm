/datum/job/advclass/mercenary/abyssal
	title = "Abyssal Guard"
	tutorial = "Amphibious warriors from the depths, the Abyss Guard is a legion of triton mercenaries forged in the seas, the males are trained in the arcyne whilst the females take the vanguard with their imposing physique."
	allowed_races = list(SPEC_ID_TRITON)
	outfit = /datum/outfit/mercenary/abyssal
	category_tags = list(CTAG_MERCENARY)
	total_positions = 2

	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander3.ogg'

/datum/outfit/mercenary/abyssal/pre_equip(mob/living/carbon/human/H)
	..()
	shoes = /obj/item/clothing/shoes/sandals
	belt = /obj/item/storage/belt/leather/mercenary
	backl = /obj/item/storage/backpack/satchel
	armor = /obj/item/clothing/armor/medium/scale
	head = /obj/item/clothing/head/helmet/winged
	neck = /obj/item/clothing/neck/chaincoif/iron
	var/const/obj/item/weapon/sword_type = /obj/item/weapon/sword/sabre/cutlass
	beltl = sword_type
	scabbards = list(sword_type::associated_scabbard_type)
	backpack_contents = list(/obj/item/key/mercenary, /obj/item/storage/belt/pouch/coins/poor, /obj/item/reagent_containers/food/snacks/fish/swordfish) //soul

	H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)

	H.merctype = 10

	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

	if(H.gender == FEMALE) //Slow tank with a spear

		backr = /obj/item/weapon/polearm/spear/hoplite/abyssal
		beltr = /obj/item/weapon/shield/tower/buckleriron
		H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)

		H.change_stat(STATKEY_STR, 1)
		H.change_stat(STATKEY_CON, 2)
		H.change_stat(STATKEY_INT, -1)
		H.change_stat(STATKEY_PER, 2)
	if(H.gender == MALE) //Arcyne gifted trident wielder

		H.add_spell(/datum/action/cooldown/spell/undirected/conjure_item/summon_trident)
		H.add_spell(/datum/action/cooldown/spell/pressure)
		H.mana_pool?.set_intrinsic_recharge(MANA_ALL_LEYLINES)
		H.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/medicine, 2, TRUE)
		H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
		H.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
		H.change_stat(STATKEY_INT, 2)
		H.change_stat(STATKEY_PER, 2)
		if(!istype(H.patron, /datum/patron/inhumen/zizo))
			H.set_patron(/datum/patron/divine/noc)


