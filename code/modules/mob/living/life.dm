/mob/living/proc/Life(seconds, times_fired)
	set waitfor = FALSE

	var/signal_result = SEND_SIGNAL(src, COMSIG_LIVING_LIFE, seconds, times_fired)

	if(signal_result & COMPONENT_LIVING_CANCEL_LIFE_PROCESSING) // mmm less work
		return

	if (client)
		var/turf/T = get_turf(src)
		if(!T)
			var/msg = "[ADMIN_LOOKUPFLW(src)] was found to have no .loc with an attached client, if the cause is unknown it would be wise to ask how this was accomplished."
			message_admins(msg)
			send2irc_adminless_only("Mob", msg, R_ADMIN)
			log_game("[key_name(src)] was found to have no .loc with an attached client.")

		// This is a temporary error tracker to make sure we've caught everything
		else if (registered_z != T.z)
#ifdef TESTING
			message_admins("[ADMIN_LOOKUPFLW(src)] has somehow ended up in Z-level [T.z] despite being registered in Z-level [registered_z]. If you could ask them how that happened and notify coderbus, it would be appreciated.")
#endif
			log_game("Z-TRACKING: [src] has somehow ended up in Z-level [T.z] despite being registered in Z-level [registered_z].")
			update_z(T.z)
	else if (registered_z)
		log_game("Z-TRACKING: [src] of type [src.type] has a Z-registration despite not having a client.")
		update_z(null)

	if(isnull(loc) || HAS_TRAIT(src, TRAIT_NO_TRANSFORM))
		return

	if(!HAS_TRAIT(src, TRAIT_STASIS))
		//Breathing, if applicable
		handle_temperature()
		handle_breathing(times_fired)
		if(HAS_TRAIT(src, TRAIT_SIMPLE_WOUNDS))
			handle_wounds()
			handle_embedded_objects()
			handle_blood()
			//passively heal even wounds with no passive healing
			for(var/datum/wound/wound as anything in get_wounds())
				wound.heal_wound(1)

		if(HAS_TRAIT(src, TRAIT_WOUNDREGEN))
			//passively heal wounds
			for(var/datum/wound/wound as anything in get_wounds())
				wound.heal_wound(10)

		/// ENDURE AS HE DOES.
		if(!stat && HAS_TRAIT(src, TRAIT_PSYDONIAN_GRIT) && !HAS_TRAIT(src, TRAIT_PARALYSIS))
			handle_wounds()
			//passively heal wounds, but not if you're skullcracked OR DEAD.
			if(blood_volume > BLOOD_VOLUME_SURVIVE)
				for(var/datum/wound/wound as anything in get_wounds())
					wound.heal_wound(wound.passive_healing * 0.25)

		if (QDELETED(src)) // diseases can qdel the mob via transformations
			return

		//Random events (vomiting etc)
		handle_random_events()

		handle_status_effects() //all special effects, stun, knockdown, jitteryness, hallucination, sleeping, etc

	update_sneak_invis()
	handle_fire()

	if(machine)
		machine.check_eye(src)

	handle_typing_indicator()

	if(istype(loc, /turf/open/water))
		handle_inwater(loc)

	if(!client && (world.time - last_island_check) > 20 SECONDS)
		last_island_check = world.time
		update_island_cache()

	if(stat != DEAD)
		return 1

/mob/living/proc/update_island_cache()
	if(!length(SSterrain_generation.island_registry))
		last_island_check = world.time + 3 HOURS
		return
	var/turf/T = get_turf(src)
	if(!T)
		if(cached_island_id)
			SSisland_mobs.remove_mob(src)
			cached_island_id = null
		return

	var/datum/island_data/island = SSterrain_generation.get_island_at_location(T)
	var/new_island_id = island?.island_id

	if(new_island_id != cached_island_id)
		if(new_island_id)
			SSisland_mobs.register_mob(src, new_island_id)
		else
			SSisland_mobs.remove_mob(src)
			cached_island_id = null

/mob/living/proc/force_island_check()
	last_island_check = 0
	update_island_cache()

/mob/living/proc/DeadLife()
	set invisibility = 0
	if (HAS_TRAIT(src, TRAIT_NO_TRANSFORM))
		return
	if(!loc)
		return
	if(HAS_TRAIT(src, TRAIT_SIMPLE_WOUNDS))
		handle_wounds()
		handle_embedded_objects()
		handle_blood()
	update_sneak_invis()
	handle_fire()
	handle_typing_indicator()

/mob/living/proc/handle_temperature()
	return

/mob/living/proc/handle_breathing(times_fired)
	return

