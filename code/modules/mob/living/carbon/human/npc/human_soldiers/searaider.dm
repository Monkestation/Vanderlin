GLOBAL_LIST_INIT(searaider_aggro, file2list("strings/rt/searaideraggrolines.txt"))

/mob/living/carbon/human/species/human/northern/searaider
	ai_controller = /datum/ai_controller/human_npc
	faction = list("viking", "station")
	ambushable = FALSE
	dodgetime = 30
	flee_in_pain = TRUE
	var/is_silent = FALSE /// Determines whether or not we will scream our funny lines at people.


/mob/living/carbon/human/species/human/northern/searaider/ambush
	ambushable = TRUE

/mob/living/carbon/human/species/human/northern/searaider/Initialize()
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)
	set_species(/datum/species/human/northern)
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)
	is_silent = TRUE


/mob/living/carbon/human/species/human/northern/searaider/after_creation()
	..()
	job = "Sea Raider"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/job/human/species/human/northern/searaider)
	SEND_SIGNAL(src, COMSIG_MOB_MODIFY_AGGRO_LINES, GLOB.searaider_aggro, TRUE)
	gender = pick(MALE, FEMALE)
	var/obj/item/organ/eyes/organ_eyes = getorgan(/obj/item/organ/eyes)
	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
	var/hairf = pick(list(/datum/sprite_accessory/hair/head/barbarian,
						/datum/sprite_accessory/hair/head/countryponytailalt))
	var/hairm = pick(list(/datum/sprite_accessory/hair/head/ponytailwitcher,
						/datum/sprite_accessory/hair/head/barbarian))
	var/beard = pick(list(/datum/sprite_accessory/hair/facial/viking,
						/datum/sprite_accessory/hair/facial/manly,
						/datum/sprite_accessory/hair/facial/pick))
	head.sellprice = 30 // 50% More than gobbo

	var/datum/bodypart_feature/hair/head/new_hair = new()
	var/datum/bodypart_feature/hair/facial/new_facial = new()

	if(gender == FEMALE)
		new_hair.set_accessory_type(hairf, null, src)
	else
		new_hair.set_accessory_type(hairm, null, src)
		new_facial.set_accessory_type(beard, null, src)

	if(prob(50))
		new_hair.accessory_colors = "#C1A287"
		new_hair.hair_color = "#C1A287"
		new_facial.accessory_colors = "#C1A287"
		new_facial.hair_color = "#C1A287"
		set_hair_color("#C1A287")
	else
		new_hair.accessory_colors = "#A56B3D"
		new_hair.hair_color = "#A56B3D"
		new_facial.accessory_colors = "#A56B3D"
		new_facial.hair_color = "#A56B3D"
		set_hair_color("#A56B3D")

	head.add_bodypart_feature(new_hair)
	head.add_bodypart_feature(new_facial)

	dna.update_ui_block(DNA_HAIR_COLOR_BLOCK)
	dna.species.handle_body(src)

	if(organ_eyes)
		organ_eyes.eye_color = "#336699"
		organ_eyes.accessory_colors = "#336699#336699"

	if(gender == FEMALE)
		real_name = pick(file2list("strings/rt/names/human/vikingf.txt"))
	else
		real_name = pick(file2list("strings/rt/names/human/vikingm.txt"))
	update_body()

/datum/attribute_holder/sheet/job/npc/searaider
	attribute_variance = list(
		STAT_CONSTITUTION = list(0, 2)
	)
	raw_attribute_list = list(
		STAT_SPEED = -1,
		STAT_ENDURANCE = 5,
		STAT_STRENGTH = 4,
		STAT_INTELLIGENCE = -9,
		/datum/attribute/skill/combat/polearms = 30,
		/datum/attribute/skill/combat/axesmaces = 30,
		/datum/attribute/skill/combat/swords = 30,
		/datum/attribute/skill/combat/shields = 30,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 20,
	)

/datum/outfit/job/human/species/human/northern/searaider/pre_equip(mob/living/carbon/human/H)
	wrists = /obj/item/clothing/wrists/bracers/leather
	if(prob(50))
		wrists = /obj/item/clothing/wrists/bracers/leather/advanced
	armor = /obj/item/clothing/armor/chainmail/iron
	shirt = /obj/item/clothing/shirt/undershirt/colored/vagrant
	if(prob(50))
		shirt = /obj/item/clothing/shirt/tunic
	pants = /obj/item/clothing/pants/tights
	if(prob(50))
		pants = /obj/item/clothing/pants/chainlegs/iron
	head = /obj/item/clothing/head/helmet/leather
	if(prob(50))
		head = /obj/item/clothing/head/helmet/horned
	if(prob(50))
		neck = /obj/item/clothing/neck/gorget
	if(prob(50))
		gloves = /obj/item/clothing/gloves/leather
	switch(rand(1, 4))
		if(1)
			r_hand = /obj/item/weapon/sword/iron
			l_hand = /obj/item/weapon/shield/wood
		if(2)
			r_hand = /obj/item/weapon/polearm/spear
		if(3)
			r_hand = /obj/item/weapon/greataxe
		if(4)
			r_hand = /obj/item/weapon/sword/long/greatsword

	shoes = /obj/item/clothing/shoes/boots/leather

	H.attributes?.add_sheet(/datum/attribute_holder/sheet/job/npc/searaider)
