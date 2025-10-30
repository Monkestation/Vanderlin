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

	if(length(allowed_races) && !(to_check.dna.species.id in allowed_races))
		if(!(to_check.client.has_triumph_buy(TRIUMPH_BUY_RACE_ALL)))
			return FALSE

	if(length(allowed_ages) && !(to_check.age in allowed_ages))
		return FALSE

	if(length(allowed_patrons) && !(to_check.patron.type in allowed_patrons))
		return FALSE

	if(total_positions > -1)
		if(current_positions >= total_positions)
			return FALSE

#ifdef USES_PQ
	if(min_pq != -100) // If someone sets this we actually do the check.
		if(get_playerquality(to_check.client.ckey) < min_pq)
			return FALSE
#endif

#ifdef USES_PQ
	var/pq_prob = roll_chance + max(get_playerquality(to_check.client.ckey) / 2, 0) // Takes the base pick rate of the rare class and adds the client's pq divided by 2 or 0, whichever is higher. Allows a maximum of 65 pick probability at 100 pq
#else
	var/pq_prob = roll_chance
#endif
	if(prob(pq_prob))
		return TRUE