/mob/living/proc/handle_random_events()
	//random painstun
	if(stat || HAS_TRAIT(src, TRAIT_NOPAINSTUN))
		return
	if(!MOBTIMER_FINISHED(src, MT_PAINSTUN, 60 SECONDS))
		return
	if((getBruteLoss() + getFireLoss()) < (STAEND * 10))
		return

	var/probby = 53 - (STAEND * 2)
	if(body_position == LYING_DOWN)
		probby = probby - 20
	if(prob(probby))
		MOBTIMER_SET(src, MT_PAINSTUN)
		Immobilize(10)
		emote("painscream")
		visible_message("<span class='warning'>[src] freezes in pain!</span>",
					"<span class='warning'>I'm frozen in pain!</span>")
		sleep(10)
		Stun(110)
		Knockdown(110)

/mob/living/proc/handle_fire()
	if(fire_stacks < 0) //If we've doused ourselves in water to avoid fire, dry off slowly
		fire_stacks = min(0, fire_stacks + 0.4)//So we dry ourselves back to default, nonflammable.
	if(!on_fire)
		return TRUE //the mob is no longer on fire, no need to do the rest.
	if(fire_stacks + divine_fire_stacks > 0)
		adjust_divine_fire_stacks(-0.05)
		if(fire_stacks > 0)
			adjust_fire_stacks(-0.05) //the fire is slowly consumed
	else
		ExtinguishMob()
		return TRUE //mob was put out, on_fire = FALSE via ExtinguishMob(), no need to update everything down the chain.
	update_fire()
	var/turf/location = get_turf(src)
	location?.hotspot_expose(700, 50, 1)

/mob/living/proc/handle_wounds()
	if(stat >= DEAD)
		for(var/datum/wound/wound as anything in get_wounds())
			wound.on_death()
		return
	for(var/datum/wound/wound as anything in get_wounds())
		wound.on_life()

/obj/item/proc/on_embed_life(mob/living/user, obj/item/bodypart/bodypart)
	return

/mob/living/proc/handle_embedded_objects()
	for(var/obj/item/embedded in simple_embedded_objects)
		if(embedded.on_embed_life(src))
			continue

		if(prob(embedded.embedding.embedded_pain_chance))
			to_chat(src, "<span class='danger'>[embedded] in me hurts!</span>")

		if(prob(embedded.embedding.embedded_fall_chance))
			simple_remove_embedded_object(embedded)
			to_chat(src,"<span class='danger'>[embedded] falls out of me!</span>")

/**
 * Get the fullness of the mob
 *
 * This returns a value form 0 upwards to represent how full the mob is.
 * The value is a total amount of consumable reagents in the body combined
 * with the total amount of nutrition they have.
 * This does not have an upper limit.
 */
/mob/living/proc/get_fullness()
	var/fullness = nutrition
	// we add the nutrition value of what we're currently digesting
	for(var/datum/reagent/consumable/bits in reagents.reagent_list)
		if(bits)
			fullness += bits.nutriment_factor * bits.volume / bits.metabolization_rate
	return fullness

/**
 * Check if the mob contains this reagent.
 *
 * This will validate the the reagent holder for the mob and any sub holders contain the requested reagent.
 * Vars:
 * * reagent (typepath) takes a PATH to a reagent.
 * * amount (int) checks for having a specific amount of that chemical.
 * * needs_metabolizing (bool) takes into consideration if the chemical is matabolizing when it's checked.
 */
/mob/living/proc/has_reagent(reagent, amount = -1, needs_metabolizing = FALSE)
	return reagents.has_reagent(reagent, amount, needs_metabolizing)

/**
 * Removes reagents from the mob
 *
 * This will locate the reagent in the mob and remove it from reagent holders
 * Vars:
 * * reagent (typepath) takes a PATH to a reagent.
 * * custom_amount (int)(optional) checks for having a specific amount of that chemical.
 * * safety (bool) check for the trans_id_to
 */
/mob/living/proc/remove_reagent(reagent, custom_amount, safety)
	if(!custom_amount)
		custom_amount = get_reagent_amount(reagent)
	return reagents.remove_reagent(reagent, custom_amount, safety)

/**
 * Returns the amount of a reagent from the mob
 *
 * This will locate the reagent in the mob and return the total amount from all reagent holders
 * Vars:
 * * reagent (typepath) takes a PATH to a reagent.
 */
/mob/living/proc/get_reagent_amount(reagent)
	return reagents.get_reagent_amount(reagent)

//this updates all special effects: knockdown, druggy, stuttering, etc..
/mob/living/proc/handle_status_effects()
	if(slowdown)
		slowdown = max(slowdown - 1, 0)
	if(slowdown <= 0)
		remove_movespeed_modifier(MOVESPEED_ID_LIVING_SLOWDOWN_STATUS)

/mob/living/proc/update_damage_hud()
	return

/mob/living/proc/gravity_animate()
	if(!get_filter("gravity"))
		add_filter("gravity", 1, motion_blur_filter(0, 0))
	INVOKE_ASYNC(src, PROC_REF(gravity_pulse_animation))

/mob/living/proc/gravity_pulse_animation()
	animate(get_filter("gravity"), y = 1, time = 10)
	sleep(10)
	animate(get_filter("gravity"), y = 0, time = 10)
