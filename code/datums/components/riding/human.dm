
///////Yes, I said humans. No, this won't end well...//////////
/datum/component/riding/creature/human
	can_be_driven = FALSE

/datum/component/riding/creature/human/Initialize(mob/living/riding_mob, force = FALSE, ride_check_flags = NONE)
	. = ..()
	var/mob/living/carbon/human/human_parent = parent
	// human_parent.add_movespeed_modifier(/datum/movespeed_modifier/human_carry)
	var/amt2use = HUMAN_CARRY_SLOWDOWN
	var/reqstrength = 10
	if(human_parent.r_grab?.grabbed == riding_mob)
		reqstrength -= 1
	if(human_parent.l_grab?.grabbed == riding_mob)
		reqstrength -= 1
	if(GET_MOB_ATTRIBUTE_VALUE(human_parent, STAT_STRENGTH) < reqstrength)
		amt2use += 2
	human_parent.add_movespeed_modifier(MOVESPEED_ID_HUMAN_CARRYING, multiplicative_slowdown = amt2use)

	if(ride_check_flags & RIDER_NEEDS_ARMS) // piggyback
		human_parent.buckle_lying = 0
		// the riding mob is made nondense so they don't bump into any dense atoms the carrier is pulling,
		// since pulled movables are moved before buckled movables
		ADD_TRAIT(riding_mob, TRAIT_UNDENSE, VEHICLE_TRAIT)
	else if(ride_check_flags & CARRIER_NEEDS_ARM) // fireman
		human_parent.buckle_lying = 90

/datum/component/riding/creature/human/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_HUMAN_MELEE_UNARMED_ATTACK, PROC_REF(on_host_unarmed_melee))
	RegisterSignal(parent, COMSIG_LIVING_SET_BODY_POSITION, PROC_REF(check_carrier_fall_over))

/datum/component/riding/creature/human/log_riding(mob/living/living_parent, mob/living/rider)
	if(!istype(living_parent) || !istype(rider))
		return

	if(ride_check_flags & RIDER_NEEDS_ARMS) // piggyback
		living_parent.log_message("started giving [rider] a piggyback ride.", LOG_GAME, color="pink")
		rider.log_message("started piggyback riding [living_parent].", LOG_GAME, color="pink")
	else if(ride_check_flags & CARRIER_NEEDS_ARM) // fireman
		living_parent.log_message("started fireman carrying [rider].", LOG_GAME, color="pink")
		rider.log_message("was fireman carried by [living_parent].", LOG_GAME, color="pink")

/datum/component/riding/creature/human/vehicle_mob_unbuckle(datum/source, mob/living/former_rider, force = FALSE)
	unequip_buckle_inhands(parent)
	var/mob/living/carbon/human/human_parent = parent
	// human_parent.remove_movespeed_modifier(/datum/movespeed_modifier/human_carry)
	human_parent.remove_movespeed_modifier(MOVESPEED_ID_HUMAN_CARRYING)
	REMOVE_TRAIT(former_rider, TRAIT_UNDENSE, VEHICLE_TRAIT)
	return ..()

/// If the carrier shoves the person they're carrying, force the carried mob off
/datum/component/riding/creature/human/proc/on_host_unarmed_melee(mob/living/source, atom/target, proximity, modifiers)
	SIGNAL_HANDLER

	if(source.used_intent.type == INTENT_DISARM && (target in source.buckled_mobs))
		force_dismount(target)
		return COMPONENT_CANCEL_ATTACK_CHAIN
	return NONE

/// If the carrier gets knocked over, force the rider(s) off and see if someone got hurt
/datum/component/riding/creature/human/proc/check_carrier_fall_over(mob/living/carbon/human/human_parent)
	SIGNAL_HANDLER

	for(var/mob/living/rider as anything in human_parent.buckled_mobs)
		human_parent.unbuckle_mob(rider)
		rider.Paralyze(1 SECONDS)
		rider.Knockdown(4 SECONDS)
		// human_parent.visible_message(
		// 	span_danger("[rider] topples off of [human_parent] as they both fall to the ground!"),
		// 	span_warning("You fall to the ground, bringing [rider] with you!"),
		// 	span_hear("You hear two consecutive thuds."),
		// 	COMBAT_MESSAGE_RANGE,
		// 	ignored_mobs = rider,
		// 	visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
		// )
		human_parent.visible_message(
			span_danger("[rider] topples off of [human_parent] as they both fall to the ground!"),
			span_warning("You fall to the ground, bringing [rider] with you!"),
			span_hear("You hear two consecutive thuds."),
			COMBAT_MESSAGE_RANGE,
			ignored_mobs = rider,
		)
		to_chat(rider, span_danger("[human_parent] falls to the ground, bringing you with [human_parent.p_them()]!"))

/datum/component/riding/creature/human/get_rider_offsets_and_layers(pass_index, mob/offsetter)
	var/mob/living/carbon/human/seat = parent
	// fireman carry
	if(seat.buckle_lying)
		return list(
			TEXT_NORTH = list(0, 6, MOB_ABOVE_PIGGYBACK_LAYER),
			TEXT_SOUTH = list(0, 6, MOB_BELOW_PIGGYBACK_LAYER),
			TEXT_EAST =  list(0, 6, MOB_BELOW_PIGGYBACK_LAYER),
			TEXT_WEST =  list(0, 6, MOB_BELOW_PIGGYBACK_LAYER),
		)
	// piggyback
	return list(
		TEXT_NORTH = list( 0, 8, MOB_ABOVE_PIGGYBACK_LAYER),
		TEXT_SOUTH = list( 0, 8, MOB_BELOW_PIGGYBACK_LAYER),
		TEXT_EAST =  list(-6, 8, MOB_BELOW_PIGGYBACK_LAYER),
		TEXT_WEST =  list( 6, 8, MOB_BELOW_PIGGYBACK_LAYER),
	)

/datum/component/riding/creature/human/get_parent_offsets_and_layers()
	return list(
		TEXT_NORTH = list(0, 0),
		TEXT_SOUTH = list(0, 0),
		TEXT_EAST =  list(0, 0),
		TEXT_WEST =  list(0, 0),
	)

/datum/component/riding/creature/human/force_dismount(mob/living/rider, throw_range = 8, throw_speed = 3, gentle = FALSE)
	var/atom/movable/seat = parent
	seat.unbuckle_mob(rider)
	rider.Paralyze(1 SECONDS)
	rider.Knockdown(4 SECONDS)
	rider.visible_message(
		span_warning("[seat] pushes [rider] off of [seat.p_them()]!"),
		span_warning("[seat] pushes you off of [seat.p_them()]!"),
	)
