/datum/attribute_holder/sheet/job/orc_npc/footsoldier
	raw_attribute_list = list(
		STAT_STRENGTH     = 1,
		STAT_SPEED        = -2,
		STAT_CONSTITUTION = 1,
		STAT_ENDURANCE    = 1,
		STAT_INTELLIGENCE = -6, // Very dumb
		/datum/attribute/skill/combat/polearms = 20,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/misc/athletics = 40,
		/datum/attribute/skill/combat/shields = 20,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/swimming = 20,
	)

/datum/attribute_holder/sheet/job/orc_npc/marauder
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_SPEED = -2,
		STAT_CONSTITUTION = 2,
		STAT_INTELLIGENCE = -6,
		/datum/attribute/skill/combat/polearms = 30,
		/datum/attribute/skill/combat/swords = 30,
		/datum/attribute/skill/combat/axesmaces = 30,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/labor/mining = 30,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/misc/athletics = 40,
		/datum/attribute/skill/combat/shields = 20,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/swimming = 20,
	)

/datum/attribute_holder/sheet/job/orc_npc/berserker
	raw_attribute_list = list(
		STAT_STRENGTH     = 3,
		STAT_CONSTITUTION = 2,
		STAT_ENDURANCE    = 2,
		STAT_INTELLIGENCE = -9, // Minmax department
		/datum/attribute/skill/combat/knives = 30,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/labor/mining = 30,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/misc/athletics = 40,
		/datum/attribute/skill/combat/shields = 20,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/swimming = 20,
	)

/datum/attribute_holder/sheet/job/orc_npc/elite
	raw_attribute_list = list(
		STAT_STRENGTH     = 4,
		STAT_CONSTITUTION = 2,
		STAT_ENDURANCE    = 2,
		STAT_INTELLIGENCE = -9,
		/datum/attribute/skill/combat/polearms = 40,
		/datum/attribute/skill/combat/swords = 40,
		/datum/attribute/skill/combat/axesmaces = 40,
		/datum/attribute/skill/combat/wrestling = 40,
		/datum/attribute/skill/combat/unarmed = 40,
		/datum/attribute/skill/misc/athletics = 40,
		/datum/attribute/skill/combat/shields = 30,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/swimming = 20,
	)

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
			r_hand = /obj/item/weapon/shield/wood
		if(3)
			l_hand = /obj/item/weapon/mace/cudgel
	H.attributes.add_sheet(/datum/attribute_holder/sheet/job/orc_npc/footsoldier)

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
			r_hand = /obj/item/weapon/shield/wood
		if(3)
			l_hand = /obj/item/weapon/mace
		if(4)
			l_hand = /obj/item/weapon/greataxe
		if(5)
			l_hand = /obj/item/weapon/pick
	H.attributes.add_sheet(/datum/attribute_holder/sheet/job/orc_npc/marauder)
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
	H.attributes.add_sheet(/datum/attribute_holder/sheet/job/orc_npc/berserker)
	ADD_TRAIT(H, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_CRITICAL_RESISTANCE, INNATE_TRAIT)

// Heavily armored orc with complete iron protection, heavy armor, and a two hander
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
	H.attributes.add_sheet(/datum/attribute_holder/sheet/job/orc_npc/elite)
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)

// Orc archer
/datum/outfit/job/orc/npc/archer_test/pre_equip(mob/living/carbon/human/H)
	backr = /obj/item/gun/ballistic/bow
	backl = /obj/item/ammo_holder/quiver/arrows
	l_hand = /obj/item/weapon/sword/short/iron
	armor = /obj/item/clothing/armor/leather/hide
	shirt = /obj/item/clothing/armor/gambeson/light
	pants = /obj/item/clothing/pants/trou/leather
	belt = /obj/item/storage/belt/leather/knifebelt/black/steel
	beltr = /obj/item/storage/belt/pouch/medicine
	H.attributes.add_sheet(/datum/attribute_holder/sheet/job/orc_npc/elite)
