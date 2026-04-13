/datum/attribute_holder/sheet/job/skeleton_npc/supereasy
	raw_attribute_list = list(
		STAT_STRENGTH = 0,
		STAT_SPEED = -2,
		STAT_CONSTITUTION = -6,
		STAT_ENDURANCE = 0,
		STAT_INTELLIGENCE = -9,
		/datum/attribute/skill/combat/polearms = 10,
		/datum/attribute/skill/combat/axesmaces = 10,
		/datum/attribute/skill/combat/swords = 10,
		/datum/attribute/skill/combat/knives = 10,
		/datum/attribute/skill/combat/shields = 10,
		/datum/attribute/skill/combat/unarmed = 10,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 20,
	)

/datum/attribute_holder/sheet/job/skeleton_npc/easy
	raw_attribute_list = list(
		STAT_STRENGTH = -1,
		STAT_SPEED = -2,
		STAT_CONSTITUTION = -6,
		STAT_ENDURANCE = 2,
		STAT_INTELLIGENCE = -9,
		/datum/attribute/skill/combat/polearms = 20,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/swords = 20,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/shields = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 20,
	)

/datum/attribute_holder/sheet/job/skeleton_npc/pirate
	raw_attribute_list = list(
		STAT_STRENGTH = -1,
		STAT_SPEED = -2,
		STAT_CONSTITUTION = -6,
		STAT_ENDURANCE = 2,
		STAT_INTELLIGENCE = -9,
		/datum/attribute/skill/combat/polearms = 20,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/swords = 20,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/shields = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 20,
	)

/datum/attribute_holder/sheet/job/skeleton_npc/medium
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_SPEED = -2,
		STAT_CONSTITUTION = -4,
		STAT_ENDURANCE = 0,
		STAT_INTELLIGENCE = -9,
		/datum/attribute/skill/combat/polearms = 30,
		/datum/attribute/skill/combat/axesmaces = 30,
		/datum/attribute/skill/combat/swords = 30,
		/datum/attribute/skill/combat/knives = 30,
		/datum/attribute/skill/combat/shields = 30,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/misc/swimming = 30,
		/datum/attribute/skill/misc/climbing = 30,
	)

/datum/attribute_holder/sheet/job/skeleton_npc/hard/khopesh
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_SPEED = 2,
		STAT_CONSTITUTION = -2,
		STAT_ENDURANCE = 2,
		STAT_INTELLIGENCE = -9,
		/datum/attribute/skill/combat/polearms = 40,
		/datum/attribute/skill/combat/axesmaces = 40,
		/datum/attribute/skill/combat/swords = 40,
		/datum/attribute/skill/combat/knives = 40,
		/datum/attribute/skill/combat/shields = 40,
		/datum/attribute/skill/combat/unarmed = 40,
		/datum/attribute/skill/combat/wrestling = 40,
		/datum/attribute/skill/misc/swimming = 40,
		/datum/attribute/skill/misc/climbing = 40,
	)

/datum/attribute_holder/sheet/job/skeleton_npc/hard/dreadknight
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_SPEED = -2,
		STAT_CONSTITUTION = -2,
		STAT_ENDURANCE = 2,
		STAT_INTELLIGENCE = -9,
		/datum/attribute/skill/combat/polearms = 40,
		/datum/attribute/skill/combat/axesmaces = 40,
		/datum/attribute/skill/combat/swords = 40,
		/datum/attribute/skill/combat/knives = 40,
		/datum/attribute/skill/combat/shields = 40,
		/datum/attribute/skill/combat/unarmed = 40,
		/datum/attribute/skill/combat/wrestling = 40,
		/datum/attribute/skill/misc/swimming = 40,
		/datum/attribute/skill/misc/climbing = 40,
	)

/mob/living/carbon/human/species/skeleton/npc/supereasy
	skel_outfit = /datum/outfit/job/skeleton/npc/supereasy

/datum/outfit/job/skeleton/npc/supereasy/pre_equip(mob/living/carbon/human/H)
	..()
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
	H.attributes.add_sheet(/datum/attribute_holder/sheet/job/skeleton_npc/supereasy)

/mob/living/carbon/human/species/skeleton/npc/easy
	skel_outfit = /datum/outfit/job/skeleton/npc/easy

/datum/outfit/job/skeleton/npc/easy/pre_equip(mob/living/carbon/human/H)
	..()
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
	H.attributes.add_sheet(/datum/attribute_holder/sheet/job/skeleton_npc/easy)

/mob/living/carbon/human/species/skeleton/npc/pirate
	skel_outfit = /datum/outfit/job/skeleton/npc/pirate

/datum/outfit/job/skeleton/npc/pirate/pre_equip(mob/living/carbon/human/H)
	..()
	name = "Skeleton Pirate"
	head = /obj/item/clothing/head/helmet/leather/tricorn
	wrists = /obj/item/clothing/wrists/bracers/ancient
	shirt = /obj/item/clothing/armor/chainmail/iron
	pants = /obj/item/clothing/pants/tights/sailor
	shoes = /obj/item/clothing/shoes/boots/armor/light
	if(prob(50))
		r_hand = /obj/item/weapon/knife/dagger
	else
		r_hand = /obj/item/weapon/knuckles
	H.attributes.add_sheet(/datum/attribute_holder/sheet/job/skeleton_npc/pirate)

/mob/living/carbon/human/species/skeleton/npc/medium
	skel_outfit = /datum/outfit/job/skeleton/npc/medium

/datum/outfit/job/skeleton/npc/medium/pre_equip(mob/living/carbon/human/H)
	..()
	name = "Skeleton Soldier"
	cloak = /obj/item/clothing/cloak/heartfelt
	head = /obj/item/clothing/head/helmet/heavy/ancient
	armor = /obj/item/clothing/armor/cuirass/copperchest
	shirt = /obj/item/clothing/armor/chainmail/iron
	wrists = /obj/item/clothing/wrists/bracers/ancient
	pants = /obj/item/clothing/pants/chainlegs/kilt/iron
	shoes = /obj/item/clothing/shoes/boots/armor/light
	neck = /obj/item/clothing/neck/chaincoif/iron
	gloves = /obj/item/clothing/gloves/chain
	belt = /obj/item/storage/belt/leather/rope
	if(prob(33))
		l_hand = /obj/item/weapon/shield/tower/metal/ancient
	if(prob(33))
		r_hand = /obj/item/weapon/polearm/spear/bonespear
	else if(prob(33))
		r_hand = /obj/item/weapon/sword/gladius
	else
		r_hand = /obj/item/weapon/flail
	H.attributes.add_sheet(/datum/attribute_holder/sheet/job/skeleton_npc/medium)

/mob/living/carbon/human/species/skeleton/npc/hard
	skel_outfit = /datum/outfit/job/skeleton/npc/hard

/datum/outfit/job/skeleton/npc/hard/pre_equip(mob/living/carbon/human/H)
	..()
	name = "Skeleton Dreadnought"
	var/skeletonclass = rand(1, 2)
	if(skeletonclass == 1)
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
		H.attributes.add_sheet(/datum/attribute_holder/sheet/job/skeleton_npc/hard/khopesh)
	else
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
		H.attributes.add_sheet(/datum/attribute_holder/sheet/job/skeleton_npc/hard/dreadknight)

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
	var/outfit = rand(1, 4)
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
