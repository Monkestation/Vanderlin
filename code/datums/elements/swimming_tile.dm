/// A tile which drains stamina of people crossing it and deals oxygen damage to people who are prone inside of it
/datum/element/swimming_tile
	element_flags = ELEMENT_DETACH_ON_HOST_DESTROY | ELEMENT_BESPOKE
	argument_hash_start_idx = 2
	/// How much stamina does it cost to enter this tile?
	var/stamina_entry_cost
	/// Probability to exhaust our swimmer
	var/exhaust_swimmer_prob
	/// How much stamina does it cost per tick interval to stay in this tile?
	var/ticking_stamina_cost
	/// How fast do we kill people who collapse?
	var/ticking_oxy_damage
	/// Whether /datum/status_effect/swimming always rolls to cause lost breathes.
	var/block_breathing
	/// Tracked list of all mobs that are present in our turfs
	var/list/mob/swimmers = list()

/datum/element/swimming_tile/Destroy(force)
	swimmers = null
	return ..()

/datum/element/swimming_tile/Attach(turf/target, stamina_entry_cost = 7, ticking_stamina_cost = 5, ticking_oxy_damage = 2, exhaust_swimmer_prob = 30, block_breathing = FALSE)
	. = ..()
	if(!isturf(target))
		return ELEMENT_INCOMPATIBLE

	src.stamina_entry_cost = stamina_entry_cost
	src.ticking_stamina_cost = ticking_stamina_cost
	src.ticking_oxy_damage = ticking_oxy_damage
	src.exhaust_swimmer_prob = exhaust_swimmer_prob
	src.block_breathing = block_breathing

	RegisterSignals(target, list(COMSIG_ATOM_ENTERED, COMSIG_ATOM_AFTER_SUCCESSFUL_INITIALIZED_ON), PROC_REF(enter_water))
	RegisterSignal(target, COMSIG_ATOM_EXITED, PROC_REF(out_of_water))

	for(var/mob/living/drownee in target.contents)
		if(!(drownee.flags_1 & INITIALIZED_1)) //turfs initialize before movables
			continue
		enter_water(target, drownee)

/datum/element/swimming_tile/Detach(turf/source)
	UnregisterSignal(source, list(COMSIG_ATOM_ENTERED, COMSIG_ATOM_AFTER_SUCCESSFUL_INITIALIZED_ON, COMSIG_ATOM_EXITED))
	for(var/mob/living/dry_guy in source.contents)
		out_of_water(source, dry_guy)
	return ..()

/// When something enters the water set up to start drowning it
/datum/element/swimming_tile/proc/enter_water(atom/source, mob/living/swimmer, atom/old_loc)
	SIGNAL_HANDLER

	if(!istype(swimmer))
		return

	if(QDELETED(swimmer))
		return

	if(HAS_TRAIT(swimmer, TRAIT_IMMERSED))
		dip_in(swimmer)

	if(swimmer in swimmers)
		return

	RegisterSignal(swimmer, SIGNAL_ADDTRAIT(TRAIT_IMMERSED), PROC_REF(dip_in))
	RegisterSignal(swimmer, COMSIG_QDELETING, PROC_REF(on_swimmer_del))
	swimmers |= swimmer

/// When something exits the water it probably shouldn't drowning
/datum/element/swimming_tile/proc/out_of_water(atom/source, mob/living/landlubber)
	SIGNAL_HANDLER
	UnregisterSignal(landlubber, list(SIGNAL_ADDTRAIT(TRAIT_IMMERSED), COMSIG_QDELETING))
	swimmers -= landlubber

/datum/element/swimming_tile/proc/on_swimmer_del(atom/source)
	SIGNAL_HANDLER
	out_of_water(null, source)

/// When we've validated that someone is actually in the water start drowning the-I mean, start swimming!
/datum/element/swimming_tile/proc/dip_in(mob/living/floater)
	SIGNAL_HANDLER

	if(HAS_TRAIT(floater, TRAIT_SWIMMER) || ismob(floater.buckled) || !prob(exhaust_swimmer_prob))
		// Apply the status anyway for when they stop riding
		floater.apply_status_effect(/datum/status_effect/swimming, null, ticking_stamina_cost, ticking_oxy_damage, block_breathing)
		return

	if(CHECK_MOVE_LOOP_FLAGS(floater, MOVEMENT_LOOP_CALLED_MOVE))
		return

	var/swimming_skill = (GET_MOB_SKILL_VALUE(floater, /datum/attribute/skill/misc/swimming) / SKILL_LEVEL_LEGENDARY) * stamina_entry_cost

	var/encumbrance_penalty = ENCUMBRANCE_TO_SIGMOID(floater.encumbrance) * stamina_entry_cost

	var/effective_stamina_entry_cost = stamina_entry_cost - swimming_skill + encumbrance_penalty
	if(effective_stamina_entry_cost > 0 && !floater.adjust_stamina(effective_stamina_entry_cost, "drown"))
		addtimer(CALLBACK(floater, TYPE_PROC_REF(/mob/living, Knockdown), 3 SECONDS), 1 SECONDS)

	var/swimming_experience = stamina_entry_cost * GET_MOB_ATTRIBUTE_VALUE(floater, STAT_ENDURANCE) * 0.01
	floater.adjust_experience(/datum/attribute/skill/misc/swimming, swimming_experience)

	floater.apply_status_effect(/datum/status_effect/swimming, null, ticking_stamina_cost, ticking_oxy_damage, block_breathing) // Apply the status anyway for when they stop riding

