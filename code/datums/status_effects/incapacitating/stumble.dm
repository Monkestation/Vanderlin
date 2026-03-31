//STUMBLE
/datum/status_effect/incapacitating/stumble
	id = "stumble"
	var/didknockdown = FALSE

/datum/status_effect/incapacitating/stumble/on_apply()
	. = ..()
	if(!.)
		didknockdown = TRUE
		return
	owner.add_movespeed_modifier("shove", multiplicative_slowdown = 0.85)
	ADD_TRAIT(owner, TRAIT_STUMBLE, TRAIT_STATUS_EFFECT(id))
	if(!didknockdown && iscarbon(owner))
		var/mob/living/carbon/carbon_owner = owner
		switch(carbon_owner.diceroll(GET_MOB_ATTRIBUTE_VALUE(carbon_owner, STAT_ENDURANCE), context = DICE_CONTEXT_PHYSICAL))
			if(DICE_FAILURE)
				carbon_owner.CombatKnockdown(50)
				didknockdown = TRUE
			if(DICE_CRIT_FAILURE)
				carbon_owner.CombatKnockdown(75)
				didknockdown = TRUE

/datum/status_effect/incapacitating/stumble/on_remove()
	owner.remove_movespeed_modifier("shove")
	REMOVE_TRAIT(owner, TRAIT_STUMBLE, TRAIT_STATUS_EFFECT(id))
	if(!didknockdown && iscarbon(owner))
		var/mob/living/carbon/carbon_owner = owner
		switch(carbon_owner.diceroll(GET_MOB_ATTRIBUTE_VALUE(carbon_owner, STAT_ENDURANCE), context = DICE_CONTEXT_PHYSICAL))
			if(DICE_FAILURE)
				carbon_owner.CombatKnockdown(50)
				didknockdown = TRUE
			if(DICE_CRIT_FAILURE)
				carbon_owner.CombatKnockdown(75)
				didknockdown = TRUE
	return ..()
