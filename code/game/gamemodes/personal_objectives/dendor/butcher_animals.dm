/datum/objective/personal/butcher_animals
	name = "Butcher Animals"
	category = "Dendor's Chosen"
	triumph_count = 2
	rewards = list("2 Triumphs", "Dendor grows stronger", "Butchering knowledge")
	var/animals_butchered = 0
	var/animals_required = 2

/datum/objective/personal/butcher_animals/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_MOB_BUTCHERED, PROC_REF(on_animal_butchered))
	update_explanation_text()

/datum/objective/personal/butcher_animals/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_MOB_BUTCHERED)
	return ..()

/datum/objective/personal/butcher_animals/proc/on_animal_butchered(datum/source, mob/animal)
	SIGNAL_HANDLER
	if(completed)
		return

	animals_butchered++
	if(animals_butchered >= animals_required)
		complete_objective()
	else
		to_chat(owner.current, span_notice("Animal butchered! Butcher [animals_required - animals_butchered] more to complete Dendor's will."))

/datum/objective/personal/butcher_animals/complete_objective()
	. = ..()
	to_chat(owner.current, span_greentext("You've butchered enough animals to satisfy Dendor!"))
	adjust_storyteller_influence(DENDOR, 20)
	UnregisterSignal(owner.current, COMSIG_MOB_BUTCHERED)

/datum/objective/personal/butcher_animals/reward_owner()
	. = ..()
	owner.current.adjust_skillrank(/datum/skill/labor/butchering, 1)

/datum/objective/personal/butcher_animals/update_explanation_text()
	explanation_text = "Butcher [animals_required] animal\s to satisfy Dendor."
