// Ultra easy tier skeleton with no armor and just a single weapon.
/mob/living/carbon/human/species/skeleton/npc/supereasy
	skel_outfit = /datum/outfit/job/skeleton/npc/supereasy


/datum/outfit/job/skeleton/npc/supereasy/pre_equip(mob/living/carbon/human/H)
	..()
	H.base_strength = 10
	H.base_speed = 8
	H.base_constitution = 4
	H.base_endurance = 10
	H.base_intelligence = 1
	name = "Skeleton"
	if(prob(50))
		shirt = /obj/item/clothing/shirt/rags
	else
		shirt = /obj/item/clothing/shirt/tunic/colored/random
	if(prob(50))
		pants = /obj/item/clothing/pants/tights/colored/random
	else
		pants = /obj/item/clothing/pants/loincloth
	var/weapon_choice = rand(1, 4)
	switch(weapon_choice)
		if(1)
			r_hand = /obj/item/weapon/axe/iron
		if(2)
			r_hand = /obj/item/weapon/sword/short/iron
		if(3)
			r_hand = /obj/item/weapon/polearm/spear/bonespear
		if(4)
			r_hand = /obj/item/weapon/mace

	H.adjust_skillrank(/datum/skill/combat/polearms, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axesmaces, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)

// Easy tier skeleton, with only incomplete chainmail and kilt
// Ambushes people in "safe" route. A replacement for old skeletons that were effectively naked.
/mob/living/carbon/human/species/skeleton/npc/easy
	skel_outfit = /datum/outfit/job/skeleton/npc/easy


/datum/outfit/job/skeleton/npc/easy/pre_equip(mob/living/carbon/human/H)
	..()
	H.base_strength = 9
	H.base_speed = 8
	H.base_constitution = 4 // Same statblock as before easily killed
	H.base_endurance = 12
	H.base_intelligence = 1
	name = "Skeleton Footsoldier"
	shirt = /obj/item/clothing/armor/chainmail
	pants = /obj/item/clothing/pants/chainlegs/kilt
	shoes = /obj/item/clothing/shoes/boots/armor/light
	var/weapon_choice = rand(1, 4)
	switch(weapon_choice)
		if(1)
			r_hand = /obj/item/weapon/axe/iron
		if(2)
			r_hand = /obj/item/weapon/sword/short/iron
		if(3)
			r_hand = /obj/item/weapon/polearm/spear/bonespear
		if(4)
			r_hand = /obj/item/weapon/mace

	H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axesmaces, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)

// Also an "easy" tier skeleton, pirate themed, with a free hand to grab you
/mob/living/carbon/human/species/skeleton/npc/pirate
	skel_outfit = /datum/outfit/job/skeleton/npc/pirate

/datum/outfit/job/skeleton/npc/pirate/pre_equip(mob/living/carbon/human/H)
	..()
	H.base_strength = 9
	H.base_speed = 8
	H.base_constitution = 4 // Same statblock as before easily killed
	H.base_endurance = 12
	H.base_intelligence = 1
	name = "Skeleton Pirate"
	head =  /obj/item/clothing/head/helmet/leather/tricorn
	wrists = /obj/item/clothing/wrists/bracers/ancient
	shirt = /obj/item/clothing/armor/chainmail/iron
	pants = /obj/item/clothing/pants/tights/sailor
	shoes = /obj/item/clothing/shoes/boots/armor/light
	if(prob(50))
		r_hand = /obj/item/weapon/knife/dagger
	else
		r_hand = /obj/item/weapon/knuckles

	H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axesmaces, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)

// Medium tier skeleton, 3 skills.
/mob/living/carbon/human/species/skeleton/npc/medium
	skel_outfit = /datum/outfit/job/skeleton/npc/medium


