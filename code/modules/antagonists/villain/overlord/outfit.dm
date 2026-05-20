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

	H.attributes?.add_sheet(/datum/attribute_holder/sheet/job/lich)

	H.adjust_spell_points(17)
	H.grant_language(/datum/language/undead)
	if(H.dna?.species)
		H.dna.species.native_language = "Zizo Chant"
		H.dna.species.accent_language = H.dna.species.get_accent(H.dna.species.native_language)
	H.dna.species.soundpack_m = new /datum/voicepack/lich()
	H.ambushable = FALSE

	addtimer(CALLBACK(H, TYPE_PROC_REF(/mob/living/carbon/human, choose_name_popup), "OVERLORD"), 5 SECONDS)
