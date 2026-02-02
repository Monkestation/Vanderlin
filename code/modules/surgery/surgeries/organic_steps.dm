//BASIC SURGERY STEPS

/// Incision
/datum/surgery_step/incise
	name = "Incise"
	implements = list(
		TOOL_SCALPEL = 80,
		TOOL_SHARP = 60,
	) // 60% success with any sharp item.
	target_mobtypes = list(/mob/living/carbon/human, /mob/living/simple_animal)
	time = 1.6 SECONDS
	surgery_flags = SURGERY_BLOODY
	surgery_flags_blocked = SURGERY_INCISED
	skill_min = SKILL_LEVEL_NOVICE
	skill_median = SKILL_LEVEL_APPRENTICE
	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/scalpel2.ogg'

/datum/surgery_step/incise/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, "<span class='notice'>I begin to make an incision in [target]'s [parse_zone(target_zone)]...</span>",
		"<span class='notice'>[user] begins to make an incision in [target]'s [parse_zone(target_zone)].</span>",
		"<span class='notice'>[user] begins to make an incision in [target]'s [parse_zone(target_zone)].</span>")
	return TRUE

/datum/surgery_step/incise/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, "<span class='notice'>Blood pools around the incision in [target]'s [parse_zone(target_zone)].</span>",
		"<span class='notice'>Blood pools around the incision in [target]'s [parse_zone(target_zone)].</span>")
	var/obj/item/bodypart/gotten_part = target.get_bodypart(check_zone(target_zone))
	if(gotten_part)
		gotten_part.add_wound(/datum/wound/slash/incision)
	return TRUE

/// Clamping
/datum/surgery_step/clamp
	name = "Clamp bleeders"
	implements = list(
		TOOL_HEMOSTAT = 75,
		TOOL_WIRECUTTER = 60,
		TOOL_IMPROVISED_HEMOSTAT = 38,
	)
	time = 2.4 SECONDS
	surgery_flags_blocked = SURGERY_CLAMPED
	skill_min = SKILL_LEVEL_NOVICE
	skill_median = SKILL_LEVEL_JOURNEYMAN
	preop_sound = 'sound/surgery/hemostat1.ogg'

/datum/surgery_step/clamp/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, "<span class='notice'>I begin to clamp bleeders in [target]'s [parse_zone(target_zone)]...</span>",
		"<span class='notice'>[user] begins to clamp bleeders in [target]'s [parse_zone(target_zone)].</span>",
		"<span class='notice'>[user] begins to clamp bleeders in [target]'s [parse_zone(target_zone)].</span>")
	return TRUE

/datum/surgery_step/clamp/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, "<span class='notice'>I clamp the bleeders in [target]'s [parse_zone(target_zone)].</span>",
		"<span class='notice'>[user] clamps the bleeders in [target]'s [parse_zone(target_zone)].</span>",
		"<span class='notice'>[user] clamps the bleeders in [target]'s [parse_zone(target_zone)].</span>")
	var/obj/item/bodypart/bodypart = target.get_bodypart(check_zone(target_zone))
	bodypart?.add_embedded_object(tool, crit_message = FALSE)
	return TRUE

/// Retracting
/datum/surgery_step/retract
	name = "Retract incision"
	implements = list(
		TOOL_RETRACTOR = 75,
		TOOL_SCREWDRIVER = 50,
		TOOL_IMPROVISED_RETRACTOR = 38,
		TOOL_WIRECUTTER = 35,
	)
	time = 2.4 SECONDS
	surgery_flags_blocked = SURGERY_RETRACTED
	skill_min = SKILL_LEVEL_NOVICE
	skill_median = SKILL_LEVEL_JOURNEYMAN
	preop_sound = 'sound/surgery/retractor1.ogg'

/datum/surgery_step/retract/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, "<span class='notice'>I begin to retract [target]'s [parse_zone(target_zone)]...</span>",
		"<span class='notice'>[user] begins to retract [target]'s [parse_zone(target_zone)].</span>",
		"<span class='notice'>[user] begins to retract [target]'s [parse_zone(target_zone)].</span>")
	return TRUE

/datum/surgery_step/retract/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, "<span class='notice'>I retract [target]'s [parse_zone(target_zone)].</span>",
		"<span class='notice'>[user] retract [target]'s [parse_zone(target_zone)].</span>",
		"<span class='notice'>[user] retract [target]'s [parse_zone(target_zone)].</span>")
	var/obj/item/bodypart/bodypart = target.get_bodypart(check_zone(target_zone))
	bodypart?.add_embedded_object(tool, crit_message = FALSE)
	return TRUE

