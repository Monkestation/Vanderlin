// Summons stronger minions and buffs existing ones
/datum/ai_behavior/fishboss_deep_call
	action_cooldown = 1 SECONDS

/datum/ai_behavior/fishboss_deep_call/perform(delta_time, datum/ai_controller/controller)
	. = ..()
	var/mob/living/simple_animal/hostile/boss/fishboss/boss = controller.pawn
	if(!istype(boss))
		finish_action(controller, FALSE)
		return

	// Set cooldown
	controller.set_blackboard_key(BB_FISHBOSS_DEEP_CALL_COOLDOWN, world.time + 60 SECONDS)

	// Create dramatic effect
	boss.visible_message("<span class='warning'>[boss] calls forth the power of the depths! The water around you trembles with ancient power!</span>")
	playsound(boss, 'sound/misc/explode/explosion.ogg', 100, TRUE)
	new /obj/effect/temp_visual/cult/sparks(get_turf(boss))

	// Buff all existing minions
	for(var/mob/living/simple_animal/hostile/deepone/minion in range(15, boss))
		if(boss.faction_check_atom(minion))
			minion.apply_status_effect(/datum/status_effect/deep_blessing)

	// Summon stronger elite minions
	var/num_elites = rand(2, 4)
	var/list/spawn_locs = list()
	for(var/turf/T in orange(3, boss))
		if(istype(T, /turf/open/floor) && !T.density)
			spawn_locs += T

	if(length(spawn_locs) >= num_elites)
		for(var/i = 1 to num_elites)
			var/turf/spawn_loc = pick(spawn_locs)
			spawn_locs -= spawn_loc

			var/mob/living/simple_animal/hostile/deepone/elite/new_elite = new(spawn_loc)
			new_elite.apply_status_effect(/datum/status_effect/deep_blessing)
			new /obj/effect/temp_visual/guardian/phase/out(spawn_loc)

	finish_action(controller, TRUE)

/datum/status_effect/deep_blessing
	id = "deep_blessing"
	duration = -1 // Permanent until death
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/deep_blessing

/atom/movable/screen/alert/status_effect/deep_blessing
	name = "Deep Blessing"
	desc = "You've been blessed by the Duke of the Deep. Your power is increased."
	icon = 'icons/effects/effects.dmi' // Replace with appropriate icon
	icon_state = "blessing" // Replace with appropriate icon_state

/datum/status_effect/deep_blessing/on_apply()
	. = ..()
	if(ishostile(owner))
		var/mob/living/simple_animal/hostile/H = owner
		H.melee_damage_lower *= 1.3
		H.melee_damage_upper *= 1.3
		H.maxHealth *= 1.5
		H.health = H.maxHealth
		H.color = "#66DDFF"
		H.add_filter("blessing_glow", 2, outline_filter(1, "#3366FF"))
		return TRUE
	return FALSE

/datum/status_effect/deep_blessing/on_remove()
	. = ..()
	if(ishostile(owner))
		var/mob/living/simple_animal/hostile/H = owner
		H.melee_damage_lower /= 1.3
		H.melee_damage_upper /= 1.3
		H.maxHealth /= 1.5
		H.color = initial(H.color)
		H.remove_filter("blessing_glow")
