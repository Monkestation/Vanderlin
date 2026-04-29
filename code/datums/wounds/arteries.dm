/datum/wound/artery
	name = "Torn Artery"
	sound_effect = list('sound/gore/artery1.ogg', \
						'sound/gore/artery2.ogg', \
						'sound/gore/artery3.ogg')
	severity = WOUND_SEVERITY_SEVERE
	critical = TRUE
	mortal = FALSE
	can_sew = TRUE
	can_cauterize = TRUE
	embed_chance = 0
	werewolf_infection_probability = 50
	sleep_healing = 0
	associated_bclasses = ARTERY_BCLASSES
	min_damage = 5
	min_damage_dividend = 0
	strong_intent_bonus = TRUE
	aimed_intent_bonus = TRUE
	var/artery_type_override

/datum/wound/artery/get_crit_prob(bclass, dam, damage_dividend, mob/living/user, obj/item/bodypart/affected, zone_precise, list/modifiers)
	if(affected.limb_flags & BODYPART_BONE_ENCASED && !affected.has_wound(/datum/wound/fracture))
		return 0
	return ..()

/datum/wound/artery/can_apply_to_bodypart(obj/item/bodypart/affected)
	. = ..()
	if(affected.status == BODYPART_ROBOTIC)
		return FALSE
	if(!affected.get_incision())
		return FALSE
	if(affected.limb_flags & BODYPART_BONE_ENCASED && !affected.has_wound(/datum/wound/fracture))
		return FALSE

/datum/wound/artery/can_stack_with(datum/wound/other)
	if(istype(other, /datum/wound/artery) && (type == other.type))
		return FALSE
	return TRUE

/datum/wound/artery/apply_to_bodypart(obj/item/bodypart/affected, silent, crit_message)
	. = ..()
	if(!.)
		return
	var/obj/item/organ/artery/artery
	for(var/obj/item/organ/possible_artery in shuffle(affected.getorganslotlist(ORGAN_SLOT_ARTERY)))
		if(!possible_artery)
			continue
		if(possible_artery.damage >= possible_artery.maxHealth)
			continue
		if(artery_type_override && !istype(possible_artery, artery_type_override))
			continue
		artery = possible_artery
		break
	var/dissection = (severity >= WOUND_SEVERITY_CRITICAL) || (artery?.damage >= (artery.maxHealth * 0.5))
	if(artery)
		if(dissection)
			artery.dissect()
		else
			artery.tear()
	qdel(src)

/datum/wound/artery/neck
	artery_type_override = /obj/item/organ/artery/neck
	can_roll = FALSE //snowflake used for neck slit

/datum/wound/artery/chest
	artery_type_override = /obj/item/organ/artery/chest
	associated_bclasses = ARTERY_HEART_BCLASSES
	viable_zones = list(BODY_ZONE_CHEST)

/datum/wound/artery/dissect
	severity = WOUND_SEVERITY_CRITICAL

/datum/wound/artery/dissect/neck
	artery_type_override = /obj/item/organ/artery/neck
	can_roll = FALSE //snowflake used for neck slit
