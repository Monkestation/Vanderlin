/**
 * Advanced class, job subclasses
 *
 * Handled via class_select_handler.dm
 */
/datum/job/advclass
	abstract_type = /datum/job/advclass
	total_positions = -1 // Infinite slots unless overriden
	/// Take on the title of the previous job, if applied through regular means
	var/inherit_parent_title = FALSE
	/// Chance for this advanced class to roll for each player
	var/roll_chance = 100
	/// What categories we are going to sort it in, handles selection
	var/list/category_tags = null
	/// Bypass the class_cat_alloc_attempts limits and always be rolled
	var/bypass_class_cat_limits = FALSE
	/// Should reset STATMOD_JOB, set to FALSE if you want to be additive to parent's stats.
	/// Doesn't effect skills only stats.
	var/should_reset_stats = TRUE
	/// Should this advclass spawn with a torch?
	var/spawn_with_torch = FALSE

/datum/job/advclass/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	// Remove the stun first, then grant us the torch.
	for(var/datum/status_effect/incapacitating/stun/S in spawned.status_effects)
		spawned.remove_status_effect(S)

	if(spawn_with_torch)
		spawned.put_in_hands(new /obj/item/flashlight/flare/torch)

	apply_character_post_equipment(spawned)

/datum/job/advclass/proc/check_requirements(mob/living/carbon/human/to_check)
	if(!prob(roll_chance))
		return FALSE

	var/datum/preferences/player_prefs = to_check.client.prefs

	if(length(allowed_sexes) && !(to_check.gender in allowed_sexes))
		return FALSE

	if(!to_check.client.has_triumph_buy(TRIUMPH_BUY_RACE_ALL) && !prefs_species_check(player_prefs))
		return FALSE

	if(length(allowed_ages) && !(to_check.age in allowed_ages))
		return FALSE

	if(length(allowed_patrons) && !(to_check.patron.type in allowed_patrons))
		return FALSE

	if(!antags_can_pick && to_check.mind?.special_role)
		return FALSE

	if(total_positions > -1)
		if(current_positions >= total_positions)
			return FALSE

	return TRUE
