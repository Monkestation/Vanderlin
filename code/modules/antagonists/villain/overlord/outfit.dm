/datum/outfit/overlord
	name = "Overlord"

/datum/outfit/overlord/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/helmet/skullcap/cult
	pants = /obj/item/clothing/pants/chainlegs
	shoes = /obj/item/clothing/shoes/shortboots
	neck = /obj/item/clothing/neck/chaincoif
	armor = /obj/item/clothing/shirt/robe/necromancer
	shirt = /obj/item/clothing/shirt/tunic/colored
	wrists = /obj/item/clothing/wrists/bracers
	gloves = /obj/item/clothing/gloves/chain
	belt = /obj/item/storage/belt/leather/black
	backl = /obj/item/storage/backpack/satchel
	beltr = /obj/item/reagent_containers/glass/bottle/manapot
	beltl = /obj/item/weapon/knife/dagger/steel
	r_hand = /obj/item/weapon/polearm/woodstaff

	H.set_skillrank(/datum/skill/misc/reading, 6, TRUE)
	H.set_skillrank(/datum/skill/craft/alchemy, 5, TRUE)
	H.set_skillrank(/datum/skill/magic/arcane, 5, TRUE)
	H.set_skillrank(/datum/skill/misc/riding, 4, TRUE)
	H.set_skillrank(/datum/skill/combat/polearms, 4, TRUE)
	H.set_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.set_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
	H.set_skillrank(/datum/skill/misc/swimming, 1, TRUE)
	H.set_skillrank(/datum/skill/misc/climbing, 1, TRUE)
	H.set_skillrank(/datum/skill/misc/athletics, 1, TRUE)
	H.set_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.set_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.set_skillrank(/datum/skill/craft/crafting, 1, TRUE)
	H.adjust_skillrank(/datum/skill/labor/mathematics, 4, TRUE)

	H.change_stat(STATKEY_STR, -1)
	H.change_stat(STATKEY_INT, 5)
	H.change_stat(STATKEY_CON, 5)
	H.change_stat(STATKEY_END, -1)
	H.change_stat(STATKEY_SPD, -1)
	H.adjust_spell_points(17)
	H.grant_language(/datum/language/undead)
	if(H.dna?.species)
		H.dna.species.native_language = "Zizo Chant"
		H.dna.species.accent_language = H.dna.species.get_accent(H.dna.species.native_language)
	H.dna.species.soundpack_m = new /datum/voicepack/lich()
	H.ambushable = FALSE

	addtimer(CALLBACK(H, TYPE_PROC_REF(/mob/living/carbon/human, choose_name_popup), "OVERLORD"), 5 SECONDS)
