/datum/action/cooldown/meatvine/personal/mark_target
	name = "Mark Target"
	desc = "Mark a living target, making them visible to all putrid. Uses 15 personal resources."
	button_icon_state = "mark_target"
	cooldown_time = 45 SECONDS
	personal_resource_cost = 15
	var/mark_duration = 30 SECONDS

/datum/action/cooldown/meatvine/personal/mark_target/IsAvailable()
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/simple_animal/hostile/retaliate/meatvine/consumed = owner
	if(!consumed.master)
		return FALSE
	return TRUE

/datum/action/cooldown/meatvine/personal/mark_target/Activate(atom/target)
	var/mob/living/simple_animal/hostile/retaliate/meatvine/consumed = owner

	if(!isliving(target))
		to_chat(owner, span_warning("You can only mark living targets!"))
		return FALSE

	var/mob/living/living_target = target
	if(living_target.stat == DEAD)
		to_chat(owner, span_warning("That target is already dead!"))
		return FALSE

	if(consumed.faction_check_mob(living_target))
		to_chat(owner, span_warning("You cannot mark allies!"))
		return FALSE

	if(consumed.master)
		consumed.master.add_hive_tracker(living_target, mark_duration)

	to_chat(owner, span_notice("You mark [living_target] for the hive!"))
	living_target.visible_message(
		span_danger("[consumed] marks [living_target] with a strange energy!"),
		span_userdanger("[consumed] marks you with a strange energy!")
	)

	return ..()

/datum/action/cooldown/meatvine/personal/mark_target/evaluate_ai_score(datum/ai_controller/controller)
	var/mob/living/simple_animal/hostile/retaliate/meatvine/consumed = controller.pawn
	if(!istype(consumed))
		return 0

	if(consumed.personal_resource_pool < personal_resource_cost)
		return 0

	var/mob/living/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(!isliving(target) || target.stat == DEAD)
		return 0
	if(consumed.faction_check_mob(target))
		return 0

	// Calculate distance to target
	var/distance = get_dist(consumed, target)

	// Don't bother if target is too far
	if(distance > 10)
		return 0

	// Score based on proximity - closer = higher priority
	// Max score of 100 when adjacent, decreasing as distance increases
	var/score = max(0, 100 - (distance * 10))

	// Bonus score if target is already injured (more likely to escape/need tracking)
	if(target.health < target.maxHealth * 0.5)
		score += 20

	return score

/datum/action/cooldown/meatvine/personal/mark_target/ai_use_ability(datum/ai_controller/controller)
	var/mob/living/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]

	if(!isliving(target))
		return FALSE

	return Activate(target)

/datum/action/cooldown/meatvine/personal/mark_target/get_movement_target(datum/ai_controller/controller)
	var/mob/living/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(isliving(target) && get_dist(controller.pawn, target) > get_required_range())
		return target
	return null

/datum/action/cooldown/meatvine/personal/mark_target/get_required_range()
	return 7
