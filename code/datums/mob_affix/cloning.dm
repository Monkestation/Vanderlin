/datum/mob_affix/mirror_images
	name = "Cloning"
	description = "Creates mirror images of itself when struck in combat"
	color = "#E6E6FA"
	intensity = 1.0
	delve_level = 1
	var/clone_timer
	var/combat_duration_timer
	var/in_combat = FALSE
	var/combat_duration = 10 SECONDS // How long combat mode lasts after being hit

/datum/mob_affix/mirror_images/apply_affix(mob/living/simple_animal/hostile/retaliate/target)
	RegisterSignal(target, COMSIG_MOB_APPLY_DAMGE, PROC_REF(on_damaged))

/datum/mob_affix/mirror_images/proc/on_damaged(mob/living/simple_animal/hostile/retaliate/target)
	SIGNAL_HANDLER

	if(!in_combat)
		start_combat_mode(target)
	else
		// Reset the combat duration timer
		deltimer(combat_duration_timer)
		combat_duration_timer = addtimer(CALLBACK(src, PROC_REF(end_combat_mode)), combat_duration, TIMER_STOPPABLE)

/datum/mob_affix/mirror_images/proc/start_combat_mode(mob/living/simple_animal/hostile/retaliate/target)
	in_combat = TRUE
	clone_timer = addtimer(CALLBACK(src, PROC_REF(create_clones), target), 16 SECONDS, TIMER_STOPPABLE | TIMER_LOOP)
	combat_duration_timer = addtimer(CALLBACK(src, PROC_REF(end_combat_mode)), combat_duration, TIMER_STOPPABLE)

/datum/mob_affix/mirror_images/proc/end_combat_mode()
	in_combat = FALSE
	deltimer(clone_timer)
	clone_timer = null

/datum/mob_affix/mirror_images/proc/create_clones(mob/living/simple_animal/hostile/retaliate/target)
	if(!in_combat)
		return

	var/clones_to_make = 2 + round(intensity)
	for(var/i = 1 to clones_to_make)
		var/turf/spawn_turf = get_turf(target)
		if(spawn_turf)
			var/mob/living/simple_animal/hostile/retaliate/clone = new target.type(spawn_turf)
			clone.faction = target.faction
			clone.maxHealth = target.maxHealth * 0.1 // Weak clones
			clone.health = clone.maxHealth
			clone.melee_damage_lower = target.melee_damage_lower * 0.3
			clone.melee_damage_upper = target.melee_damage_upper * 0.3
			clone.alpha = 150 // Slightly transparent
			QDEL_IN(clone, 5 SECONDS) // Clones disappear after 5 seconds

/datum/mob_affix/mirror_images/cleanup_affix(mob/living/simple_animal/hostile/retaliate/target)
	UnregisterSignal(target, COMSIG_MOB_APPLY_DAMGE)
	deltimer(clone_timer)
	deltimer(combat_duration_timer)
	in_combat = FALSE
