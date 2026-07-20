// For any mob that can be ridden

/datum/component/riding/creature
	/// If TRUE, this creature's movements can be controlled by the rider while mounted (as opposed to riding cyborgs and humans, which is passive)
	var/can_be_driven = TRUE
	/// If TRUE, this creature's abilities can be triggered by the rider while mounted
	var/can_use_abilities = FALSE
	/// Do we use vehicle_move_delay or default to mob's own movespeed?
	var/uses_native_speed = FALSE
	/// unsharable abilities that we will force to be shared anyway
	var/list/override_unsharable_abilities = list()
	/// abilities that are always blacklisted from sharing
	var/list/blacklist_abilities = list()
	/// flag that determine how our ai acts while ridden
	var/ai_behavior_while_ridden = RIDING_PAUSE_AI_PLANNING | RIDING_PAUSE_AI_MOVEMENT

/datum/component/riding/creature/Initialize(mob/living/riding_mob, force = FALSE, ride_check_flags = NONE)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	. = ..()
	var/mob/living/living_parent = parent
	// living_parent.stop_pulling() // was only used on humans previously, may change some other behavior
	log_riding(living_parent, riding_mob)
	riding_mob.set_glide_size(living_parent.glide_size)
	update_parent_layer_and_offsets(living_parent.dir)

	if(can_use_abilities)
		setup_abilities(riding_mob)

/datum/component/riding/creature/Destroy(force)
	unequip_buckle_inhands(parent)
	parent.remove_traits(list(TRAIT_AI_PAUSED, TRAIT_AI_MOVEMENT_HALTED), REF(src))
	return ..()

/datum/component/riding/creature/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_MOB_EMOTE, PROC_REF(check_emote))
	if(can_be_driven)
		RegisterSignal(parent, COMSIG_RIDDEN_DRIVER_MOVE, PROC_REF(driver_move)) // this isn't needed on riding humans or cyborgs since the rider can't control them

/// Creatures need to be logged when being mounted
/datum/component/riding/creature/proc/log_riding(mob/living/living_parent, mob/living/rider)
	if(!istype(living_parent) || !istype(rider))
		return

	living_parent.log_message("is now being ridden by [rider].", LOG_GAME, color="pink")
	rider.log_message("started riding [living_parent].", LOG_GAME, color="pink")

// this applies to humans and most creatures, but is replaced again for cyborgs
/datum/component/riding/creature/ride_check(mob/living/rider, consequences = TRUE)
	. = TRUE
	var/mob/living/living_parent = parent

	if(living_parent.body_position != STANDING_UP) // if we move while on the ground, the rider falls off
		. = FALSE
	// for piggybacks and (redundant?) borg riding, check if the rider is stunned/restrained
	else if((ride_check_flags & RIDER_NEEDS_ARMS) && (HAS_TRAIT(rider, TRAIT_RESTRAINED) || rider.incapacitated(IGNORE_GRAB|IGNORE_RESTRAINTS)))
		. = FALSE
	// for fireman carries, check if the ridden is stunned/restrained
	else if((ride_check_flags & CARRIER_NEEDS_ARM) && (HAS_TRAIT(living_parent, TRAIT_RESTRAINED) || living_parent.incapacitated(IGNORE_GRAB|IGNORE_RESTRAINTS)))
		. = FALSE
	else if((ride_check_flags & JUST_FRIEND_RIDERS) && !(living_parent.has_ally(rider)))
		. = FALSE

	if(. || !consequences)
		return

	rider.visible_message(span_warning("[rider] falls off of [living_parent]!"), \
					span_warning("I fall off of [living_parent]!"))
	rider.Paralyze(1 SECONDS)
	rider.Knockdown(4 SECONDS)
	living_parent.unbuckle_mob(rider)

/datum/component/riding/creature/vehicle_mob_buckle(mob/living/ridden, mob/living/rider, force = FALSE)
	// Ensure that the /mob/post_buckle_mob(mob/living/M) does not mess us up with layers
	// If we do not do this override we'll be stuck with the above proc (+ 0.1)-ing our rider's layer incorrectly
	rider.layer = initial(rider.layer)
	if(can_be_driven)
		//let the player take over if they should be controlling movement
		if(ai_behavior_while_ridden & RIDING_PAUSE_AI_PLANNING)
			ADD_TRAIT(ridden, TRAIT_AI_PAUSED, REF(src))
		if(ai_behavior_while_ridden & RIDING_PAUSE_AI_MOVEMENT)
			ADD_TRAIT(ridden, TRAIT_AI_MOVEMENT_HALTED, REF(src))

	if(ishostile(ridden))
		var/mob/living/simple_animal/hostile/hostile_ridden = ridden
		vehicle_move_delay = hostile_ridden.move_to_delay
	return ..()

/datum/component/riding/creature/vehicle_mob_unbuckle(mob/living/formerly_ridden, mob/living/former_rider, force = FALSE)
	if(istype(formerly_ridden) && istype(former_rider))
		formerly_ridden.log_message("is no longer being ridden by [former_rider].", LOG_GAME, color="pink")
		former_rider.log_message("is no longer riding [formerly_ridden].", LOG_GAME, color="pink")
	remove_abilities(former_rider)
	if(!formerly_ridden.buckled_mobs.len)
		formerly_ridden.remove_traits(list(TRAIT_AI_PAUSED, TRAIT_AI_MOVEMENT_HALTED), REF(src))
	// We gotta reset those layers at some point, don't we?
	former_rider.layer = MOB_LAYER
	formerly_ridden.layer = MOB_LAYER
	return ..()

