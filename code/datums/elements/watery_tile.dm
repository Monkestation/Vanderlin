/datum/element/watery_tile
	element_flags = ELEMENT_DETACH_ON_HOST_DESTROY | ELEMENT_BESPOKE
	argument_hash_start_idx = 2
	/// List of atoms that are present in this element's turfs
	var/list/atom/movable/wet_dogs = list()
	/// Water height of source turf
	var/water_height
	/// Water cleanliness factor
	var/cleanliness_factor

/datum/element/watery_tile/Destroy(force)
	wet_dogs = null
	return ..()

/datum/element/watery_tile/Attach(turf/target, water_height = WATER_HEIGHT_ANKLE, cleanliness_factor = 1)
	. = ..()
	if(!isturf(target))
		return ELEMENT_INCOMPATIBLE
	src.water_height = water_height
	src.cleanliness_factor = cleanliness_factor

	RegisterSignals(target, list(COMSIG_ATOM_ENTERED, COMSIG_ATOM_AFTER_SUCCESSFUL_INITIALIZED_ON), PROC_REF(enter_water))
	RegisterSignal(target, COMSIG_ATOM_EXITED, PROC_REF(out_of_water))
	for(var/atom/movable/movable as anything in target.contents)
		if(!(movable.flags_1 & INITIALIZED_1) || movable.invisibility >= INVISIBILITY_OBSERVER) //turfs initialize before movables
			continue
		enter_water(target, movable)

/datum/element/watery_tile/Detach(turf/source)
	UnregisterSignal(source, list(COMSIG_ATOM_ENTERED, COMSIG_ATOM_AFTER_SUCCESSFUL_INITIALIZED_ON, COMSIG_ATOM_EXITED))
	for(var/atom/movable/movable as anything in source.contents)
		out_of_water(source, movable)
	return ..()

/datum/element/watery_tile/proc/enter_water(atom/source, atom/movable/entered)
	SIGNAL_HANDLER

	// if(QDELETED(entered) || HAS_TRAIT(entered, TRAIT_WALLMOUNTED))
	// 	return

	if(QDELETED(entered))
		return

	if(HAS_TRAIT(entered, TRAIT_IMMERSED))
		dip_in(entered)

	if(entered in wet_dogs)
		return

	RegisterSignal(entered, SIGNAL_ADDTRAIT(TRAIT_IMMERSED), PROC_REF(dip_in))
	RegisterSignal(entered, COMSIG_QDELETING, PROC_REF(on_content_del))
	if(isliving(entered))
		RegisterSignal(entered, SIGNAL_REMOVETRAIT(TRAIT_IMMERSED), PROC_REF(dip_out))
	wet_dogs |= entered

/datum/element/watery_tile/proc/dip_in(atom/movable/source)
	SIGNAL_HANDLER
	source.extinguish()
	if(istype(source, /obj/item/clothing))
		var/obj/item/clothing/cloth = source
		if(cloth.wetable)
			cloth.wet.add_water(20, cleanliness_factor < 0)

	if(!isliving(source))
		return
	var/mob/living/our_mob = source
	// our_mob.adjust_wet_stacks(3)
	our_mob.apply_status_effect(/datum/status_effect/watery_tile_wetness, null, water_height, cleanliness_factor)

/datum/element/watery_tile/proc/out_of_water(atom/source, atom/movable/gone)
	SIGNAL_HANDLER
	on_content_del(gone)
	if(isliving(gone))
		dip_out(gone)

/datum/element/watery_tile/proc/on_content_del(atom/movable/source)
	SIGNAL_HANDLER
	UnregisterSignal(source, list(SIGNAL_ADDTRAIT(TRAIT_IMMERSED), SIGNAL_REMOVETRAIT(TRAIT_IMMERSED), COMSIG_QDELETING))
	wet_dogs -= source

/datum/element/watery_tile/proc/dip_out(mob/living/source)
	SIGNAL_HANDLER
	source.remove_status_effect(/datum/status_effect/watery_tile_wetness)

///Added by the watery_tile element. Keep adding wet stacks over time until removed from the watery turf.
/datum/status_effect/watery_tile_wetness
	id = "watery_tile_wetness"
	alert_type = null
	duration = STATUS_EFFECT_PERMANENT
	tick_interval = 2 SECONDS
	status_type = STATUS_EFFECT_UNIQUE
	/// Water height of source turf
	var/water_height
	/// Water cleanliness factor
	var/cleanliness_factor = 1

/datum/status_effect/watery_tile_wetness/on_creation(mob/living/new_owner, duration_override, water_height, cleanliness_factor)
	. = ..()
	src.water_height = water_height
	src.cleanliness_factor = cleanliness_factor
	time_until_next_tick = 0

/datum/status_effect/watery_tile_wetness/tick(seconds_between_ticks)
	. = ..()
	// owner.adjust_wet_stacks(1)
	var/turf/owner_turf = get_turf(owner)
	if(iswaterturf(owner_turf))
		var/turf/open/water/water_turf = owner_turf
		if(water_turf.water_reagent)
			var/datum/reagent/turf_reagent = new water_turf.water_reagent()
			turf_reagent.reaction_mob(owner, TOUCH, 2)

			if(ishuman(owner) && istype(water_turf, /turf/open/water/bath))
				var/mob/living/carbon/human/human_owner = owner
				if(!human_owner.wear_armor && !human_owner.wear_shirt && !human_owner.wear_pants)
					human_owner.add_stress(/datum/stress_event/bathwater)

	var/dirty_water_turf = FALSE
	if(cleanliness_factor < 0)
		dirty_water_turf = TRUE
	if(owner.body_position == LYING_DOWN || water_height >= WATER_HEIGHT_DEEP)
		owner.SoakMob(FULL_BODY, dirty_water_turf)
	else if(water_height == WATER_HEIGHT_SHALLOW)
		owner.SoakMob(BELOW_CHEST, dirty_water_turf)
	else if(water_height == WATER_HEIGHT_ANKLE)
		owner.SoakMob(FEET, dirty_water_turf)
