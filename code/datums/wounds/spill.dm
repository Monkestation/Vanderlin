/obj/effect/ebeam/gut
	name = "intestines"

/mob/living/carbon/proc/gut_cut()
	if(get_chem_effect(CE_PAINKILLER) < 100)
		emote("scream")
		CombatKnockdown(30)
		var/obj/item/bodypart/vitals = get_bodypart(BODY_ZONE_CHEST)
		vitals?.add_pain(25)

/datum/wound/spill
	name = "Spill"
	severity = WOUND_SEVERITY_CRITICAL
	abstract_type = /datum/wound/spill
	associated_bclasses = ARTERY_BCLASSES

/datum/wound/spill/gut
	name = "Gut Spill"
	viable_zones = list(BODY_ZONE_PRECISE_STOMACH)
	min_damage_dividend = 0
	strong_intent_bonus = TRUE
	aimed_intent_bonus = TRUE
	severity = WOUND_SEVERITY_CRITICAL
	disabling = TRUE

/datum/wound/spill/gut/can_apply_to_bodypart(obj/item/bodypart/new_limb)
	. = ..()
	if(!.)
		return FALSE
	// Must be vitals zone
	if(new_limb.body_zone != BODY_ZONE_CHEST)
		return FALSE
	if(!new_limb.getorganslot(ORGAN_SLOT_GUTS))
		return FALSE
	if(new_limb.spilled)
		return FALSE
	var/gaping_wound = FALSE
	for(var/datum/wound/other_wound as anything in new_limb.wounds)
		if(other_wound.bleed_rate && (other_wound.whp >= 30))
			gaping_wound = TRUE
			break
	var/gaping_injury = FALSE
	for(var/datum/injury/injury as anything in new_limb.injuries)
		if(injury.damage_type != WOUND_SLASH)
			continue
		if(injury.damage && (injury.damage >= 30))
			gaping_wound = TRUE
			break
	if(!gaping_wound && !gaping_injury)
		return FALSE
	return TRUE

/datum/wound/spill/gut/on_crit_applied(obj/item/bodypart/affected, mob/living/user, zone_precise, list/modifiers)
	affected.add_wound(/datum/wound/slash/disembowel)

/datum/wound/spill/gut/on_bodypart_gain(obj/item/bodypart/new_limb)
	. = ..()
	if(sound_effect)
		playsound(new_limb.owner, pick(sound_effect), 100, TRUE)
	new_limb.spilled = TRUE
	owner?.bleed(20)
	owner?.update_damage_overlays()
	var/list/intestines = new_limb.getorganslotlist(ORGAN_SLOT_GUTS)
	for(var/obj/item/organ/gut in intestines)
		gut.Remove(gut.owner)
		if(QDELETED(gut))
			continue
		gut.organ_flags |= ORGAN_CUT_AWAY
		gut.scar_organ(30, 60)
		var/turf/drop_location = owner.drop_location()
		if(istype(drop_location))
			gut.forceMove(owner.drop_location())
			owner.AddComponent(/datum/component/rope, gut, 'icons/effects/beam.dmi', "gut_beam2", 3, TRUE, /obj/effect/ebeam/gut, CALLBACK(owner, /mob/living/carbon/proc/gut_cut))
		else
			qdel(gut)
	qdel(src)
