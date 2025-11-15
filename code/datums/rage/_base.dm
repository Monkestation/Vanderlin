/datum/rage
	var/mob/living/carbon/human/holder_mob = null
	var/mob/living/carbon/human/secondary_mob = null ///this is a shitcode follower for transformations so that ww's can acccess hud updates

	var/rage = 0
	var/max_rage = 100

	/// Base rage gain multiplier from stress
	var/stress_rage_multiplier = 0.1
	/// How much rage decays per process call
	var/rage_decay_rate = 0.5

	/// Rage threshold tiers for dynamic abilities
	var/list/rage_thresholds = list(
		RAGE_LEVEL_LOW = list(),
		RAGE_LEVEL_MEDIUM = list(),
		RAGE_LEVEL_HIGH = list(),
		RAGE_LEVEL_CRITICAL = list(),
	)
	/// Currently active tier
	var/current_tier = 0
	/// List of abilities currently granted
	var/list/active_abilities = list()
	/// List of extra abilities to add unconditionally
	var/list/abilities_extra = list()
	/// Traits added by this
	var/list/traits = list()
	var/rage_color = "#A41C1C"

/datum/rage/Destroy(force)
	remove()
	return ..()

/datum/rage/proc/on_life()
	if(holder_mob.stat >= DEAD)
		return

	// Decay rage over time
	if(rage > 0)
		update_rage(-rage_decay_rate)

	// Check if we need to update tier
	check_rage_tier()

/datum/rage/proc/grant_to(mob/living/carbon/human/holder)
	if(!holder)
		return

	RegisterSignal(holder, COMSIG_HUMAN_LIFE, PROC_REF(on_life))
	holder_mob = holder
	holder_mob.rage_datum = src
	holder_mob?.hud_used?.initialize_bloodpool()
	holder_mob?.hud_used?.bloodpool.set_fill_color(rage_color)
	for(var/trait as anything in traits)
		ADD_TRAIT(holder_mob, trait, RAGE_TRAIT)
	for(var/datum/action/ability as anything in abilities_extra)
		grant_ability(ability, permanent = TRUE)

	RegisterSignal(holder_mob, COMSIG_MOB_ADD_STRESS, PROC_REF(on_stress_added))
	holder_mob.AddElement(/datum/element/relay_attackers)
	RegisterSignal(holder_mob, COMSIG_ATOM_WAS_ATTACKED, PROC_REF(rage))

	update_hud()

/datum/rage/proc/grant_to_secondary(mob/living/carbon/human/holder)
	if(!holder)
		return

	secondary_mob = holder
	secondary_mob.rage_datum = src
	secondary_mob?.hud_used?.initialize_bloodpool()
	secondary_mob?.hud_used?.bloodpool.set_fill_color(rage_color)

	RegisterSignal(secondary_mob, COMSIG_MOB_ADD_STRESS, PROC_REF(on_stress_added))
	secondary_mob.AddElement(/datum/element/relay_attackers)
	RegisterSignal(secondary_mob, COMSIG_ATOM_WAS_ATTACKED, PROC_REF(rage))

	update_hud()

/datum/rage/proc/remove_secondary()
	if(secondary_mob)
		UnregisterSignal(secondary_mob, COMSIG_MOB_ADD_STRESS)
		UnregisterSignal(secondary_mob, COMSIG_ATOM_WAS_ATTACKED)
		secondary_mob.rage_datum = null
		secondary_mob.RemoveElement(/datum/element/relay_attackers)

/datum/rage/proc/remove()
	if(holder_mob)
		UnregisterSignal(holder_mob, COMSIG_MOB_ADD_STRESS)
		holder_mob.rage_datum = null
		for(var/datum/action/ability as anything in active_abilities)
			holder_mob.remove_spell(ability)
		active_abilities.Cut()
		holder_mob.remove_spells(source = src)
		for(var/trait as anything in traits)
			REMOVE_TRAIT(holder_mob, trait, RAGE_TRAIT)
	holder_mob = null

/datum/rage/proc/grant_ability(datum/action/ability, permanent = FALSE)
	if(!ability)
		return
	holder_mob.add_spell(ability, source = src)
	if(!permanent)
		active_abilities += ability

/datum/rage/proc/remove_ability(datum/action/ability)
	if(!ability)
		return
	holder_mob.remove_spell(ability)
	active_abilities -= ability

