/datum/objective/personal/ultimate_sacrifice
	name = "Ultimate Sacrifice"
	category = "Ravox's Chosen"
	triumph_count = 3
	immediate_effects = list("Gained an ability to give up your life to save another")
	rewards = list("3 Triumphs", "Ravox grows stronger", "Honorable Death")

/datum/objective/personal/ultimate_sacrifice/on_creation()
	. = ..()
	if(owner?.current)
		owner.current.add_spell(/datum/action/cooldown/spell/undirected/list_target/ultimate_sacrifice, source = src)
	update_explanation_text()

/datum/objective/personal/ultimate_sacrifice/complete_objective()
	. = ..()
	adjust_storyteller_influence(RAVOX, 20)

/datum/objective/personal/ultimate_sacrifice/update_explanation_text()
	explanation_text = "Make the highest sacrifice by giving your own life to save truly innocent and worthy soul in the name of Ravox."
