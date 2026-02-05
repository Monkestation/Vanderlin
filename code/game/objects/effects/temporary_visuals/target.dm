// I don't like this but we have it so
/// Visual effect that does something once the duration is finished
/obj/effect/temp_visual/target
	icon = 'icons/effects/effects.dmi'
	icon_state = "trap"
	layer = BELOW_MOB_LAYER
	plane = GAME_PLANE
	light_outer_range = 2
	duration = 9
	var/duration_extra

/obj/effect/temp_visual/target/Initialize(mapload, list/hit_atoms)
	if(duration_extra)
		duration = rand(duration, duration + duration_extra)
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(fall), hit_atoms)

/obj/effect/temp_visual/target/proc/fall(list/hit_atoms)
	return

/obj/effect/temp_visual/target/minotaur
	duration = 1.8 SECONDS

/obj/effect/temp_visual/fireball
	name = "meteor"
	desc = "Get out of the way!"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "meteor"
	plane = GAME_PLANE_UPPER
	randomdir = FALSE
	duration = 9
	pixel_z = 270

/obj/effect/temp_visual/fireball/Initialize(mapload, incoming_duration)
	duration = incoming_duration || duration
	. = ..()
	animate(src, pixel_z = 0, time = duration)

/obj/effect/temp_visual/target/meteor
	var/exp_heavy = 1
	var/exp_light = 3
	var/exp_flash = 2
	var/exp_fire = 2
	var/exp_hotspot = 1
	var/explode_sound = list('sound/misc/explode/incendiary (1).ogg','sound/misc/explode/incendiary (2).ogg')

/obj/effect/temp_visual/target/meteor/fall(list/hit_atoms)
	var/turf/T = get_turf(src)
	playsound(T, 'sound/magic/meteorstorm.ogg', 80, TRUE)
	new /obj/effect/temp_visual/fireball(T, duration)
	sleep(duration)
	if(ismineralturf(T))
		var/turf/closed/mineral/M = T
		M.gets_drilled()
	for(var/mob/living/L in T.contents)
		if(islist(hit_atoms) && !hit_atoms[L])
			L.adjustFireLoss(40)
			L.adjust_fire_stacks(8)
			L.IgniteMob()
			to_chat(L, span_userdanger("You're hit by a meteor!"))
			hit_atoms[L] = TRUE
		else
			L.adjustFireLoss(10) //if we've already hit them, do way less damage
	explosion(T, -1, exp_heavy, exp_light, exp_flash, 0, flame_range = exp_fire, hotspot_range = exp_hotspot, soundin = explode_sound)

/obj/effect/temp_visual/stone_throw
	icon = 'icons/roguetown/items/natural.dmi'
	icon_state = "stonebig1"
	name = "stone"
	desc = "You should scram..."
	layer = FLY_LAYER
	plane = GAME_PLANE_UPPER
	randomdir = FALSE
	duration = 1 SECONDS
	pixel_z = 270

/obj/effect/temp_visual/stone_throw/Initialize(mapload, incoming_duration = 9)
	duration = incoming_duration
	. = ..()
	animate(src, pixel_z = 0, time = duration)

/obj/effect/temp_visual/target/orcthrow
	icon = 'icons/mob/actions/actions_spells.dmi'
	icon_state = "projectile"
	var/exp_heavy = 1
	var/exp_light = 2
	var/exp_flash = 0
	var/exp_fire = 0
	var/exp_hotspot = 0
	var/explode_sound = list('sound/misc/explode/incendiary (1).ogg','sound/misc/explode/incendiary (2).ogg')

/obj/effect/temp_visual/target/orcthrow/fall()
	var/turf/hit_turf = get_turf(src)
	new /obj/effect/temp_visual/stone_throw(hit_turf, duration)
	sleep(duration)
	if(ismineralturf(hit_turf))
		var/turf/closed/mineral/rock_turf = hit_turf
		rock_turf.gets_drilled()
	for(var/mob/living/mob in hit_turf)
		mob.take_overall_damage(25)

	explosion(hit_turf, -1, exp_heavy, exp_light, exp_flash, 0, flame_range = exp_fire, hotspot_range = exp_hotspot, soundin = explode_sound)

/obj/effect/temp_visual/lightning
	icon = 'icons/effects/32x200.dmi'
	icon_state = "lightning"
	light_color = COLOR_PALE_BLUE_GRAY
	light_outer_range = 15
	light_power = 25
	duration = 12

/obj/effect/temp_visual/lightning/Initialize(mapload)
	. = ..()
	playsound(src,'sound/weather/rain/thunder_1.ogg', 80, TRUE)
	add_overlay(emissive_appearance(icon, icon_state))

/obj/effect/temp_visual/target/lightning
	light_color = COLOR_PALE_BLUE_GRAY
	duration = 12

/obj/effect/temp_visual/target/lightning/fall(list/hit_atoms)
	var/turf/T = get_turf(src)
	sleep(duration)
	playsound(T,'sound/magic/lightning.ogg', 80, TRUE)
	new /obj/effect/temp_visual/lightning(T)

	for(var/mob/living/L in T)
		L.electrocute_act(50)
