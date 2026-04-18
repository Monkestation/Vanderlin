
/// Offsets applied for people riding something
#define RIDING_SOURCE "riding"
/// Offsets applied for something being ridden
#define BEING_RIDDEN_SOURCE "being_ridden"

/datum/component/riding
	var/last_vehicle_move = 0 //used for move delays
	var/last_move_diagonal = FALSE
	var/vehicle_move_delay = 2 //tick delay between movements, lower = faster, higher = slower

	var/slowed = FALSE
	var/slowvalue = 1

	/// position_of_user = list(dir = list(px, py)), or RIDING_OFFSET_ALL for a generic one.
	var/list/riding_offsets = list()
	/// ["[DIRECTION]"] = layer. Don't set it for a direction for default, set a direction to null for no change.
	var/list/directional_vehicle_layers = list()
	/// same as above but instead of layer you have a list(px, py)
	var/list/directional_vehicle_offsets = list()
	/// allow typecache for only certain turfs, forbid to allow all but those. allow only certain turfs will take precedence.
	var/list/allowed_turf_typecache
	/// allow typecache for only certain turfs, forbid to allow all but those. allow only certain turfs will take precedence.
	var/list/forbid_turf_typecache

	/// We don't need roads where we're going if this is TRUE, allow normal movement in space tiles
	var/override_allow_spacemove = FALSE

	var/allow_one_away_from_valid_turf = TRUE		//allow moving one tile away from a valid turf but not more.
	var/drive_verb = "drive"
	var/ride_check_rider_incapacitated = FALSE
	var/ride_check_rider_restrained = FALSE
	var/ride_check_ridden_incapacitated = FALSE

	var/del_on_unbuckle_all = FALSE

/datum/component/riding/Initialize()
	if(!ismovableatom(parent))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(parent, COMSIG_MOVABLE_BUCKLE, PROC_REF(vehicle_mob_buckle))
	RegisterSignal(parent, COMSIG_MOVABLE_UNBUCKLE, PROC_REF(vehicle_mob_unbuckle))
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(vehicle_moved))
	RegisterSignal(parent, COMSIG_BUCKLED_CAN_Z_MOVE, PROC_REF(riding_can_z_move))

/datum/component/riding/proc/vehicle_mob_unbuckle(datum/source, mob/living/M, force = FALSE)
	var/atom/movable/AM = parent
	AM.ai_controller?.set_blackboard_key(BB_IS_BEING_RIDDEN, FALSE)
	restore_position(M)
	unequip_buckle_inhands(M)
	M.updating_glide_size = TRUE
	if(del_on_unbuckle_all && !AM.has_buckled_mobs())
		qdel(src)

/datum/component/riding/proc/vehicle_mob_buckle(datum/source, mob/living/M, force = FALSE)
	var/atom/movable/AM = parent
	AM.ai_controller?.set_blackboard_key(BB_IS_BEING_RIDDEN, TRUE)
	M.set_glide_size(AM.glide_size)
	M.updating_glide_size = FALSE

	handle_vehicle_offsets()

/datum/component/riding/proc/handle_vehicle_layer()
	var/atom/movable/AM = parent
	var/static/list/defaults = list(TEXT_NORTH = OBJ_LAYER, TEXT_SOUTH = ABOVE_MOB_LAYER, TEXT_EAST = ABOVE_MOB_LAYER, TEXT_WEST = ABOVE_MOB_LAYER)
	. = defaults["[AM.dir]"]
	if(directional_vehicle_layers["[AM.dir]"])
		. = directional_vehicle_layers["[AM.dir]"]
	if(isnull(.))	//you can set it to null to not change it.
		. = AM.layer
	AM.layer = .

/datum/component/riding/proc/set_vehicle_dir_layer(dir, layer)
	directional_vehicle_layers["[dir]"] = layer

/datum/component/riding/proc/vehicle_moved(datum/source)
	var/atom/movable/AM = parent
	AM.set_glide_size(DELAY_TO_GLIDE_SIZE(vehicle_move_delay))
	for(var/mob/M in AM.buckled_mobs)
		ride_check(M)
		M.set_glide_size(AM.glide_size)
	handle_vehicle_offsets()
	handle_vehicle_layer()

