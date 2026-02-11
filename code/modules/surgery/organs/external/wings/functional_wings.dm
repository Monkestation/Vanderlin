/obj/item/organ/wings/flight
	/// Flight datum
	var/datum/action/item_action/organ_action/use/flight/fly
	/// What species ids get flight from these wings
	var/list/flight_for_species
	/// Cannot fly upwards
	var/hover_only = FALSE
	/// Max flight time
	var/flight_time = null

/obj/item/organ/wings/flight/Destroy()
	QDEL_NULL(fly)
	return ..()

/obj/item/organ/wings/flight/Insert(mob/living/carbon/M, special, drop_if_replaced)
	. = ..()
	if(length(flight_for_species) && !(M.dna?.species.id in flight_for_species))
		return
	if(QDELETED(fly))
		fly = new(src)
	if(hover_only)
		fly.allows_z_rise = FALSE
	if(flight_time)
		fly.flight_time = flight_time
	fly.Grant(M)

/obj/item/organ/wings/flight/Remove(mob/living/carbon/M, special, drop_if_replaced)
	. = ..()
	if(QDELETED(fly))
		return
	fly.Remove(M)

/obj/item/organ/wings/flight/harpy
	name = "harpy wings"
	accessory_type = /datum/sprite_accessory/wings/large/harpyswept
	flight_for_species = list(SPEC_ID_HARPY)

/obj/item/organ/wings/flight/kobold
	name = "kobold wings"
	accessory_type = /datum/sprite_accessory/wings/kobold
	flight_for_species = list(SPEC_ID_KOBOLD, SPEC_ID_KOBOLD_FORMIKRAG)
	hover_only = TRUE
	flight_time = 5 SECONDS

/obj/effect/flyer_shadow
	name = "humanoid shadow"
	desc = "A shadow cast from something flying above."
	icon = 'icons/effects/effects.dmi'
	icon_state = "shadow"
	anchored = TRUE
	layer = BELOW_MOB_LAYER
	alpha = 180
	var/datum/weakref/flying_ref

/obj/effect/flyer_shadow/Initialize(mapload, flying_mob)
	. = ..()
	if(flying_mob)
		flying_ref = WEAKREF(flying_mob)
	transform = matrix() * 0.75 // Make the shadow slightly smaller
	add_filter("shadow_blur", 1, gauss_blur_filter(1))

/obj/effect/flyer_shadow/Destroy()
	flying_ref = null
	return ..()

/obj/effect/flyer_shadow/attackby(obj/item/I, mob/user, list/modifiers)
	var/mob/living/flying_mob = flying_ref.resolve()
	if(QDELETED(flying_mob))
		return

	if(flying_mob.z == user.z || !I.is_pointy_weapon(user))
		return

	user.visible_message(
		span_warning("[user] prepares to thrust [I] upward at [flying_mob]!"),
		span_warning("You prepare to thrust [I] upward at [flying_mob]!")
	)

	if(do_after(user, 3 SECONDS, src))
		I = user.get_active_held_item()
		if(!I?.is_pointy_weapon(user) || !flying_mob)
			return

		var/attack_damage = I.force

		user.visible_message(
			span_warning("[user] thrusts [I] upward, striking [flying_mob]!"),
			span_warning("You thrust [I] upward, striking [flying_mob]!")
		)

		flying_mob.apply_damage(attack_damage, BRUTE)

		return TRUE

/obj/item/proc/is_pointy_weapon(mob/user)
	return (user?.used_intent?.reach >= 2) && (sharpness == IS_SHARP || w_class >= WEIGHT_CLASS_NORMAL)

/datum/action/item_action/organ_action/use/flight
	name = "Toggle Flying"
	desc = "Take to the skies or return to the ground."
	button_icon_state = "flight"
	var/active_background_icon_state = "spell1"

	/// If currently flying, for feedback
	var/flying = FALSE
	/// Shadow for stabbing and feedback
	var/obj/effect/flyer_shadow/shadow
	/// If we fly upwards when starting
	var/allows_z_rise = TRUE

	/// If the flight-time is limited, how long?
	var/flight_time = null
	/// Flight timer
	var/flight_timer = null

/datum/action/item_action/organ_action/use/flight/Destroy()
	if(shadow)
		QDEL_NULL(shadow)
	return ..()

