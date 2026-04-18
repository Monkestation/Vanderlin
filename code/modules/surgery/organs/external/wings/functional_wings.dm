
#define FLIGHT_DRAIN_AMOUNT 3

/obj/item/organ/wings/flight
	/// Flight datum
	var/datum/action/item_action/organ_action/use/flight/fly
	/// What species ids get flight from these wings
	var/list/flight_for_species
	/// Shadow for stabbing and feedback
	var/obj/effect/flyer_shadow/shadow
	/// How long dpes it takes to start flying?
	var/flight_startup = 5 SECONDS
	/// How long does it take to stop flying?
	var/flight_wind_down = 3 SECONDS
	/// Whether wings are able to lift us up a zlevel
	var/can_takeoff = TRUE
	/// Max flight time
	var/flight_time = null
	var/flight_timer

/obj/item/organ/wings/flight/Destroy()
	QDEL_NULL(fly)
	QDEL_NULL(shadow)
	deltimer(flight_timer)
	return ..()

/obj/item/organ/wings/flight/Insert(mob/living/carbon/M, special, drop_if_replaced, new_zone = null)
	. = ..()
	if(length(flight_for_species) && !(M.dna?.species.id in flight_for_species))
		return
	if(QDELETED(fly))
		fly = new(src)
	fly.Grant(M)

/obj/item/organ/wings/flight/Remove(mob/living/carbon/organ_owner, special, drop_if_replaced)
	. = ..()
	fly?.Remove(organ_owner)
	if(wings_open)
		stop_flying(organ_owner, drop_flyer = TRUE)

/obj/item/organ/wings/flight/on_life(seconds_per_tick)
	. = ..()
	handle_flight(owner)

/// Called on_life(). Handle flight code and check if we're still flying
/obj/item/organ/wings/flight/proc/handle_flight(mob/living/carbon/carbon_owner)
	if(!HAS_TRAIT_FROM(carbon_owner, TRAIT_MOVE_FLOATING, SPECIES_FLIGHT_TRAIT))
		return FALSE
	if(!can_fly(FALSE))
		stop_flying(carbon_owner, drop_flyer = TRUE)
		return FALSE
	carbon_owner.adjust_energy(-FLIGHT_DRAIN_AMOUNT)
	return TRUE

/// Check if we're still eligible for flight
/obj/item/organ/wings/flight/proc/can_fly(feedback = TRUE)
	var/mob/living/flier = owner
	var/turf/location = get_turf(flier)
	if(!location)
		return FALSE

	if(!flier.check_energy(1))
		if(feedback)
			flier.balloon_alert(flier, "no energy!")
		return FALSE

	if(flier.stat || flier.body_position == LYING_DOWN || isnull(flier.client))
		if(feedback)
			flier.balloon_alert(flier, "can't my spread wings!")
		return FALSE
	if(flier.encumbrance >= ENCUMBRANCE_HEAVY)
		if(feedback)
			flier.balloon_alert(flier, "too heavy!")
		return FALSE
	if(flier.incapacitated())
		if(feedback)
			owner.balloon_alert(owner, "incapacitated!")
		return FALSE

	return TRUE

///UNSAFE PROC, should only be called through the Activate or other sources that check for CanFly
/obj/item/organ/wings/flight/proc/toggle_flight(mob/living/carbon/human/human, try_takeoff)
	if(!HAS_TRAIT_FROM(human, TRAIT_MOVE_FLOATING, SPECIES_FLIGHT_TRAIT))
		var/attempt_takeoff = can_takeoff && try_takeoff
		if(attempt_takeoff)
			to_chat(human, span_info("I will try to fly upwards if possible."))
		if(do_after(owner, flight_startup, extra_checks = CALLBACK(src, PROC_REF(can_fly))))
			start_flying(human, attempt_takeoff)
	else
		if(do_after(owner, flight_wind_down))
			stop_flying(human)

