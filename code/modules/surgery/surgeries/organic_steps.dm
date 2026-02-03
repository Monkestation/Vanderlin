//BASIC SURGERY STEPS

/// Incision
/datum/surgery_step/incise
	name = "Incise"

	implements = list(
		TOOL_SCALPEL = 80,
		TOOL_SHARP = 60,
	)

	time = 1.6 SECONDS

	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/scalpel2.ogg'

/datum/surgery_step/incise/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(
		user,
		target,
		span_notice("I begin to make an incision in [target]'s [parse_zone(target_zone)]..."),
		span_notice("[user] begins to make an incision in [target]'s [parse_zone(target_zone)]."),
		span_notice("[user] begins to make an incision in [target]'s [parse_zone(target_zone)].")
	)

/datum/surgery_step/incise/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(
		user,
		target,
		span_notice("Blood pools around the incision in [target]'s [parse_zone(target_zone)]."),
		span_notice("Blood pools around the incision in [target]'s [parse_zone(target_zone)]."),
	)

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

	preop_sound = 'sound/surgery/hemostat1.ogg'

/datum/surgery_step/clamp/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(
		user,
		target,
		span_notice("I begin to clamp bleeders in [target]'s [parse_zone(target_zone)]..."),
		span_notice("[user] begins to clamp bleeders in [target]'s [parse_zone(target_zone)]."),
		span_notice("[user] begins to clamp bleeders in [target]'s [parse_zone(target_zone)]."),
	)

/datum/surgery_step/clamp/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(
		user,
		target,
		span_notice("I clamp the bleeders in [target]'s [parse_zone(target_zone)]."),
		span_notice("[user] clamps the bleeders in [target]'s [parse_zone(target_zone)]."),
		span_notice("[user] clamps the bleeders in [target]'s [parse_zone(target_zone)]."),
	)

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

	preop_sound = 'sound/surgery/retractor1.ogg'

/datum/surgery_step/retract/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(
		user,
		target,
		span_notice("I begin to retract [target]'s [parse_zone(target_zone)]..."),
		span_notice("[user] begins to retract [target]'s [parse_zone(target_zone)]."),
		span_notice("[user] begins to retract [target]'s [parse_zone(target_zone)]."),
	)

/datum/surgery_step/retract/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(
		user,
		target,
		span_notice("I retract [target]'s [parse_zone(target_zone)]."),
		span_notice("[user] retract [target]'s [parse_zone(target_zone)]."),
		span_notice("[user] retract [target]'s [parse_zone(target_zone)]."),
	)

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

/datum/surgery_step/cauterize/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(
		user,
		target,
		span_notice("I begin to cauterize the wounds on [target]'s [parse_zone(target_zone)]..."),
		span_notice("[user] begins to cauterize the wounds on [target]'s [parse_zone(target_zone)]."),
		span_notice("[user] begins to cauterize the wounds on [target]'s [parse_zone(target_zone)]."),
	)

/datum/surgery_step/cauterize/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(
		user,
		target,
		span_notice("I cauterize the wounds on [target]'s [parse_zone(target_zone)]."),
		span_notice("[user] cauterizes the wounds on [target]'s [parse_zone(target_zone)]."),
		span_notice("[user] cauterizes the wounds on [target]'s [parse_zone(target_zone)]."),
	)
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

	time = 5 SECONDS

	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/saw/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(
		user,
		target,
		span_notice("I begin to saw through the bone in [target]'s [parse_zone(target_zone)]..."),
		span_notice("[user] begins to saw through the bone in [target]'s [parse_zone(target_zone)]."),
		span_notice("[user] begins to saw through the bone in [target]'s [parse_zone(target_zone)]."),
	)

/datum/surgery_step/saw/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(
		user,
		target,
		span_notice("I saw [target]'s [parse_zone(target_zone)] open."),
		span_notice("[user] saws [target]'s [parse_zone(target_zone)] open!"),
		span_notice("[user] saws [target]'s [parse_zone(target_zone)] open!"),
	)

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
