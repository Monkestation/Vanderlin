/datum/action/cooldown/meatvine/personal/evade
	name = "Evade"
	desc = "Allows you to evade any projectile or swing that would hit you for a few seconds."
	button_icon_state = "evade"
	personal_resource_cost = 50
	cooldown_time = 60 SECONDS
	/// If the evade ability is currently active or not
	var/evade_active = FALSE
	/// How long evasion should last
	var/evasion_duration = 10 SECONDS

/datum/action/cooldown/meatvine/personal/evade/Activate(atom/target)
	. = ..()
	if(evade_active) //Can't evade while we're already evading.
		owner.balloon_alert(owner, "already evading")
		return FALSE

	owner.balloon_alert(owner, "evasive movements began")
	addtimer(CALLBACK(src, PROC_REF(evasion_deactivate)), evasion_duration)
	evade_active = TRUE
	RegisterSignal(owner, COMSIG_PROJECTILE_ON_HIT, PROC_REF(on_projectile_hit))
	ADD_TRAIT(owner, TRAIT_EVASIVE, INNATE_TRAIT)
	return TRUE

/// Handles deactivation of the xeno evasion ability, mainly unregistering the signal and giving a balloon alert
/datum/action/cooldown/meatvine/personal/evade/proc/evasion_deactivate()
	evade_active = FALSE
	owner.balloon_alert(owner, "evasion ended")
	UnregisterSignal(owner, COMSIG_PROJECTILE_ON_HIT)
	REMOVE_TRAIT(owner, TRAIT_EVASIVE, INNATE_TRAIT)

/// Handles if either BULLET_ACT_HIT or BULLET_ACT_FORCE_PIERCE happens to something using evade
/datum/action/cooldown/meatvine/personal/evade/proc/on_projectile_hit()
	if(owner.incapacitated(IGNORE_GRAB) || !isturf(owner.loc) || !evade_active)
		return BULLET_ACT_HIT

	owner.visible_message(span_danger("[owner] effortlessly dodges the projectile!"), span_userdanger("You dodge the projectile!"))
	owner.add_filter("evade", 2, gauss_blur_filter(5))
	addtimer(CALLBACK(owner, TYPE_PROC_REF(/atom/movable, remove_filter), "evade"), 0.5 SECONDS)
	return BULLET_ACT_FORCE_PIERCE


/datum/action/cooldown/meatvine/personal/evade/evaluate_ai_score(datum/ai_controller/controller)
	var/mob/living/simple_animal/hostile/retaliate/meatvine/mob = owner

	if(evade_active)
		return 0

	// Use when taking ranged fire
	var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]

	if(!target)
		return 0

	var/dist = get_dist(mob, target)

	// Use evade when fighting ranged enemies at distance
	if(dist >= 5 && dist <= 15)
		// Check if we've taken damage recently (last 3 seconds)
		if(mob.health < mob.maxHealth * 0.8)
			return 70

	return 0

/datum/action/cooldown/meatvine/personal/evade/ai_use_ability(datum/ai_controller/controller)
	return Activate(null)
