/mob/living/carbon/human/species/orc/npc/footsoldier
	orc_outfit = /datum/outfit/job/orc/npc/footsoldier

/mob/living/carbon/human/species/orc/npc/marauder
	orc_outfit = /datum/outfit/job/orc/npc/marauder

/mob/living/carbon/human/species/orc/npc/berserker
	orc_outfit = /datum/outfit/job/orc/npc/berserker

/mob/living/carbon/human/species/orc/npc/warlord
	orc_outfit = /datum/outfit/job/orc/npc/warlord

/mob/living/carbon/human/species/orc/npc/archer_test
	orc_outfit = /datum/outfit/job/orc/npc/archer_test

// Underarmored orc with incomplete protection, bone axe / spear, and slow speed
/datum/outfit/job/orc/npc/footsoldier/pre_equip(mob/living/carbon/human/H)
	name = "Orc Footsoldier"
	wrists = /obj/item/clothing/wrists/bracers/leather
	if(prob(50))
		armor = /obj/item/clothing/armor/leather/hide
	else
		armor = /obj/item/clothing/armor/leather
	pants = /obj/item/clothing/pants/loincloth
	if(prob(50))
		head = /obj/item/clothing/head/helmet/leather
	shoes = /obj/item/clothing/shoes/gladiator
	var/wepchoice = rand(1, 3)
	switch(wepchoice)
		if(1)
			l_hand = /obj/item/weapon/axe/boneaxe
		if(2)
			l_hand = /obj/item/weapon/polearm/spear/bonespear
			r_hand = /obj/item/weapon/shield/wood // Help preserve integrity
		if(3)
			l_hand = /obj/item/weapon/mace/cudgel
	H.base_strength = 11
	H.base_speed = 8
	H.base_constitution = 11
	H.base_endurance = 11
	H.base_intelligence = 4 // Very dumb
	H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axesmaces, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)

// Slightly armored orc with slight facial protection, incomplete chainmail and spear / sword
/datum/outfit/job/orc/npc/marauder/pre_equip(mob/living/carbon/human/H)
	name = "Orc Marauder"
	wrists = /obj/item/clothing/wrists/bracers/leather
	armor = /obj/item/clothing/armor/chainmail
	shirt = /obj/item/clothing/armor/gambeson/light
	pants = /obj/item/clothing/pants/chainlegs/iron
	neck = /obj/item/clothing/neck/coif
	head = /obj/item/clothing/head/helmet/leather
	mask = /obj/item/clothing/face/facemask
	shoes = /obj/item/clothing/shoes/boots/leather/advanced
	var/wepchoice = rand(1, 5)
	switch(wepchoice)
		if(1)
			l_hand = /obj/item/weapon/polearm/spear
		if(2)
			l_hand = /obj/item/weapon/sword/scimitar/falchion
			r_hand = /obj/item/weapon/shield/wood // Help preserve integrity
		if(3)
			l_hand = /obj/item/weapon/mace // Threat to parry-er
		if(4)
			l_hand = /obj/item/weapon/greataxe
		if(5)
			l_hand = /obj/item/weapon/pick
	H.base_strength = 12 // GAGGER GAGGER GAGGER
	H.base_speed = 8
	H.base_constitution = 12
	H.base_endurance = 10
	H.base_intelligence = 4
	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axesmaces, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/labor/mining, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

// Lightly armored orc in light armor with no pain stun, and grappling oriented weapons
/datum/outfit/job/orc/npc/berserker/pre_equip(mob/living/carbon/human/H)
	wrists = /obj/item/clothing/wrists/bracers/leather
	armor = /obj/item/clothing/armor/leather/hide
	shirt = /obj/item/clothing/armor/gambeson/light
	pants = /obj/item/clothing/pants/trou/leather
	head = /obj/item/clothing/head/helmet/leather
	neck = /obj/item/clothing/neck/coif
	mask = /obj/item/clothing/face/facemask
	shoes = /obj/item/clothing/shoes/boots/leather/advanced
	var/wepchoice = rand(1, 2)
	switch(wepchoice)
		if(1)
			l_hand = /obj/item/weapon/knife/dagger
		if(2)
			l_hand = /obj/item/weapon/pick
	H.base_strength = 13 // GAGGER GAGGER GAGGER
	H.base_speed = 10 // Fast, for an orc
	H.base_constitution = 12
	H.base_endurance = 12
	H.base_intelligence = 1 // Minmax department
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/labor/mining, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	ADD_TRAIT(H, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_CRITICAL_RESISTANCE, INNATE_TRAIT)

// Heavily armored orc with complete iron protection, heavy armor, and a two hander.
/datum/outfit/job/orc/npc/warlord/pre_equip(mob/living/carbon/human/H)
	wrists = /obj/item/clothing/wrists/bracers/leather/advanced
	armor = /obj/item/clothing/armor/chainmail
	shirt = /obj/item/clothing/armor/gambeson
	pants = /obj/item/clothing/pants/chainlegs/iron
	head = /obj/item/clothing/head/helmet/skullcap
	neck = /obj/item/clothing/neck/chaincoif/iron
	mask = /obj/item/clothing/face/facemask
	shoes = /obj/item/clothing/shoes/boots/leather/advanced
	var/wepchoice = rand(1, 6)
	switch(wepchoice)
		if(1)
			l_hand = /obj/item/weapon/polearm/halberd/bardiche
		if(2)
			l_hand = /obj/item/weapon/polearm/halberd
		if(3)
			l_hand = /obj/item/weapon/greataxe
		if(4)
			l_hand = /obj/item/weapon/polearm/eaglebeak/lucerne
		if(5)
			l_hand = /obj/item/weapon/mace/goden
		if(6)
			l_hand = /obj/item/weapon/sword/scimitar/falchion
			r_hand = /obj/item/weapon/sword/scimitar/falchion // intrusive thoughts
	H.base_strength = 14 // GAGGER GAGGER GAGGER
	H.base_speed = 10 // Fast, for an orc
	H.base_constitution = 12
	H.base_endurance = 12
	H.base_intelligence = 1
	H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axesmaces, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)


// Heavily armored orc with complete iron protection, heavy armor, and a two hander.
/datum/outfit/job/orc/npc/archer_test/pre_equip(mob/living/carbon/human/H)
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
	backl = /obj/item/ammo_holder/quiver/arrows
	l_hand = /obj/item/weapon/sword/short/iron
	armor = /obj/item/clothing/armor/leather/hide
	shirt = /obj/item/clothing/armor/gambeson/light
	pants = /obj/item/clothing/pants/trou/leather
	belt = /obj/item/storage/belt/leather/knifebelt/black/steel
	beltr = /obj/item/storage/belt/pouch/medicine
	H.base_strength = 14 // GAGGER GAGGER GAGGER
	H.base_speed = 10 // Fast, for an orc
	H.base_constitution = 12
	H.base_endurance = 12
	H.base_intelligence = 1
