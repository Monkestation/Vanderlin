
//After the bogfort fell to undead, the remaining guard who didn't flea turned to bandirty. Wellarmed and trained.
//These guys use alot of iron stuff with small amounts of steel mixed in, not really one for finetuned balance might be too hard or easy idk. Going off vibes atm
/datum/outfit/job/human/northern/bog_deserters/proc/add_random_deserter_cloak(mob/living/carbon/human/H)
	var/random_deserter_cloak = rand(1,4)
	switch(random_deserter_cloak)
		if(1)
			cloak = /obj/item/clothing/cloak/stabard/mercenary
		if(2)
			cloak = /obj/item/clothing/cloak/stabard/colored/dungeon
		if(3)
			cloak = /obj/item/clothing/armor/brigandine/coatplates

/datum/outfit/job/human/northern/bog_deserters/proc/add_random_deserter_weapon(mob/living/carbon/human/H)
	var/random_deserter_weapon = rand(1,3)
	switch(random_deserter_weapon)
		if(1)
			r_hand = /obj/item/weapon/sword/iron
			l_hand = /obj/item/weapon/shield/heater
		if(2)
			r_hand = /obj/item/weapon/polearm/spear
		if(3)
			r_hand = /obj/item/weapon/axe

/datum/outfit/job/human/northern/bog_deserters/proc/add_random_deserter_weapon_hard(mob/living/carbon/human/H)
	var/add_random_deserter_weapon_hard = rand(1,4)
	switch(add_random_deserter_weapon_hard)
		if(1)
			r_hand = /obj/item/weapon/sword/iron
			l_hand = /obj/item/weapon/shield/heater
		if(2)
			r_hand = /obj/item/weapon/mace/warhammer
			l_hand = /obj/item/weapon/shield/heater
		if(3)
			r_hand = /obj/item/weapon/axe
		if(4)
			r_hand = /obj/item/weapon/flail
			l_hand = /obj/item/weapon/shield/heater

/datum/outfit/job/human/northern/bog_deserters/proc/add_random_deserter_beltl_stuff(mob/living/carbon/human/H)
	var/add_random_deserter_beltl_stuff = rand(1,7)
	switch(add_random_deserter_beltl_stuff)
		if(1)
			beltl = /obj/item/storage/belt/pouch/food
		if(2)
			beltl = /obj/item/storage/belt/pouch/medicine
		if(3)
			beltl = /obj/item/storage/belt/pouch/coins/poor
		if(4)
			beltl = /obj/item/storage/belt/pouch/coins/mid
		if(5)
			beltl = /obj/item/reagent_containers/glass/bottle/waterskin
		if(6)
			beltl = /obj/item/reagent_containers/glass/bottle/healthpot
		if(7)
			beltl = /obj/item/weapon/scabbard/sword

/datum/outfit/job/human/northern/bog_deserters/proc/add_random_deserter_beltr_stuff(mob/living/carbon/human/H)
	var/add_random_deserter_beltr_stuff = rand(1,7)
	switch(add_random_deserter_beltr_stuff)
		if(1)
			beltr = /obj/item/storage/belt/pouch/food
		if(2)
			beltr = /obj/item/storage/belt/pouch/medicine
		if(3)
			beltr = /obj/item/storage/belt/pouch/coins/poor
		if(4)
			beltr = /obj/item/storage/belt/pouch/coins/mid
		if(5)
			beltr = /obj/item/reagent_containers/glass/bottle/waterskin
		if(6)
			beltr = /obj/item/reagent_containers/glass/bottle/healthpot
		if(7)
			beltr = /obj/item/weapon/scabbard/sword

/datum/outfit/job/human/northern/bog_deserters/proc/add_random_deserter_armor_hard(mob/living/carbon/human/H)
	var/random_deserter_armor_hard = rand(1,3)
	switch(random_deserter_armor_hard)
		if(1)
			armor = /obj/item/clothing/armor/brigandine/light
		if(2)
			armor = /obj/item/clothing/armor/cuirass/iron
		if(3)
			armor = /obj/item/clothing/armor/plate/fluted

/mob/living/carbon/human/species/human/northern/bog_deserters
	ai_controller = /datum/ai_controller/human_npc
	faction = list("viking", "station")
	ambushable = FALSE
	cmode = 1
	setparrytime = 30
	flee_in_pain = TRUE
	a_intent = INTENT_HELP
	d_intent = INTENT_PARRY
	possible_mmb_intents = list(INTENT_BITE, INTENT_JUMP, INTENT_KICK)

	headprice = 16
	var/is_silent = FALSE /// Determines whether or not we will scream our funny lines at people.


/mob/living/carbon/human/species/human/northern/bog_deserters/ambush
	wander = TRUE

/mob/living/carbon/human/species/human/northern/bog_deserters/Initialize()
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)
	set_species(/datum/species/human/northern)
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)
	is_silent = TRUE


/mob/living/carbon/human/species/human/northern/bog_deserters/after_creation()
	..()
	job = "Garrison Deserter"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_KNEESTINGER_IMMUNITY, TRAIT_GENERIC) //For when they're just kinda patrolling around/ambushes
	equipOutfit(new /datum/outfit/job/human/northern/bog_deserters)
	var/obj/item/organ/eyes/organ_eyes = getorgan(/obj/item/organ/eyes)
	if(organ_eyes)
		organ_eyes.eye_color = pick("27becc", "35cc27", "000000")
	update_body()

