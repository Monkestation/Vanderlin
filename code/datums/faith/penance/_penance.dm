GLOBAL_LIST_EMPTY(active_penances) // List of all active penances

/datum/stress_event/penance_completed
	stress_change = -3
	desc = span_green("I have completed my penance and been absolved!")
	timer = 15 MINUTES

/datum/stress_event/penance_failed
	stress_change = 5
	desc = span_red("I have failed my penance...")
	timer = 30 MINUTES

/datum/stress_event/penance_assigned
	stress_change = 2
	desc = span_warning("I have been assigned a penance for my transgressions.")
	timer = 10 MINUTES

/datum/penance
	var/name = "Penance"
	var/desc = "A task of atonement"
	var/mob/living/carbon/human/penitent
	var/mob/living/carbon/human/priest
	var/datum/patron/patron
	var/completion_message = "You have been absolved of your penance."
	var/failure_message = "You have failed your penance."

	/// Signal to track for progress
	var/signal_type
	var/required_count = 1
	var/current_count = 0
	var/time_limit = 0 // 0 = no limit
	var/assigned_time = 0

	/// Rewards/Punishments
	var/devotion_reward = 50
	var/progression_reward = 30

/datum/penance/New(mob/living/carbon/human/target, mob/living/carbon/human/assigner)
	. = ..()
	penitent = target
	priest = assigner
	patron = target.patron
	assigned_time = world.time

	// Register signal if applicable
	if(signal_type)
		RegisterSignal(penitent, signal_type, PROC_REF(on_signal_progress))

	to_chat(penitent, span_danger("You have been assigned a penance by [priest]: [name]"))
	to_chat(penitent, span_notice("[desc]"))
	to_chat(penitent, span_notice("Progress: [current_count]/[required_count]"))

	add_verb(target, list(/mob/living/carbon/human/proc/check_penance_verb))

/datum/penance/Destroy()
	if(signal_type && penitent)
		UnregisterSignal(penitent, signal_type)
	penitent = null
	priest = null
	return ..()

/datum/penance/proc/on_signal_progress(datum/source, ...)
	progress(1)

/datum/penance/proc/check_completion()
	if(current_count >= required_count)
		complete()
		return TRUE

	if(time_limit && world.time > assigned_time + time_limit)
		fail()
		return TRUE

	return FALSE

/datum/penance/proc/progress(amount = 1)
	current_count += amount
	to_chat(penitent, span_notice("Penance progress: [current_count]/[required_count]"))

	// Notify priest of progress
	if(priest && current_count % 3 == 0) // Every 3 progress
		to_chat(priest, span_notice("[penitent] is making progress on their penance. ([current_count]/[required_count])"))

	check_completion()

/datum/penance/proc/complete()
	to_chat(penitent, span_boldnotice(completion_message))
	to_chat(priest, span_notice("[penitent] has completed their penance: [name]"))

	if(penitent.cleric)
		penitent.cleric.update_devotion(devotion_reward)
		penitent.cleric.update_progression(progression_reward)

	penitent.add_stress(/datum/stress_event/penance_completed)
	penitent.playsound_local(penitent, 'sound/misc/notice (2).ogg', 100, FALSE)

	if(signal_type)
		UnregisterSignal(penitent, signal_type)

	qdel(src)

/datum/penance/proc/fail()
	to_chat(penitent, span_danger(failure_message))
	to_chat(priest, span_danger("[penitent] has failed their penance: [name]"))

	penitent.add_stress(/datum/stress_event/penance_failed)

	if(signal_type)
		UnregisterSignal(penitent, signal_type)

	qdel(src)

/datum/penance/proc/absolve()
	to_chat(penitent, span_boldnotice("[priest] has absolved you of your penance."))
	to_chat(priest, span_notice("You absolve [penitent] of their penance."))

	if(penitent.cleric)
		penitent.cleric.update_devotion(devotion_reward / 2)

	if(signal_type)
		UnregisterSignal(penitent, signal_type)

	qdel(src)

/mob/living/carbon/human/proc/assign_penance_verb()
	set name = "Assign Penance"
	set category = "RoleUnique.Divine"

	var/list/targets = list()
	for(var/mob/living/carbon/human/H in view(7, src))
		if(H != src)
			targets += H

	if(!length(targets))
		to_chat(src, span_warning("No valid penitents nearby."))
		return

	var/mob/living/carbon/human/target = input(src, "Who shall receive penance?") as null|anything in targets
	if(!target)
		return

	var/list/penance_types = list(
		"Prayers of Atonement" = /datum/penance/prayer,
		"Charitable Donation" = /datum/penance/donation,
		"Healing the Sick" = /datum/penance/healing,
		"Trial by Combat" = /datum/penance/combat,
	)

	var/choice = input(src, "What penance shall they perform?") as null|anything in penance_types
	if(!choice)
		return

	var/penance_path = penance_types[choice]
	if(assign_penance_to(target, penance_path, src))
		to_chat(src, span_notice("You assign [choice] to [target]."))
		visible_message(span_warning("[src] pronounces penance upon [target]!"))

/mob/living/carbon/human/proc/absolve_penance_verb()
	set name = "Absolve Penance"
	set category = "RoleUnique.Divine"

	var/list/penitents = list()
	for(var/mob/living/carbon/human/H in view(7, src))
		if(H != src && has_penance(H))
			penitents += H

	if(!length(penitents))
		to_chat(src, span_warning("No penitents nearby."))
		return

	var/mob/living/carbon/human/target = input(src, "Who shall be absolved?") as null|anything in penitents
	if(!target)
		return

	var/datum/penance/P = get_penance(target)
	if(!P)
		return

	visible_message(span_notice("[src] absolves [target] of their penance."))
	P.absolve()

/mob/living/carbon/human/proc/check_penance_verb()
	set name = "Check Penance"
	set category = "RoleUnique.Divine"

	var/datum/penance/P = get_penance(src)
	if(!P)
		to_chat(src, span_notice("You have no active penance."))
		return

	to_chat(src, span_boldnotice("Current Penance: [P.name]"))
	to_chat(src, span_notice("[P.desc]"))
	to_chat(src, span_notice("Progress: [P.current_count]/[P.required_count]"))
	if(P.time_limit)
		var/time_remaining = (P.assigned_time + P.time_limit - world.time) / 10
		to_chat(src, span_warning("Time remaining: [round(time_remaining / 60)] minutes"))

/// Get active penance for a mob
/proc/get_penance(mob/living/carbon/human/target)
	for(var/datum/penance/P in GLOB.active_penances)
		if(P.penitent == target)
			return P
	return null

/// Check if a mob has an active penance
/proc/has_penance(mob/living/carbon/human/target)
	return get_penance(target) != null

/// Assign penance to any mob (doesn't need devotion datum)
/proc/assign_penance_to(mob/living/carbon/human/target, datum/penance/penance_type, mob/living/carbon/human/assigner)
	// Check if they already have a penance
	if(has_penance(target))
		to_chat(assigner, span_warning("[target] already has an active penance."))
		return FALSE

	// Create the penance
	new penance_type(target, assigner)
	return TRUE
