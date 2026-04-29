/datum/status_effect/buff/bone_ward
	id = "bone_ward"
	alert_type = /atom/movable/screen/alert/status_effect/buff/bone_ward
	duration = -1

/datum/status_effect/buff/bone_ward/on_apply()
	. = ..()
	var/mob/living/target = owner
	target.AddElement(/datum/element/relay_attackers)
	RegisterSignal(target, COMSIG_ATOM_WAS_ATTACKED, PROC_REF(upon_attacked))

/datum/status_effect/buff/bone_ward/on_remove()
	var/mob/living/target = owner
	target.RemoveElement(/datum/element/relay_attackers)
	UnregisterSignal(target, COMSIG_ATOM_WAS_ATTACKED)
	return ..()

/datum/status_effect/buff/bone_ward/proc/upon_attacked(mob/living/attacked, mob/living/carbon/human/attacker, damage)
	SIGNAL_HANDLER
	if(!attacker || !attacked)
		return FALSE
	if(attacked == attacker)
		return FALSE
	if(!ishuman(attacker) || !attacker.client)
		return FALSE
	if(HAS_TRAIT(attacker, TRAIT_ASSASSIN))
		return FALSE
	attacker.apply_status_effect(arglist(list(/datum/status_effect/debuff/bone_ward, 60 SECONDS, attacked)))
	return TRUE

// ##########################################################################################

/atom/movable/screen/alert/status_effect/buff/bone_ward
	name = "Bone Ward"
	desc = span_nicegreen("I am watched over.")
	icon_state = "bone_ward"

// ##########################################################################################
// ##########################################################################################
// ##########################################################################################

/datum/status_effect/debuff/bone_ward
	id = "bone_ward_r"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/bone_ward
	duration = 60 SECONDS
	var/mob/living/source_mob

/datum/status_effect/debuff/bone_ward/on_creation(mob/living/new_owner, duration_override, mob/living/origin_mob)
	if(!origin_mob)
		qdel(src)
		return FALSE
	source_mob = origin_mob
	return ..()

/datum/status_effect/debuff/bone_ward/on_apply()
	. = ..()
	RegisterSignal(source_mob, COMSIG_LIVING_DEATH, PROC_REF(on_source_death))

/datum/status_effect/debuff/bone_ward/on_remove()
	UnregisterSignal(source_mob, COMSIG_LIVING_DEATH)
	return ..()

/datum/status_effect/debuff/bone_ward/proc/on_source_death()
	var/mob/living/carbon/human/target = owner
	if(!ishuman(owner))
		return
	if(!target.get_quirk(/datum/quirk/vice/hunted))
		target.add_quirk(/datum/quirk/vice/hunted)
		var/datum/quirk/vice/hunted/quirk = target.get_quirk(/datum/quirk/vice/hunted)
		quirk.desc = "Your actions have made you a target. You will be hunted and have assassination attempts made against you without any escalation."
		quirk.customization_value = "Responsible for the death of someone protected with a Bone Ward."
		to_chat(target, span_warningbig("My actions did not go unnoticed, I am being hunted..."))

// ##########################################################################################

/atom/movable/screen/alert/status_effect/debuff/bone_ward
	name = "Bone Ward"
	desc = span_red("I have recently brought harm upon someone protected by a Bone Ward.")
	icon_state = "bone_ward_bad"
	alert_group = ALERT_DEBUFF
