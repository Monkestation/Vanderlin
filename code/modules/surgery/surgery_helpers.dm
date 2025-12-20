/proc/get_location_accessible(mob/victim, location = BODY_ZONE_CHEST, grabs = FALSE, skipundies = TRUE)
	var/covered_locations = NONE	//based on body_parts_covered
	if(iscarbon(victim))
		var/mob/living/carbon/carbon_victim = victim
		for(var/obj/item/equipped_item in carbon_victim.get_equipped_items(include_pockets = FALSE))
			if(zone2covered(location, equipped_item.body_parts_covered) && equipped_item.surgery_cover)
				return FALSE
		if(ishuman(carbon_victim))
			var/mob/living/carbon/human/human_victim = carbon_victim
			if(!skipundies)
				if(human_victim.underwear != "Nude")
					covered_locations |= GROIN
			if(grabs)
				for(var/obj/item/grabbing/grab in human_victim.grabbedby)
					if(grab.sublimb_grabbed == BODY_ZONE_PRECISE_GROIN)
						covered_locations |= GROIN
					if(grab.sublimb_grabbed == BODY_ZONE_PRECISE_MOUTH)
						covered_locations |= MOUTH
			if(zone2covered(location, covered_locations))
				return FALSE
	return TRUE

/proc/zone2covered(location, covered_locations)
	switch(location)
		if(BODY_ZONE_HEAD)
			if(covered_locations & HEAD)
				return TRUE
		if(BODY_ZONE_PRECISE_EARS)
			if(covered_locations & EARS)
				return TRUE
		if(BODY_ZONE_PRECISE_SKULL)
			if(covered_locations & HAIR)
				return TRUE
		if(BODY_ZONE_PRECISE_NOSE)
			if(covered_locations & NOSE)
				return TRUE
		if(BODY_ZONE_PRECISE_NECK)
			if(covered_locations & NECK)
				return TRUE
		if(BODY_ZONE_PRECISE_L_EYE)
			if(covered_locations & LEFT_EYE)
				return TRUE
		if(BODY_ZONE_PRECISE_R_EYE)
			if(covered_locations & RIGHT_EYE)
				return TRUE
		if(BODY_ZONE_PRECISE_MOUTH)
			if(covered_locations & MOUTH)
				return TRUE
		if(BODY_ZONE_CHEST)
			if(covered_locations & CHEST)
				return TRUE
		if(BODY_ZONE_PRECISE_STOMACH)
			if(covered_locations & VITALS)
				return TRUE
		if(BODY_ZONE_PRECISE_GROIN)
			if(covered_locations & GROIN)
				return TRUE
		if(BODY_ZONE_L_ARM)
			if(covered_locations & ARM_LEFT)
				return TRUE
		if(BODY_ZONE_R_ARM)
			if(covered_locations & ARM_RIGHT)
				return TRUE
		if(BODY_ZONE_L_LEG)
			if(covered_locations & LEG_LEFT)
				return TRUE
		if(BODY_ZONE_R_LEG)
			if(covered_locations & LEG_RIGHT)
				return TRUE
		if(BODY_ZONE_PRECISE_L_HAND)
			if(covered_locations & HAND_LEFT)
				return TRUE
		if(BODY_ZONE_PRECISE_R_HAND)
			if(covered_locations & HAND_RIGHT)
				return TRUE
		if(BODY_ZONE_PRECISE_L_FOOT)
			if(covered_locations & FOOT_LEFT)
				return TRUE
		if(BODY_ZONE_PRECISE_R_FOOT)
			if(covered_locations & FOOT_RIGHT)
				return TRUE

	return FALSE
