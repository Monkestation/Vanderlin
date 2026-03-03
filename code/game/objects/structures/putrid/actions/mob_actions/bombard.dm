#define BOMBARD_ACID 1
#define BOMBARD_NEUROTOXIN 2

/datum/action/cooldown/meatvine/personal/bombard
	name = "Bombard"
	desc = "Dig in and fire acidic or neurotoxic globs at distant targets. Takes 5 seconds to prepare."
	button_icon_state = "bombard"
	cooldown_time = 30 SECONDS
	personal_resource_cost = 25
	var/mob/camera/bombard_eye/camera_mob
	var/preparing = FALSE
	var/projectile_type = BOMBARD_ACID

/datum/action/cooldown/meatvine/personal/bombard/Destroy()
	QDEL_NULL(camera_mob)
	return ..()

/datum/action/cooldown/meatvine/personal/bombard/Activate(atom/target)
	var/mob/living/simple_animal/hostile/retaliate/meatvine/consumed = owner
	if(!istype(consumed))
		return FALSE

	if(preparing)
		return FALSE

	preparing = TRUE
	consumed.visible_message(span_warning("[consumed] digs into the ground and prepares to fire!"))
	consumed.anchored = TRUE

	if(!consumed.client)
		addtimer(CALLBACK(src, PROC_REF(ai_fire_bombard)), 5 SECONDS)
		return TRUE

	camera_mob = new(get_turf(consumed))
	camera_mob.link_bombard(src, consumed)

	consumed.client.perspective = EYE_PERSPECTIVE
	consumed.client.eye = camera_mob
	camera_mob.key = consumed.key

	to_chat(camera_mob, span_notice("You are now aiming the bombard. <b>Click</b> a location to fire. <b>Alt-click</b> to toggle projectile type. You have 30 seconds."))
	to_chat(camera_mob, span_notice("Current mode: <b>[projectile_type == BOMBARD_ACID ? "ACID" : "NEUROTOXIN"]</b>"))

	addtimer(CALLBACK(src, PROC_REF(cancel_bombard)), 30 SECONDS)

	return TRUE

/datum/action/cooldown/meatvine/personal/bombard/proc/ai_fire_bombard()
	var/mob/living/simple_animal/hostile/retaliate/meatvine/consumed = owner
	if(!istype(consumed) || !preparing)
		return

	var/mob/living/target = consumed.target
	if(!target)
		cancel_bombard()
		return

	var/turf/target_turf = get_turf(target)
	if(!target_turf)
		cancel_bombard()
		return

	var/enemy_count = 0
	for(var/mob/living/M in range(2, target))
		if(!istype(M, /mob/living/simple_animal/hostile/retaliate/meatvine))
			enemy_count++

	projectile_type = enemy_count >= 2 ? BOMBARD_ACID : BOMBARD_NEUROTOXIN

	fire_at_target(target_turf)

/datum/action/cooldown/meatvine/personal/bombard/proc/fire_at_target(turf/target_turf)
	var/mob/living/simple_animal/hostile/retaliate/meatvine/consumed = owner
	if(!istype(consumed) || !preparing)
		return FALSE

	var/turf/start_turf = get_turf(consumed)
	if(!start_turf || !target_turf)
		cancel_bombard()
		return FALSE

	if(!can_bombard_target(start_turf, target_turf))
		if(camera_mob)
			to_chat(camera_mob, span_warning("You cannot hit that location!"))
		cancel_bombard()
		return FALSE

	consumed.visible_message(span_danger("[consumed] fires a glob of [projectile_type == BOMBARD_ACID ? "acid" : "neurotoxin"]!"))

	if(projectile_type == BOMBARD_ACID)
		new /obj/effect/temp_visual/bombard_incoming/acid(target_turf)
		addtimer(CALLBACK(src, PROC_REF(spawn_acid_zone), target_turf), 2 SECONDS)
	else
		new /obj/effect/temp_visual/bombard_incoming/neurotoxin(target_turf)
		addtimer(CALLBACK(src, PROC_REF(spawn_neurotoxin_zone), target_turf), 2 SECONDS)

	cleanup_bombard()
	StartCooldown()
	consumed.personal_resource_pool -= personal_resource_cost
	return TRUE

/datum/action/cooldown/meatvine/personal/bombard/proc/spawn_acid_zone(turf/T)
	new /obj/effect/bombard_zone/acid(T)
	playsound(T, 'sound/misc/bamf.ogg', 60, TRUE)

/datum/action/cooldown/meatvine/personal/bombard/proc/spawn_neurotoxin_zone(turf/T)
	new /obj/effect/bombard_zone/neurotoxin(T)
	playsound(T, 'sound/misc/bamf.ogg', 60, TRUE)

/datum/action/cooldown/meatvine/personal/bombard/proc/can_bombard_target(turf/start_turf, turf/target_turf)
	var/distance = get_dist(start_turf, target_turf)
	if(distance > 11)
		return FALSE

	if(start_turf.z == target_turf.z)
		var/turf/blocked = get_line_of_sight_blocker(start_turf, target_turf)
		if(!blocked)
			return TRUE

	var/turf/above = GET_TURF_ABOVE(start_turf)
	if(above)
		var/turf/check = above
		for(var/i = 1 to distance)
			if(!check)
				break
			check = get_step_towards(check, target_turf)
			if(!check)
				break
			var/turf/below = GET_TURF_BELOW(check)
			if(below && get_dist(below, target_turf) <= 1)
				return TRUE

	return FALSE