/obj/item/organ/wings/flight/proc/start_flying(mob/living/carbon/human/human, attempt_takeoff)
	if(HAS_TRAIT_FROM(human, TRAIT_MOVE_FLOATING, SPECIES_FLIGHT_TRAIT))
		return

	wings_open = TRUE
	human.update_body_parts()

	human.physiology.stun_mod *= 2
	init_signals(human)
	passtable_on(human, SPECIES_FLIGHT_TRAIT)
	human.set_resting(FALSE, TRUE)
	ADD_TRAIT(human, TRAIT_MOVE_FLOATING, SPECIES_FLIGHT_TRAIT)
	if(attempt_takeoff)
		human.stop_pulling()
		if(human.zMove(dir = UP, z_move_flags = ZMOVE_INCAPACITATED_CHECKS|ZMOVE_CHECK_PULLS))
			flight_animation(human)

	playsound(human, 'sound/mobs/wingflap.ogg', 75, FALSE)
	to_chat(human, span_notice("I beat my wings and begin to hover..."))
	if(flight_time)
		to_chat(owner, span_userdanger("I can only stay airborne for [flight_time / 10] seconds!"))
		flight_timer = addtimer(CALLBACK(src, PROC_REF(stop_flying), human, TRUE), flight_time, TIMER_STOPPABLE)

	fly?.build_all_button_icons(update_flags = UPDATE_BUTTON_BACKGROUND)

/obj/item/organ/wings/flight/proc/stop_flying(mob/living/carbon/human/human, drop_flyer = FALSE)
	if(!HAS_TRAIT_FROM(human, TRAIT_MOVE_FLOATING, SPECIES_FLIGHT_TRAIT))
		return

	wings_open = FALSE
	human.update_body_parts()

	human.physiology.stun_mod *= 0.5
	remove_signals(human)
	passtable_off(human, SPECIES_FLIGHT_TRAIT)

	deltimer(flight_timer)
	QDEL_NULL(shadow)

	if(!drop_flyer)
		var/turf/old_turf = get_turf(human)
		old_turf.zFall(human)
		if(old_turf != get_turf(human))
			flight_animation(human)
	else
		to_chat(human, span_notice("My wings give out, and I suddenly stop flying!"))

	// /datum/element/movetype_handler will zFall owner when removing TRAIT_MOVE_FLOATING
	REMOVE_TRAIT(human, TRAIT_MOVE_FLOATING, SPECIES_FLIGHT_TRAIT)
	playsound(human, 'sound/mobs/wingflap.ogg', 75, FALSE)
	fly?.build_all_button_icons(update_flags = UPDATE_BUTTON_BACKGROUND)

/obj/item/organ/wings/flight/proc/flight_animation(mob/living/carbon/carbon_owner)
	var/matrix/original = carbon_owner.transform
	var/prev_alpha = carbon_owner.alpha
	var/prev_pixel_z = carbon_owner.pixel_z
	carbon_owner.alpha = 0
	carbon_owner.pixel_z = 156
	carbon_owner.transform = matrix() * 8
	animate(carbon_owner, pixel_z = prev_pixel_z, alpha = prev_alpha, time = 1.2 SECONDS, easing = EASE_IN, flags = ANIMATION_PARALLEL)
	animate(carbon_owner, transform = original, time = 1.2 SECONDS, easing = EASE_IN, flags = ANIMATION_PARALLEL)

/obj/item/organ/wings/flight/proc/init_signals(mob/living/carbon/carbon_owner)
	RegisterSignal(carbon_owner, COMSIG_MOB_APPLY_DAMAGE, PROC_REF(check_damage))
	RegisterSignal(carbon_owner, COMSIG_MOVABLE_MOVED, PROC_REF(check_movement))
	RegisterSignal(carbon_owner, COMSIG_LIVING_SET_BODY_POSITION, PROC_REF(check_laying))
	RegisterSignal(carbon_owner, SIGNAL_ADDTRAIT(TRAIT_IMMOBILIZED), PROC_REF(fall))

/obj/item/organ/wings/flight/proc/remove_signals(mob/living/carbon/carbon_owner)
	UnregisterSignal(carbon_owner, list(
		COMSIG_MOB_APPLY_DAMAGE,
		COMSIG_MOVABLE_MOVED,
		COMSIG_LIVING_SET_BODY_POSITION,
		SIGNAL_ADDTRAIT(TRAIT_IMMOBILIZED)
	))

/obj/item/organ/wings/flight/proc/check_damage(datum/source, damage, damagetype, def_zone)
	SIGNAL_HANDLER

	if(damagetype != BRUTE && damagetype != BURN)
		return

	if(!isliving(source))
		return

	var/mob/living/flier = source
	if(prob(damage / 4))
		to_chat(owner, span_warning("The damage knocks you out of the air!"))
		flier.Knockdown(2 SECONDS)

