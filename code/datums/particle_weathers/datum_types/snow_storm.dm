//Snow - goes down and swirls
/particles/weather/snow
	icon_state             = list("cross"=2, "snow_1"=5, "snow_2"=2, "snow_3"=2,)
	color                  = "#ffffff"
	position               = generator("box", list(-500,-256,0), list(400,500,0))
	grow			       = list(-0.01,-0.01)
	spin                   = generator("num",-10,10)
	gravity                = list(0, -2, 0.1)
	drift                  = generator("circle", 0, 3) // Some random movement for variation
	friction               = 0.3  // shed 30% of velocity and drift every 0.1s
	//Weather effects, max values
	maxSpawning           = 100
	minSpawning           = 20
	wind                  = 2
	transform 			   = null

/datum/particle_weather/snow_gentle
	name = "Gentle Snow"
	desc = "Gentle Rain, la la description."
	particleEffectType = /particles/weather/snow

	scale_vol_with_severity = TRUE
	weather_sounds = /datum/looping_sound/snow

	minSeverity = 1
	maxSeverity = 10
	maxSeverityChange = 5
	severitySteps = 5
	immunity_type = TRAIT_SNOWSTORM_IMMUNE
	probability = 1
	target_trait = PARTICLEWEATHER_SNOW
	forecast_tag = "snow"

	temperature_modification = -10


//Makes you a little chilly
/datum/particle_weather/snow_gentle/weather_act(mob/living/L)
	L.snow_shiver = world.time + 7 SECONDS


/datum/particle_weather/snow_storm
	name = "Snow Storm"
	desc = "Gentle Rain, la la description."
	particleEffectType = /particles/weather/snow

	scale_vol_with_severity = TRUE
	weather_sounds = /datum/looping_sound/snow

	minSeverity = 40
	maxSeverity = 100

	weather_duration_lower = 4 MINUTES
	weather_duration_upper = 10 MINUTES

	maxSeverityChange = 50
	severitySteps = 50
	immunity_type = TRAIT_SNOWSTORM_IMMUNE
	probability = 1
	target_trait = PARTICLEWEATHER_SNOW
	weather_special_effect = /datum/weather_effect/snow
	forecast_tag = "snow"

	temperature_modification = -15

/datum/weather_effect/snow
	name = "snow effect"
	probability = 40

/datum/weather_effect/snow/effect_affect(turf/target_turf)
	if(!target_turf.snow)
		new /obj/structure/snow(target_turf, 1)
	else
		target_turf.snow.weathered(src)

//Makes you a lot little chilly
/mob/living/var/snow_shiver

/datum/particle_weather/snow_storm/weather_act(mob/living/L)
	L.snow_shiver = world.time + 10 SECONDS


/datum/weather_effect/snow_storm/effect_affect(turf/target_turf)
	if(!target_turf.snow)
		new /obj/structure/snow(target_turf, 1)
	else
		target_turf.snow.weathered(src)

/particles/fog
	icon = 'icons/effects/particles/smoke.dmi'
	icon_state = list("chill_1" = 2, "chill_2" = 2, "chill_3" = 1)

/particles/fog/breath
	count = 1
	spawning = 1
	lifespan = 1 SECONDS
	fade = 0.5 SECONDS
	grow = 0.05
	spin = 2
	color = "#fcffff77"

/turf
	var/obj/structure/snow/snow

/turf/proc/apply_weather_effect(datum/weather_effect/effect)
	SIGNAL_HANDLER
	if(!effect)
		return

	if(is_blocked_turf(TRUE))
		return

	effect.effect_affect(src)

/obj/structure/snow
	name = "Snow"
	desc = "Big pile of snow"
	icon = 'icons/effects/snow.dmi'
	icon_state = MAP_SWITCH("blank", "snow_1")
	var/icon_prefix = "snow"
	anchored = TRUE
	density = FALSE
	plane = GAME_PLANE
	layer = TABLE_LAYER - 0.1
	var/bleed_layer = 0
	var/progression = 0
	var/turf/snowed_turf
	var/list/snows_connections = list(list("0", "0", "0", "0"), list("0", "0", "0", "0"), list("0", "0", "0", "0"))
	var/list/diged = list("2" = 0, "1" = 0, "8" = 0, "4" = 0)

/obj/structure/snow/Initialize(mapload, bleed_layers)
	. = ..()
	bleed_layer = bleed_layers
	if(!bleed_layer)
		bleed_layer = rand(1, 3)

	//RegisterSignal(src, COMSIG_ATOM_TURF_CHANGE, PROC_REF(update_visuals_effects))

	START_PROCESSING(SSslowobj, src)

	update_corners(TRUE)
	update_appearance(UPDATE_OVERLAYS)

	update_visuals_effects(first = TRUE)