/datum/component/riding/proc/ride_check(mob/living/M)
	var/atom/movable/AM = parent
	var/mob/AMM = AM
	if((ride_check_rider_restrained && HAS_TRAIT(M, TRAIT_RESTRAINED)) || (ride_check_rider_incapacitated && M.incapacitated(IGNORE_GRAB)) || (ride_check_ridden_incapacitated && istype(AMM) && AMM.incapacitated(IGNORE_GRAB)))
		M.visible_message("<span class='warning'>[M] falls off of [AM]!</span>", \
						"<span class='warning'>I fall off of [AM]!</span>")
		AM.unbuckle_mob(M)
	return TRUE

#define GET_X_OFFSET(offsets) (length(offsets) >= 1 ? offsets[1] : 0)
#define GET_Y_OFFSET(offsets) (length(offsets) >= 2 ? offsets[2] : 0)
#define GET_LAYER(offsets, default) (length(offsets) >= 3 ? offsets[3] : default)

/datum/component/riding/proc/update_rider_layer_and_offsets(dir, passindex, mob/living/rider, animate = FALSE)
	if(rider.dir != dir)
		rider.setDir(dir)

	var/list/diroffsets = get_rider_offsets_and_layers(passindex, rider)?["[dir]"]
	var/x_offset = GET_X_OFFSET(diroffsets)
	var/y_offset = GET_Y_OFFSET(diroffsets)
	var/layer = GET_LAYER(diroffsets, rider.layer)

	// if they are intended to be buckled, offset their existing offset
	var/atom/movable/seat = parent
	if(seat.buckle_lying && rider.body_position == LYING_DOWN)
		y_offset += (-1 * PIXEL_Y_OFFSET_LYING)

	// Rider uses pixel_z offsets as they're above the turf, not up north on the turf
	rider.add_offsets(RIDING_SOURCE, x_add = x_offset, z_add = y_offset, animate = animate)
	rider.layer = layer

#undef GET_X_OFFSET
#undef GET_Y_OFFSET
#undef GET_LAYER

/datum/component/riding/proc/force_dismount(mob/living/M)
	var/atom/movable/AM = parent
	AM.unbuckle_mob(M)

/datum/component/riding/proc/handle_vehicle_offsets()
	var/atom/movable/seat = parent
	if(!seat.has_buckled_mobs())
		return

	var/passindex = 0
	for(var/mob/living/buckled_mob as anything in seat.buckled_mobs)
		passindex++
		update_rider_layer_and_offsets(get_rider_dir(passindex), passindex, buckled_mob)

/datum/component/riding/proc/set_vehicle_dir_offsets(dir, x, y)
	directional_vehicle_offsets["[dir]"] = list(x, y)

/**
 * Determines where riders get offset while riding
 *
 * * pass_index: The index of the rider in the list of buckled mobs
 * * mob/offsetter: The mob that is being offset
 */
/datum/component/riding/proc/get_rider_offsets_and_layers(pass_index, mob/offsetter) as /list // list(dir = x, y, layer)
	RETURN_TYPE(/list)
	return list(
		TEXT_NORTH = list(0, 0),
		TEXT_SOUTH = list(0, 0),
		TEXT_EAST =  list(0, 0),
		TEXT_WEST =  list(0, 0),
	)

//Override this to set the passengers/riders dir based on which passenger they are.
//ie: rider facing the vehicle's dir, but passenger 2 facing backwards, etc.
/datum/component/riding/proc/get_rider_dir(pass_index)
	var/atom/movable/AM = parent
	return AM.dir

//BUCKLE HOOKS
/datum/component/riding/proc/restore_position(mob/living/buckled_mob)
	if(buckled_mob)
		buckled_mob.remove_offsets("riding")
		if(buckled_mob.client)
			buckled_mob.client.view_size.resetToDefault()

//MOVEMENT
/datum/component/riding/proc/turf_check(turf/next, turf/current)
	if(allowed_turf_typecache && !allowed_turf_typecache[next.type])
		return (allow_one_away_from_valid_turf && allowed_turf_typecache[current.type])
	else if(forbid_turf_typecache && forbid_turf_typecache[next.type])
		return (allow_one_away_from_valid_turf && !forbid_turf_typecache[current.type])
	return TRUE

