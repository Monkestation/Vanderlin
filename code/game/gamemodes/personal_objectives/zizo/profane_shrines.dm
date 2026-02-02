/datum/objective/personal/build_zizo_shrine
	name = "Construct Profane Shrines"
	category = "Zizo's Chosen"
	triumph_count = 2
	immediate_effects = list("Gained an ability to construct profane shrines")
	rewards = list("2 Triumphs", "Zizo grows stronger", "Zizo blesses you (+2 Fortune)")
	var/target_type = /obj/structure/fluff/psycross/zizocross
	var/target_count = 2
	var/current_count = 0

/datum/objective/personal/build_zizo_shrine/on_creation()
	. = ..()
	if(owner?.current)
		owner.current.mind.teach_crafting_recipe(/datum/blueprint_recipe/zizo/shrine)
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
		to_chat(owner.current, span_notice("You have built [current_count] out of [target_count] profane shrines."))
		return

	complete_objective()

/datum/objective/personal/build_zizo_shrine/complete_objective()
	. = ..()
	to_chat(owner.current, span_greentext("You have built all the required profane shrines, completing Zizo's objective!"))
	adjust_storyteller_influence(ZIZO, 20)
	UnregisterSignal(owner.current, COMSIG_ITEM_CRAFTED)

/datum/objective/personal/build_zizo_shrine/reward_owner()
	. = ..()
	owner.current.adjust_stat_modifier(STATMOD_ZIZO_BLESSING, STATKEY_LCK, 2)

/datum/objective/personal/build_zizo_shrine/update_explanation_text()
	explanation_text = "Construct [target_count] profane shrine[target_count > 1 ? "s" : ""] to spread Zizo's corruption!"

