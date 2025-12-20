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



/datum/job/advclass/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	// Remove the stun first, then grant us the torch.
	for(var/datum/status_effect/incapacitating/stun/S in spawned.status_effects)
		spawned.remove_status_effect(S)

	apply_character_post_equipment(spawned)

/datum/job/advclass/proc/check_requirements(mob/living/carbon/human/to_check)
	var/list/local_allowed_sexes = list()
	if(length(allowed_sexes))
		local_allowed_sexes |= allowed_sexes

	if(length(local_allowed_sexes) && !(to_check.gender in local_allowed_sexes))
		return FALSE

	if((length(allowed_races) && !(to_check.dna.species.id in allowed_races)) || \
		(length(blacklisted_species) && (to_check.dna.species.id in blacklisted_species)))
		if(!(to_check.client.has_triumph_buy(TRIUMPH_BUY_RACE_ALL)))
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

	if(prob(roll_chance))
		return TRUE
