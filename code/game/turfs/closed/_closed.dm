/turf/closed
	name = ""
	icon_state = "black"
	layer = CLOSED_TURF_LAYER
	opacity = TRUE
	density = TRUE
	blocks_air = TRUE
	baseturfs = /turf/open/floor/naturalstone
	smoothing_groups = SMOOTH_GROUP_CLOSED
	pass_flags_self = PASSCLOSEDTURF

	var/above_floor
	var/wallpress = TRUE
	var/wallclimb = FALSE
	var/climbdiff = 0

	var/obj/effect/skill_tracker/thieves_cant/thieves_marking

/turf/closed/basic
	baseturfs = /turf/closed/basic

/turf/closed/basic/New()//Do not convert to Initialize
	SHOULD_CALL_PARENT(FALSE)
	//This is used to optimize the map loader
	return

/turf/closed/examine(mob/user)
	. = ..()
	if(thieves_marking)
		if(thieves_marking.can_see(user))
			thieves_marking.examine(user)

/turf/closed/MouseDrop_T(atom/movable/O, mob/user)
	. = ..()
	if(!wallpress)
		return
	if(user == O && isliving(O))
		var/mob/living/L = O
		if(isanimal(L))
			var/mob/living/simple_animal/A = L
			if (!A.dextrous)
				return
		if(!HAS_TRAIT(L, TRAIT_IMMOBILIZED))
			wallpress(L)
			return

/turf/closed/get_explosion_resistance()
	return 1000000

/turf/closed/proc/feel_turf(mob/living/user)
	to_chat(user, span_notice("I start feeling around [src]"))
	if(!do_after(user, 1.5 SECONDS, src))
		return

	for(var/obj/structure/lever/hidden/lever in contents)
		lever.feel_button(user)

/turf/closed/proc/wallpress(mob/living/user)
	if(user.wallpressed)
		return
	if(user.body_position == LYING_DOWN)
		return
	var/dir2wall = get_dir(user,src)
	if(!(dir2wall in GLOB.cardinals))
		return
	user.wallpressed = dir2wall
	user.update_wallpress_slowdown()
	user.visible_message("<span class='info'>[user] leans against [src].</span>")
	switch(dir2wall)
		if(NORTH)
			user.setDir(SOUTH)
			user.add_offsets("wall_press", x_add = 0, y_add = 20)
		if(SOUTH)
			user.setDir(NORTH)
			user.add_offsets("wall_press", x_add = 0, y_add = -10)
		if(EAST)
			user.setDir(WEST)
			user.add_offsets("wall_press", x_add = 12, y_add = 0)
		if(WEST)
			user.setDir(EAST)
			user.add_offsets("wall_press", x_add = -12, y_add = 0)

/turf/closed/proc/wallshove(mob/living/user)
	if(user.wallpressed)
		return
	if(user.body_position == LYING_DOWN)
		return
	var/dir2wall = get_dir(user,src)
	if(!(dir2wall in GLOB.cardinals))
		return
	user.wallpressed = dir2wall
	user.update_wallpress_slowdown()
	switch(dir2wall)
		if(NORTH)
			user.setDir(NORTH)
			user.add_offsets("wall_press", x_add = 0, y_add = 20)
		if(SOUTH)
			user.setDir(SOUTH)
			user.add_offsets("wall_press", x_add = 0, y_add = -10)
		if(EAST)
			user.setDir(EAST)
			user.add_offsets("wall_press", x_add = 12, y_add = 0)
		if(WEST)
			user.setDir(WEST)
			user.add_offsets("wall_press", x_add = -12, y_add = 0)

/mob/living/proc/update_wallpress_slowdown()
	if(wallpressed)
		add_movespeed_modifier(MOVESPEED_ID_WALLPRESS, TRUE, 100, override = TRUE, multiplicative_slowdown = 3)
	else
		remove_movespeed_modifier(MOVESPEED_ID_WALLPRESS)

/turf/closed/Bumped(atom/movable/AM)
	..()
	if(density)
		if(ishuman(AM))
			var/mob/living/carbon/human/H = AM
			if(H.dir == get_dir(H,src) && (H.m_intent == MOVE_INTENT_RUN || HAS_TRAIT(H, TRAIT_STUMBLE)) && H.body_position != LYING_DOWN)
				H.Immobilize(10)
				H.apply_damage(15, BRUTE, BODY_ZONE_HEAD, H.run_armor_check("head", "blunt", damage = 15), damage_type = BCLASS_BLUNT)
				H.toggle_rogmove_intent(MOVE_INTENT_WALK, TRUE)
				playsound(src, "genblunt", 100, TRUE)
				H.visible_message("<span class='warning'>[H] runs into [src]!</span>", "<span class='warning'>I run into [src]!</span>")
				addtimer(CALLBACK(H, TYPE_PROC_REF(/mob/living/carbon/human, Knockdown), 10), 10)

