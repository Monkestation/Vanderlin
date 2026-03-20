/mob/living/carbon/human/species/human/northern/militia //weak peasant infantry. Neutral but can be given factions for events. doesn't attack players.
	ai_controller = /datum/ai_controller/human_npc
	faction = list("neutral")
	ambushable = FALSE
	wander = TRUE
	dodgetime = 30
	var/is_silent = TRUE /// Determines whether or not we will scream our funny lines at people.
	headprice = 10

/mob/living/carbon/human/species/human/northern/militia/Initialize()
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)
	set_species(/datum/species/human/northern)
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)
	is_silent = TRUE


/mob/living/carbon/human/species/human/northern/militia/after_creation()
	..()
	job = "Militia"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/job/human/species/human/northern/militia)
	var/obj/item/organ/eyes/organ_eyes = getorgan(/obj/item/organ/eyes)
	if(organ_eyes)
		organ_eyes.eye_color = pick("27becc", "35cc27", "000000")
	update_body()

/datum/attribute_holder/sheet/job/npc/militia
	attribute_variance = list(
		STAT_STRENGTH = list(0, 1),
		STAT_CONSTITUTION = list(0, 2)
	)
	raw_attribute_list = list(
		/datum/attribute/skill/combat/polearms = 20,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/swords = 20,
		/datum/attribute/skill/combat/shields = 20,
		/datum/attribute/skill/combat/unarmed = 20, // Trash mobs, untrained.
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 20,
	)

/datum/outfit/job/human/species/human/northern/militia/pre_equip(mob/living/carbon/human/H)
	if(H.faction && ("viking" in H.faction))
		cloak = /obj/item/clothing/cloak/stabard/mercenary
	else
		cloak = /obj/item/clothing/cloak/stabard/guard
	wrists = /obj/item/clothing/wrists/bracers/leather
	shirt = /obj/item/clothing/armor/gambeson/light
	if(prob(50))
		shirt = /obj/item/clothing/armor/gambeson
	if(prob(25))
		armor = /obj/item/clothing/armor/leather
	pants = /obj/item/clothing/pants/trou/leather
	if(prob(50))
		pants = /obj/item/clothing/pants/trou
	// Helmet, or lackthereof
	switch(rand(1, 7))
		if(1)
			head = /obj/item/clothing/head/helmet/kettle/iron
		if(2)
			head = /obj/item/clothing/head/helmet/sallet/iron
		if(3)
			head = /obj/item/clothing/head/helmet/skullcap
		if(4 to 6)
			head = /obj/item/clothing/neck/coif
		if(7)
			head = null
	// Neck protection, if there's no coif on head
	if(prob(50))
		neck = /obj/item/clothing/neck/coif
	gloves = /obj/item/clothing/gloves/fingerless
	if(prob(25))
		gloves = /obj/item/clothing/gloves/angle
	switch(rand(1, 11))
		// Militia Weapon. Of course they spawn with it
		if(1)
			r_hand = /obj/item/weapon/polearm/woodstaff
		if(2)
			r_hand = /obj/item/weapon/greataxe
		if(3)
			r_hand = /obj/item/weapon/polearm/spear
		if(4)
			r_hand = /obj/item/weapon/polearm/spear
			l_hand = /obj/item/weapon/shield/wood
		if(5)
			r_hand = /obj/item/weapon/sickle/scythe
		if(6)
			r_hand = /obj/item/weapon/pick
		if(7)
			r_hand = /obj/item/weapon/sword/scimitar/falchion
		if(8)
			r_hand = /obj/item/weapon/mace/cudgel
		if(9)
			r_hand = /obj/item/weapon/mace/goden
		if(10)
			r_hand = /obj/item/weapon/axe/iron
			l_hand = /obj/item/weapon/shield/wood
		if(11)
			r_hand = /obj/item/weapon/flail/peasantwarflail
	shoes = /obj/item/clothing/shoes/boots/leather
	var/eye_color = pick("27becc", "35cc27", "000000")
	H.set_eye_color(eye_color,eye_color)
	H.set_hair_color(pick("4f4f4f", "61310f", "faf6b9"))
	H.set_facial_hair_color(H.get_hair_color())
	if(H.gender == FEMALE)
		H.set_hair_style(pick(/datum/sprite_accessory/hair/head/countryponytailalt, /datum/sprite_accessory/hair/head/barbarian, /datum/sprite_accessory/hair/head/messy))
	else
		H.set_hair_style(pick(/datum/sprite_accessory/hair/head/majestic_human, /datum/sprite_accessory/hair/head/messy, /datum/sprite_accessory/hair/head/barbarian))
		H.set_facial_hair_style(pick(/datum/sprite_accessory/hair/facial/viking, /datum/sprite_accessory/hair/facial/pick, /datum/sprite_accessory/hair/facial/manly))
	H.attributes?.add_sheet(/datum/attribute_holder/sheet/job/npc/militia)

/mob/living/carbon/human/species/human/northern/militia/ambush
	wander = TRUE

/mob/living/carbon/human/species/human/northern/militia/guard //variant that doesn't wander, if you want to place them as set dressing. will aggro enemies and animals
	wander = FALSE

/mob/living/carbon/human/species/human/northern/militia/deserter // Bad deserter, trash mob
	faction = list("viking", "station")
