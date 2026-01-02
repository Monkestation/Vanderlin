/datum/objective/personal/embrace_death
	name = "Embrace Death"
	category = "Marked by Necra"
	triumph_count = 3
	immediate_effects = list("Gained an ability to pass on peacefully")
	rewards = list("3 Triumphs", "Necra grows stronger", "Eternal Rest")

/datum/objective/personal/embrace_death/on_creation()
	. = ..()
	if(owner?.current)
		var/datum/action/innate/embrace_death/action = new(src)
		action.Grant(owner.current)
	update_explanation_text()

/datum/objective/personal/embrace_death/complete_objective()
	. = ..()
	adjust_storyteller_influence(NECRA, 20)

/datum/objective/personal/embrace_death/update_explanation_text()
	explanation_text = "Your time has come. Embrace death through Necra's gift to achieve final rest and secure your soul."
