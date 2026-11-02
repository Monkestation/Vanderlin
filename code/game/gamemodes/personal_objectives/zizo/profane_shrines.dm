/datum/objective/personal/build_zizo_shrine
	name = "Construct  Inverted Crosses"
	category = "Zizo's Chosen"
	triumph_count = 2
	immediate_effects = list("Gained an ability to construct inverted crosses")
	rewards = list("2 Triumphs", "Zizo grows stronger", "Zizo blesses you (+2 Fortune)")
	var/target_type = /obj/structure/fluff/psycross/zizocross
	var/target_count = 2
	var/current_count = 0

/datum/objective/personal/build_zizo_shrine/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_ITEM_CRAFTED, PROC_REF(on_item_crafted))
	update_explanation_text()

/datum/objective/personal/build_zizo_shrine/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_ITEM_CRAFTED)
	return ..()

/datum/objective/personal/build_zizo_shrine/proc/on_item_crafted(datum/source, mob/user, craft_path)
	SIGNAL_HANDLER
	if(completed || !ispath(craft_path, target_type))
		return

	current_count++
	if(current_count < target_count)
		to_chat(owner.current, span_notice("You have built [current_count] out of [target_count] inverted crosses."))
		return

	complete_objective()

/datum/objective/personal/build_zizo_shrine/complete_objective()
	. = ..()
	to_chat(owner.current, span_greentext("You have built all the required inverted crosses, completing Zizo's objective!"))
	adjust_storyteller_influence(ZIZO, 20)
	UnregisterSignal(owner.current, COMSIG_ITEM_CRAFTED)

/datum/objective/personal/build_zizo_shrine/reward_owner()
	. = ..()
	owner.current.adjust_stat_modifier(STATMOD_ZIZO_BLESSING, list(STAT_FORTUNE = 2))

/datum/objective/personal/build_zizo_shrine/update_explanation_text()
	explanation_text = "Construct [target_count] inverted cross[target_count > 1 ? "s" : ""] to spread Zizo's corruption!"

