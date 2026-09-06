/datum/worker_attack_strategy
	var/search_objects = FALSE

	var/mob/living/current_target
	var/vision_range = 8
	var/mob/living/worker
	var/simple_detect_bonus = 0

	var/end_current_chase_id
	var/chase_timer = 30 SECONDS

	var/attack_range = 1
	var/obj/projectile/spawning_projectile

/datum/worker_attack_strategy/New(mob/living/incoming_worker)
	. = ..()
	if(!incoming_worker)
		return INITIALIZE_HINT_QDEL
	worker = incoming_worker

/datum/worker_attack_strategy/proc/list_targets()
	if(!search_objects)
		. = hearers(vision_range, worker) - worker //Remove self, so we don't suicide

		var/static/hostile_machines = typecacheof(list())

		for(var/HM in typecache_filter_list(range(vision_range, worker), list()))
			if(can_see(worker, HM, vision_range))
				. += HM
	else
		. = oview(vision_range, worker)

/datum/worker_attack_strategy/proc/find_targets(list/targets = list())
	. = list()
	if(!length(targets))
		targets = list_targets()

	for(var/atom/target in targets)
		if(on_target_selection(target))
			. = list(target)
			break
		if(can_attack(target))
			. += target
			continue
	var/atom/picked_target = pick_target(.)
	if(picked_target)
		give_target(picked_target)
	return picked_target

/datum/worker_attack_strategy/proc/on_target_selection(mob/living/target)
	if(!isliving(target))
		return
	if(target.alpha == 0 && target.rogue_sneaking)
		return worker.npc_detect_sneak(target, simple_detect_bonus)

/datum/worker_attack_strategy/proc/pick_target(list/possible_targets)
	if(current_target)
		var/target_dist = get_dist(worker, current_target)
		for(var/atom/target in possible_targets)
			var/possible_target_distance = get_dist(worker, target)
			if(target_dist < possible_target_distance)
				possible_targets -= target
	if(!length(possible_targets))
		return
	var/chosen_target = pick(possible_targets)
	return chosen_target

/datum/worker_attack_strategy/proc/reset_patience()
	deltimer(end_current_chase_id)
	end_current_chase_id = addtimer(CALLBACK(src, PROC_REF(lose_target)), chase_timer, TIMER_STOPPABLE)

/datum/worker_attack_strategy/proc/give_target(atom/new_target)
	current_target = new_target
	if(current_target)
		reset_patience()
		worker.emote("aggro")
		return TRUE
	deltimer(end_current_chase_id)

/datum/worker_attack_strategy/proc/lose_target()
	current_target = null
	worker.controller_mind.stop_chase()
	deltimer(end_current_chase_id)

/datum/worker_attack_strategy/proc/can_attack(mob/living/possible_target)
	if(!isliving(possible_target))
		return FALSE

	if(possible_target.controller_mind)
		if(possible_target.controller_mind.master != worker.controller_mind.master)
			return TRUE

	if(HAS_TRAIT(possible_target, TRAIT_GODMODE))
		return FALSE

	if(worker.see_invisible < possible_target.invisibility)//Target's invisible to us, forget it
		return FALSE

	return TRUE

/datum/worker_attack_strategy/proc/can_attack_target()
	var/distance = get_dist(worker, current_target)
	if(distance > attack_range)
		return FALSE

	if(current_target.stat >= DEAD)
		lose_target()
		return FALSE

	if(assess_threat_level() > 3)
		call_for_backup()

	reset_patience()
	if(!spawning_projectile)
		worker.AttackingTarget(current_target)
	else
		fire_projectile()
	after_attack()
	return TRUE

/datum/worker_attack_strategy/proc/fire_projectile()
	if( QDELETED(current_target) || current_target == worker.loc || current_target == worker )
		return
	var/turf/startloc = get_turf(worker)
	var/obj/projectile/P = new spawning_projectile(startloc)
	P.starting = startloc
	P.firer = worker
	P.fired_from = worker
	P.yo = current_target.y - startloc.y
	P.xo = current_target.x - startloc.x
	P.original = current_target
	P.preparePixelProjectile(current_target, src)
	P.fire()
	return P

/datum/worker_attack_strategy/proc/after_attack()
	return

/datum/worker_attack_strategy/proc/assess_threat_level()
	if(!current_target)
		return 0

	var/threat = 1
	if(isliving(current_target))
		var/mob/living/L = current_target
		threat = L.health / 10 // Basic threat assessment

	return threat

/datum/worker_attack_strategy/proc/call_for_backup()
	// Alert nearby workers if facing strong enemy
	var/threat = assess_threat_level()
	if(threat > 5)
		for(var/mob/living/ally in view(8, worker))
			if(ally.controller_mind && ally.controller_mind.master == worker.controller_mind.master)
				ally.controller_mind.apply_attack_strategy(/datum/worker_attack_strategy)
				ally.controller_mind.attack_mode.give_target(current_target)
				ally.visible_message("[ally] rushes to help [worker]!")
