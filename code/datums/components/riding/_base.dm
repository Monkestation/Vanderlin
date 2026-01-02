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

/datum/component/riding/proc/force_dismount(mob/living/M)
	var/atom/movable/AM = parent
	AM.unbuckle_mob(M)

/datum/component/riding/proc/handle_vehicle_offsets()
	var/atom/movable/AM = parent
	var/AM_dir = "[AM.dir]"
	var/passindex = 0
	if(AM.has_buckled_mobs())
		for(var/m in AM.buckled_mobs)
			passindex++
			var/mob/living/buckled_mob = m
			var/list/offsets = get_offsets(passindex)
			var/rider_dir = get_rider_dir(passindex)
			buckled_mob.setDir(rider_dir)
			dir_loop:
				for(var/offsetdir in offsets)
					if(offsetdir == AM_dir)
						var/list/diroffsets = offsets[offsetdir]
						var/x2off
						var/y2off
						x2off = diroffsets[1]
						if(diroffsets.len >= 2)
							y2off = diroffsets[2]
						if(diroffsets.len == 3)
							buckled_mob.layer = diroffsets[3]
						buckled_mob.set_mob_offsets("riding", _x = x2off, _y = y2off)
						break dir_loop
	var/static/list/default_vehicle_pixel_offsets = list(TEXT_NORTH = list(0, 0), TEXT_SOUTH = list(0, 0), TEXT_EAST = list(0, 0), TEXT_WEST = list(0, 0))
/*	var/px = default_vehicle_pixel_offsets[AM_dir]
	var/py = default_vehicle_pixel_offsets[AM_dir]
	if(directional_vehicle_offsets[AM_dir])
		if(isnull(directional_vehicle_offsets[AM_dir]))
			px = AM.pixel_x
			py = AM.pixel_y
		else
			px = directional_vehicle_offsets[AM_dir][1]
			py = directional_vehicle_offsets[AM_dir][2]
	AM.pixel_x = px
	AM.pixel_y = py*/

/datum/component/riding/proc/set_vehicle_dir_offsets(dir, x, y)
	directional_vehicle_offsets["[dir]"] = list(x, y)

//Override this to set my vehicle's various pixel offsets
/datum/component/riding/proc/get_offsets(pass_index) // list(dir = x, y, layer)
	. = list(TEXT_NORTH = list(0, 0), TEXT_SOUTH = list(0, 0), TEXT_EAST = list(0, 0), TEXT_WEST = list(0, 0))
	if(riding_offsets["[pass_index]"])
		. = riding_offsets["[pass_index]"]
	else if(riding_offsets["[RIDING_OFFSET_ALL]"])
		. = riding_offsets["[RIDING_OFFSET_ALL]"]

/datum/component/riding/proc/set_riding_offsets(index, list/offsets)
	if(!islist(offsets))
		return FALSE
	riding_offsets["[index]"] = offsets

//Override this to set the passengers/riders dir based on which passenger they are.
//ie: rider facing the vehicle's dir, but passenger 2 facing backwards, etc.
/datum/component/riding/proc/get_rider_dir(pass_index)
	var/atom/movable/AM = parent
	return AM.dir

//BUCKLE HOOKS
/datum/component/riding/proc/restore_position(mob/living/buckled_mob)
	if(buckled_mob)
		buckled_mob.reset_offsets("riding")
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
