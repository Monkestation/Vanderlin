
/datum/action/cooldown/meatvine/personal/corrosion
	name = "Corrosive Acid"
	desc = "Drench an object in acid, destroying it over time."
	button_icon_state = "alien_acid"
	personal_resource_cost = 20
	click_to_activate = TRUE
	unset_after_click = FALSE

/datum/action/cooldown/meatvine/personal/corrosion/set_click_ability(mob/on_who)
	. = ..()
	if(!.)
		return

	to_chat(on_who, span_noticealien("You prepare to vomit acid. <b>Click a target to acid it!</b>"))
	on_who.update_icons()

/datum/action/cooldown/meatvine/personal/corrosion/unset_click_ability(mob/on_who, refund_cooldown = TRUE)
	. = ..()
	if(!.)
		return

	if(refund_cooldown)
		to_chat(on_who, span_noticealien("You empty your corrosive acid glands."))
	on_who.update_icons()

/datum/action/cooldown/meatvine/personal/corrosion/PreActivate(atom/target)
	if(get_dist(owner, target) > 1)
		return FALSE
	if(ismob(target))
		owner.balloon_alert(owner, "doesn't work on mobs!")
		return FALSE
	if(isfloorturf(target))
		owner.balloon_alert(owner, "doesn't work on floors!")
		return FALSE

	return ..()

/datum/action/cooldown/meatvine/personal/corrosion/Activate(atom/target)
	if(!target.acid_act(200, 1000))
		to_chat(owner, span_noticealien("You cannot dissolve this object."))
		return FALSE

	owner.visible_message(
		span_alertalien("[owner] vomits globs of vile stuff all over [target]. It begins to sizzle and melt under the bubbling mess of acid!"),
		span_noticealien("You vomit globs of acid over [target]. It begins to sizzle and melt."),
	)
	return ..()


/datum/action/cooldown/meatvine/personal/corrosion/evaluate_ai_score(datum/ai_controller/controller)
	var/mob/living/simple_animal/hostile/retaliate/meatvine/mob = owner

	// Look for obstacles blocking spread
	var/atom/obstacle = controller.blackboard[BB_OBSTACLE_TARGET]

	if(!obstacle || QDELETED(obstacle))
		return 0

	if(get_dist(mob, obstacle) > 1)
		return 0

	// High priority for removing obstacles
	return 85

/datum/action/cooldown/meatvine/personal/corrosion/ai_use_ability(datum/ai_controller/controller)
	var/atom/obstacle = controller.blackboard[BB_OBSTACLE_TARGET]

	if(!obstacle || QDELETED(obstacle))
		return FALSE

	if(get_dist(owner, obstacle) > 1)
		return FALSE

	return Activate(obstacle)
