/datum/ai_behavior/fishboss_summon_minions
	action_cooldown = 60 SECONDS // Matches the original cooldown of 600

/datum/ai_behavior/fishboss_summon_minions/perform(seconds_per_tick, datum/ai_controller/controller, minions_key)
	. = ..()
	var/mob/living/simple_animal/hostile/boss/fishboss/fishboss = controller.pawn
	var/minions_to_spawn = controller.blackboard[minions_key]
	var/phase = controller.blackboard[BB_RAGE_PHASE]
	if(phase <= 1)
		controller.set_blackboard_key(BB_NEXT_SUMMON, world.time + (60 - (phase * 10)) SECONDS)  // Reduce cooldown in higher phases
		finish_action(controller, TRUE)
		return

	// Adjust spawn numbers based on phase
	var/actual_minions = minions_to_spawn
	if(phase >= 1)
		actual_minions += 2
	if(phase >= 2)
		actual_minions += 2
	if(phase >= 3)
		actual_minions += 3

	spawn_minions(fishboss, actual_minions, phase)

	// More dramatic message based on phase
	var/message = "Ggglg- ♐︎◆︎♋︎❒︎♑︎'♎︎□︎♓︎♑︎!"
	if(phase >= 2)
		message = "♐︎◆︎♋︎❒︎♑︎'♎︎ 🙱⋢⎍⏁ ☊⏃⋏⏁ ⏚⟒ ⌇⏁⍜⌿⌿⟒⎅!"
	if(phase >= 3)
		message = "☌⏃☊⊑-☌⍜⏁⊑⟟☈ ⊑⟟♐︎◆︎♋︎❒︎♑︎ ⋔⟒☌⏃☊⊑⏁⟒⌇!"

	INVOKE_ASYNC(fishboss, TYPE_PROC_REF(/atom/movable, say), message, null, list("colossus", "yell"))

	// Add visual effect
	new /obj/effect/temp_visual/cult/sparks(get_turf(fishboss))

	controller.set_blackboard_key(BB_NEXT_SUMMON, world.time + (60 - (phase * 10)) SECONDS)  // Reduce cooldown in higher phases
	finish_action(controller, TRUE)

/datum/ai_behavior/fishboss_summon_minions/proc/spawn_minions(mob/living/simple_animal/fishboss, minions_to_spawn, phase)
	var/list/minions = list(
		/mob/living/simple_animal/hostile/deepone/boss = 40,
		/mob/living/simple_animal/hostile/deepone/spit/boss = 30,
		/mob/living/simple_animal/hostile/deepone/arm/boss = 20,
		/mob/living/simple_animal/hostile/deepone/wiz/boss = 20
	)

	// In higher phases, add some elite versions
	if(phase >= 2)
		minions[/mob/living/simple_animal/hostile/deepone/elite] = 15
	if(phase >= 3)
		minions[/mob/living/simple_animal/hostile/deepone/elite] = 25

	var/i = 0
	while (i < minions_to_spawn)
		var/turf/spawn_turf = get_random_valid_turf(fishboss)
		if (spawn_turf)
			var/mob_type = pickweight(minions)
			var/mob/living/new_mob = new mob_type(spawn_turf)
			if (new_mob)
				// Visual effect for spawning
				new /obj/effect/temp_visual/guardian/phase/out(spawn_turf)

				// In phase 3, give a chance for spawn with buff
				if(phase >= 3 && prob(30))
					new_mob.apply_status_effect(/datum/status_effect/deep_blessing)
		i++

/datum/ai_behavior/fishboss_summon_minions/proc/get_random_valid_turf(mob/living/simple_animal/fishboss)
	var/list/valid_turfs = list()
	for (var/turf/T in range(6, fishboss))
		if (is_valid_spawn_turf(T))
			valid_turfs += T
	if (valid_turfs.len == 0)
		return null
	return pick(valid_turfs)

/datum/ai_behavior/fishboss_summon_minions/proc/is_valid_spawn_turf(turf/T)
	if (!(istype(T, /turf/open/floor)))
		return FALSE
	if (istype(T, /turf/closed))
		return FALSE
	return TRUE
