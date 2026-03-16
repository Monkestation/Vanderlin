/*
*	based on pages from elden ring in terms of visual design, these guys are intended to be a speedbump to solo adventurers at mount decap
*	deadly but small in numbers. come back with a party, chump
*/

/mob/living/carbon/human/species/human/northern/mad_touched_treasure_hunter
	ai_controller = /datum/ai_controller/human_npc
	faction = list("viking", "station")
	ambushable = FALSE
	dodgetime = 15
	flee_in_pain = FALSE

/mob/living/carbon/human/species/human/northern/mad_touched_treasure_hunter/ambush
	wander = TRUE

/mob/living/carbon/human/species/human/northern/mad_touched_treasure_hunter/Initialize()
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)
	set_species(/datum/species/human/northern)
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)

/mob/living/carbon/human/species/human/northern/mad_touched_treasure_hunter/after_creation()
	..()
	job = "Mad-touched Treasure Hunter"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_DISFIGURED, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/job/human/species/human/northern/mad_touched_treasure_hunter)
	var/obj/item/organ/eyes/organ_eyes = getorgan(/obj/item/organ/eyes)
	if(organ_eyes)
		organ_eyes.eye_color = pick("27becc", "35cc27", "000000")
	update_body()
	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
	head.sellprice = 40

/datum/attribute_holder/sheet/job/npc/mad_touched_treasure_hunter
	raw_attribute_list = list(
		STAT_STRENGTH = 5,
		STAT_SPEED = 5,
		STAT_CONSTITUTION = 5,
		STAT_ENDURANCE = 5,
		STAT_PERCEPTION = 5,
		STAT_INTELLIGENCE = 2,
		/datum/attribute/skill/combat/polearms = 40,
		/datum/attribute/skill/combat/axesmaces = 40,
		/datum/attribute/skill/combat/swords = 40,
		/datum/attribute/skill/combat/knives = 40,
		/datum/attribute/skill/combat/shields = 40,
		/datum/attribute/skill/combat/unarmed = 40,
		/datum/attribute/skill/combat/wrestling = 40,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 20,
	)

/datum/outfit/job/human/species/human/northern/mad_touched_treasure_hunter/pre_equip(mob/living/carbon/human/H)
	wrists = /obj/item/clothing/wrists/bracers
	mask = /obj/item/clothing/face/facemask/steel/mad_touched
	armor = /obj/item/clothing/armor/leather/heavy
	shirt = /obj/item/clothing/armor/gambeson
	if(prob(20))
		shirt = /obj/item/clothing/armor/gambeson/light
	pants = /obj/item/clothing/pants/platelegs
	belt = /obj/item/storage/belt/leather
	if(prob(33))
		beltl = /obj/item/reagent_containers/glass/bottle/healthpot
	head = /obj/item/clothing/head/menacing/mad_touched_treasure_hunter
	neck = /obj/item/clothing/neck/chaincoif
	gloves = /obj/item/clothing/gloves/plate
	cloak = /obj/item/clothing/cloak/wickercloak
	if(prob(33))
		r_hand = /obj/item/weapon/sword/long/greatsword
	else if(prob(33))
		r_hand = /obj/item/weapon/shield/tower/buckleriron
		l_hand = /obj/item/weapon/knife/dagger/steel/dirk
	else
		r_hand = /obj/item/weapon/sword/sabre/hook
		l_hand = /obj/item/weapon/sword/sabre/hook

	shoes = /obj/item/clothing/shoes/boots/leather
	//carbon ai is still pretty dumb so making them a threat to players requires pretty crazy looking stats. don't think too hard about it.

	H.set_eye_color("#27becc","#27becc")
	H.set_hair_color("#61310f")
	H.set_facial_hair_color(H.get_hair_color())
	if(H.gender == FEMALE)
		H.set_hair_style(/datum/sprite_accessory/hair/head/messy)
	else
		H.set_hair_style(/datum/sprite_accessory/hair/head/messy)
		H.set_facial_hair_style(/datum/sprite_accessory/hair/facial/manly)

	H.attributes?.add_sheet(/datum/attribute_holder/sheet/job/npc/mad_touched_treasure_hunter)
	H.real_name = pick(file2list("strings/rt/names/human/mad_touched_names.txt"))

/obj/item/clothing/head/menacing/mad_touched_treasure_hunter //its here so it doesnt wind up on some class' loadout.
	name = "sack hood"
	desc = "A ragged hood of thick jute fibres. The itchiness is unbearable."
	sewrepair = TRUE
	color = "#999999"
	armor = ARMOR_LEATHER

/obj/item/clothing/face/facemask/steel/mad_touched
	name = "eerie ancient mask"

/obj/item/clothing/face/facemask/steel/mad_touched/equipped(mob/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_MASK)
		ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)
		var/mob/living/carbon/human/mad_touched = user
		mad_touched.apply_damage(25, BRUTE, BODY_ZONE_HEAD)

/obj/item/clothing/face/facemask/steel/mad_touched/dropped(mob/user)
	. = ..()
	REMOVE_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)