/datum/action/item_action/organ_action/use/flight/do_effect(trigger_flags)
	. = ..()
	if(trigger_flags & TRIGGER_SECONDARY_ACTION)
		owner.balloon_alert(owner, "[flying ? "" : "not"] flying.")
		return

	if(!flying)
		if(!can_takeoff())
			return
		if(do_after(owner, 5 SECONDS, owner, extra_checks = CALLBACK(src, PROC_REF(can_takeoff))))
			start_flying()
		return

	if(!owner.can_zTravel(direction = DOWN))
		stop_flying()
	else if(do_after(owner, 1 SECONDS, owner))
		stop_flying()

/datum/action/item_action/organ_action/use/flight/proc/can_takeoff()
	if(!isliving(owner))
		return FALSE

	// Only stop flight if there is somewhere to go
	// This is so you can fly on the top Z level
	var/turf/above_turf = GET_TURF_ABOVE(get_turf(owner))
	if(above_turf && (!isopenspace(above_turf) || !owner.can_zTravel(direction = UP)))
		owner.balloon_alert(owner, "can't fly up!")
		return FALSE

	return can_fly()

/datum/action/item_action/organ_action/use/flight/proc/can_fly()
	if(!isliving(owner))
		return FALSE

	var/mob/living/flier = owner

	if(flier.get_encumbrance() > 0.7)
		owner.balloon_alert(owner, "too heavy!")
		return FALSE

	if(!isturf(flier.loc) || flier.body_position != STANDING_UP)
		owner.balloon_alert(owner, "can't my spread wings!")
		return FALSE

	if(flier.incapacitated())
		owner.balloon_alert(owner, "incapacitated!")
		return FALSE

	if(flier.stat < CONSCIOUS)
		return FALSE

	return TRUE

/datum/action/item_action/organ_action/use/flight/apply_button_background(atom/movable/screen/movable/action_button/current_button)
	if(active_background_icon_state)
		background_icon_state = is_action_active(current_button) ? active_background_icon_state : initial(src.background_icon_state)
	return ..()

/datum/action/item_action/organ_action/use/flight/is_action_active(atom/movable/screen/movable/action_button/current_button)
	return flying

// Start flying normally
/datum/action/item_action/organ_action/use/flight/proc/start_flying()
	var/turf/turf = get_turf(owner)

	if(!allows_z_rise)
		ADD_TRAIT(owner, TRAIT_MOVE_FLOATING, ORGAN_TRAIT)
	else
		ADD_TRAIT(owner, TRAIT_MOVE_FLYING, ORGAN_TRAIT)

		var/turf/above_turf = GET_TURF_ABOVE(turf)
		if(owner.can_zTravel(direction = UP) && isopenspace(above_turf))
			turf = above_turf

	if(flight_time)
		to_chat(owner, span_notice("I can fly for around [flight_time / 10] seconds at most."))
		flight_timer = addtimer(CALLBACK(src, PROC_REF(flight_time_out)), flight_time, TIMER_STOPPABLE)

	flying = TRUE
	to_chat(owner, span_notice("I start flying."))
	playsound(owner, 'sound/mobs/wingflap.ogg', 75, FALSE)

	init_signals()

	if(turf != get_turf(owner))
		var/matrix/original = owner.transform
		var/prev_alpha = owner.alpha
		var/prev_pixel_z = owner.pixel_z
		animate(owner, pixel_z = 156, alpha = 0, time = 1.5 SECONDS, easing = EASE_IN, flags = ANIMATION_PARALLEL|ANIMATION_RELATIVE)
		animate(owner, transform = matrix() * 6, time = 1 SECONDS, easing = EASE_IN, flags = ANIMATION_PARALLEL)
		animate(transform = original, time = 0.5 SECONDS, EASE_OUT)
		owner.pixel_z = prev_pixel_z
		owner.alpha = prev_alpha
		owner.forceMove(turf)

	build_all_button_icons(update_flags = UPDATE_BUTTON_BACKGROUND)

/datum/action/item_action/organ_action/use/flight/proc/init_signals()
	RegisterSignal(owner, COMSIG_MOB_APPLY_DAMGE, PROC_REF(check_damage))
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(check_movement))
	RegisterSignal(owner, COMSIG_LIVING_SET_BODY_POSITION, PROC_REF(check_laying))
	RegisterSignals(owner, SIGNAL_ADDTRAIT(TRAIT_IMMOBILIZED), PROC_REF(fall))