/datum/attribute_holder/sheet/job/npc/bog_deserters
	attribute_variance = list(
		STAT_STRENGTH = list(2, 4),
		STAT_CONSTITUTION = list(1, 3)
	)
	raw_attribute_list = list(
		STAT_SPEED = 1,
		STAT_ENDURANCE = 3,
		STAT_PERCEPTION = 1,
		/datum/attribute/skill/combat/axesmaces = 40, //NPCs do not get these skills unless a mind takes them over, hopefully in the future someone can fix
		/datum/attribute/skill/combat/whipsflails = 40,
		/datum/attribute/skill/combat/polearms = 40,
		/datum/attribute/skill/combat/swords = 40,
		/datum/attribute/skill/combat/shields = 30,
		/datum/attribute/skill/combat/wrestling = 40,
		/datum/attribute/skill/combat/unarmed = 40,
		/datum/attribute/skill/misc/athletics = 30,
	)

/datum/outfit/job/human/northern/bog_deserters/pre_equip(mob/living/carbon/human/H)
	..()
	//Body Stuff
	H.set_eye_color("#27becc","#27becc")
	H.set_hair_color("#61310f")
	H.set_facial_hair_color(H.get_hair_color())
	if(H.gender == FEMALE)
		H.set_hair_style(/datum/sprite_accessory/hair/head/messy)
	else
		H.set_hair_style(/datum/sprite_accessory/hair/head/messy)
		H.set_facial_hair_style(/datum/sprite_accessory/hair/facial/manly)
	//skill Stuff

	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	H.attributes?.add_sheet(/datum/attribute_holder/sheet/job/npc/bog_deserters)
	//Chest Gear
	add_random_deserter_cloak(H)
	shirt = /obj/item/clothing/armor/gambeson
	armor = /obj/item/clothing/armor/chainmail/hauberk/iron
	//Head Gear
	neck = /obj/item/clothing/neck/coif
	head = /obj/item/clothing/head/helmet/kettle/iron
	//wrist Gear
	gloves = /obj/item/clothing/gloves/chain/iron
	wrists = /obj/item/clothing/wrists/bracers/iron
	//Lower Gear
	belt = /obj/item/storage/belt/leather
	pants = /obj/item/clothing/pants/chainlegs/iron
	shoes = /obj/item/clothing/shoes/boots/armor
	//Weapons
	add_random_deserter_weapon(H)
	add_random_deserter_beltl_stuff(H)
	add_random_deserter_beltr_stuff(H)

/mob/living/carbon/human/species/human/northern/bog_deserters/better_gear
	faction = list("viking", "station")
	ambushable = FALSE
	cmode = 1
	setparrytime = 30
	flee_in_pain = TRUE
	a_intent = INTENT_HELP
	d_intent = INTENT_PARRY
	possible_mmb_intents = list(INTENT_BITE, INTENT_JUMP, INTENT_KICK)
	headprice = 20

/mob/living/carbon/human/species/human/northern/bog_deserters/better_gear/ambush
	wander = TRUE

/mob/living/carbon/human/species/human/northern/bog_deserters/better_gear/after_creation()
	job = "Garrison Deserter"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_KNEESTINGER_IMMUNITY, TRAIT_GENERIC) //For when they're just kinda patrolling around/ambushes
	equipOutfit(new /datum/outfit/job/human/northern/bog_deserters/better_gear)
	var/obj/item/organ/eyes/organ_eyes = getorgan(/obj/item/organ/eyes)
	if(organ_eyes)
		organ_eyes.eye_color = pick("27becc", "35cc27", "000000")
	update_body()

/datum/outfit/job/human/northern/bog_deserters/better_gear/pre_equip(mob/living/carbon/human/H)
	//Body Stuff
	H.set_eye_color("#27becc","#27becc")
	H.set_hair_color("#61310f")
	H.set_facial_hair_color(H.get_hair_color())
	if(H.gender == FEMALE)
		H.set_hair_style(/datum/sprite_accessory/hair/head/messy)
	else
		H.set_hair_style(/datum/sprite_accessory/hair/head/messy)
		H.set_facial_hair_style(/datum/sprite_accessory/hair/facial/manly)
	//skill Stuff
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	H.attributes?.add_sheet(/datum/attribute_holder/sheet/job/npc/bog_deserters)
	//Chest Gear
	shirt = /obj/item/clothing/armor/chainmail/hauberk/iron
	add_random_deserter_armor_hard(H)
	add_random_deserter_cloak(H)
	//Head Gear
	neck = /obj/item/clothing/neck/chaincoif/iron
	head = /obj/item/clothing/head/helmet/heavy/frog
	//wrist Gear
	gloves = /obj/item/clothing/gloves/plate/iron
	wrists = /obj/item/clothing/wrists/bracers/iron
	//Lower Gear
	belt = /obj/item/storage/belt/leather
	pants = /obj/item/clothing/pants/chainlegs/iron
	shoes = /obj/item/clothing/shoes/boots/armor
	//Weapons
	add_random_deserter_weapon_hard(H)
	add_random_deserter_beltl_stuff(H)
	add_random_deserter_beltr_stuff(H)
