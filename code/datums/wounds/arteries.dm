/datum/wound/artery
	name = "Torn Artery"
	sound_effect = list('sound/gore/artery1.ogg', \
						'sound/gore/artery2.ogg', \
						'sound/gore/artery3.ogg')
	severity = WOUND_SEVERITY_SEVERE
	critical = TRUE
	associated_bclasses = ARTERY_BCLASSES
	min_damage = 5
	min_damage_dividend = 0
	strong_intent_bonus = TRUE
	aimed_intent_bonus = TRUE
	crit_message = list(
		"Blood sprays from %VICTIM's %BODYPART!",
		"Blood rushes from %VICTIM's %BODYPART!",
		"Blood bursts from %VICTIM's %BODYPART with a great force!",
	)
	var/artery_type_override
	var/list/artery_type_blacklist = list(ARTERY_HEART, ARTERY_NECK)
	viable_zones = list(\
		BODY_ZONE_R_ARM, \
		BODY_ZONE_R_LEG, \
		BODY_ZONE_PRECISE_MOUTH, \
		BODY_ZONE_L_LEG, \
		BODY_ZONE_L_ARM, \
		BODY_ZONE_PRECISE_STOMACH, BODY_ZONE_PRECISE_GROIN, \
		BODY_ZONE_CHEST, \
		BODY_ZONE_HEAD)
	required_bodypart_status = BODYPART_ORGANIC

/datum/wound/artery/can_apply_to_bodypart(obj/item/bodypart/affected, zone_precise, bclass)
	if(!affected.get_cut(ignore_gauze = TRUE))
		return FALSE
	return ..()

/datum/wound/artery/can_stack_with(datum/wound/other)
	if(istype(other, /datum/wound/artery) && (type == other.type))
		return FALSE
	return TRUE

/datum/wound/artery/apply_to_bodypart(obj/item/bodypart/affected, silent, crit_message)
	var/obj/item/organ/artery/artery
	for(var/obj/item/organ/possible_artery in shuffle(affected.getorganslotlist(ORGAN_SLOT_ARTERY)))
		if(!possible_artery)
			continue
		if(possible_artery.damage >= possible_artery?.maxHealth)
			continue
		if(artery_type_override && !istype(possible_artery, artery_type_override))
			continue
		if(artery_type_blacklist && (possible_artery.type in artery_type_blacklist))
			continue
		artery = possible_artery
		break
	if(!artery)
		qdel(src)
		return FALSE
	var/dissection = (severity >= WOUND_SEVERITY_CRITICAL) || ((artery?.maxHealth - artery?.damage) <= (artery?.maxHealth * artery?.tear_damage_multiplier))
	if(dissection)
		artery.dissect()
	else
		artery.tear()
	. = ..()
	affected.temporary_crit_paralysis(10 SECONDS)
	qdel(src)

/datum/wound/artery/neck_slice
	severity = WOUND_SEVERITY_CRITICAL
	artery_type_override = ARTERY_NECK
	artery_type_blacklist = list(ARTERY_HEAD)
	viable_zones = list(BODY_ZONE_PRECISE_NECK)
	show_in_book = FALSE
	crit_message = "Blood sprays from %VICTIM's throat!"

/datum/wound/artery/heart
	name = "Aortic Dissection"
	severity = WOUND_SEVERITY_FATAL
	artery_type_override = ARTERY_HEART
	artery_type_blacklist = list(ARTERY_CHEST)
	viable_zones = list(BODY_ZONE_CHEST)
	show_in_book = FALSE
	crit_message = "A fountain of blood erupts from %VICTIM!"

/datum/wound/artery/heart/can_apply_to_bodypart(obj/item/bodypart/affected, zone_precise, bclass)
	if(affected.limb_flags & BODYPART_BONE_ENCASED && !affected.has_wound(/datum/wound/fracture) && !(bclass in ARTERY_HEART_BCLASSES))
		return FALSE
	// Must be vitals zone
	if(affected.body_zone != BODY_ZONE_CHEST)
		return FALSE
	if(!affected.getorganslot(ORGAN_SLOT_HEART))
		return FALSE
	return ..()

