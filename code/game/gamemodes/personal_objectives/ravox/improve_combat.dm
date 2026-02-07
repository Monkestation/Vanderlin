/datum/objective/personal/improve_combat
	name = "Improve Combat Skills"
	category = "Ravox's Chosen"
	triumph_count = 2
	rewards = list("2 Triumphs", "Ravox grows stronger", "Ravox blesses you (+1 Strength)")
	var/levels_gained = 0
	var/required_levels = 2

/datum/objective/personal/improve_combat/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_SKILL_RANK_CHANGE, PROC_REF(on_skill_change))
	update_explanation_text()

/datum/objective/personal/improve_combat/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_SKILL_RANK_CHANGE)
	return ..()

/datum/objective/personal/improve_combat/proc/on_skill_change(datum/source, datum/skill/skill_ref, new_level, old_level)
	SIGNAL_HANDLER
	if(completed)
		return

	if(!istype(skill_ref, /datum/skill/combat))
		return

	var/real_old = (old_level == SKILL_LEVEL_NONE && !owner.current?.has_skill(skill_ref)) ? SKILL_LEVEL_NONE : old_level

	if(new_level <= real_old)
		return

	var/level_diff = new_level - real_old
	levels_gained += level_diff

	if(levels_gained >= required_levels)
		complete_objective()
	else
		var/remaining = required_levels - levels_gained
		to_chat(owner.current, span_notice("Combat skill improved! [remaining] more level[remaining == 1 ? "" : "s"] needed to fulfill Ravox's task!"))

/datum/objective/personal/improve_combat/complete_objective()
	. = ..()
	to_chat(owner.current, span_greentext("You've improved your combat skills enough to satisfy Ravox!"))
	adjust_storyteller_influence(RAVOX, 20)
	UnregisterSignal(owner.current, COMSIG_SKILL_RANK_CHANGE)

/datum/objective/personal/improve_combat/reward_owner()
	. = ..()
	owner.current.adjust_stat_modifier(STATMOD_RAVOX_BLESSING, STATKEY_STR, 1)

/datum/objective/personal/improve_combat/update_explanation_text()
	explanation_text = "Improve your combat skills by gaining [required_levels] new skill levels through practice or dreams. For Ravox!"