/obj/item/organ/wings/flight/proc/check_movement(datum/source)
	SIGNAL_HANDLER

	if(!owner.adjust_stamina(FLIGHT_DRAIN_AMOUNT))
		to_chat(owner, span_warning("You're too exhausted to keep flying!"))
		stop_flying(owner, TRUE)
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

	if(!owner.throwing && isopenspace(below_turf))
		if(owner.zMove(dir = DOWN, z_move_flags = ZMOVE_CHECK_PULLS))
			to_chat(owner, span_info("I glide down to a more manageable height!"))
			playsound(owner, 'sound/mobs/wingflap.ogg', 75, FALSE)

// Fall out the sky like a brick, no animation
/obj/item/organ/wings/flight/proc/fall(datum/source)
	SIGNAL_HANDLER
	stop_flying(source, TRUE)

/obj/item/organ/wings/flight/proc/check_laying(datum/source, new_pos, old_pos)
	SIGNAL_HANDLER

	if((old_pos == STANDING_UP) && (old_pos == new_pos))
		return
	stop_flying(source, TRUE)

/obj/item/organ/wings/flight/harpy
	name = "harpy wings"
	accessory_type = /datum/sprite_accessory/wings/large/harpyswept
	flight_for_species = list(SPEC_ID_HARPY)

/obj/item/organ/wings/flight/kobold
	name = "kobold wings"
	accessory_type = /datum/sprite_accessory/wings/kobold
	flight_for_species = list(SPEC_ID_KOBOLD, SPEC_ID_KOBOLD_FORMIKRAG)
	can_takeoff = FALSE
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

	var/pointy_weapon = ((user?.used_intent?.reach >= 2) && (I.sharpness == IS_SHARP || I.w_class >= WEIGHT_CLASS_NORMAL))
	if(flying_mob.z == user.z || !pointy_weapon)
		return

	user.visible_message(
		span_warning("[user] prepares to thrust [I] upward at [flying_mob]!"),
		span_warning("You prepare to thrust [I] upward at [flying_mob]!")
	)

	if(do_after(user, 3 SECONDS, src))
		I = user.get_active_held_item()
		pointy_weapon = ((user?.used_intent?.reach >= 2) && (I.sharpness == IS_SHARP || I.w_class >= WEIGHT_CLASS_NORMAL))
		if(!pointy_weapon || !flying_mob)
			return

		var/attack_damage = I.force

		user.visible_message(
			span_warning("[user] thrusts [I] upward, striking [flying_mob]!"),
			span_warning("You thrust [I] upward, striking [flying_mob]!")
		)

		flying_mob.apply_damage(attack_damage, BRUTE)
		return TRUE

/datum/action/item_action/organ_action/use/flight
	name = "Toggle Flying"
	desc = "Take to the skies or return to the ground."
	check_flags = AB_CHECK_CONSCIOUS|AB_CHECK_IMMOBILE|AB_CHECK_INCAPACITATED|AB_CHECK_LYING
	button_icon_state = "flight"
	var/active_background_icon_state = "spell1"

/datum/action/item_action/organ_action/use/flight/do_effect(trigger_flags)
	var/mob/living/carbon/carbon_owner = owner
	var/obj/item/organ/wings/flight/wings = carbon_owner.getorganslot(ORGAN_SLOT_WINGS)
	if(wings?.can_fly())
		var/try_takeoff = (trigger_flags & TRIGGER_SECONDARY_ACTION)
		wings.toggle_flight(carbon_owner, try_takeoff)

/datum/action/item_action/organ_action/use/flight/apply_button_background(atom/movable/screen/movable/action_button/current_button)
	if(active_background_icon_state)
		background_icon_state = is_action_active(current_button) ? active_background_icon_state : initial(src.background_icon_state)
	return ..()

/datum/action/item_action/organ_action/use/flight/is_action_active(atom/movable/screen/movable/action_button/current_button)
	return HAS_TRAIT_FROM(owner, TRAIT_MOVE_FLOATING, SPECIES_FLIGHT_TRAIT)

#undef FLIGHT_DRAIN_AMOUNT
