#define MAX_DENT_DECALS 15

/turf/closed/wall
	name = ""
	desc = ""
	icon = 'icons/turf/walls.dmi'
	icon_state = "wall"
	explosion_block = 1

	baseturfs = /turf/open/floor/dirt/road

	smoothing_groups = SMOOTH_GROUP_CLOSED_WALL

	var/hardness = 40 //lower numbers are harder. Used to determine the probability of a hulk smashing through.
	var/slicing_duration = 100  //default time taken to slice the wall
	var/sheet_type = null
	var/sheet_amount = 2

	var/list/dent_decals

/turf/closed/wall/get_explosion_resistance()
	return (atom_integrity) / 15

/turf/closed/wall/handle_ricochet(obj/projectile/P)			//A huge pile of shitcode!
	var/turf/p_turf = get_turf(P)
	var/face_direction = get_dir(src, p_turf)
	var/face_angle = dir2angle(face_direction)
	var/incidence_s = GET_ANGLE_OF_INCIDENCE(face_angle, (P.Angle + 180))
	if(abs(incidence_s) > 90 && abs(incidence_s) < 270)
		return FALSE
	var/new_angle_s = SIMPLIFY_DEGREES(face_angle + incidence_s)
	P.setAngle(new_angle_s)
	return TRUE

/turf/closed/wall/atom_destruction(damage_flag)
	. = ..()
	visible_message(span_notice("\The [src] crumbles!"))
	dismantle_wall(TRUE, FALSE)

/turf/closed/wall/proc/dismantle_wall(devastated=0, explode=0)
	playsound(src, 'sound/blank.ogg', 100, TRUE)
	ScrapeAway()
	QUEUE_SMOOTH_NEIGHBORS(src)

/turf/closed/wall/ex_act(severity, target, epicenter, devastation_range, heavy_impact_range, light_impact_range, flame_range)
	if(target == src)
		dismantle_wall(1,1)
		take_damage(INFINITY, BRUTE, "blunt", 0)
		return
	var/ddist = devastation_range
	var/hdist = heavy_impact_range
	var/ldist = light_impact_range
	var/fdist = flame_range
	var/fodist = get_dist(src, epicenter)
	var/brute_loss = 0
	var/dmgmod = round(rand(0.1, 2), 0.1)

	switch (severity)
		if (EXPLODE_DEVASTATE)
			brute_loss = ((250 * ddist) - (250 * fodist) * dmgmod)

		if (EXPLODE_HEAVY)
			brute_loss = ((100 * hdist) - (100 * fodist) * dmgmod)

		if(EXPLODE_LIGHT)
			brute_loss = ((25 * ldist) - (25 * fodist) * dmgmod)

	if(fodist == 0)
		brute_loss *= 2
	take_damage(brute_loss, BRUTE, "blunt", 0)

	if(fdist && !QDELETED(src))
		var/stacks = ((fdist - fodist) * 2)
		fire_act(stacks)

	if(!density)
		..()

/turf/closed/wall/attack_paw(mob/living/user)
	user.changeNext_move(CLICK_CD_MELEE)
	return attack_hand(user)


/turf/closed/wall/attack_animal(mob/living/simple_animal/M)
	M.changeNext_move(CLICK_CD_MELEE)
	M.do_attack_animation(src)
	if((M.environment_smash & ENVIRONMENT_SMASH_WALLS) || (M.environment_smash & ENVIRONMENT_SMASH_RWALLS))
		playsound(src, 'sound/blank.ogg', 100, TRUE)
		dismantle_wall(1)
		return

/turf/closed/wall/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	add_fingerprint(user)

