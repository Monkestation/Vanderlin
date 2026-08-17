/datum/wound/slash/disembowel
	name = "disembowelment"
	check_name = "<span class='userdanger'><B>GUTS</B></span>"
	severity = WOUND_SEVERITY_FATAL
	crit_message = list(
		"%VICTIM spills %P_THEIR organs!",
		"%VICTIM spills %P_THEIR entrails!",
	)
	sound_effect = 'sound/combat/crit2.ogg'
	whp = 100
	sewn_whp = 35
	bleed_rate = 15
	sewn_bleed_rate = 0.8
	clotting_rate = 0.02
	sewn_clotting_rate = 0.02
	clotting_threshold = 10
	sewn_clotting_threshold = 0.5
	woundpain = 50
	sewn_woundpain = 20
	sew_threshold = 150 //absolutely awful to sew up
	critical = TRUE
	associated_bclasses = ARTERY_BCLASSES
	viable_zones = list(BODY_ZONE_PRECISE_STOMACH)
	min_damage_dividend = 0
	strong_intent_bonus = TRUE
	aimed_intent_bonus = TRUE
	/// Organs we can disembowel associated with chance to disembowel
	var/static/list/affected_organs = list(
		ORGAN_SLOT_STOMACH = 100,
		ORGAN_SLOT_LIVER = 50,
	)

/datum/wound/slash/disembowel/can_stack_with(datum/wound/other)
	if(istype(other, /datum/wound/slash/disembowel) && (type == other.type))
		return FALSE
	return TRUE

/datum/wound/slash/disembowel/can_apply_to_bodypart(obj/item/bodypart/new_limb)
	if(HAS_TRAIT(new_limb.owner, TRAIT_CRITICAL_RESISTANCE))
		return FALSE
	. = ..()
	if(!.)
		return FALSE
	var/gaping_wound = FALSE
	for(var/datum/wound/other_wound as anything in new_limb.wounds)
		if(other_wound.bleed_rate && (other_wound.whp >= 30))
			gaping_wound = TRUE
			break
	var/gaping_injury = FALSE
	for(var/datum/injury/injury as anything in new_limb.injuries)
		if(!(injury.damage_type & WOUND_SLASH))
			continue
		if(injury.damage_per_injury() >= 30)
			gaping_wound = TRUE
			break
	if(!gaping_wound && !gaping_injury)
		return FALSE
	return TRUE

/datum/wound/slash/disembowel/on_mob_gain(mob/living/affected)
	. = ..()
	affected.emote("paincrit", TRUE)
	affected.Slowdown(20)
	shake_camera(affected, 2, 2)

/datum/wound/slash/disembowel/on_bodypart_gain(obj/item/bodypart/affected)
	. = ..()

	var/mob/living/carbon/gutted = affected.owner
	if(gutted)
		gutted.emote("painscream")

	var/atom/drop_location = gutted.drop_location()
	for(var/atom/movable/movable as anything in affected)
		if(gutted)
			movable.add_mob_blood(gutted)

		if(!isorgan(movable))
			movable.forceMove(drop_location)
			movable.screen_loc = null // organ storage
			continue

		var/obj/item/organ/organ = movable
		if(!(organ.slot in affected_organs))
			continue

		organ.Remove(owner)
		organ.forceMove(get_turf(drop_location))
		organ.scar_organ(30, 60)
		organ.screen_loc = null // organ storage