/obj/structure/snow/Destroy(force)
	update_visuals_effects(src, FALSE)

	for(var/atom/movable/movable in get_turf(src))
		if(movable.get_filter("mob_moving_effect_mask"))
			animate(movable.get_filter("mob_moving_effect_mask"), y = -32, time = 0)
			if(ismob(movable))
				movable:update_vision_cone()
			for(var/mob/living/carbon/human/human in view(movable, 7))
				human.update_vision_cone()

	STOP_PROCESSING(SSslowobj, src)
	snowed_turf.snow = null
	snowed_turf = null

	. = ..()

	for(var/obj/structure/snow/bordered_snow in orange(get_turf(src), 1))
		if(!bordered_snow)
			continue
		if(bordered_snow == src)
			continue
		bordered_snow.update_corners(ignored = src)
		bordered_snow.update_appearance(UPDATE_OVERLAYS)


/obj/structure/snow/process()
	if(!SSParticleWeather.runningWeather)
		damage_act(3)
	else if(!istype(SSParticleWeather.runningWeather, /datum/weather_effect/snow))
		damage_act(6)
	update_appearance(UPDATE_OVERLAYS)

/obj/structure/snow/proc/get_slowdown()
	return 1.5 * bleed_layer

/obj/structure/snow/proc/update_visuals_effects(datum/source, replace = TRUE, first = FALSE)
	SIGNAL_HANDLER

	var/list/contained_mobs = list()
	var/turf/turf = get_turf(src)
	for(var/mob/living/contained_mob in contents)
		contained_mobs += contained_mob
		SEND_SIGNAL(src, COMSIG_MOB_OVERLAY_FORCE_REMOVE, contained_mob)

	for(var/obj/structure/contained_structure in contents)
		if(istype(contained_structure, /obj/structure/snow) || istype(contained_structure, /obj/structure/flora/grass/bush/wall))
			continue
		contained_mobs += contained_structure
		SEND_SIGNAL(src, COMSIG_MOB_OVERLAY_FORCE_REMOVE, contained_structure)

	for(var/obj/item/contained_item in contents)
		contained_mobs += contained_item
		SEND_SIGNAL(src, COMSIG_MOB_OVERLAY_FORCE_REMOVE, contained_item)

	for(var/obj/machinery/contained_machinery in contents)
		contained_mobs += contained_machinery
		SEND_SIGNAL(src, COMSIG_MOB_OVERLAY_FORCE_REMOVE, contained_machinery)


	if(first)
		for(var/mob/living/contained_mob in turf.contents)
			contained_mobs += contained_mob
			SEND_SIGNAL(src, COMSIG_MOB_OVERLAY_FORCE_REMOVE, contained_mob)

		for(var/obj/structure/contained_structure in turf.contents)
			if(istype(contained_structure, /obj/structure/snow) || istype(contained_structure, /obj/structure/flora/grass/bush/wall))
				continue
			contained_mobs += contained_structure
			SEND_SIGNAL(src, COMSIG_MOB_OVERLAY_FORCE_REMOVE, contained_structure)

		for(var/obj/item/contained_item in turf.contents)
			contained_mobs += contained_item
			SEND_SIGNAL(src, COMSIG_MOB_OVERLAY_FORCE_REMOVE, contained_item)

		for(var/obj/machinery/contained_machinery in turf.contents)
			contained_mobs += contained_machinery
			SEND_SIGNAL(src, COMSIG_MOB_OVERLAY_FORCE_REMOVE, contained_machinery)

	RemoveElement(/datum/element/mob_overlay_effect)
	if(replace)
		AddElement(/datum/element/mob_overlay_effect, bleed_layer * 2.4, -6 + (bleed_layer * 3.5), 100)
		for(var/mob/living/contained_mob as anything in contained_mobs)
			SEND_SIGNAL(src, COMSIG_MOB_OVERLAY_FORCE_UPDATE, contained_mob)
		for(var/obj/structure/contained_structure in contained_mobs)
			contained_mobs += contained_structure
			SEND_SIGNAL(src, COMSIG_MOB_OVERLAY_FORCE_UPDATE, contained_structure)
		for(var/obj/item/contained_item in contained_mobs)
			contained_mobs += contained_item
			SEND_SIGNAL(src, COMSIG_MOB_OVERLAY_FORCE_UPDATE, contained_item)

		for(var/obj/machinery/contained_machinery in contained_mobs)
			contained_mobs += contained_machinery
			SEND_SIGNAL(src, COMSIG_MOB_OVERLAY_FORCE_UPDATE, contained_machinery)