/turf/closed/Initialize()
	. = ..()
	if(above_floor)
		var/turf/open/openspace/target = GET_TURF_ABOVE(src)
		if(istype(target))
			target.ChangeTurf(above_floor)

/turf/closed/Destroy()
	if(above_floor)
		var/turf/above = GET_TURF_ABOVE(src)
		if(above)
			if(istype(above, above_floor))
				var/count
				for(var/D in GLOB.cardinals)
					var/turf/T = get_step(above, D)
					if(T)
						var/turf/closed/C = GET_TURF_BELOW(T)
						if(istype(C))
							count++
					if(count >= 2)
						break
				if(count < 2)
					above.ScrapeAway()
	. = ..()

/turf/closed/attack_paw(mob/user)
	return attack_hand(user)

/turf/closed/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(wallclimb && isliving(user))
		. = TRUE
		if(DOING_INTERACTION(user, DOAFTER_SOURCE_CLIMBING_LADDER))
			return
		if(!user.can_z_move(UP, start = get_turf(user), z_move_flags = Z_MOVE_CLIMBING_FLAGS))
			return
		var/turf/target = GET_TURF_ABOVE(src)
		if(!target || !istype(target, /turf/open))
			to_chat(user, span_warning("I can't climb here."))
			return
		for(var/obj/structure/F in target)
			if(F && (F.density && !F.climbable))
				to_chat(user, span_warning("I can't climb here."))
				return
		INVOKE_ASYNC(src, PROC_REF(start_traveling), user, UP)

/turf/closed/proc/start_traveling(mob/living/user, direction)
	var/turf/target = get_step_multiz(src, direction)
	var/climbsound = 'sound/foley/climb.ogg'
	var/myskill = GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/misc/climbing)
	if(locate(/obj/structure/table) in user.loc)
		myskill += 1
	if(locate(/obj/structure/chair) in user.loc)
		myskill += 1
	var/obj/structure/wallladder/found_wallladder = locate() in user.loc
	if(found_wallladder)
		if(get_dir(found_wallladder.loc, src) == found_wallladder.dir)
			myskill += 8
			climbsound = 'sound/foley/ladder.ogg'

	if(myskill < climbdiff)
		to_chat(user, span_warning("I'm not capable of climbing this."))
		return
	var/used_time = max(70 - (myskill * 10) - (GET_MOB_ATTRIBUTE_VALUE(user, STAT_SPEED) * 3), 30)
	if(user.m_intent != MOVE_INTENT_SNEAK)
		playsound(user, climbsound, 100, TRUE)
	user.visible_message(span_warning("[user] starts to climb [src]."), span_warning("I start to climb [src]..."))
	if(do_after(user, used_time, src, display_over_user = TRUE, interaction_key = DOAFTER_SOURCE_CLIMBING_LADDER))
		user.zMove(target = target, z_move_flags = Z_MOVE_CLIMBING_FLAGS)
		if(user.m_intent != MOVE_INTENT_SNEAK)
			playsound(user, 'sound/foley/climb.ogg', 100, TRUE)
		user.adjust_experience(/datum/attribute/skill/misc/climbing, floor(GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE)/2) * user.get_learning_boon(/datum/attribute/skill/misc/climbing), FALSE)

/turf/closed/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	feel_turf(user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/turf/closed/attack_ghost(mob/dead/observer/user)
	if(!user.Adjacent(src))
		return
	var/turf/target = GET_TURF_ABOVE(get_turf(user))
	if(!target)
		to_chat(user, "<span class='warning'>I can't go there.</span>")
		return
	if(!istype(target, /turf/open/openspace))
		to_chat(user, "<span class='warning'>I can't go there.</span>")
		return
	user.forceMove(target)
	to_chat(user, "<span class='warning'>I crawl up the wall.</span>")
	. = ..()

/turf/closed/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	return FALSE

/turf/closed/indestructible
	name = "wall"
	icon = 'icons/turf/walls.dmi'
	explosion_block = 50

/turf/closed/indestructible/TerraformTurf(path, new_baseturf, flags, defer_change = FALSE, ignore_air = FALSE)
	return

/turf/closed/indestructible/acid_act(acidpwr, acid_volume, acid_id)
	return 0

/turf/closed/indestructible/Melt()
	to_be_destroyed = FALSE
	return src

// Dakkatown Turfs
/turf/closed/indestructible/wooddark
	name = "wall"
	desc = ""
	icon = 'icons/turf/walls.dmi'
	icon_state = "corner"

/turf/closed/indestructible/roguewindow
	name = "window"
	desc = ""
	opacity = FALSE
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "window-solid"

// Boat
/turf/closed/indestructible/wooddark/hull
	name = "hull"
	color = "#d6d5a8"

/turf/closed/indestructible/wooddark/mast
	name = "mast"
	color = "#a6a68b"