/turf/closed/wall/attackby(obj/item/W, mob/user, list/modifiers)
	user.changeNext_move(CLICK_CD_MELEE)
	if (!user.IsAdvancedToolUser())
		to_chat(user, "<span class='warning'>I don't have the dexterity to do this!</span>")
		return

	//get the user's location
	if(!isturf(user.loc))
		return	//can't do this stuff whilst inside objects and such

	add_fingerprint(user)

	var/turf/T = user.loc	//get user's location for delay checks

	//the istype cascade has been spread among various procs for easy overriding
	if(try_clean(W, user, T) || try_wallmount(W, user, T) || try_decon(W, user, T))
		return

	// Are you trying to break your instrument? Go ahead!
	if(istype(W, /obj/item/instrument))
		user.do_attack_animation(src, used_item = W, item_animation_override = ATTACK_ANIMATION_BONK)
		visible_message("<span class='warning'>[user] slams \the [W] against \the [src]!</span>",
						"<span class='warning'>I slam \the [W] against \the [src]!</span>",null ,COMBAT_MESSAGE_RANGE)
		W.take_damage(10, BRUTE, "blunt")
		return

	return ..()

/turf/closed/wall/proc/try_clean(obj/item/W, mob/user, turf/T)
	if((user.used_intent.type != INTENT_HELP) || !LAZYLEN(dent_decals))
		return FALSE

	if(W.tool_behaviour == TOOL_WELDER)
		if(!W.tool_start_check(user, amount=0))
			return FALSE

		to_chat(user, "<span class='notice'>I begin fixing dents on the wall...</span>")
		if(W.use_tool(src, user, 0, volume=100))
			if(iswallturf(src) && LAZYLEN(dent_decals))
				to_chat(user, "<span class='notice'>I fix some dents on the wall.</span>")
				cut_overlay(dent_decals)
				dent_decals.Cut()
			return TRUE

	return FALSE

/turf/closed/wall/proc/try_wallmount(obj/item/W, mob/user, turf/T)
	return FALSE

/turf/closed/wall/proc/try_decon(obj/item/I, mob/user, turf/T)
	if(I.tool_behaviour == TOOL_WELDER)
		if(!I.tool_start_check(user, amount=0))
			return FALSE

		to_chat(user, "<span class='notice'>I begin slicing through the outer plating...</span>")
		if(I.use_tool(src, user, slicing_duration, volume=100))
			if(iswallturf(src))
				to_chat(user, "<span class='notice'>I remove the outer plating.</span>")
				dismantle_wall()
			return TRUE

	return FALSE

/turf/closed/wall/get_dumping_location(obj/item/storage/source, mob/user)
	return null

/turf/closed/wall/acid_act(acidpwr, acid_volume)
	if(explosion_block >= 2)
		acidpwr = min(acidpwr, 50) //we reduce the power so strong walls never get melted.
	. = ..()

/turf/closed/wall/acid_melt()
	dismantle_wall(1)

/turf/closed/wall/proc/add_dent(denttype, x=rand(-8, 8), y=rand(-8, 8))
	if(LAZYLEN(dent_decals) >= MAX_DENT_DECALS)
		return

	var/mutable_appearance/decal = mutable_appearance('icons/effects/effects.dmi', "", BULLET_HOLE_LAYER)
	switch(denttype)
		if(WALL_DENT_SHOT)
			decal.icon_state = "bullet_hole"
		if(WALL_DENT_HIT)
			decal.icon_state = "impact[rand(1, 3)]"

	decal.pixel_x = x
	decal.pixel_y = y

	if(LAZYLEN(dent_decals))
		cut_overlay(dent_decals)
		dent_decals += decal
	else
		dent_decals = list(decal)

	add_overlay(dent_decals)

#undef MAX_DENT_DECALS

/turf/closed/splashscreen
	name = ""
	icon = 'icons/default_title.dmi'
	icon_state = ""
	layer = FLY_LAYER
	bullet_bounce_sound = null

/turf/closed/splashscreen/New()
	SStitle.splash_turf = src
	if(SStitle.icon)
		icon = SStitle.icon
	..()

/turf/closed/splashscreen/vv_edit_var(var_name, var_value)
	. = ..()
	if(.)
		switch(var_name)
			if("icon")
				SStitle.icon = icon
