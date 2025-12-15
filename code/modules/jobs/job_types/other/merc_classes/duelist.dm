/datum/job/advclass/mercenary/duelist
	title = "Duelist"
	tutorial = "A swordsman from Valoria, wielding a rapier with deadly precision and driven by honor and a thirst for coin, they duel with unmatched precision, seeking glory and wealth."
	allowed_races = list(\
		SPEC_ID_HUMEN,\
		SPEC_ID_ELF,\
		SPEC_ID_TIEFLING,\
		SPEC_ID_HALF_ELF,\
		SPEC_ID_HALF_DROW,\
		SPEC_ID_AASIMAR,\
		SPEC_ID_HALF_ORC,\
	) //Yes, Horcs get to be Duelists, Not Drows though.
	outfit = /datum/outfit/mercenary/duelist
	category_tags = list(CTAG_MERCENARY)
	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander.ogg' //Placeholder music since apparently i can't use one from the internet...
	total_positions = 5

/datum/outfit/mercenary/duelist
	head = /obj/item/clothing/head/leather/duelhat
	cloak = /obj/item/clothing/cloak/half/duelcape
	armor = /obj/item/clothing/armor/leather/jacket/leathercoat/duelcoat
	shirt = /obj/item/clothing/shirt/undershirt
	gloves = /obj/item/clothing/gloves/leather/duelgloves
	pants = /obj/item/clothing/pants/trou/leather/advanced/colored/duelpants
	shoes = /obj/item/clothing/shoes/nobleboot/duelboots
	belt = /obj/item/storage/belt/leather/mercenary
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/storage/belt/pouch/coins/mid)

/datum/outfit/mercenary/duelist/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
		H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/sneaking, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE) //I honestly would have given them 5 in athletics, but y'know.
		H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/cooking, 3, TRUE)
	var/obj/item/weapon/sword_type = null
	var/rando = rand(1,6)
	switch(rando)
		if(1 to 2)
			sword_type = /obj/item/weapon/sword/rapier
		if(3 to 4)
			sword_type = /obj/item/weapon/sword/rapier/silver //Correct, They have a chance to receive a silver rapier, due to them being from Valoria.
		if(5 to 6)
			sword_type = /obj/item/weapon/sword/rapier/dec
	beltl = sword_type
	scabbards = list(sword_type::associated_scabbard_type)
	H.merctype = 8
	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	H.change_stat(STATKEY_END, 2)
	H.change_stat(STATKEY_SPD, 2)
	H.change_stat(STATKEY_PER, 2)
	H.change_stat(STATKEY_STR, -1) //I seriously do not understand how mercenaries stats are balanced, See Exiled, Underdwellers and the others