/datum/component/riding/creature/driver_move(atom/movable/movable_parent, mob/living/user, direction, actual_move_delay)
	if(!COOLDOWN_FINISHED(src, vehicle_move_cooldown))
		return COMPONENT_DRIVER_BLOCK_MOVE
	if(!keycheck(user))
		if(ispath(keytype, /obj/item))
			var/obj/item/key = keytype
			to_chat(user, span_warning("You need a [initial(key.name)] to ride [movable_parent]!"))
		return COMPONENT_DRIVER_BLOCK_MOVE
	var/mob/living/living_parent = parent
	step(living_parent, direction)
	var/modified_move_delay = uses_native_speed ? living_parent.cached_multiplicative_slowdown : vehicle_move_delay
	modified_move_delay *= 0.45 // so ridden animals are faster in general than their AI movement speed
	if(user.m_intent == MOVE_INTENT_RUN)
		modified_move_delay *= 0.7

	var/riding_skill = GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/misc/riding)
	modified_move_delay *= 1 - min(0.4 * (riding_skill/6), 0.9) //40% reduction at legendary riding

	if(NSCOMPONENT(direction) && EWCOMPONENT(direction))
		modified_move_delay = FLOOR(modified_move_delay * sqrt(2), world.tick_lag)
	COOLDOWN_START(src, vehicle_move_cooldown, modified_move_delay)

	user.adjust_experience(/datum/attribute/skill/misc/riding, (GET_MOB_ATTRIBUTE_VALUE(user, STAT_ENDURANCE)*0.02) * user.get_learning_boon(/datum/attribute/skill/misc/riding))

	return ..(movable_parent, user, direction, actual_move_delay = modified_move_delay)

/// Yeets the rider off, used for animals and cyborgs, redefined for humans who shove their piggyback rider off
/datum/component/riding/creature/proc/force_dismount(mob/living/rider, throw_range = 8, throw_speed = 3, gentle = FALSE)
	var/atom/movable/movable_parent = parent
	movable_parent.unbuckle_mob(rider)
	rider.Knockdown(3 SECONDS)
	if(throw_range == 0)
		return
	if(!isanimal(movable_parent))
		return
	var/turf/target = get_edge_target_turf(movable_parent, movable_parent.dir)
	rider.visible_message(span_warning("[rider] is thrown clear of [movable_parent]!"), \
	span_warning("You're thrown clear of [movable_parent]!"))
	rider.throw_at(target, throw_range, throw_speed, movable_parent, gentle = gentle)

/// If we're a cyborg or animal and we spin, we yeet whoever's on us off us
/datum/component/riding/creature/proc/check_emote(mob/living/user, datum/emote/emote)
	SIGNAL_HANDLER
	if(!isanimal(user) || !istype(emote, /datum/emote/spin))
		return

	for(var/mob/yeet_mob in user.buckled_mobs)
		force_dismount(yeet_mob, gentle = !user.cmode) // gentle on help, byeeee if not

/// If the ridden creature has abilities, and some var yet to be made is set to TRUE, the rider will be able to control those abilities
/datum/component/riding/creature/proc/setup_abilities(mob/living/rider)
	if(!isliving(parent))
		return

	var/mob/living/ridden_creature = parent

	for(var/datum/action/action as anything in ridden_creature.actions)
		if(is_type_in_list(action, blacklist_abilities))
			continue
		if(!action.can_be_shared && !is_type_in_list(action, override_unsharable_abilities))
			continue
		action.GiveAction(rider)

/// Takes away the riding parent's abilities from the rider
/datum/component/riding/creature/proc/remove_abilities(mob/living/rider)
	if(!isliving(parent))
		return

	var/mob/living/ridden_creature = parent

	for(var/datum/action/action as anything in ridden_creature.actions)
		if(istype(action, /datum/action/cooldown) && rider.click_intercept == action)
			var/datum/action/cooldown/cooldown_action = action
			cooldown_action.unset_click_ability(rider, refund_cooldown = TRUE)
		action.HideFrom(rider)

/datum/component/riding/creature/riding_can_z_move(atom/movable/movable_parent, direction, turf/start, turf/destination, z_move_flags, mob/living/rider)
	if(!(z_move_flags & ZMOVE_CAN_FLY_CHECKS))
		return COMPONENT_RIDDEN_ALLOW_Z_MOVE
	if(!can_be_driven)
		if(z_move_flags & ZMOVE_FEEDBACK)
			to_chat(rider, span_warning("[movable_parent] cannot be driven around. Unbuckle from [movable_parent.p_them()] first."))
		return COMPONENT_RIDDEN_STOP_Z_MOVE
	if(!ride_check(rider, FALSE))
		if(z_move_flags & ZMOVE_FEEDBACK)
			to_chat(rider, span_warning("You're unable to ride [movable_parent] right now!"))
		return COMPONENT_RIDDEN_STOP_Z_MOVE
	return COMPONENT_RIDDEN_ALLOW_Z_MOVE