/datum/action/cooldown/meatvine/personal/bombard/proc/get_line_of_sight_blocker(turf/start, turf/end)
	var/list/line = get_line(start, end)
	for(var/turf/T in line)
		if(T == start || T == end)
			continue
		if(T.density)
			return T
		for(var/obj/O in T)
			if(O.density)
				return T
	return null

/datum/action/cooldown/meatvine/personal/bombard/proc/cancel_bombard()
	var/mob/living/simple_animal/hostile/retaliate/meatvine/consumed = owner
	if(!istype(consumed))
		return

	cleanup_bombard()

	if(camera_mob)
		to_chat(camera_mob, span_warning("Bombard cancelled."))

/datum/action/cooldown/meatvine/personal/bombard/proc/cleanup_bombard()
	var/mob/living/simple_animal/hostile/retaliate/meatvine/consumed = owner
	if(!istype(consumed))
		return

	preparing = FALSE
	consumed.anchored = FALSE

	if(camera_mob)
		if(camera_mob.client)
			camera_mob.client.perspective = MOB_PERSPECTIVE
			camera_mob.client.eye = consumed
			consumed.key = camera_mob.key
		QDEL_NULL(camera_mob)

/datum/action/cooldown/meatvine/personal/bombard/proc/toggle_projectile_type()
	if(projectile_type == BOMBARD_ACID)
		projectile_type = BOMBARD_NEUROTOXIN
		to_chat(camera_mob || owner, span_notice("Switched to <b>NEUROTOXIN</b> globs."))
	else
		projectile_type = BOMBARD_ACID
		to_chat(camera_mob || owner, span_notice("Switched to <b>ACID</b> globs."))

/datum/action/cooldown/meatvine/personal/bombard/evaluate_ai_score(datum/ai_controller/controller)
	if(!IsAvailable())
		return 0

	var/mob/living/simple_animal/hostile/retaliate/meatvine/consumed = owner
	if(!istype(consumed) || !consumed.target)
		return 0

	var/distance = get_dist(consumed, consumed.target)

	if(distance < 4 || distance > 11)
		return 0

	var/score = 0

	if(distance >= 6 && distance <= 10)
		score += 40
	else if(distance >= 4 && distance < 6)
		score += 20

	var/turf/start = get_turf(consumed)
	var/turf/target_turf = get_turf(consumed.target)
	if(!can_bombard_target(start, target_turf))
		return 0

	var/enemy_count = 0
	for(var/mob/living/M in range(2, consumed.target))
		if(!istype(M, /mob/living/simple_animal/hostile/retaliate/meatvine))
			enemy_count++

	if(enemy_count >= 2)
		score += 30

	return score

/datum/action/cooldown/meatvine/personal/bombard/ai_use_ability(datum/ai_controller/controller)
	return Activate(null)

/datum/action/cooldown/meatvine/personal/bombard/get_movement_target(datum/ai_controller/controller)
	var/mob/living/simple_animal/hostile/retaliate/meatvine/consumed = owner
	if(!istype(consumed) || !consumed.target)
		return null

	var/distance = get_dist(consumed, consumed.target)

	if(distance < 6)
		var/turf/away = get_turf_away(consumed, consumed.target)
		return away
	else if(distance > 10)
		return consumed.target

	return null

/datum/action/cooldown/meatvine/personal/bombard/get_required_range()
	return 8

/datum/action/cooldown/meatvine/personal/bombard/proc/get_turf_away(mob/living/from, mob/living/away_from)
	var/list/possible_turfs = list()
	for(var/turf/T in range(3, from))
		if(get_dist(T, away_from) > get_dist(from, away_from))
			possible_turfs += T

	if(possible_turfs.len)
		return pick(possible_turfs)
	return null

/mob/camera/bombard_eye
	name = "bombard targeting"
	desc = "An ethereal eye surveying the battlefield."
	icon = 'icons/mob/cameramob.dmi'
	icon_state = "generic_camera"
	see_invisible = SEE_INVISIBLE_LIVING
	invisibility = INVISIBILITY_OBSERVER
	sight = SEE_TURFS
	hud_type = /datum/hud/putrid

	mouse_opacity = MOUSE_OPACITY_OPAQUE
	density = FALSE

	var/datum/action/cooldown/meatvine/personal/bombard/linked_bombard
	var/mob/living/simple_animal/hostile/retaliate/meatvine/origin_mob
	var/range_limit = 11

/mob/camera/bombard_eye/proc/link_bombard(datum/action/cooldown/meatvine/personal/bombard/bombard, mob/living/simple_animal/hostile/retaliate/meatvine/origin)
	linked_bombard = bombard
	origin_mob = origin