/datum/component/riding/proc/handle_ride(mob/user, direction)
	var/atom/movable/AM = parent
	if(user.incapacitated(IGNORE_GRAB))
		Unbuckle(user)
		return

	if(world.time < last_vehicle_move + ((last_move_diagonal? 2 : 1) * vehicle_move_delay))
		return
	last_vehicle_move = world.time

	var/turf/next = get_step(AM, direction)
	var/turf/current = get_turf(AM)
	if(!istype(next) || !istype(current))
		return	//not happening.
	if(!turf_check(next, current))
		to_chat(user, "<span class='warning'>My \the [AM] can not go onto [next]!</span>")
		return
	if(!isturf(AM.loc))
		return
	step(AM, direction)

	if((direction & (direction - 1)) && (AM.loc == next))		//moved diagonally
		last_move_diagonal = TRUE
	else
		last_move_diagonal = FALSE

	handle_vehicle_layer()
	handle_vehicle_offsets()

	SEND_SIGNAL(AM, COMSIG_RIDDEN_DRIVER_MOVE, user, direction)
	return TRUE

/datum/component/riding/proc/Unbuckle(atom/movable/M)
	addtimer(CALLBACK(parent, TYPE_PROC_REF(/atom/movable, unbuckle_mob), M), 0, TIMER_UNIQUE)


/datum/component/riding/proc/account_limbs(mob/living/M)
	if(M.usable_legs < 2 && !slowed)
		vehicle_move_delay = vehicle_move_delay + slowvalue
		slowed = TRUE
	else if(slowed)
		vehicle_move_delay = vehicle_move_delay - slowvalue
		slowed = FALSE

/datum/component/riding/proc/equip_buckle_inhands(mob/living/carbon/human/user, amount_required = 1, riding_target_override = null)
	var/atom/movable/AM = parent
	var/amount_equipped = 0
	for(var/amount_needed = amount_required, amount_needed > 0, amount_needed--)
		var/obj/item/riding_offhand/inhand = new /obj/item/riding_offhand(user)
		if(!riding_target_override)
			inhand.rider = user
		else
			inhand.rider = riding_target_override
		inhand.parent = AM
		if(user.put_in_hands(inhand, TRUE))
			amount_equipped++
		else
			break
	if(amount_equipped >= amount_required)
		return TRUE
	else
		unequip_buckle_inhands(user)
		return FALSE

/datum/component/riding/proc/unequip_buckle_inhands(mob/living/carbon/user)
	var/atom/movable/AM = parent
	for(var/obj/item/riding_offhand/O in user.contents)
		if(O.parent != AM)
			stack_trace("RIDING OFFHAND ON WRONG MOB")
			continue
		if(O.selfdeleting)
			continue
		else
			qdel(O)
	return TRUE

/// Extra checks before buckled.can_z_move can be called in mob/living/can_z_move()
/datum/component/riding/proc/riding_can_z_move(atom/movable/movable_parent, direction, turf/start, turf/destination, z_move_flags, mob/living/rider)
	SIGNAL_HANDLER
	return COMPONENT_RIDDEN_ALLOW_Z_MOVE

/obj/item/riding_offhand
	name = "offhand"
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "offhand"
	w_class = WEIGHT_CLASS_HUGE
	item_flags = ABSTRACT | DROPDEL | NOBLUDGEON
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/mob/living/carbon/rider
	var/mob/living/parent
	var/selfdeleting = FALSE

/obj/item/riding_offhand/dropped()
	selfdeleting = TRUE
	. = ..()

/obj/item/riding_offhand/equipped()
	if(loc != rider && loc != parent)
		selfdeleting = TRUE
		qdel(src)
	. = ..()

/obj/item/riding_offhand/Destroy()
	var/atom/movable/AM = parent
	if(selfdeleting)
		if(rider in AM.buckled_mobs)
			AM.unbuckle_mob(rider)
	. = ..()

#undef RIDING_SOURCE
#undef BEING_RIDDEN_SOURCE
