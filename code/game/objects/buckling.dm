/atom/movable
	var/can_buckle = 0
	/// Bed-like behaviour, forces mob.lying = buckle_lying if not set to [NO_BUCKLE_LYING].
	var/buckle_lying = NO_BUCKLE_LYING
	var/buckle_requires_restraints = 0 //require people to be handcuffed before being able to buckle. eg: pipes
	var/list/mob/living/buckled_mobs = null //list()
	var/max_buckled_mobs = 1
	var/buckle_prevents_pull = FALSE
	var/buckleverb = "sit"
	var/sleepy = 0

//Interaction
/atom/movable/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(can_buckle && has_buckled_mobs())
		if(length(buckled_mobs) > 1)
			var/unbuckled = input(user, "Who do you wish to remove?","?") as null|mob in sortNames(buckled_mobs)
			if(isnull(unbuckled))
				return
			if(user_unbuckle_mob(unbuckled,user))
				return 1
		else
			if(user_unbuckle_mob(buckled_mobs[1],user))
				return 1

/atom/movable/MouseDrop_T(mob/living/M, mob/living/user)
	. = ..()
	return mouse_buckle_handling(M, user)

/atom/movable/proc/mouse_buckle_handling(mob/living/M, mob/living/user)
	if(can_buckle && istype(M) && istype(user))
		if(user_buckle_mob(M, user))
			return TRUE

/atom/movable/proc/has_buckled_mobs()
	if(length(buckled_mobs))
		return TRUE
	return FALSE

//procs that handle the actual buckling and unbuckling
/atom/movable/proc/buckle_mob(mob/living/M, force = FALSE, check_loc = TRUE)
	if(!buckled_mobs)
		buckled_mobs = list()

	if(!istype(M))
		return FALSE

	if(check_loc && M.loc != loc)
		return FALSE

	if((!can_buckle && !force) || M.buckled || (buckled_mobs.len >= max_buckled_mobs) || (buckle_requires_restraints && !HAS_TRAIT(M, TRAIT_RESTRAINED)) || M == src)
		return FALSE

	// This signal will check if the mob is mounting this atom to ride it. There are 3 possibilities for how this goes
	// 1. This movable doesn't have a ridable element and can't be ridden, so nothing gets returned, so continue on
	// 2. There's a ridable element but we failed to mount it for whatever reason (maybe it has no seats left, for example), so we cancel the buckling
	// 3. There's a ridable element and we were successfully able to mount, so keep it going and continue on with buckling
	if(SEND_SIGNAL(src, COMSIG_MOVABLE_PREBUCKLE, M, force) & COMPONENT_BLOCK_BUCKLE)
		return FALSE

	M.buckling = src
	if(!M.can_buckle() && !force)
		if(M == usr)
			to_chat(M, "<span class='warning'>I am unable to [buckleverb] on [src].</span>")
		else
			to_chat(usr, "<span class='warning'>I am unable to [buckleverb] [M] on [src].</span>")
		M.buckling = null
		return FALSE

	if(M.pulledby)
		if(buckle_prevents_pull)
			M.pulledby.stop_pulling()
		else if(isliving(M.pulledby))
			var/mob/living/living_mob = M.pulledby
			living_mob.reset_pull_offsets(M, TRUE)

	if(!check_loc && M.loc != loc)
		M.forceMove(loc)

	M.buckling = null
	if(anchored)
		ADD_TRAIT(M, TRAIT_NO_FLOATING_ANIM, BUCKLED_TRAIT)
	//if(!length(buckled_mobs))
		//RegisterSignal(src, COMSIG_MOVABLE_SET_ANCHORED, PROC_REF(on_set_anchored))
	M.set_buckled(src)
	M.setDir(dir)
	buckled_mobs |= M
	M.throw_alert("buckled", /atom/movable/screen/alert/restrained/buckled)
	M.set_glide_size(glide_size)
	post_buckle_mob(M)

	SEND_SIGNAL(src, COMSIG_MOVABLE_BUCKLE, M, force)
	return TRUE

