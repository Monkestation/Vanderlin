/** BURNS **/
/datum/injury/intense_burn
	damage_type = WOUND_INTENSE_BURN
	autoheal_cutoff = 6
	infection_rate = 1.25
	pain_modifier = 2
	bleed_rate = BLEED_DAMAGE_RATIO / 100 // burns generally don't bleed much

/datum/injury/intense_burn/infection_check()
	//anything less than a FUCK burn isn't infectable if treated properly
	var/normalized_damage = damage_per_injury()
	if(is_treated() && normalized_damage < 25)
		return FALSE
	if(is_disinfected())
		return FALSE
	//Robotic injury
	if(required_status == BODYPART_ROBOTIC)
		return FALSE

	switch(damage_type)
		if(WOUND_BLUNT)
			return prob(normalized_damage/2)
		if(WOUND_BURN, WOUND_INTENSE_BURN)
			return prob(normalized_damage*2)
		if(WOUND_SLASH)
			return prob(normalized_damage)
		if(WOUND_PUNCTURE)
			return prob(normalized_damage*1.25)

	return FALSE

/datum/injury/intense_burn/can_merge(datum/injury/other)
	return FALSE // don't merge burns so we can calculate fluid loss correctly

/datum/injury/intense_burn/apply_to_bodypart(obj/item/bodypart/limb)
	. = ..()
	//Burn damage can cause fluid loss due to blistering and cook-off
	if(limb.owner && (limb.burn_dam/limb.max_damage) >= 0.25) // medium burn damage
		limb.owner.adjust_blood_volume(-CEILING(BLOOD_VOLUME_SURVIVE * damage/150, 1))

/*
/datum/injury/intense_burn/receive_damage(damage_received = 0, pain_received = 0, wounding_type = WOUND_BLUNT)
	. = ..()
	if((wounding_type & WOUND_BURN) && (damage + damage_received >= 50) && parent_bodypart)
		if(!parent_bodypart.is_dead())
			if(parent_bodypart.is_organic_limb())
				parent_bodypart.kill_limb()
			else
				if(parent_bodypart.dismemberable)
					parent_bodypart.dismember(BURN)
		else if(parent_bodypart.dismemberable)
			parent_bodypart.dismember(BURN)
*/

/datum/injury/intense_burn/moderate
	bleed_threshold = 10
	stages = list(
		"ripped burn" = 10,
		"moderate burn" = 5,
		"healing moderate burn" = 2,
		"fresh skin" = 0
		)

/datum/injury/intense_burn/large
	bleed_threshold = 20
	stages = list(
		"ripped large burn" = 20,
		"large burn" = 15,
		"healing large burn" = 5,
		"fresh burn scar" = 0
		)
	fade_away_time = INFINITY

/datum/injury/intense_burn/severe
	bleed_threshold = 35
	stages = list(
		"ripped severe burn" = 35,
		"severe burn" = 30,
		"healing severe burn" = 10,
		"burn scar" = 0
		)
	fade_away_time = INFINITY

/datum/injury/intense_burn/deep
	bleed_threshold = 45
	stages = list(
		"ripped deep burn" = 45,
		"deep burn" = 40,
		"healing deep burn" = 15,
		"large burn scar" = 0
		)
	fade_away_time = INFINITY

/datum/injury/intense_burn/carbonised
	bleed_threshold = 50
	stages = list(
		"carbonised area" = 50,
		"healing carbonised area" = 20,
		"massive burn scar" = 0
		)
	fade_away_time = INFINITY
