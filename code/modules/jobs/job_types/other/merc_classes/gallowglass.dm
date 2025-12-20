
/datum/job/advclass/mercenary/gallowglass
	title = "Gallowglass"
	tutorial = "A claymore-wielding mercenary hailing from the land of Kaledon, you are a fighter for coin, having fled the Grenzelhoftian occupation of your homeland. Your Kerns fight under you."
	allowed_races = list(\
		SPEC_ID_HUMEN,\
		SPEC_ID_ELF,\
		SPEC_ID_HALF_ELF,\
		SPEC_ID_DWARF,\
	)
	outfit = /datum/outfit/mercenary/gallowglass
	category_tags = list(CTAG_MERCENARY)
	total_positions = 2

	cmode_music = 'sound/music/cmode/Combat_Dwarf.ogg'

/datum/outfit/mercenary/gallowglass/pre_equip(mob/living/carbon/human/H)
	..()
	shoes = /obj/item/clothing/shoes/boots/leather
	head = /obj/item/clothing/head/helmet/nasal
	gloves = /obj/item/clothing/gloves/chain/iron
	belt = /obj/item/storage/belt/leather/mercenary/black
	armor = /obj/item/clothing/armor/cuirass
	cloak = /obj/item/clothing/cloak/stabard/kaledon
	neck = /obj/item/clothing/neck/gorget
	wrists = /obj/item/clothing/wrists/bracers/leather
	beltr = /obj/item/storage/belt/pouch/coins/poor
	beltl = /obj/item/weapon/mace/cudgel
	shirt = /obj/item/clothing/armor/gambeson/light/striped
	pants = /obj/item/clothing/pants/chainlegs/kilt
	backl = /obj/item/weapon/sword/long/greatsword/steelclaymore
	if(H.mind)
		H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE) // main weapon skill  the gallowglass is REALLY good with their claymore however there is only one of them
		H.adjust_skillrank(/datum/skill/combat/axesmaces, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.change_stat(STATKEY_STR, 2)
	H.change_stat(STATKEY_END, 1) //both Kaledon Highlanders get more endurance due to their harsh upbringing
	H.change_stat(STATKEY_SPD, -1) //Strong not fast
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
