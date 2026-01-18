/datum/rage
	/// The main mob that determines when on_life() ticks.
	var/mob/living/carbon/human/holder_mob = null
	/// This is a shitcode follower so transformed states can acccess hud updates.
	var/mob/living/carbon/human/secondary_mob = null

	var/rage = 0
	var/max_rage = 100

	/// How much rage changes per process call
	var/rage_change_on_life = 0

	/// Rage threshold tiers for dynamic abilities. Should be a typecache list where keys are strings of the threshold value.
	var/list/rage_thresholds = list()
	/// Currently active tier
	var/current_tier = 0
	/// List of abilities currently granted to the holder mob.
	var/list/datum/action/active_abilities = list()
	/// List of extra abilities to add regardless of rage level to the holder mob.
	var/list/datum/action/abilities_extra = list()
	/// Traits granted to the holder mob.
	var/list/traits = list()
	/// Color used by rage meter for the HUD.
	var/rage_color = "#ff0e0e"

/datum/rage/Destroy(force)
	remove_secondary()
	remove_holder()
	return ..()

/datum/rage/proc/on_life(datum/source)
	SIGNAL_HANDLER

	if(holder_mob.stat >= DEAD)
		return

	update_rage(rage_change_on_life)

/datum/rage/proc/grant_to_holder(mob/living/carbon/human/holder)
	if(!ishuman(holder))
		return FALSE

	holder_mob = holder
	RegisterSignal(holder_mob, COMSIG_HUMAN_LIFE, PROC_REF(on_life))
	RegisterSignal(holder_mob, COMSIG_PARENT_QDELETING, PROC_REF(remove_holder))
	holder_mob.rage_datum = src

	for(var/trait as anything in traits)
		ADD_TRAIT(holder_mob, trait, RAGE_TRAIT)
	for(var/datum/action/ability as anything in abilities_extra)
		grant_ability(ability, permanent = TRUE)

	holder_mob.hud_used?.initialize_bloodpool()
	holder_mob.hud_used?.bloodpool.set_fill_color(rage_color)
	update_hud()

	return TRUE

/// holder_mob is nulled at the end. As rage depends on holder_mob life ticks, you probably shouldn't call this unless the datum is being deleted or transfered.
/datum/rage/proc/remove_holder()
	if(holder_mob)
		UnregisterSignal(holder_mob, list(COMSIG_HUMAN_LIFE, COMSIG_PARENT_QDELETING))
		holder_mob.rage_datum = null
		holder_mob.hud_used?.shutdown_bloodpool()
		for(var/datum/action/ability as anything in active_abilities)
			holder_mob.remove_spell(ability)
		active_abilities.Cut()
		holder_mob.remove_spells(source = src)
		for(var/trait as anything in traits)
			REMOVE_TRAIT(holder_mob, trait, RAGE_TRAIT)
	holder_mob = null

/datum/rage/proc/grant_to_secondary(mob/living/carbon/human/secondary)
	if(!ishuman(secondary))
		return FALSE

	secondary_mob = secondary
	RegisterSignal(secondary_mob, COMSIG_PARENT_QDELETING, PROC_REF(remove_secondary))
	secondary_mob.rage_datum = src

	secondary_mob.hud_used?.initialize_bloodpool()
	secondary_mob.hud_used?.bloodpool.set_fill_color(rage_color)
	update_hud()

	return TRUE

/datum/rage/proc/remove_secondary()
	if(secondary_mob)
		UnregisterSignal(secondary_mob, COMSIG_PARENT_QDELETING)
		secondary_mob.rage_datum = null
		secondary_mob.hud_used?.shutdown_bloodpool()
	secondary_mob = null

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

/datum/rage/proc/update_rage(amount)
	if(!amount) return

	var/old_rage = rage
	rage = clamp(rage + amount, 0, max_rage)

	update_hud()
	if(old_rage != rage)
		check_rage_tier()
		SEND_SIGNAL(holder_mob, COMSIG_RAGE_CHANGED, amount)
		if(secondary_mob)
			SEND_SIGNAL(secondary_mob, COMSIG_RAGE_CHANGED, amount)

		if(rage <= 0)
			SEND_SIGNAL(holder_mob, COMSIG_RAGE_BOTTOMED)
		else if(rage >= max_rage)
			SEND_SIGNAL(holder_mob, COMSIG_RAGE_OVERRAGE)

/datum/rage/proc/update_hud()
	if(holder_mob)
		holder_mob.hud_used?.bloodpool?.name = "Rage: [round(rage, 0.1)]"
		holder_mob.hud_used?.bloodpool?.desc = "Rage: [round(rage, 0.1)]/[max_rage]"
		if(rage <= 0)
			holder_mob.hud_used?.bloodpool?.set_value(0, 1 SECONDS)
		else
			holder_mob.hud_used?.bloodpool?.set_value((100 / (max_rage / rage)) / 100, 1 SECONDS)

	if(secondary_mob)
		secondary_mob.hud_used?.bloodpool?.name = "Rage: [round(rage, 0.1)]"
		secondary_mob.hud_used?.bloodpool?.desc = "Rage: [round(rage, 0.1)]/[max_rage]"
		if(rage <= 0)
			secondary_mob.hud_used?.bloodpool?.set_value(0, 1 SECONDS)
		else
			secondary_mob.hud_used?.bloodpool?.set_value((100 / (max_rage / rage)) / 100, 1 SECONDS)

/datum/rage/proc/check_rage(required)
	return rage >= abs(required)

/// Checked every time holder_mob's Life() ticks
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
		upon_tier_change(current_tier, old_tier)

/datum/rage/proc/upon_tier_change(new_rage_tier, old_rage_tier)
	// Remove old tier abilities
	if(old_rage_tier && rage_thresholds["[old_rage_tier]"])
		var/list/old_abilities = rage_thresholds["[old_rage_tier]"]
		if(!islist(old_abilities))
			old_abilities = list(old_abilities)
		for(var/ability in old_abilities)
			remove_ability(ability)

	// Grant new tier abilities
	if(new_rage_tier && rage_thresholds["[new_rage_tier]"])
		var/list/new_abilities = rage_thresholds["[new_rage_tier]"]
		if(!islist(new_abilities))
			new_abilities = list(new_abilities)
		for(var/ability in new_abilities)
			grant_ability(ability, permanent = FALSE)
