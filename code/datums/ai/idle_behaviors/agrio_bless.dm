#define AGRIOPYLON_STATE_IDLE 0
#define AGRIOPYLON_STATE_BLESSING 1

/datum/idle_behavior/bless_crops
	var/cooldown = 2 MINUTES

/datum/idle_behavior/bless_crops/perform_idle_behavior(delta_time, datum/ai_controller/controller)
	. = ..()
	if(!controller.able_to_run())
		return

	var/last_cooldown = controller.blackboard[BB_AGRIOPYLON_BLESS_COOLDOWN] || 0
	if(world.time < last_cooldown)
		return

	var/mob/living/simple_animal/hostile/retaliate/fae/agriopylon/agrio = controller.pawn
	if(!istype(agrio))
		return

	var/obj/structure/soil/target_soil
	var/list/unblessed_soils = list()
	var/list/all_soils = list()

	for(var/obj/structure/soil/S in view(6, agrio))
		all_soils += S
		if(S.blessed_time <= 0)
			unblessed_soils += S

	if(unblessed_soils.len)
		var/min_dist = 99
		for(var/obj/structure/soil/S in unblessed_soils)
			var/d = get_dist(agrio, S)
			if(d < min_dist)
				target_soil = S
				min_dist = d
	else
		if(all_soils.len)
			target_soil = pick(all_soils)

	if(!target_soil)
		return

	agrio.change_agriopylon_state(AGRIOPYLON_STATE_BLESSING)
	target_soil.bless_soil()
	new /obj/effect/temp_visual/bless_swirl(get_turf(target_soil))
	agrio.visible_message(span_greentext("[agrio] blesses [target_soil]."))
	playsound(agrio, 'sound/items/gem.ogg', 60, TRUE)
	addtimer(CALLBACK(agrio, TYPE_PROC_REF(/mob/living/simple_animal/hostile/retaliate/fae/agriopylon, change_agriopylon_state), AGRIOPYLON_STATE_IDLE), 2 SECONDS)

	controller.set_blackboard_key(BB_AGRIOPYLON_BLESS_COOLDOWN, world.time + cooldown)

/obj/effect/temp_visual/bless_swirl
	icon = 'icons/effects/effects.dmi'
	icon_state = "dna_swirl"
	duration = 3 SECONDS
	layer = EFFECTS_LAYER

#undef AGRIOPYLON_STATE_IDLE
#undef AGRIOPYLON_STATE_BLESSING