/mob/camera/bombard_eye/relaymove(mob/living/user, direction)
	var/turf/new_turf = get_step(src, direction)
	if(!new_turf)
		return

	if(origin_mob)
		var/turf/origin_turf = get_turf(origin_mob)
		if(get_dist(origin_turf, new_turf) > range_limit)
			to_chat(src, span_warning("You cannot move any further from your body!"))
			return

	forceMove(new_turf)

/mob/camera/bombard_eye/MiddleClickOn(atom/A, list/modifiers)
	if(linked_bombard)
		linked_bombard.toggle_projectile_type()

/mob/camera/bombard_eye/AltClickOn(atom/A, list/modifiers)
	if(linked_bombard)
		linked_bombard.toggle_projectile_type()

/mob/camera/bombard_eye/ClickOn(atom/A, params)
	if(!linked_bombard)
		return

	var/list/modifiers = params2list(params)

	if(LAZYACCESS(modifiers, ALT_CLICKED) || LAZYACCESS(modifiers, MIDDLE_CLICK))
		linked_bombard.toggle_projectile_type()
		return

	if(LAZYACCESS(modifiers, SHIFT_CLICKED) || LAZYACCESS(modifiers, CTRL_CLICKED))
		return ..()

	var/turf/target = get_turf(A)
	if(!target)
		return

	new /obj/effect/temp_visual/target/bombard_preview(target)

	linked_bombard.fire_at_target(target)

/mob/camera/bombard_eye/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	if(!origin_mob)
		return
	origin_mob.say(message)

/mob/camera/bombard_eye/Destroy()
	linked_bombard = null
	origin_mob = null
	return ..()

/obj/effect/temp_visual/bombard_incoming
	name = "incoming glob"
	desc = "Get out of the way!"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "meteor"
	plane = GAME_PLANE_UPPER
	randomdir = FALSE
	duration = 2 SECONDS
	pixel_z = 270

/obj/effect/temp_visual/bombard_incoming/Initialize(mapload)
	. = ..()
	animate(src, pixel_z = 0, time = duration)

/obj/effect/temp_visual/bombard_incoming/acid
	name = "incoming acid"
	color = "#00ff00"
	light_color = "#00ff00"
	light_outer_range = 3

/obj/effect/temp_visual/bombard_incoming/neurotoxin
	name = "incoming neurotoxin"
	color = "#9900ff"
	light_color = "#9900ff"
	light_outer_range = 3

/obj/effect/temp_visual/target/bombard_preview
	icon = 'icons/effects/effects.dmi'
	icon_state = "trap"
	layer = BELOW_MOB_LAYER
	light_outer_range = 2
	duration = 0.5 SECONDS
	alpha = 128

/obj/effect/bombard_zone
	name = "hazard zone"
	desc = "A dangerous area."
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	anchored = TRUE
	layer = ABOVE_MOB_LAYER
	var/lifetime = 10 SECONDS
	var/affect_radius = 2
	var/list/affected_turfs = list()

/obj/effect/bombard_zone/Initialize(mapload)
	. = ..()
	for(var/turf/T in range(affect_radius, src))
		affected_turfs += T
		new /obj/effect/temp_visual/bombard_zone_tile(T, src)

	START_PROCESSING(SSobj, src)
	QDEL_IN(src, lifetime)

/obj/effect/bombard_zone/Destroy()
	STOP_PROCESSING(SSobj, src)
	affected_turfs = null
	return ..()

/obj/effect/bombard_zone/process()
	affect_targets()

/obj/effect/bombard_zone/proc/affect_targets()
	for(var/turf/T in affected_turfs)
		for(var/mob/living/M in T)
			if(istype(M, /mob/living/simple_animal/hostile/retaliate/meatvine))
				continue
			apply_effect(M)

/obj/effect/bombard_zone/proc/apply_effect(mob/living/M)
	return

/obj/effect/bombard_zone/acid
	name = "acid pool"
	desc = "A pool of highly corrosive acid."
	icon_state = "acid_weak"
	color = "#00ff00"
	light_color = "#00ff00"
	light_outer_range = 3

/obj/effect/bombard_zone/acid/apply_effect(mob/living/M)
	M.apply_damage(5, BURN)
	M.adjust_fire_stacks(1)

/obj/effect/bombard_zone/neurotoxin
	name = "neurotoxin cloud"
	desc = "A cloud of deadly neurotoxin."
	icon_state = "smoke"
	color = "#9900ff"
	light_color = "#9900ff"
	light_outer_range = 3

/obj/effect/bombard_zone/neurotoxin/apply_effect(mob/living/carbon/C)
	C.adjustOxyLoss(3)
	C.adjust_eye_blur(4 SECONDS)

	if(prob(10))
		C.apply_damage(2, TOX)

/obj/effect/temp_visual/bombard_zone_tile
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	layer = ABOVE_MOB_LAYER
	alpha = 180
	duration = 10 SECONDS

/obj/effect/temp_visual/bombard_zone_tile/Initialize(mapload, obj/effect/bombard_zone/parent_zone)
	. = ..()
	if(parent_zone)
		color = parent_zone.color
		light_color = parent_zone.light_color
		light_outer_range = 1

#undef BOMBARD_ACID
#undef BOMBARD_NEUROTOXIN