/datum/rage/proc/on_stress_added(datum/source, datum/stress_event/new_stress)
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

	// Visual feedback based on stress and rage levels
	if(total_stress >= 10 && rage >= RAGE_LEVEL_MEDIUM)
		to_chat(holder_mob, span_danger("My rage builds as stress overwhelms me!"))


/datum/rage/proc/update_rage(amount)
	var/old_rage = rage
	if(holder_mob.stat == DEAD) return
	rage = clamp(rage + amount, 0, max_rage)

	update_hud()

	if(old_rage != rage)
		SEND_SIGNAL(holder_mob, COMSIG_LIVING_RAGE_CHANGED, amount)
		check_rage_tier()
		if(rage <= 0)
			SEND_SIGNAL(holder_mob, COMSIG_RAGE_BOTTOMED)
	if(rage == max_rage)
		SEND_SIGNAL(holder_mob, COMSIG_RAGE_OVERRAGE)

/datum/rage/proc/update_hud()
	holder_mob?.hud_used?.bloodpool?.name = "Rage: [round(rage, 0.1)]"
	holder_mob?.hud_used?.bloodpool?.desc = "Rage: [round(rage, 0.1)]/[max_rage]"
	if(rage <= 0)
		holder_mob?.hud_used?.bloodpool?.set_value(0, 1 SECONDS)
	else
		holder_mob?.hud_used?.bloodpool?.set_value((100 / (max_rage / rage)) / 100, 1 SECONDS)

	if(secondary_mob)
		secondary_mob?.hud_used?.bloodpool?.name = "Rage: [round(rage, 0.1)]"
		secondary_mob?.hud_used?.bloodpool?.desc = "Rage: [round(rage, 0.1)]/[max_rage]"
		if(rage <= 0)
			secondary_mob?.hud_used?.bloodpool?.set_value(0, 1 SECONDS)
		else
			secondary_mob?.hud_used?.bloodpool?.set_value((100 / (max_rage / rage)) / 100, 1 SECONDS)

/datum/rage/proc/check_rage(required)
	return rage >= abs(required)

/datum/rage/proc/check_rage_tier()
	var/new_tier = 0

	// Find highest threshold we've crossed
	for(var/threshold in rage_thresholds)
		if(rage >= text2num(threshold))
			new_tier = text2num(threshold)

	// If tier changed, update abilities
	if(new_tier != current_tier)
		var/old_tier = current_tier
		current_tier = new_tier

		// Remove old tier abilities
		if(old_tier && rage_thresholds["[old_tier]"])
			var/list/old_abilities = rage_thresholds["[old_tier]"]
			if(!islist(old_abilities))
				old_abilities = list(old_abilities)
			for(var/ability in old_abilities)
				remove_ability(ability)

		// Grant new tier abilities
		if(new_tier && rage_thresholds["[new_tier]"])
			var/list/new_abilities = rage_thresholds["[new_tier]"]
			if(!islist(new_abilities))
				new_abilities = list(new_abilities)
			for(var/ability in new_abilities)
				grant_ability(ability, permanent = FALSE)

			// Notify player of tier change
			switch(new_tier)
				if(RAGE_LEVEL_LOW)
					to_chat(holder_mob, span_warning("My rage begins to build..."))
				if(RAGE_LEVEL_MEDIUM)
					to_chat(holder_mob, span_boldwarning("My rage intensifies!"))
				if(RAGE_LEVEL_HIGH)
					to_chat(holder_mob, span_userdanger("My rage reaches dangerous levels!"))
				if(RAGE_LEVEL_CRITICAL)
					to_chat(holder_mob, span_userdanger("I am consumed by RAGE!"))
		else if(old_tier > 0)
			to_chat(holder_mob, span_notice("My rage subsides..."))

/datum/rage/proc/suppress_rage()
	rage = 0
	update_hud()
	check_rage_tier()
	to_chat(holder_mob, span_userdanger("My rage has been completely suppressed!"))

/datum/rage/proc/unleash_rage()
	rage = max_rage
	update_hud()
	check_rage_tier()
	to_chat(holder_mob, span_boldwarning("My rage has been unleashed to its full potential!"))

/datum/rage/proc/rage(mob/living/attacked, mob/living/carbon/human/attacker, damage)
	var/base_rage = damage ? damage : 5
	var/stress_multi = 1
	if(stress_rage_multiplier > stress_multi)
		stress_multi = stress_rage_multiplier

	update_rage(base_rage * stress_multi)

