/datum/objective/personal/tame_animal
	name = "Tame an Animal"
	category = "Dendor's Chosen"
	triumph_count = 2
	rewards = list("2 Triumphs", "Dendor grows stronger", "Taming knowledge")
	var/tamed_count = 0
	var/required_tames = 1

/datum/objective/personal/tame_animal/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_ANIMAL_TAMED, PROC_REF(on_animal_tamed))
	update_explanation_text()

/datum/objective/personal/tame_animal/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_ANIMAL_TAMED)
	return ..()

/datum/objective/personal/tame_animal/proc/on_animal_tamed(datum/source, mob/living/simple_animal/animal)
	SIGNAL_HANDLER
	if(completed)
		return

	tamed_count++
	if(tamed_count >= required_tames)
		complete_objective(animal)

/datum/objective/personal/tame_animal/complete_objective(mob/living/simple_animal/animal)
	. = ..()
	to_chat(owner.current, span_greentext("You have tamed [animal], fulfilling Dendor's will!"))
	adjust_storyteller_influence(DENDOR, 20)
	UnregisterSignal(owner.current, COMSIG_ANIMAL_TAMED)

/datum/objective/personal/tame_animal/reward_owner()
	. = ..()
	owner.current.adjust_skillrank(/datum/skill/labor/taming, 1)

/datum/objective/personal/tame_animal/update_explanation_text()
	explanation_text = "Tame an animal, either by feeding it or any other means until it acknowledges you as a friend. Dendor wills it!"