/obj/buckle_mob(mob/living/M, force = FALSE, check_loc = TRUE)
	. = ..()
	if(.)
		if(resistance_flags & ON_FIRE) //Sets the mob on fire if you buckle them to a burning atom/movableect
			M.adjust_fire_stacks(1)
			M.IgniteMob()

/atom/movable/proc/unbuckle_mob(mob/living/buckled_mob, force = FALSE)
	if(!isliving(buckled_mob))
		CRASH("Non-living [buckled_mob] thing called unbuckle_mob() for source.")
	if(buckled_mob.buckled != src)
		CRASH("[buckled_mob] called unbuckle_mob() for source while having buckled as [buckled_mob.buckled].")
	if(!force && !buckled_mob.can_unbuckle())
		return
	. = buckled_mob
	buckled_mob.set_buckled(null)
	buckled_mob.anchored = initial(buckled_mob.anchored)
	buckled_mob.clear_alert("buckled")
	buckled_mob.set_glide_size(DELAY_TO_GLIDE_SIZE(buckled_mob.total_multiplicative_slowdown()))
	buckled_mobs -= buckled_mob
	if(anchored)
		REMOVE_TRAIT(buckled_mob, TRAIT_NO_FLOATING_ANIM, BUCKLED_TRAIT)
	//if(!length(buckled_mobs))
		//UnregisterSignal(src, COMSIG_MOVABLE_SET_ANCHORED, PROC_REF(on_set_anchored))
	SEND_SIGNAL(src, COMSIG_MOVABLE_UNBUCKLE, buckled_mob, force)
	post_unbuckle_mob(.)

/atom/movable/proc/on_set_anchored(atom/movable/source, anchorvalue)
	SIGNAL_HANDLER
	for(var/_buckled_mob in buckled_mobs)
		if(!_buckled_mob)
			continue
		var/mob/living/buckled_mob = _buckled_mob
		if(anchored)
			ADD_TRAIT(buckled_mob, TRAIT_NO_FLOATING_ANIM, BUCKLED_TRAIT)
		else
			REMOVE_TRAIT(buckled_mob, TRAIT_NO_FLOATING_ANIM, BUCKLED_TRAIT)

/atom/movable/proc/unbuckle_all_mobs(force=FALSE)
	if(!has_buckled_mobs())
		return
	for(var/m in buckled_mobs)
		unbuckle_mob(m, force)

//Handle any extras after buckling
//Called on buckle_mob()
/atom/movable/proc/post_buckle_mob(mob/living/M)
	M.update_wallpress()

//same but for unbuckle
/atom/movable/proc/post_unbuckle_mob(mob/living/M)

//Wrapper procs that handle sanity and user feedback
/atom/movable/proc/user_buckle_mob(mob/living/M, mob/user, check_loc = TRUE)
	if(!in_range(user, src) || !isturf(user.loc) || user.incapacitated(IGNORE_GRAB) || M.anchored)
		return FALSE

	add_fingerprint(user)
	. = buckle_mob(M, check_loc = check_loc)
	if(.)
		if(M == user)
			M.visible_message("<span class='notice'>[M] [buckleverb]s on [src].</span>",\
				"<span class='notice'>I [buckleverb] on [src].</span>")
		else
			M.visible_message("<span class='warning'>[user] [buckleverb]s [M] on [src]!</span>",\
				"<span class='warning'>[user] [buckleverb]s me on [src]!</span>")

/atom/movable/proc/user_unbuckle_mob(mob/living/buckled_mob, mob/user)
	var/mob/living/M = unbuckle_mob(buckled_mob)
	if(M)
		if(M != user)
			M.visible_message("<span class='notice'>[user] pulls [M] from [src].</span>",\
				"<span class='notice'>[user] pulls me from [src].</span>",\
				"<span class='hear'>I hear metal clanking.</span>")
		else
			M.visible_message("<span class='notice'>[M] gets off of [src].</span>",\
				"<span class='notice'>I get off of [src].</span>",\
				"<span class='hear'>I hear metal clanking.</span>")
		add_fingerprint(user)
		if(isliving(M.pulledby))
			var/mob/living/L = M.pulledby
			L.set_pull_offsets(M, L.grab_state)
	return M
