GLOBAL_LIST_INIT(drowraider_aggro, file2list("strings/rt/drowaggrolines.txt"))

/mob/living/carbon/human/species/elf/dark/drowraider
	ai_controller = /datum/ai_controller/human_npc
	faction = list("drow")
	ambushable = FALSE
	dodgetime = 30
	flee_in_pain = TRUE
	d_intent = INTENT_DODGE
	var/is_silent = FALSE /// Determines whether or not we will scream our funny lines at people.

/mob/living/carbon/human/species/elf/dark/drowraider/ambush
	wander = TRUE

/mob/living/carbon/human/species/elf/dark/drowraider/Initialize()
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)
	set_species(/datum/species/elf/dark)
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)
	is_silent = TRUE


/mob/living/carbon/human/species/elf/dark/drowraider/after_creation()
	..()
	job = "Drow Raider"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_DUALWIELDER, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/job/human/species/elf/dark/drowraider)
	SEND_SIGNAL(src, COMSIG_MOB_MODIFY_AGGRO_LINES, GLOB.drowraider_aggro, TRUE)
	if(prob(40))
		gender = MALE
	else
		gender = FEMALE
	regenerate_icons()

	var/obj/item/organ/eyes/organ_eyes = getorgan(/obj/item/organ/eyes)
	var/obj/item/organ/ears/organ_ears = getorgan(/obj/item/organ/ears)
	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
	var/hairf = pick(list(
						/datum/sprite_accessory/hair/head/countryponytailalt,
						/datum/sprite_accessory/hair/head/stacy,
						/datum/sprite_accessory/hair/head/kusanagi_alt))
	var/hairm = pick(list(/datum/sprite_accessory/hair/head/ponytailwitcher,
						/datum/sprite_accessory/hair/head/dave,
						/datum/sprite_accessory/hair/head/sabitsuki))

	var/datum/bodypart_feature/hair/head/new_hair = new()

	if(gender == FEMALE)
		new_hair.set_accessory_type(hairf, null, src)
	else
		new_hair.set_accessory_type(hairm, null, src)

	new_hair.accessory_colors = "#DDDDDD"
	new_hair.hair_color = "#DDDDDD"
	set_hair_color("#DDDDDD")

	head.add_bodypart_feature(new_hair)
	head.sellprice = 40

	dna.update_ui_block(DNA_HAIR_COLOR_BLOCK)
	dna.species.handle_body(src)

	if(organ_eyes)
		organ_eyes.eye_color = "#FFBF00"
		organ_eyes.accessory_colors = "#FFBF00#FFBF00"

	if(organ_ears)
		organ_ears.accessory_colors = "#5f5f70"

	skin_tone = "5f5f70"

	if(gender == FEMALE)
		real_name = pick(file2list("strings/rt/names/elf/elfdf.txt"))
	else
		real_name = pick(file2list("strings/rt/names/elf/elfdm.txt"))

	faction += "spider_lowers"

	update_body()

/datum/outfit/job/human/species/elf/dark/drowraider/pre_equip(mob/living/carbon/human/H)
	shoes = /obj/item/clothing/shoes/boots/leather/advanced
	pants = /obj/item/clothing/pants/trou/shadowpants
	armor = /obj/item/clothing/armor/leather/jacket/silk_coat
	shirt = /obj/item/clothing/shirt/shadowshirt
	gloves = /obj/item/clothing/gloves/fingerless/shadowgloves
	wrists = /obj/item/clothing/wrists/bracers/leather/advanced
	mask = /obj/item/clothing/face/facemask
	neck = /obj/item/clothing/neck/coif
	r_hand = /obj/item/weapon/whip
	if(prob(45))
		r_hand = /obj/item/weapon/sword/sabre/stalker
		l_hand = /obj/item/weapon/sword/sabre/stalker
	else if(prob(15))
		r_hand = /obj/item/weapon/knife/dagger/steel/dirk
		l_hand = /obj/item/weapon/knife/dagger/steel/dirk

	H.base_strength = 12 // 6 Points
	H.base_speed = 13 // 3 points
	H.base_constitution = 14 // 4 points
	H.base_endurance = 12 // 2 points - 14 points spread. Equal to 1 more than a KC accounting for Statpack.
	H.base_perception = 10
	H.base_intelligence = 10
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axesmaces, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
