/datum/objective/personal/wise_trees
	name = "Create Wise Trees"
	category = "Dendor's Chosen"
	triumph_count = 2
	immediate_effects = list("Gained an ability to make wise trees")
	rewards = list("2 Triumphs", "Dendor grows stronger", "Dendor blesses you (+1 Fortune)")
	var/trees_transformed = 0
	var/trees_required = 3

/datum/objective/personal/wise_trees/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_TREE_TRANSFORMED, PROC_REF(on_tree_transformed))
	update_explanation_text()

/datum/objective/personal/wise_trees/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_TREE_TRANSFORMED)
	return ..()

/datum/objective/personal/wise_trees/proc/on_tree_transformed(datum/source)
	SIGNAL_HANDLER
	if(completed)
		return

	trees_transformed++
	to_chat(owner.current, span_green("Tree transformed! [trees_required - trees_transformed] more tree\s needed."))

	if(trees_transformed >= trees_required)
		complete_objective()

/datum/objective/personal/wise_trees/complete_objective()
	. = ..()
	to_chat(owner.current, span_greentext("You have created enough wise trees to satisfy Dendor!"))
	adjust_storyteller_influence(DENDOR, 20)
	UnregisterSignal(owner.current, COMSIG_TREE_TRANSFORMED)

/datum/objective/personal/wise_trees/reward_owner()
	. = ..()
	owner.current.adjust_stat_modifier(STATMOD_DENDOR_BLESSING, STATKEY_LCK, 1)

/datum/objective/personal/wise_trees/update_explanation_text()
	explanation_text = "Transform [trees_required] common trees into guardian wise trees using Dendor's blessing."