// Stop flying normally
/datum/action/item_action/organ_action/use/flight/proc/stop_flying()
	var/turf/turf = get_turf(owner)
	// If you can't fly up you can't fly down, drop like a rock
	if(allows_z_rise)
		if(isopenspace(turf) && owner.can_zTravel(direction = DOWN))
			turf = GET_TURF_BELOW(turf)

	to_chat(owner, span_notice("I stop flying."))
	playsound(owner, 'sound/mobs/wingflap.ogg', 75, FALSE)

	if(turf != get_turf(owner))
		var/matrix/original = owner.transform
		var/prev_alpha = owner.alpha
		var/prev_pixel_z = owner.pixel_z
		owner.alpha = 0
		owner.pixel_z = 156
		owner.transform = matrix() * 8
		owner.forceMove(turf)
		animate(owner, pixel_z = prev_pixel_z, alpha = prev_alpha, time = 1.2 SECONDS, easing = EASE_IN, flags = ANIMATION_PARALLEL)
		animate(owner, transform = original, time = 1.2 SECONDS, easing = EASE_IN, flags = ANIMATION_PARALLEL)

	cancel_flight()
	build_all_button_icons(update_flags = UPDATE_BUTTON_BACKGROUND)

/datum/action/item_action/organ_action/use/flight/proc/cancel_flight()
	if(allows_z_rise)
		REMOVE_TRAIT(owner, TRAIT_MOVE_FLYING, ORGAN_TRAIT)
	else
		REMOVE_TRAIT(owner, TRAIT_MOVE_FLOATING, ORGAN_TRAIT)

	if(flight_timer)
		deltimer(flight_timer)

	flying = FALSE

	UnregisterSignal(owner, list(
		COMSIG_MOB_APPLY_DAMGE,
		COMSIG_MOVABLE_MOVED,
		COMSIG_LIVING_SET_BODY_POSITION,
		SIGNAL_ADDTRAIT(TRAIT_IMMOBILIZED)
	))

	// The fact we have to do this is awful
	var/turf/open = get_turf(owner)
	if(isopenspace(open))
		open.zFall(owner)

	if(shadow)
		QDEL_NULL(shadow)

/datum/action/item_action/organ_action/use/flight/proc/flight_time_out()
	if(QDELETED(owner) || QDELETED(src))
		return

	to_chat(owner, span_userdanger("I can't fly anymore!"))

	fall()

// Fall out the sky like a brick, no animation
/datum/action/item_action/organ_action/use/flight/proc/fall(datum/source)
	SIGNAL_HANDLER

	cancel_flight()

	build_all_button_icons(update_flags = UPDATE_BUTTON_BACKGROUND)

/datum/action/item_action/organ_action/use/flight/proc/check_damage(datum/source, damage, damagetype, def_zone)
	SIGNAL_HANDLER

	if(damagetype != BRUTE || damagetype != BURN)
		return

	if(prob(damage / 4))
		to_chat(owner, span_warning("The damage knocks you out of the air!"))
		fall()
		if(isliving(owner))
			var/mob/living/flier = owner
			flier.Knockdown(2 SECONDS)

/datum/action/item_action/organ_action/use/flight/proc/check_movement(datum/source)
	SIGNAL_HANDLER

	if(owner.movement_type & FLYING)
		if(!can_fly())
			stop_flying(owner)
			return

		if(!owner.adjust_stamina(-3))
			to_chat(owner, span_warning("You're too exhausted to keep flying!"))
			stop_flying(owner)
			return

		var/turf/this_turf = get_turf(owner)
		var/turf/below_turf = GET_TURF_BELOW(this_turf)
		if(shadow)
			if(!istransparentturf(this_turf))
				shadow.alpha= 0
			else
				shadow.alpha = 255

			if(below_turf)
				shadow.forceMove(below_turf)
		else
			if(below_turf && istransparentturf(this_turf))
				shadow = new /obj/effect/flyer_shadow(below_turf, owner)

/datum/action/item_action/organ_action/use/flight/proc/check_laying(datum/source, new_pos, old_pos)
	SIGNAL_HANDLER

	if((old_pos == STANDING_UP) && (old_pos == new_pos))
		return

	fall()
