/datum/objective/personal/release_fish
	name = "Release Fish"
	category = "Abyssor's Chosen"
	triumph_count = 2
	rewards = list("2 Triumphs", "Abyssor grows stronger", "Fishing knowledge")
	var/released_count = 0
	var/required_count = 1
	var/target_fish_type
	var/target_fish_name

/datum/objective/personal/release_fish/on_creation()
	. = ..()
	var/list/possible_fish = list()
	for(var/obj/item/reagent_containers/food/snacks/fish/F as anything in subtypesof(/obj/item/reagent_containers/food/snacks/fish))
		if(F.status != FISH_DEAD)
			possible_fish += F

	if(length(possible_fish))
		target_fish_type = pick(possible_fish)
		var/obj/item/reagent_containers/food/snacks/fish/F = target_fish_type
		target_fish_name = initial(F.name)

	RegisterSignal(SSdcs, COMSIG_GLOBAL_FISH_RELEASED, PROC_REF(on_fish_released))
	update_explanation_text()

/datum/objective/personal/release_fish/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOBAL_FISH_RELEASED)
	return ..()

/datum/objective/personal/release_fish/proc/on_fish_released(datum/source, obj/item/reagent_containers/food/snacks/fish/fish)
	SIGNAL_HANDLER
	if(completed || !owner?.current)
		return

	if(!istype(fish, target_fish_type) || fish.status == FISH_DEAD)
		return

	released_count++
	if(released_count >= required_count)
		complete_objective()

/datum/objective/personal/release_fish/complete_objective()
	. = ..()
	to_chat(owner.current, span_greentext("The [target_fish_name] has been returned to the depths, pleasing Abyssor!"))
	adjust_storyteller_influence(ABYSSOR, 20)
	UnregisterSignal(SSdcs, COMSIG_GLOBAL_FISH_RELEASED)

/datum/objective/personal/release_fish/reward_owner()
	. = ..()
	owner.current.adjust_skillrank(/datum/skill/labor/fishing, 1)

/datum/objective/personal/release_fish/update_explanation_text()
	explanation_text = "Release an alive [target_fish_name] back to the water to honor Abyssor."
