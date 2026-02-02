// Most of this code is ripped from the use_mana component for use in spells only
// This is so that spells can be more flexible in their cost and when they use that cost

// If something is NOT a spell use the component instead

/// Get all pools currently available to the mob
/mob/living/proc/get_all_pools()
	var/list/datum/mana_pool/usable_pools = list()

	for(var/atom/movable/thing as anything in contents)
		if(!isnull(thing.mana_pool) && HAS_TRAIT(thing, TRAIT_POOL_AVAILABLE_FOR_CAST))
			usable_pools += thing.mana_pool

	if(!isnull(mana_pool)) //we want this last so foci run first
		usable_pools += mana_pool

	return usable_pools

/// Check if all pools have the required amount of mana
/mob/living/proc/has_mana_available(list/attunements, total_required_mana)
	var/list/datum/mana_pool/provided_mana = get_all_pools()
	var/total_effective_mana = 0

	for(var/datum/mana_pool/iterated_pool as anything in provided_mana)
		total_effective_mana += iterated_pool.get_attuned_amount(attunements, src)

	return (total_effective_mana > total_required_mana)

/// Consume the given amount of mana
/mob/living/proc/consume_mana(list/attunements, amount_to_use)
	var/mana_consumed = -amount_to_use
	var/total_mana_consumed = -mana_consumed

	var/list/datum/mana_pool/available_pools = get_all_pools()
	var/attunement_total_value = 0
	var/total_damage = 0
	for(var/datum/attunement/attunement as anything in attunements)
		attunement_total_value += attunements[attunement]

	while(mana_consumed <= -0.05)
		var/mult
		var/attuned_cost
		for(var/datum/mana_pool/pool as anything in available_pools)
			mult = pool.get_overall_attunement_mults(attunements, src)
			attuned_cost = mana_consumed * mult
			if(pool.amount < attuned_cost)
				attuned_cost = pool.amount
			var/mana_adjusted = SAFE_DIVIDE(pool.adjust_mana((attuned_cost)), mult) * (has_world_trait(/datum/world_trait/noc_wisdom) ? 0.8 : 1)
			mana_consumed -= mana_adjusted
			record_featured_stat(FEATURED_STATS_MAGES, src, abs(mana_adjusted))
			record_round_statistic(STATS_MANA_SPENT, abs(mana_adjusted))

			if(available_pools.Find(pool) == length(available_pools) && mana_consumed <= -0.05) // if we're at the end of the list and mana_consumed is not 0 or near 0 (floating points grrr)
				mana_consumed = 0 // lets terminate the loop to be safe

			if(pool.parent == src)
				for(var/datum/attunement/attunement as anything in attunements)
					if(pool.negative_attunements[attunement] < 0)
						var/composition_gain = attunement_total_value / attunements[attunement]
						var/negative_impact_mana = total_mana_consumed * composition_gain
						total_damage += round(negative_impact_mana * 0.1, 1)
	if(total_damage)
		mana_pool.mana_backlash(total_damage)

// Spell visual effect procs
// Mob level as only mobs can cast spells
// Living because ghosts can not use real spells

/// Start effects, used for channeled spells,
/// Creates and sets the spell_rune.
/mob/living/proc/start_spell_visual_effects(list/attunements)
	if(QDELETED(src))
		return

	var/spell_color = get_blended_attunement_color(attunements)

	if(spell_rune)
		QDEL_NULL(spell_rune)

	//Create the following rune
	var/obj/effect/spell_rune/rune = new(null, src, spell_color)
	vis_contents |= rune
	spell_rune = rune

	//Start particle effects
	start_spell_particles(spell_color)

/// Intermittent fluff effect while the effects are ongoing.
/// Requires the spell_rune therefore applicable to channeled spells only.
/mob/living/proc/start_spell_particles(spell_color = "#FFFFFF")
	if(QDELETED(src) || QDELETED(spell_rune))
		return

	var/obj/effect/temp_visual/particle_up/particles = new(null, src, spell_rune)
	vis_contents |= particles
	particles.color = spell_color

	addtimer(CALLBACK(src, PROC_REF(start_spell_particles), spell_color), 3.6 SECONDS)

/// Finish effect, used by most spells.
/// Cleans up the spell_rune if present and creates a cloud visual based on attunement.
/mob/living/proc/finish_spell_visual_effects(list/attunements)
	if(QDELETED(src))
		return

	var/spell_color = get_blended_attunement_color(attunements)

	// Clean up the rune
	if(spell_rune)
		QDEL_NULL(spell_rune)

	// Create wave_up effect
	var/obj/effect/temp_visual/wave_up/wave = new(null, src)
	vis_contents |= wave
	wave.color = spell_color

/// Force cancel the effects by deleting the spell_rune
/mob/living/proc/cancel_spell_visual_effects()
	if(QDELETED(src))
		return

	// Clean up the rune
	if(spell_rune)
		QDEL_NULL(spell_rune)
