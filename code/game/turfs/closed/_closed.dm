/turf/closed
	name = ""
	icon_state = "black"
	layer = CLOSED_TURF_LAYER
	opacity = 1
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
			user.set_mob_offsets("wall_press", _x = 0, _y = 20)
		if(SOUTH)
			user.setDir(NORTH)
			user.set_mob_offsets("wall_press", _x = 0, _y = -10)
		if(EAST)
			user.setDir(WEST)
			user.set_mob_offsets("wall_press", _x = 12, _y = 0)
		if(WEST)
			user.setDir(EAST)
			user.set_mob_offsets("wall_press", _x = -12, _y = 0)

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
			user.set_mob_offsets("wall_press", _x = 0, _y = 20)
		if(SOUTH)
			user.setDir(SOUTH)
			user.set_mob_offsets("wall_press", _x = 0, _y = -10)
		if(EAST)
			user.setDir(EAST)
			user.set_mob_offsets("wall_press", _x = 12, _y = 0)
		if(WEST)
			user.setDir(WEST)
			user.set_mob_offsets("wall_press", _x = -12, _y = 0)

/mob/living/proc/update_wallpress_slowdown()
	if(wallpressed)
		add_movespeed_modifier("wallpress", TRUE, 100, override = TRUE, multiplicative_slowdown = 3)
	else
		remove_movespeed_modifier("wallpress")

/turf/closed/Bumped(atom/movable/AM)
	..()
	if(density)
		if(ishuman(AM))
			var/mob/living/carbon/human/H = AM
			if(H.dir == get_dir(H,src) && H.m_intent == MOVE_INTENT_RUN && H.body_position != LYING_DOWN)
				H.Immobilize(10)
				H.apply_damage(15, BRUTE, "head", H.run_armor_check("head", "blunt", damage = 15))
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
	if(wallclimb)
		if(isliving(user))
			var/turf/user_turf = get_turf(user)
			var/mob/living/L = user
			var/climbsound = 'sound/foley/climb.ogg'
			if(L.stat != CONSCIOUS)
				return
			var/turf/target = GET_TURF_ABOVE(user_turf)
			if(!istype(target, /turf/open/openspace))
				to_chat(user, "<span class='warning'>I can't climb here.</span>")
				return
			if(!L.can_zTravel(target, UP))
				to_chat(user, "<span class='warning'>I can't climb there.</span>")
				return
			target = GET_TURF_ABOVE(src)
			if(!target || istype(target, /turf/closed) || istype(target, /turf/open/openspace))
				target = GET_TURF_ABOVE(user_turf)
				if(!target || !istype(target, /turf/open/openspace))
					to_chat(user, "<span class='warning'>I can't climb here.</span>")
					return
			for(var/obj/structure/F in target)
				if(F && (F.density && !F.climbable))
					to_chat(user, "<span class='warning'>I can't climb here.</span>")
					return
			var/used_time = 0
			var/amt2raise = 0
			var/boon = 0
			if(L.mind)
				var/myskill = L.get_skill_level(/datum/skill/misc/climbing, TRUE)
				amt2raise = floor(L.STAINT/2)
				boon = L.get_learning_boon(/datum/skill/misc/climbing)
				var/obj/structure/table/TA = locate() in L.loc
				if(TA)
					myskill += 1
				else
					var/obj/structure/chair/CH = locate() in L.loc
					if(CH)
						myskill += 1
					var/obj/structure/wallladder/WL = locate() in L.loc
					if(WL)
						if(get_dir(WL.loc,src) == WL.dir)
							myskill += 8
							climbsound = 'sound/foley/ladder.ogg'

				if(myskill < climbdiff)
					to_chat(user, "<span class='warning'>I'm not capable of climbing this.</span>")
					return
				used_time = max(70 - (myskill * 10) - (L.STASPD * 3), 30)
			if(user.m_intent != MOVE_INTENT_SNEAK)
				playsound(user, climbsound, 100, TRUE)
			user.visible_message("<span class='warning'>[user] starts to climb [src].</span>", "<span class='warning'>I start to climb [src]...</span>")
			if(do_after(L, used_time, src))
				var/pulling = user.pulling
				if(ismob(pulling))
					user.pulling.forceMove(target)
				user.forceMove(target)
				user.start_pulling(pulling,suppress_message = TRUE)
				if(user.m_intent != MOVE_INTENT_SNEAK)
					playsound(user, 'sound/foley/climb.ogg', 100, TRUE)
				if(L.mind)
					L.adjust_experience(/datum/skill/misc/climbing, floor(amt2raise * boon), FALSE)
	else
		..()

/turf/closed/attack_hand_secondary(mob/user, params)
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
	opacity = 0
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "window-solid"

// Boat
/turf/closed/indestructible/wooddark/hull
	name = "hull"
	color = "#d6d5a8"

/turf/closed/indestructible/wooddark/mast
	name = "mast"
	color = "#a6a68b"
