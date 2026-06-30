/datum/disease/lycanthropy
	name = "Lycanthropy"

	max_stages = 3
	stage_prob = 3

	disease_flags = UNCURABLE
	severity = DISEASE_SEVERITY_BIOHAZARD
	spread_flags = DISEASE_SPREAD_NON_CONTAGIOUS
	bypasses_immunity = TRUE

/datum/disease/lycanthropy/can_infect(mob/living/carbon/human/human_infectee)
	. = ..()
	if(!.)
		return FALSE

	if(is_species(human_infectee, /datum/species/werewolf))
		return FALSE

	if(IS_WEREWOLF(human_infectee))
		return FALSE

	var/static/list/silver_items = list(
		/obj/item/clothing/neck/psycross/silver,
		/obj/item/clothing/neck/silveramulet
	)

	if(is_type_in_list(human_infectee.wear_wrists, silver_items) || is_type_in_list(human_infectee.wear_neck, silver_items))
		return prob(50)

/datum/disease/lycanthropy/after_add()
	to_chat(affected_mob, span_userdanger("I feel horrible... REALLY horrible."))

/datum/disease/lycanthropy/stage_act()
	. = ..()
	if(!.)
		return

	var/mob/living/carbon/human/infected = affected_mob

	switch(stage)
		if(1)
			if(prob(4))
				to_chat(infected, span_warning("My skin feels itchy."))
			if(prob(3))
				to_chat(infected, span_warning("I feel dizzy."))
			if(prob(1))
				to_chat(infected, span_warning("I smell... blood."))

		if(2)
			if(prob(5))
				to_chat(infected, span_userdanger("The itching won't stop!"))
				if(infected.num_hands >= 1)
					infected.drop_all_held_items()
					infected.emote("scratches", forced = TRUE, intentional = TRUE)
					infected.apply_damage(5, BRUTE)

			if(!HAS_TRAIT(infected, TRAIT_NOBREATH) && prob(4))
				to_chat(infected, span_userdanger("It hurts to breathe!"))
				infected.apply_damage(2, OXY)
				infected.losebreath += 2

		if(3) // Wolf time!
			infected.flash_fullscreen("redflash3")
			to_chat(infected, span_danger("It hurts... Is this really the end for me?"))
			infected.emote("scream") // heres your warning to others bro
			infected.Knockdown(1)

			var/datum/antagonist/werewolf/wolfy = infected.werewolf_check()
			if(!wolfy)
				to_chat(infected, span_danger("Not today."))

			cure(force = TRUE) // Our work is done regardless
