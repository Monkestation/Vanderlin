/datum/ai_planning_subtree/leyline_special_abilities
	var/energy_surge_behavior = /datum/ai_behavior/leyline_energy_surge
	var/shockwave_behavior = /datum/ai_behavior/leyline_shockwave

/datum/ai_planning_subtree/leyline_special_abilities/SelectBehaviors(datum/ai_controller/controller, delta_time)
	. = ..()
	var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	var/energy_cooldown = controller.blackboard[BB_ENERGY_SURGE_COOLDOWN]
	var/shockwave_cooldown = controller.blackboard[BB_SHOCKWAVE_COOLDOWN]
	var/energy_level = controller.blackboard[BB_LEYLINE_ENERGY]

	if(QDELETED(target))
		return

	// Energy surge - ranged attack when target is distant
	if(world.time >= energy_cooldown && energy_level >= 30)
		var/mob/living/simple_animal/hostile/retaliate/leylinelycan/lycan = controller.pawn
		var/distance = get_dist(lycan, target)

		if(distance >= 3 && distance <= 7)
			controller.queue_behavior(energy_surge_behavior, BB_BASIC_MOB_CURRENT_TARGET)
			return

	// Shockwave - AOE attack when multiple targets are nearby
	if(world.time >= shockwave_cooldown && energy_level >= 60)
		var/mob/living/simple_animal/hostile/retaliate/leylinelycan/lycan = controller.pawn
		var/nearby_enemies = 0

		for(var/mob/living/L in view(3, lycan))
			if(L == lycan)
				continue
			if(L.has_faction("leyline"))
				continue
			nearby_enemies++

		if(nearby_enemies >= 2)
			controller.queue_behavior(shockwave_behavior)
			return

/**
 * Behavior for energy surge ranged attack
 */
/datum/ai_behavior/leyline_energy_surge
	action_cooldown = 8 SECONDS
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT

/datum/ai_behavior/leyline_energy_surge/setup(datum/ai_controller/controller, target_key)
	. = ..()
	var/atom/target = controller.blackboard[target_key]
	if(QDELETED(target))
		return FALSE

	set_movement_target(controller, target)

/datum/ai_behavior/leyline_energy_surge/perform(delta_time, datum/ai_controller/controller, target_key)
	. = ..()
	var/mob/living/simple_animal/hostile/retaliate/leylinelycan/lycan = controller.pawn
	var/atom/target = controller.blackboard[target_key]
	var/energy_level = controller.blackboard[BB_LEYLINE_ENERGY]

	if(QDELETED(target) || !isturf(target.loc) || !isturf(lycan.loc) || energy_level < 30)
		finish_action(controller, FALSE)
		return

	// Set cooldown
	controller.set_blackboard_key(BB_ENERGY_SURGE_COOLDOWN, world.time + action_cooldown)

	// Use energy
	controller.set_blackboard_key(BB_LEYLINE_ENERGY, energy_level - 30)

	// Visual effects
	lycan.visible_message(span_warning("[lycan]'s eyes glow with leyline energy as it focuses on [target]!"))
	new /obj/effect/temp_visual/leyline_charge(get_turf(lycan))

	playsound(lycan, 'sound/magic/charging_lightning.ogg', 65, TRUE)
	lycan.face_atom(target)

	// Create the actual projectile after a short delay
	addtimer(CALLBACK(src, PROC_REF(fire_energy_surge), controller, lycan, target), 1 SECONDS)

/datum/ai_behavior/leyline_energy_surge/proc/fire_energy_surge(datum/ai_controller/controller, mob/living/simple_animal/hostile/retaliate/leylinelycan/lycan, atom/target)
	if(QDELETED(lycan) || QDELETED(target))
		finish_action(controller, FALSE)
		return

	lycan.Beam(target, "lightning7", 'icons/effects/beam.dmi', 3 SECONDS)

	playsound(lycan, 'sound/magic/lightning.ogg', 75, TRUE)

	// Deal damage to target
	if(isliving(target))
		var/mob/living/L = target
		L.apply_damage(40, BURN)
		L.Paralyze(1 SECONDS)
		to_chat(L, span_danger("Crackling energy from [lycan] surges through your body!"))

	finish_action(controller, TRUE)


/datum/ai_behavior/leyline_shockwave
	action_cooldown = 15 SECONDS
	behavior_flags = AI_BEHAVIOR_MOVE_AND_PERFORM

/datum/ai_behavior/leyline_shockwave/perform(delta_time, datum/ai_controller/controller)
	. = ..()
	var/mob/living/simple_animal/hostile/retaliate/leylinelycan/lycan = controller.pawn
	var/energy_level = controller.blackboard[BB_LEYLINE_ENERGY]

	if(energy_level < 60)
		finish_action(controller, FALSE)
		return

	// Set cooldown
	controller.set_blackboard_key(BB_SHOCKWAVE_COOLDOWN, world.time + action_cooldown)

	// Use energy
	controller.set_blackboard_key(BB_LEYLINE_ENERGY, energy_level - 60)

	// Visual buildup
	lycan.visible_message(span_warning("[lycan] slams its claws into the ground as energy crackles around it!"))

	playsound(lycan, 'sound/magic/charging_lightning.ogg', 100, TRUE)

	// Shockwave visual effect
	var/obj/effect/temp_visual/leyline_charge/overcharge = new(get_turf(lycan))
	animate(overcharge, transform = matrix()*2, time = 3 SECONDS)

	// Short delay before explosion
	addtimer(CALLBACK(src, PROC_REF(release_shockwave), controller, lycan), 3 SECONDS)

/datum/ai_behavior/leyline_shockwave/proc/release_shockwave(datum/ai_controller/controller, mob/living/simple_animal/hostile/retaliate/leylinelycan/lycan)
	if(QDELETED(lycan))
		finish_action(controller, FALSE)
		return

	playsound(lycan, 'sound/magic/lightning.ogg', 100, TRUE)
	new /obj/effect/temp_visual/gravpush(get_turf(lycan))

	for(var/mob/living/L in view(3, lycan))
		if((L == lycan) || L.has_faction("leyline"))
			continue

		var/dist = get_dist(lycan, L)
		var/damage = 60 * (1 - (dist/6)) // Damage falls off with distance

		L.apply_damage(damage, BURN)

		// Del on death
		if(QDELETED(L))
			continue

		var/knockback_distance = max(1, 4 - dist)

		var/turf/T = get_turf(L)
		var/turf/lycan_turf = get_turf(lycan)
		var/knock_dir = get_dir(lycan_turf, T)

		for(var/i in 1 to knockback_distance)
			T = get_step(T, knock_dir)
			if(!T)
				break

		L.throw_at(T, knockback_distance, 1)
		L.Knockdown(knockback_distance * 10)
		to_chat(L, span_userdanger("A powerful shockwave from [lycan] throws you back!"))

	finish_action(controller, TRUE)


/obj/effect/temp_visual/leyline_charge
	icon = 'icons/effects/effects.dmi'
	icon_state = "electricity"
	duration = 3 SECONDS

/obj/effect/ebeam/leyline
	name = "leyline energy"
	icon = 'icons/effects/beam.dmi'
	icon_state = "lightning"
