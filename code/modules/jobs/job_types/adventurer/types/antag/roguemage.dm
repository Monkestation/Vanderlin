/datum/advclass/roguemage //mage class - like the adventurer mage, but more evil.
	name = "Rogue Mage"
	tutorial = "Those fools at the academy laughed at you and cast you from the ivory tower of higher learning and magickal practice. No matter - you will ascend to great power one day, but first you need wealth - vast amounts of it. Show those fools in the town what REAL magic looks like."
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/bandit/roguemage
	category_tags = list(CTAG_BANDIT)
	cmode_music = 'sound/music/cmode/antag/combat_bandit_mage.ogg'

/datum/outfit/job/bandit/roguemage/pre_equip(mob/living/carbon/human/H)
	..()
	if(prob(15))
		H.cmode_music = 'sound/music/cmode/antag/combat_evilwizard.ogg'

	H.mana_pool?.set_intrinsic_recharge(MANA_ALL_LEYLINES)
	shoes = /obj/item/clothing/shoes/simpleshoes
	pants = /obj/item/clothing/pants/trou/leather
	shirt = /obj/item/clothing/shirt/shortshirt
	armor = /obj/item/clothing/shirt/robe/black
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/reagent_containers/glass/bottle/manapot
	backr = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/needle/thorn = 1, /obj/item/natural/cloth = 1, /obj/item/clothing/face/spectacles/sglasses, /obj/item/chalk = 1, /obj/item/book/granter/spellbook/apprentice = 1)
	mask = /obj/item/clothing/face/facemask/steel //idk if this makes it so they cant cast but i want all of the bandits to have the same mask
	neck = /obj/item/clothing/neck/coif
	head = /obj/item/clothing/head/roguehood/black

	r_hand = /obj/item/weapon/polearm/woodstaff/quarterstaff/iron
	if(H.mind)
		H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/bows, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE) //needs climbing to get into hideout
		H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE) //polearm user, required
		H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/riding, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/reading, 4, TRUE)
		H.adjust_skillrank(/datum/skill/craft/alchemy, 3, TRUE)
		H.adjust_skillrank(/datum/skill/magic/arcane, 3, TRUE)
		if(H.age == AGE_OLD)
			H.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
			H.change_stat(STATKEY_SPD, -1)
			H.change_stat(STATKEY_INT, 1)
			H.change_stat(STATKEY_PER, 1)
			H.mind.adjust_spellpoints(1)
		H.change_stat(STATKEY_STR, -1)
		H.change_stat(STATKEY_INT, 3)
		H.change_stat(STATKEY_CON, 1)
		H.change_stat(STATKEY_END, -1)
		H.mind.adjust_spellpoints(1)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
