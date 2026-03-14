GLOBAL_LIST_INIT(highwayman_aggro, file2list("strings/rt/highwaymanaggrolines.txt"))

/mob/living/carbon/human/species/human/northern/highwayman
	ai_controller = /datum/ai_controller/human_npc
	faction = list(FACTION_VIKINGS)
	ambushable = FALSE
	dodgetime = 30
	flee_in_pain = TRUE
	d_intent = INTENT_PARRY
	var/is_silent = FALSE /// Determines whether or not we will scream our funny lines at people.


/mob/living/carbon/human/species/human/northern/highwayman/ambush
	wander = TRUE


/mob/living/carbon/human/species/human/northern/highwayman/Initialize()
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)
	set_species(/datum/species/human/northern)
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)
	is_silent = TRUE


/mob/living/carbon/human/species/human/northern/highwayman/after_creation()
	..()
	job = "Highwayman"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/job/human/species/human/northern/highwayman)
	SEND_SIGNAL(src, COMSIG_MOB_MODIFY_AGGRO_LINES, GLOB.highwayman_aggro, TRUE)
	var/obj/item/organ/eyes/organ_eyes = getorgan(/obj/item/organ/eyes)
	if(organ_eyes)
		organ_eyes.eye_color = pick("27becc", "35cc27", "000000")
	update_body()
	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
	head.sellprice = 30 // 50% More than goblin


/datum/attribute_holder/sheet/job/npc/highwayman
	attribute_variance = list(
		STAT_STRENGTH = list(2, 4),
		STAT_CONSTITUTION = list(0, 2)
	)
	raw_attribute_list = list(
		STAT_ENDURANCE = 3,
		STAT_SPEED = 1,
		/datum/attribute/skill/combat/polearms = 20,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/swords = 20,
		/datum/attribute/skill/combat/shields = 20,
		/datum/attribute/skill/combat/unarmed = 20, // Trash mobs, untrained.
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 20,
	)

/datum/outfit/job/human/species/human/northern/highwayman/pre_equip(mob/living/carbon/human/H)
	wrists = /obj/item/clothing/wrists/bracers/leather
	if(prob(50))
		mask = /obj/item/clothing/face/shepherd/rag
	armor = /obj/item/clothing/armor/leather
	shirt = /obj/item/clothing/shirt/undershirt/colored/vagrant
	if(prob(50))
		shirt = /obj/item/clothing/armor/gambeson/light
	pants = /obj/item/clothing/pants/trou/leather
	if(prob(50))
		head = /obj/item/clothing/head/helmet/leather
	if(prob(30))
		head = /obj/item/clothing/head/helmet/leather/volfhelm
	if(prob(50))
		neck = /obj/item/clothing/neck/coif
	gloves = /obj/item/clothing/gloves/leather
	H.attributes?.add_sheet(/datum/attribute_holder/sheet/job/npc/highwayman)
	if(prob(50))
		r_hand = /obj/item/weapon/sword/short/iron
	else
		r_hand = /obj/item/weapon/mace/cudgel
	if(prob(20))
		r_hand = /obj/item/weapon/sword/scimitar/falchion
	if(prob(20))
		r_hand = /obj/item/weapon/pick
	if(prob(25))
		l_hand = /obj/item/weapon/shield/wood
	if(prob(10))
		l_hand = /obj/item/weapon/shield/tower/buckleriron
	shoes = /obj/item/clothing/shoes/boots/leather
	if(prob(30))
		neck = /obj/item/clothing/neck/leathercollar
	H.set_eye_color("#27becc","#27becc")
	H.set_hair_color("#61310f")
	H.set_facial_hair_color(H.get_hair_color())
	if(H.gender == FEMALE)
		H.set_hair_style(/datum/sprite_accessory/hair/head/messy)
	else
		H.set_hair_style(/datum/sprite_accessory/hair/head/messy)
		H.set_facial_hair_style(/datum/sprite_accessory/hair/facial/manly)