///Added by the swimming_tile element. Drains stamina over time until the owner stops being immersed. Starts drowning them if they are prone or small.
/datum/status_effect/swimming
	id = "swimming"
	alert_type = null
	duration = STATUS_EFFECT_PERMANENT
	status_type = STATUS_EFFECT_UNIQUE
	tick_interval = 2 SECONDS
	/// How much damage do we do every tick interval?
	var/stamina_per_interval
	/// How much oxygen do we lose every tick interval in which we are drowning?
	var/oxygen_per_interval
	/// Probability that we lose breaths while drowning
	var/drowning_process_probability = 20
	/// Whether lose breath probability ignores the owner standing up
	var/drowning_process_ignore_standing
	/// Pity system to prevent chain stamina crits
	COOLDOWN_DECLARE(ticking_stamina_pity)

/datum/status_effect/swimming/on_creation(mob/living/new_owner, duration_override, ticking_stamina_cost = 7, ticking_oxy_damage = 2, block_breathing = FALSE)
	. = ..()
	stamina_per_interval = ticking_stamina_cost
	oxygen_per_interval = ticking_oxy_damage
	drowning_process_ignore_standing = block_breathing
	// if (!HAS_TRAIT(owner, TRAIT_SWIMMER))
	// 	owner.add_movespeed_modifier(/datum/movespeed_modifier/swimming_deep)
	RegisterSignal(owner, SIGNAL_REMOVETRAIT(TRAIT_IMMERSED), PROC_REF(stop_swimming))
	RegisterSignal(owner, COMSIG_MOB_STATCHANGE, PROC_REF(on_stat_change))
	check_sinking_state(get_turf(owner))

/datum/status_effect/swimming/proc/check_sinking_state(turf/owner_turf)
	if(iswaterturf(owner_turf))
		var/turf/open/water/water_turf = owner_turf
		if(owner.encumbrance >= (HAS_TRAIT(owner, TRAIT_SWIMMER) ? ENCUMBRANCE_EXTREME : ENCUMBRANCE_HEAVY))
			ADD_TRAIT(owner, TRAIT_SINKING, TRAIT_STATUS_EFFECT(id))
			if(istransparentturf(owner_turf))
				water_turf.try_z_swim(owner, FALSE, TRUE)
			return
	REMOVE_TRAIT(owner, TRAIT_SINKING, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/swimming/on_remove()
	. = ..()
	// owner.remove_movespeed_modifier(/datum/movespeed_modifier/swimming_deep)
	UnregisterSignal(owner, list(SIGNAL_REMOVETRAIT(TRAIT_IMMERSED), COMSIG_MOB_STATCHANGE))
	REMOVE_TRAIT(owner, TRAIT_SINKING, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/swimming/tick(seconds_between_ticks)
	// if (HAS_TRAIT(owner, TRAIT_MOB_ELEVATED))
	// 	return

	if(owner.buckled) // We're going to generously assume that being buckled to any mob or vehicle leaves you above water
		if (ismob(owner.buckled))
			return

	if(!HAS_TRAIT(owner, TRAIT_SWIMMER) && COOLDOWN_FINISHED(src, ticking_stamina_pity))
		var/effective_stamina_per_interval = stamina_per_interval

		var/athletics_skill = GET_MOB_SKILL_VALUE_OLD(owner, /datum/attribute/skill/misc/swimming)
		var/final_stamina_cost = effective_stamina_per_interval - athletics_skill

		if(final_stamina_cost > 0 && !owner.adjust_stamina(final_stamina_cost, "drown"))
			addtimer(CALLBACK(owner, TYPE_PROC_REF(/mob/living, Knockdown), 3 SECONDS), 1 SECONDS)
			COOLDOWN_START(src, ticking_stamina_pity, 6 SECONDS)

	var/turf/owner_turf = get_turf(owner)
	check_sinking_state(owner_turf)

	if(QDELETED(src)) // Sinking can cause swimming status effect to be removed
		return

	// You might not be swimming but you can breathe
	if(HAS_TRAIT(owner, TRAIT_NODROWN) || HAS_TRAIT(owner, TRAIT_NOBREATH))
		return

	var/is_drowning = prob(drowning_process_probability)

	if(owner.mob_size >= MOB_SIZE_HUMAN && owner.body_position == STANDING_UP)
		if(drowning_process_ignore_standing && is_drowning)
			owner.losebreath += floor(oxygen_per_interval / 2)
		return

	var/drowning_multiplier = has_world_trait(/datum/world_trait/abyssor_rage) ? (is_ascendant(ABYSSOR) ? 3 : 2) : 1

	owner.emote("drown")
	owner.apply_damage(oxygen_per_interval * drowning_multiplier * seconds_between_ticks, OXY)
	if(is_drowning)
		owner.losebreath += floor(oxygen_per_interval / 2)

	if(iswaterturf(owner_turf))
		var/turf/open/water/water_turf = owner_turf
		if(water_turf.water_reagent)
			var/datum/reagents/reagents = new()
			var/reagent_volume = min(5, water_turf.water_volume)
			reagents.add_reagent(water_turf.water_reagent, reagent_volume)
			reagents.trans_to(owner, reagent_volume, transfered_by = owner, method = INGEST)

/datum/status_effect/swimming/proc/on_stat_change(mob/living/source, new_stat, old_stat)
	if(!owner.client)
		return

	if(old_stat == DEAD || new_stat != DEAD) // If you die while this status effect is active, we're going to assume you drowned
		return

	record_round_statistic(STATS_PEOPLE_DROWNED)

/// When we're not in the water any more this don't matter
/datum/status_effect/swimming/proc/stop_swimming()
	SIGNAL_HANDLER
	qdel(src)
