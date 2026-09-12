/datum/attribute_holder/sheet/job/goblin
	attribute_variance = list(
		STAT_STRENGTH = list(-4, 0),
		STAT_PERCEPTION = list(-5, 0),
		STAT_INTELLIGENCE = list(-9, -6),
		STAT_CONSTITUTION = list(-6, -2),
		STAT_ENDURANCE = list(-2, 2),
		STAT_SPEED = list(-2, 4),
	)
	raw_attribute_list = list(
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/polearms = 10,
		/datum/attribute/skill/combat/knives = 10,
		/datum/attribute/skill/combat/axesmaces = 10,
		/datum/attribute/skill/combat/swords = 10,
	)

/datum/species/goblin
	name = "goblin"
	id = SPEC_ID_GOBLIN
	species_traits = list(NO_UNDERWEAR)
	inherent_traits = list(TRAIT_RESISTCOLD,TRAIT_RADIMMUNE, TRAIT_EASYDISMEMBER, TRAIT_CRITICAL_WEAKNESS, TRAIT_NASTY_EATER, TRAIT_LEECHIMMUNE, TRAIT_INHUMENCAMP)

	no_equip = list(ITEM_SLOT_SHOES, ITEM_SLOT_PANTS, ITEM_SLOT_GLOVES, ITEM_SLOT_MASK)


	statsheet_male = /datum/attribute_holder/sheet/job/goblin

	dam_icon_f = null
	dam_icon_m = null
	damage_overlay_type = ""
	changesource_flags = WABBAJACK
	var/raceicon = "goblin"
	exotic_bloodtype = /datum/blood_type/human/corrupted/goblin
	meat = list(/obj/item/reagent_containers/food/snacks/meat/strange/inhumen = 1)

	custom_clothes = TRUE
	custom_id = SPEC_ID_DWARF

	offset_features_m = list(
		OFFSET_RING = list(0,-4),\
		OFFSET_GLOVES = list(0,0),\
		OFFSET_WRISTS = list(0,0),\
		OFFSET_HANDS = list(0,-4),\
		OFFSET_CLOAK = list(0,0),\
		OFFSET_FACEMASK = list(0,-5),\
		OFFSET_HEAD = list(0,-5),\
		OFFSET_FACE = list(0,-5),\
		OFFSET_BELT = list(0,0),\
		OFFSET_BACK = list(0,-5),\
		OFFSET_NECK = list(0,-5),\
		OFFSET_MOUTH = list(0,-5),\
		OFFSET_PANTS = list(0,0),\
		OFFSET_SHIRT = list(0,-3),\
		OFFSET_ARMOR = list(0,-3),\
		OFFSET_UNDIES = list(0,0)\
	)

	offset_features_f = list(
		OFFSET_RING = list(0,-4),\
		OFFSET_GLOVES = list(0,0),\
		OFFSET_WRISTS = list(0,0),\
		OFFSET_HANDS = list(0,-4),\
		OFFSET_CLOAK = list(0,0),\
		OFFSET_FACEMASK = list(0,-5),\
		OFFSET_HEAD = list(0,-5),\
		OFFSET_FACE = list(0,-5),\
		OFFSET_BELT = list(0,0),\
		OFFSET_BACK = list(0,-5),\
		OFFSET_NECK = list(0,-5),\
		OFFSET_MOUTH = list(0,-5),\
		OFFSET_PANTS = list(0,0),\
		OFFSET_SHIRT = list(0,-3),\
		OFFSET_ARMOR = list(0,-3),\
		OFFSET_UNDIES = list(0,0)\
	)
	id_override = SPEC_ID_GOBLIN

/datum/species/goblin/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	C.grant_language(/datum/language/hellspeak)

/datum/species/goblin/after_creation(mob/living/carbon/C)
	..()
	C.dna.species.accent_language = C.dna.species.get_accent(native_language, 1)
	C.grant_language(/datum/language/hellspeak)

/datum/species/goblin/on_species_loss(mob/living/carbon/C)
	. = ..()
	UnregisterSignal(C, COMSIG_MOB_SAY)
	C.remove_language(/datum/language/hellspeak)

/datum/species/goblin/regenerate_icons(mob/living/carbon/human/H)
	H.icon_state = ""
	if(HAS_TRAIT(H, TRAIT_NO_TRANSFORM))
		return 1
	H.update_inv_hands()
	H.update_inv_handcuffed()
	H.update_inv_legcuffed()
	H.update_fire()
	H.update_body()
	H.update_transform()
	return TRUE