/datum/outfit/job/skeleton/npc/medium/pre_equip(mob/living/carbon/human/H)
	..()
	H.base_strength = 11
	H.base_speed = 8
	H.base_constitution = 6 // Slightly tougher now!
	H.base_endurance = 10
	H.base_intelligence = 1
	name = "Skeleton Soldier"
	cloak = /obj/item/clothing/cloak/heartfelt // Ooo Spooky Old Dead MAA
	head = /obj/item/clothing/head/helmet/heavy/ancient
	armor = /obj/item/clothing/armor/cuirass/copperchest
	shirt = /obj/item/clothing/armor/chainmail/iron
	wrists = /obj/item/clothing/wrists/bracers/ancient
	pants = /obj/item/clothing/pants/chainlegs/kilt/iron
	shoes = /obj/item/clothing/shoes/boots/armor/light
	neck = /obj/item/clothing/neck/chaincoif/iron
	gloves = /obj/item/clothing/gloves/chain
	belt = /obj/item/storage/belt/leather/rope
	if(prob(33)) // 33% chance of shield, so ranged don't get screwed over entirely
		l_hand = /obj/item/weapon/shield/tower/metal/ancient
	if(prob(33))
		r_hand = /obj/item/weapon/polearm/spear/bonespear
	else if(prob(33))
		r_hand = /obj/item/weapon/sword/gladius
	else
		r_hand = /obj/item/weapon/flail

	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axesmaces, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)

// High tier skeleton, 4 skills. Heavy Armor.
/mob/living/carbon/human/species/skeleton/npc/hard
	skel_outfit = /datum/outfit/job/skeleton/npc/hard

/datum/outfit/job/skeleton/npc/hard/pre_equip(mob/living/carbon/human/H)
	..()
	H.base_strength = 12
	H.base_constitution = 8 // Woe, actual limb health.
	H.base_endurance = 12
	H.base_intelligence = 1
	name = "Skeleton Dreadnought"
	// This combines the khopesh  and withered dreadknight
	var/skeletonclass = rand(1, 2)
	if(skeletonclass == 1) // Khopesh Knight
		H.base_speed = 12 // Hue
		cloak = /obj/item/clothing/cloak/heartfelt
		mask = /obj/item/clothing/face/facemask/copper
		armor = /obj/item/clothing/armor/cuirass/copperchest
		shirt = /obj/item/clothing/armor/chainmail/iron
		wrists = /obj/item/clothing/wrists/bracers/ancient
		pants = /obj/item/clothing/pants/platelegs/iron
		shoes = /obj/item/clothing/shoes/boots/armor/light
		neck = /obj/item/clothing/neck/psycross/zizo
		gloves = /obj/item/clothing/gloves/chain/iron
		r_hand = /obj/item/weapon/sword/sabre/cutlass
		l_hand = /obj/item/weapon/sword/sabre/cutlass
	else // Withered Dreadknight
		H.base_speed = 8
		cloak = /obj/item/clothing/cloak/tabard/blkknight
		head = /obj/item/clothing/head/helmet/heavy/ironplate
		armor = /obj/item/clothing/armor/plate/ancient
		shirt = /obj/item/clothing/armor/chainmail/hauberk/fluted
		wrists = /obj/item/clothing/wrists/bracers/ancient
		pants = /obj/item/clothing/pants/platelegs/ancient
		shoes = /obj/item/clothing/shoes/boots/armor/light
		neck = /obj/item/clothing/neck/gorget/ancient
		gloves = /obj/item/clothing/gloves/plate/ancient
		belt = /obj/item/storage/belt/leather
		if(prob(50))
			r_hand = /obj/item/weapon/sword/long/greatsword
		else
			r_hand = /obj/item/weapon/mace/goden

	H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axesmaces, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 4, TRUE)

// For Duke Manor & Zizo Manor - Ground based spread, so no pirate in pool!
/mob/living/carbon/human/species/skeleton/npc/mediumspread/Initialize()
	var/outfit = rand(1, 4)
	switch(outfit)
		if(1)
			skel_outfit = /datum/outfit/job/skeleton/npc/supereasy
		if(2)
			skel_outfit = /datum/outfit/job/skeleton/npc/easy
		if(3)
			skel_outfit = /datum/outfit/job/skeleton/npc/medium
		if(4)
			skel_outfit = /datum/outfit/job/skeleton/npc/hard
	. = ..()

/mob/living/carbon/human/species/skeleton/npc/hardspread/Initialize()
	var/outfit = rand(1,4)
	switch(outfit)
		if(1)
			skel_outfit = /datum/outfit/job/skeleton/npc/hard
		if(2)
			skel_outfit = /datum/outfit/job/skeleton/npc/medium
		if(3)
			skel_outfit = /datum/outfit/job/skeleton/npc/pirate
		if(4)
			skel_outfit = /datum/outfit/job/skeleton/npc/hard
	. = ..()