/obj/structure/snow/proc/update_corners(propagate = FALSE, obj/structure/ignored)
	var/list/snow_dirs = list(list(), list(), list())
	var/turf/turf = get_turf(src)
	if(!turf)
		return
	if(turf != snowed_turf)
		if(snowed_turf)
			snowed_turf.snow = null
		snowed_turf = turf
		snowed_turf.snow = src

	for(var/obj/structure/snow/bordered_snow in orange(src, 1))
		if(!bordered_snow)
			continue
		if(ignored == bordered_snow)
			continue

		if(propagate)
			bordered_snow.update_corners()
			bordered_snow.update_appearance(UPDATE_OVERLAYS)

		var/direction = get_dir(src, bordered_snow)
		for(var/deep = 1 to length(snow_dirs))
			if(deep > bleed_layer)
				continue

			if(deep > bordered_snow.bleed_layer)
				continue

			snow_dirs[deep] += direction

	for(var/deep = 1 to length(snow_dirs))
		snows_connections[deep] = dirs_to_corner_states(snow_dirs[deep])

/obj/structure/snow/update_overlays()
	. = ..()
	for(var/deep = 1 to length(snows_connections))
		if(deep > bleed_layer)
			continue

		for(var/i = 1 to 4)
			. += image(icon, "[icon_prefix]_[deep]_[snows_connections[deep][i]]", dir = 1<<(i-1))

	var/new_overlay = ""
	for(var/i in diged)
		if(diged[i] > world.time)
			new_overlay += i
	. += "[new_overlay]"

/obj/structure/snow/proc/damage_act(damage)
	if(progression > damage / 5)
		progression -= damage / 5
	else
		changing_layer(min(bleed_layer - round(damage / (bleed_layer * 20), 1), MAX_LAYER_SNOW_LEVELS))
		progression = bleed_layer * 4

/obj/structure/snow/bullet_act(obj/projectile/proj, def_zone, piercing_hit)
	return FALSE

/obj/structure/snow/proc/weathered(datum/weather_effect/effect)
	if(progression < bleed_layer * 32)
		progression++
	else
		if(bleed_layer >= 3)
			for(var/direction in GLOB.alldirs)
				var/turf/turf = get_step(loc, direction)
				if(!turf.snow)
					turf.apply_weather_effect(effect)
					break

				else if(turf.snow && turf.snow.bleed_layer != 3)
					turf.snow.weathered(effect)
					break
		else
			changing_layer(min(bleed_layer + 1, MAX_LAYER_SNOW_LEVELS))

		progression = 0

/obj/structure/snow/proc/changing_layer(new_layer)
	if(isnull(new_layer) || new_layer == bleed_layer)
		return

	bleed_layer = max(0, new_layer)

	if(!bleed_layer)
		qdel(src)
		return

	update_corners(TRUE)
	update_appearance(UPDATE_OVERLAYS)

	update_visuals_effects()

/obj/structure/snow/ex_act(severity)
	damage_act(severity)

/obj/structure/snow/Crossed(atom/movable/arrived)
	. = ..()
	if(isliving(arrived))
		set_diged_ways(REVERSE_DIR(arrived.dir))

/obj/structure/snow/Uncrossed(atom/movable/gone)
	. = ..()
	if(isliving(gone))
		set_diged_ways(gone.dir)

/obj/structure/snow/proc/set_diged_ways(dir)
	diged["[dir]"] = world.time + 1 MINUTES
	update_appearance(UPDATE_OVERLAYS)

#define CORNER_NONE 0
#define CORNER_COUNTERCLOCKWISE 1
#define CORNER_DIAGONAL 2
#define CORNER_CLOCKWISE 4

/proc/dirs_to_corner_states(list/dirs)
	if(!istype(dirs))
		return

	var/list/ret = list(NORTHWEST, SOUTHEAST, NORTHEAST, SOUTHWEST)

	for(var/i = 1 to ret.len)
		var/dir = ret[i]
		. = CORNER_NONE
		if(dir in dirs)
			. |= CORNER_DIAGONAL
		if(turn(dir,45) in dirs)
			. |= CORNER_COUNTERCLOCKWISE
		if(turn(dir,-45) in dirs)
			. |= CORNER_CLOCKWISE
		ret[i] = "[.]"

	return ret

#undef CORNER_NONE
#undef CORNER_COUNTERCLOCKWISE
#undef CORNER_DIAGONAL
#undef CORNER_CLOCKWISE


/turf/Exited(atom/movable/gone, direction)
	if(!istype(gone))
		return
	SEND_SIGNAL(src, COMSIG_TURF_EXITED, gone, direction)
	SEND_SIGNAL(gone, COMSIG_MOVABLE_TURF_EXITED, src, direction)
