/mob/living/carbon/human/species/human/northern/thief //I'm a thief, give me your shit
	faction = list("thieves")
	ambushable = FALSE
	dodgetime = 30
	flee_in_pain = TRUE
	a_intent = INTENT_HELP
	m_intent = MOVE_INTENT_SNEAK
	d_intent = INTENT_DODGE
	ai_controller = /datum/ai_controller/human_npc

/mob/living/carbon/human/species/human/northern/thief/Initialize()
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)
	set_species(/datum/species/human/northern)
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)

/mob/living/carbon/human/species/human/northern/thief/after_creation()
	..()
	job = "Thief"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LIGHT_STEP, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/job/human/species/human/northern/thief)
	gender = pick(MALE, FEMALE)
	regenerate_icons()

	var/obj/item/organ/eyes/organ_eyes = getorgan(/obj/item/organ/eyes)
	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
	var/hairf = pick(list(
						/datum/sprite_accessory/hair/head/bob))
	var/hairm = pick(list(
						/datum/sprite_accessory/hair/head/shaved))
	var/beard = pick(list(/datum/sprite_accessory/hair/facial/vandyke))

	var/datum/bodypart_feature/hair/head/new_hair = new()
	var/datum/bodypart_feature/hair/facial/new_facial = new()

	if(gender == FEMALE)
		new_hair.set_accessory_type(hairf, null, src)
	else
		new_hair.set_accessory_type(hairm, null, src)
		new_facial.set_accessory_type(beard, null, src)

	if(prob(50))
		new_hair.accessory_colors = "#96403d"
		new_hair.hair_color = "#96403d"
		new_facial.accessory_colors = "#96403d"
		new_facial.hair_color = "#96403d"
		set_hair_color("#96403d")
	else
		new_hair.accessory_colors = "#C7C755"
		new_hair.hair_color = "#C7C755"
		new_facial.accessory_colors = "#C7C755"
		new_facial.hair_color = "#C7C755"
		set_hair_color("#C7C755")

	head.add_bodypart_feature(new_hair)
	head.add_bodypart_feature(new_facial)

	dna.update_ui_block(DNA_HAIR_COLOR_BLOCK)
	dna.species.handle_body(src)

	if(organ_eyes)
		organ_eyes.eye_color = "#336699"
		organ_eyes.accessory_colors = "#336699#336699"

	if(gender == FEMALE)
		real_name = pick(file2list("strings/names/first_female.txt"))
	else
		real_name = pick(file2list("strings/names/first_male.txt"))
	update_body()
	head.sellprice = 30

/datum/attribute_holder/sheet/job/npc/thief
	raw_attribute_list = list(
		STAT_SPEED = 6,
		STAT_STRENGTH = 1,
		STAT_CONSTITUTION = 1,
		STAT_PERCEPTION = 1,
		STAT_INTELLIGENCE = -9,
		/datum/attribute/skill/combat/knives = 30,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 20,
	)

/datum/outfit/job/human/species/human/northern/thief/pre_equip(mob/living/carbon/human/H)
	cloak = /obj/item/clothing/cloak/raincloak/colored/mortus
	wrists = /obj/item/clothing/wrists/bracers/leather
	if(prob(50))
		wrists = /obj/item/clothing/wrists/bracers/copper
	armor = /obj/item/clothing/armor/cuirass/copperchest
	if(prob(50))
		armor = /obj/item/clothing/armor/leather
	shirt = /obj/item/clothing/armor/gambeson/light
	pants = /obj/item/clothing/pants/trou/leather
	head = /obj/item/clothing/head/helmet/leather
	mask = /obj/item/clothing/face/skullmask
	neck = /obj/item/clothing/neck/gorget/copper
	if(prob(50))
		neck = /obj/item/clothing/neck/leathercollar
	gloves = /obj/item/clothing/gloves/leather
	shoes = /obj/item/clothing/shoes/boots/leather
	l_hand = /obj/item/weapon/knife/dagger
	if(prob(50))
		l_hand = /obj/item/weapon/knife/copper
	H.attributes?.add_sheet(/datum/attribute_holder/sheet/job/npc/thief)
