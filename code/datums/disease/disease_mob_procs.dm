
/mob/living/proc/has_disease(datum/disease/disease)
	for(var/datum/disease/DD as anything in diseases)
		if(disease.is_same(DD))
			return TRUE

	return FALSE

/mob/living/proc/contract_contact_disease(datum/disease/disease)
	if(!disease.can_infect(src))
		return FALSE

	return disease.infect(src)

/mob/living/carbon/contract_contact_disease(datum/disease/disease, target_zone)
	if(!disease.can_infect(src))
		return FALSE

	var/passed = TRUE

	var/head_chance = 80
	var/body_chance = 100
	var/hands_chance = 35 / 2
	var/feet_chance = 15 / 2

	if(prob(15 / disease.spreading_modifier))
		return

	if(satiety > 0 && prob(satiety / 2)) // positive satiety makes it harder to contract the infecting.
		return

	if(!target_zone)
		target_zone = pickweight(list(
			BODY_ZONE_HEAD = head_chance,
			BODY_ZONE_CHEST = body_chance,
			BODY_ZONE_R_ARM = hands_chance,
			BODY_ZONE_L_ARM = hands_chance,
			BODY_ZONE_R_LEG = feet_chance,
			BODY_ZONE_L_LEG = feet_chance,
		))
	else
		target_zone = check_zone(target_zone)

	if(ishuman(src))
		var/mob/living/carbon/human/infecting_human = src

		if(HAS_TRAIT(infecting_human, TRAIT_HALE) && !HAS_TRAIT(infecting_human, TRAIT_WASTING_SICKNESS) && prob(75))
			return

		var/base_chance = 60

		// We have no bio armour so its gambling WOO GAMBLING

		switch(target_zone)
			if(BODY_ZONE_HEAD)
				if(isobj(infecting_human.head))
					passed = prob(base_chance - 20)
				if(passed && isobj(infecting_human.wear_mask))
					passed = prob(base_chance - 20)
				if(passed && isobj(infecting_human.wear_neck))
					passed = prob(base_chance - 20)
			if(BODY_ZONE_CHEST)
				if(isobj(infecting_human.wear_armor))
					passed = prob(base_chance - 20)
				if(passed && isobj(infecting_human.wear_shirt))
					passed = prob(base_chance - 20)
			if(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)
				if(isobj(infecting_human.wear_armor) && infecting_human.wear_armor.body_parts_covered & HANDS)
					passed = prob(base_chance - 20)
				if(passed && isobj(infecting_human.gloves))
					passed = prob(base_chance - 20)
			if(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
				if(isobj(infecting_human.wear_armor) && infecting_human.wear_armor.body_parts_covered & FEET)
					passed = prob(base_chance - 20)
				if(passed && isobj(infecting_human.shoes))
					passed = prob(base_chance - 20)

	if(!passed)
		return FALSE

	return disease.infect(src)

/**
 * Handle being contracted a disease via airborne transmission
 *
 * * disease - the disease datum that's infecting us
 */
/mob/living/proc/contract_airborne_disease(datum/disease/disease)
	if(!can_be_spread_airborne_disease())
		return FALSE

	if(!prob(min((50 * disease.spreading_modifier - 1), 50)))
		return FALSE

	if(!disease.has_required_infectious_organ(src, ORGAN_SLOT_LUNGS))
		return FALSE

	return contract_disease(disease)

/// Checks if this mob can currently spread air based diseases.
/// Nondeterministic
/mob/living/proc/can_spread_airborne_diseases()
	SHOULD_CALL_PARENT(TRUE)

	if(HAS_TRAIT(src, TRAIT_NOBREATH))
		return FALSE

	if(losebreath >= 1)
		return FALSE

	// I don't know how you are spreading via air with no head but sure
	if(!get_bodypart(BODY_ZONE_HEAD))
		return TRUE

	var/base_protection = 0
	if(is_mouth_covered(ITEM_SLOT_HEAD))
		base_protection += 40

	if(is_mouth_covered(ITEM_SLOT_MASK))
		base_protection += 40

	if(prob(base_protection))
		return FALSE

	return TRUE

/// Checks if this mob can currently be infected by air based diseases
/// Nondeterministic
/mob/living/proc/can_be_spread_airborne_disease()
	if(HAS_TRAIT(src, TRAIT_NOBREATH))
		return FALSE

	if(losebreath >= 1)
		return FALSE

	if(HAS_TRAIT(src, TRAIT_HALE) && !HAS_TRAIT(src, TRAIT_WASTING_SICKNESS) && prob(75))
		return FALSE

	var/base_protection = 0
	if(is_mouth_covered(ITEM_SLOT_HEAD))
		base_protection += 20
	if(is_mouth_covered(ITEM_SLOT_MASK))
		base_protection += 20

	if(prob(base_protection))
		return FALSE

	return TRUE

/// Proc to use when you 100% want to try to infect someone (ignoreing protective clothing and such), as long as they aren't immune
/mob/living/proc/contract_disease(datum/disease/disease, del_on_fail = TRUE)
	if(!istype(disease))
		disease = new

	if(!disease.can_infect(src))
		if(del_on_fail)
			qdel(disease)
		return FALSE

	disease.infect(src)

	return TRUE
