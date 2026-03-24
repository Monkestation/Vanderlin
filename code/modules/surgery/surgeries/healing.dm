/datum/surgery/healing
	abstract_type = /datum/surgery/healing
	surgery_flags = SURGERY_REQUIRE_LIMB | SURGERY_IGNORE_CLOTHES

	possible_locs = list(
		BODY_ZONE_HEAD,
		BODY_ZONE_CHEST,
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_LEG,
		BODY_ZONE_L_LEG,
	)

	skill_min = SKILL_LEVEL_APPRENTICE
	skill_median = SKILL_LEVEL_JOURNEYMAN

/datum/surgery/healing/brute
	name = "Tend Bruises"

	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/clamp,
		/datum/surgery_step/retract,
		/datum/surgery_step/heal/brute,
	)

/datum/surgery/healing/burn
	name = "Tend Burns"

	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/clamp,
		/datum/surgery_step/retract,
		/datum/surgery_step/heal/burn,
	)

/datum/surgery/healing/burn/combo
	name = "Tend Wounds"

	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/clamp,
		/datum/surgery_step/retract,
		/datum/surgery_step/heal/combo,
	)

	skill_median = SKILL_LEVEL_EXPERT

/datum/surgery_step/heal
	name = "Repair body"

	implements = list(
		TOOL_SUTURE = 100,
		TOOL_HEMOSTAT = 75,
		TOOL_IMPROVISED_HEMOSTAT = 60,
	)

	time = 4 SECONDS
	repeatable = TRUE

	success_sound = 'sound/surgery/retractor2.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

	/// How much brute damage we heal per completion
	var/brute_healing = 0
	/// How much burn damage we heal per completion
	var/burn_healing = 0
	/**
	 * Heals an extra point of damager per X missing damage of type (burn damage for burn healing, brute for brute)
	 * Smaller Number = More Healing!
	 */
	var/missing_hp_bonus = 0

/datum/surgery_step/heal/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/woundtype
	if(brute_healing && burn_healing)
		woundtype = "wounds"
	else if(brute_healing)
		woundtype = "bruises"
	else if(burn_healing)
		woundtype = "burns"
	else
		return SURGERY_STEP_FAIL

	display_results(
		user,
		target,
		span_notice("I attempt to patch some of [target]'s [woundtype]."),
		span_notice("[user] attempts to patch some of [target]'s [woundtype]."),
		span_notice("[user] attempts to patch some of [target]'s [woundtype]."),
	)

/datum/surgery_step/heal/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/umsg = "You succeed in fixing some of [target]'s wounds" //no period, add initial space to "addons"
	var/tmsg = "[user] fixes some of [target]'s wounds" //see above

	var/healing_multiplier = 1

	if(surgery)
		switch(GET_MOB_SKILL_VALUE_OLD(user, surgery.skill_used))
			if(SKILL_LEVEL_JOURNEYMAN)
				healing_multiplier = 1.1
			if(SKILL_LEVEL_EXPERT)
				healing_multiplier = 1.3
			if(SKILL_LEVEL_MASTER)
				healing_multiplier = 1.4
			if(SKILL_LEVEL_LEGENDARY)
				healing_multiplier = 1.5

	var/urhealedamt_brute = brute_healing * healing_multiplier
	var/urhealedamt_burn = burn_healing * healing_multiplier
	if(missing_hp_bonus)
		var/modifier = (target.stat != DEAD) ? 1 : 5
		if(urhealedamt_brute)
			urhealedamt_brute += round((target.getBruteLoss() / (missing_hp_bonus * modifier)), DAMAGE_PRECISION)
		if(urhealedamt_burn)
			urhealedamt_burn += round((target.getFireLoss() / (missing_hp_bonus * modifier)), DAMAGE_PRECISION)

	if(!get_location_accessible(target, target_zone))
		urhealedamt_brute *= 0.55
		urhealedamt_burn *= 0.55
		umsg += " as best as you can while they have clothing on"
		tmsg += " as best as they can while [target] has clothing on"

	target.heal_bodypart_damage(urhealedamt_brute,urhealedamt_burn, required_status = BODYPART_ORGANIC)

	SEND_SIGNAL(user, COMSIG_LIVING_HEALED_OTHER, urhealedamt_brute + urhealedamt_burn)

	display_results(
		user,
		target,
		span_notice("[umsg]."),
		span_notice("[tmsg]."),
		span_notice("[tmsg]."),
	)

	return TRUE

/datum/surgery_step/heal/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, fail_prob)
	display_results(
		user,
		target,
		span_warning("I screwed up!"),
		span_warning("[user] screws up!"),
		span_notice("[user] fixes some of [target]'s wounds. But screws up!"),
		TRUE,
	)

	var/urdamageamt_burn = brute_healing * 0.8
	var/urdamageamt_brute = burn_healing * 0.8

	if(missing_hp_bonus)
		if(urdamageamt_brute)
			urdamageamt_brute += round((target.getBruteLoss() / (missing_hp_bonus * 2)), DAMAGE_PRECISION)
		if(urdamageamt_burn)
			urdamageamt_burn += round((target.getFireLoss() / (missing_hp_bonus * 2)), DAMAGE_PRECISION)

	target.take_bodypart_damage(urdamageamt_brute, urdamageamt_burn, required_status = BODYPART_ORGANIC)

	return TRUE

/********************BRUTE STEPS********************/
/datum/surgery_step/heal/brute
	name = "Tend bruises"
	brute_healing = 10
	missing_hp_bonus = 5

/********************BURN STEPS********************/
/datum/surgery_step/heal/burn
	name = "Tend burns"
	burn_healing = 10
	missing_hp_bonus = 5

/********************COMBO STEPS********************/
/datum/surgery_step/heal/combo
	name = "Tend damage"
	brute_healing = 6
	burn_healing = 6
	missing_hp_bonus = 5
