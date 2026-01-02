/datum/objective/personal/create_abyssoids
	name = "Create Abyssoids"
	category = "Abyssor's Chosen"
	triumph_count = 2
	immediate_effects = list("Gained an ability to create abyssoid leeches")
	rewards = list("2 Triumphs", "Abyssor grows stronger", "Abyssor blesses you (+1 Constitution)")
	var/abyssoids_created = 0
	var/abyssoids_required = 5

/datum/objective/personal/create_abyssoids/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_ABYSSOID_CREATED, PROC_REF(on_abyssoid_created))
	update_explanation_text()

/datum/objective/personal/create_abyssoids/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_ABYSSOID_CREATED)
	return ..()

/datum/objective/personal/create_abyssoids/proc/on_abyssoid_created(datum/source)
	SIGNAL_HANDLER
	if(completed)
		return

	abyssoids_created++

	if(abyssoids_created >= abyssoids_required)
		complete_objective()
	else
		to_chat(owner.current, span_notice("Abyssoid created! [abyssoids_required - abyssoids_created] more abyssoid\s needed."))

/datum/objective/personal/create_abyssoids/complete_objective()
	. = ..()
	to_chat(owner.current, span_greentext("You have created enough abyssoids to satisfy Abyssor!"))
	adjust_storyteller_influence(ABYSSOR, 20)
	UnregisterSignal(owner.current, COMSIG_ABYSSOID_CREATED)

/datum/objective/personal/create_abyssoids/reward_owner()
	. = ..()
	owner.current.adjust_stat_modifier(STATMOD_ABYSSOR_BLESSING, STATKEY_CON, 1)

/datum/objective/personal/create_abyssoids/update_explanation_text()
	explanation_text = "Create [abyssoids_required] abyssoid\s from the common leeches, and then distribute them among the ingrate population!"
