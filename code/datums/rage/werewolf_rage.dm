
/datum/rage/werewolf
	max_rage = 150
	rage_change_on_life = -0.5
	/// Base rage gain multiplier from stress
	var/stress_rage_multiplier = 0.1
	rage_thresholds = list(
		WW_RAGE_LOW = list(),
		WW_RAGE_MEDIUM = list(),
		WW_RAGE_HIGH = list(),
		WW_RAGE_CRITICAL = list(),
	)

/datum/rage/werewolf/grant_to_holder(mob/living/carbon/human/holder)
	. = ..()
	if(!.)
		return

	RegisterSignal(holder_mob, COMSIG_MOB_ADD_STRESS, PROC_REF(on_stress_added))
	holder_mob.AddElement(/datum/element/relay_attackers)
	RegisterSignal(holder_mob, COMSIG_ATOM_WAS_ATTACKED, PROC_REF(upon_attacked))

/datum/rage/werewolf/remove_holder()
	holder_mob?.RemoveElement(/datum/element/relay_attackers)
	UnregisterSignal(holder_mob, list(COMSIG_MOB_ADD_STRESS, COMSIG_ATOM_WAS_ATTACKED))
	. = ..()

/datum/rage/werewolf/grant_to_secondary(mob/living/carbon/human/secondary)
	. = ..()
	if(!.)
		return

	RegisterSignal(secondary_mob, COMSIG_MOB_ADD_STRESS, PROC_REF(on_stress_added))
	secondary.AddElement(/datum/element/relay_attackers)
	RegisterSignal(secondary_mob, COMSIG_ATOM_WAS_ATTACKED, PROC_REF(upon_attacked))

/datum/rage/werewolf/remove_secondary()
	secondary_mob?.RemoveElement(/datum/element/relay_attackers)
	UnregisterSignal(secondary_mob, list(COMSIG_MOB_ADD_STRESS, COMSIG_ATOM_WAS_ATTACKED))
	. = ..()

/datum/rage/werewolf/update_rage(amount)
	if(amount > 0)
		var/mob/active_mob = secondary_mob || holder_mob
		if(active_mob?.has_status_effect(/datum/status_effect/debuff/silver_bane))
			amount *= 0.25
	. = ..(amount)

/datum/rage/werewolf/upon_tier_change(new_rage_tier, old_rage_tier)
	. = ..()
	var/active_mob = secondary_mob || holder_mob
	if(new_rage_tier && rage_thresholds["[new_rage_tier]"])
		// Notify player of tier change
		switch("[new_rage_tier]")
			if(WW_RAGE_LOW)
				to_chat(active_mob, span_notice("My rage begins to build..."))
			if(WW_RAGE_MEDIUM)
				to_chat(active_mob, span_notice("<span class='red'>My rage intensifies!</span>"))
			if(WW_RAGE_HIGH)
				to_chat(active_mob, span_notice("<span class='red'>My rage reaches dangerous levels!</span>"))
			if(WW_RAGE_CRITICAL)
				to_chat(active_mob, span_notice("<span class='red'>I am consumed by RAGE!</span>"))
	else if(old_rage_tier > 0)
		to_chat(active_mob, span_notice("My rage subsides..."))

// Stress multiplier only affects the untransformed human holder_mob
/datum/rage/werewolf/proc/on_stress_added(datum/source, datum/stress_event/new_stress)
	SIGNAL_HANDLER

	if(!holder_mob || holder_mob.stat >= DEAD)
		return

	var/new_stress_amount = new_stress.stress_change
	// Calculate rage gain based on total stress - global multiplier
	// At 0 stress: 1x multiplier, at 5 stress: 1.33x, at 10 stress: 1.67x, at 15 stress: 2x
	// Negative stress reduces rage gain
	var/total_stress = holder_mob.get_stress_amount()
	var/stress_multiplier = 1 + (total_stress / 15)
	var/rage_gain = new_stress_amount * stress_rage_multiplier * stress_multiplier

	update_rage(rage_gain)

/datum/rage/werewolf/proc/upon_attacked(mob/living/attacked, mob/living/carbon/human/attacker, damage)
	SIGNAL_HANDLER

	var/base_rage = max(1, damage / 2)
	var/rage_multiplier = max(stress_rage_multiplier, 1)

	update_rage(base_rage * rage_multiplier)
