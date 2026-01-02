/mob/living/carbon/slip(knockdown_amount, obj/O, lube, paralyze, force_drop)
	if(movement_type & FLYING)
		return 0
	if(!(lube&SLIDE_ICE))
		log_combat(src, (O ? O : get_turf(src)), "slipped on the", null, ((lube & SLIDE) ? "(LUBE)" : null))
	return loc.handle_slip(src, knockdown_amount, O, lube, paralyze, force_drop)

/mob/living/carbon/Move(NewLoc, direct)
	. = ..()
	if(. && !(movement_type & FLOATING)) //floating is easy
		if(HAS_TRAIT(src, TRAIT_NOHUNGER))
			set_nutrition(NUTRITION_LEVEL_FED - 1)	//just less than feeling vigorous
			set_hydration(HYDRATION_LEVEL_START_MAX - 1)	//just less than feeling vigorous
		else if(stat != DEAD)
			adjust_nutrition(-(0.05))
			adjust_hydration(-(0.05))
			if(m_intent == MOVE_INTENT_RUN)
				adjust_nutrition(-(0.1))
				adjust_hydration(-(0.1))
		if(m_intent == MOVE_INTENT_RUN) //sprint fatigue add
			adjust_stamina(2)

/mob/living/carbon/update_limbless_locomotion()
	var/leg_supports = COUNT_TRAIT_SOURCES(src, TRAIT_NO_LEG_AID)
	// 2 legs to stand on your own, flying/floating, or having at least 1 leg with supports (so you can't float with two walking sticks)
	if(usable_legs >= 2 || (movement_type & (FLYING|FLOATING)) || (usable_legs >= 1 && leg_supports >= 1))
		REMOVE_TRAIT(src, TRAIT_FLOORED, LACKING_LOCOMOTION_APPENDAGES_TRAIT)
	else
		ADD_TRAIT(src, TRAIT_FLOORED, LACKING_LOCOMOTION_APPENDAGES_TRAIT)

	//From having no usable limbs to having something.
	if(usable_legs > 0 || (movement_type & (FLYING|FLOATING)) || leg_supports > 0 || usable_hands != 0)
		REMOVE_TRAIT(src, TRAIT_IMMOBILIZED, LACKING_LOCOMOTION_APPENDAGES_TRAIT)
	else
		ADD_TRAIT(src, TRAIT_IMMOBILIZED, LACKING_LOCOMOTION_APPENDAGES_TRAIT)

/mob/living/carbon/set_usable_hands(new_value)
	. = ..()
	if(isnull(.))
		return
	if(. == 0)
		REMOVE_TRAIT(src, TRAIT_HANDS_BLOCKED, LACKING_MANIPULATION_APPENDAGES_TRAIT)
	else if(usable_hands == 0 && default_num_hands > 0) //From having usable hands to no longer having them.
		ADD_TRAIT(src, TRAIT_HANDS_BLOCKED, LACKING_MANIPULATION_APPENDAGES_TRAIT)

/// Called when movement_type trait is added to the mob.
/mob/living/carbon/on_movement_type_flag_enabled(datum/source, flag, old_movement_type)
	. = ..()
	if(movement_type & (FLYING | FLOATING) && !(old_movement_type & (FLYING | FLOATING)))
		update_limbless_locomotion()
		update_limbless_movespeed_mod()

/mob/living/carbon/on_movement_type_flag_disabled(datum/source, flag, old_movement_type)
	. = ..()
	if(old_movement_type & (FLYING | FLOATING) && !(movement_type & (FLYING | FLOATING)))
		update_limbless_locomotion()
		update_limbless_movespeed_mod()
