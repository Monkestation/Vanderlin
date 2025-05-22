/datum/advclass/pilgrim/rare/grenzelhoft
	name = "Grenzelhoft Count"
	tutorial = "A Count hailing from the Grenzelhoft Imperiate, here on an official visit to Vanderlin."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_GRENZ
	outfit = /datum/outfit/job/adventurer/grenzelhoft
	category_tags = list(CTAG_PILGRIM)
	maximum_possible_slots = 1
	pickprob = 30
	min_pq = 0

	cmode_music = 'sound/music/cmode/combat_grenzelhoft.ogg'

/datum/outfit/job/adventurer/grenzelhoft/pre_equip(mob/living/carbon/human/H)
	..()
	shoes = /obj/item/clothing/shoes/grenzelhoft
	gloves = /obj/item/clothing/gloves/angle/grenzel
	wrists = /obj/item/clothing/neck/psycross/g
	head = /obj/item/clothing/head/helmet/skullcap/grenzelhoft
	belt = /obj/item/storage/belt/leather/plaquesilver
	beltl = /obj/item/weapon/sword/sabre/dec
	beltr = /obj/item/flashlight/flare/torch/lantern
	backr = /obj/item/storage/backpack/satchel
	ring = /obj/item/clothing/ring/gold
	shirt = /obj/item/clothing/shirt/grenzelhoft
	pants = /obj/item/clothing/pants/grenzelpants
	neck = /obj/item/clothing/neck/gorget
	backpack_contents = list(/obj/item/storage/belt/pouch/coins/veryrich)
	if(H.gender == FEMALE)
		armor = /obj/item/clothing/armor/gambeson/heavy/dress/alt
		beltl = /obj/item/weapon/sword/rapier/dec
	if(H.mind)
		H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/riding, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/reading, 4, TRUE)
		H.adjust_skillrank(/datum/skill/misc/music, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/cooking, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/bows, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/crossbows, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
		H.adjust_skillrank(/datum/skill/labor/mathematics, 3, TRUE)
		var/prev_real_name = H.real_name
		var/prev_name = H.name
		var/honorary = "Count"
		if(H.gender == FEMALE)
			honorary = "Countess"
		H.real_name = "[honorary] [prev_real_name]"
		H.name = "[honorary] [prev_name]"
		if(!H.has_language(/datum/language/oldpsydonic))
			H.grant_language(/datum/language/oldpsydonic)
			to_chat(H, "<span class='info'>I can speak Old Psydonic with ,m before my speech.</span>")
		H.change_stat(STATKEY_INT, 1)
		H.change_stat(STATKEY_END, 2)
		ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_FOREIGNER, TRAIT_GENERIC)