/// Cauterize
/datum/surgery_step/cauterize
	name = "Cauterize wounds"
	implements = list(
		TOOL_CAUTERY = 100,
		TOOL_WELDER = 70,
		TOOL_HOT = 35,
	)
	time = 2.4 SECONDS
	surgery_flags = SURGERY_BLOODY
	skill_min = SKILL_LEVEL_NOVICE
	skill_median = SKILL_LEVEL_APPRENTICE

/datum/surgery_step/cauterize/validate_bodypart(mob/user, mob/living/carbon/target, obj/item/bodypart/bodypart, target_zone)
	. = ..()
	if(!.)
		return
	return length(bodypart.wounds)

/datum/surgery_step/cauterize/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, "<span class='notice'>I begin to cauterize the wounds on [target]'s [parse_zone(target_zone)]...</span>",
		"<span class='notice'>[user] begins to cauterize the wounds on [target]'s [parse_zone(target_zone)].</span>",
		"<span class='notice'>[user] begins to cauterize the wounds on [target]'s [parse_zone(target_zone)].</span>")
	return TRUE

/datum/surgery_step/cauterize/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, "<span class='notice'>I cauterize the wounds on [target]'s [parse_zone(target_zone)].</span>",
		"<span class='notice'>[user] cauterizes the wounds on [target]'s [parse_zone(target_zone)].</span>",
		"<span class='notice'>[user] cauterizes the wounds on [target]'s [parse_zone(target_zone)].</span>")
	var/obj/item/bodypart/bodypart = target.get_bodypart(check_zone(target_zone))
	if(bodypart)
		for(var/datum/wound/bleeder in bodypart.wounds)
			bleeder.cauterize_wound()
		bodypart.receive_damage(burn = 40) //painful, but the wounds go away eh?
	target.emote("scream")
	return TRUE

/// Saw bone
/datum/surgery_step/saw
	name = "Saw bone"
	implements = list(
		TOOL_SAW = 80,
		TOOL_IMPROVISED_SAW = 65,
		TOOL_SHOVEL = 50,
		TOOL_SHARP = 25,
	)
	possible_locs = list(
		BODY_ZONE_PRECISE_SKULL,
		BODY_ZONE_HEAD,
		BODY_ZONE_PRECISE_NECK,
		BODY_ZONE_CHEST,
		BODY_ZONE_PRECISE_GROIN,
		BODY_ZONE_R_ARM,
		BODY_ZONE_PRECISE_R_HAND,
		BODY_ZONE_L_ARM,
		BODY_ZONE_PRECISE_L_HAND,
		BODY_ZONE_R_LEG,
		BODY_ZONE_PRECISE_R_FOOT,
		BODY_ZONE_L_LEG,
		BODY_ZONE_PRECISE_L_FOOT,
	)
	time = 5 SECONDS
	surgery_flags = SURGERY_INCISED | SURGERY_RETRACTED
	surgery_flags_blocked = SURGERY_BROKEN
	skill_min = SKILL_LEVEL_NOVICE
	skill_median = SKILL_LEVEL_EXPERT
	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/saw/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, "<span class='notice'>I begin to saw through the bone in [target]'s [parse_zone(target_zone)]...</span>",
		"<span class='notice'>[user] begins to saw through the bone in [target]'s [parse_zone(target_zone)].</span>",
		"<span class='notice'>[user] begins to saw through the bone in [target]'s [parse_zone(target_zone)].</span>")
	return TRUE

/datum/surgery_step/saw/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, "<span class='notice'>I saw [target]'s [parse_zone(target_zone)] open.</span>",
		"<span class='notice'>[user] saws [target]'s [parse_zone(target_zone)] open!</span>",
		"<span class='notice'>[user] saws [target]'s [parse_zone(target_zone)] open!</span>")
	var/obj/item/bodypart/bodypart = target.get_bodypart(check_zone(target_zone))
	if(bodypart)
		var/fracture_type = /datum/wound/fracture
		//yes we ignore crit resist here because this is a proper surgical procedure, not a crit
		switch(bodypart.body_zone)
			if(BODY_ZONE_HEAD)
				fracture_type = /datum/wound/fracture/head
			if(BODY_ZONE_PRECISE_NECK)
				fracture_type = /datum/wound/fracture/neck
			if(BODY_ZONE_CHEST)
				fracture_type = /datum/wound/fracture/chest
			if(BODY_ZONE_PRECISE_GROIN)
				fracture_type = /datum/wound/fracture/groin
		bodypart.add_wound(fracture_type)
	target.emote("scream")
	return TRUE
