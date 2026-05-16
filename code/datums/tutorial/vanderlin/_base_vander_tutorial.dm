/datum/tutorial/vanderlin
	category = TUTORIAL_CATEGORY_VANDERLIN
	parent_path = /datum/tutorial/vanderlin
	icon_state = "vanderlin"

/datum/tutorial/vanderlin/init_mob()
	var/mob/living/carbon/human/species/human/northern/new_character = new(bottom_left_corner)

	new_character.key = tutorial_mob.key
	tutorial_mob = new_character
	//RegisterSignal(tutorial_mob, COMSIG_LIVING_GHOSTED, PROC_REF(on_ghost))
	RegisterSignal(tutorial_mob, list(COMSIG_QDELETING, COMSIG_LIVING_DEATH, COMSIG_MOB_END_TUTORIAL), PROC_REF(signal_end_tutorial))
	RegisterSignal(tutorial_mob, COMSIG_MOB_LOGOUT, PROC_REF(on_logout))
	return ..()
