/datum/action/cooldown/spell/detect_singles
	name = "Find Singles"
	button_icon_state = "love"
	sound = null
	self_cast_possible = FALSE
	has_visual_effects = FALSE

	antimagic_flags = NONE
	charge_required = FALSE
	cooldown_time = 10 SECONDS

/datum/action/cooldown/spell/detect_singles/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	return ishuman(cast_on)

/datum/action/cooldown/spell/detect_singles/cast(mob/living/carbon/human/cast_on)
	. = ..()
	if(cast_on.IsWedded())
		to_chat(owner, span_love("\The [cast_on] has a spouse! May they find happiness in each other."))
	else
		if(cast_on.age == AGE_CHILD)
			to_chat(owner, span_warning("\The [cast_on] is a mere child! Of course they don't have any partner."))
		else if(length(cast_on?.mind?.personal_objectives))
			var/datum/objective/personal/marry/marry_objective = locate() in cast_on.mind.personal_objectives
			if(!marry_objective.completed)
				to_chat(owner, span_love("\The [cast_on] is single and their heart is aching for love!"))
			else
				to_chat(owner, span_warning("\The [cast_on] has no romantic partner! How could this be?!"))
		else
			to_chat(owner, span_warning("\The [cast_on] has no romantic partner! How could this be?!"))
