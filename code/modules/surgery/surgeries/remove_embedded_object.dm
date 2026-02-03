/datum/surgery/embedded_removal
	name = "Removal of embedded objects"
	surgery_flags = SURGERY_REQUIRE_LIMB

	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/clamp,
		/datum/surgery_step/remove_object,
	)

	possible_locs = list(
		BODY_ZONE_HEAD,
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_LEG,
		BODY_ZONE_L_LEG,
	)

	skill_min = SKILL_LEVEL_NOVICE
	skill_median = SKILL_LEVEL_NOVICE

/datum/surgery/embedded_removal/can_start(mob/user, mob/living/patient, obj/item/tool, feedback = TRUE)
	. = ..()
	if(!.)
		return

	if(iscarbon(patient))
		var/mob/living/carbon/carbon_patient = patient
		var/obj/item/bodypart/part = carbon_patient.get_bodypart(user.zone_selected)
		return !!length(part.embedded_objects)

	return patient.has_embedded_objects()

/datum/surgery_step/remove_object
	name = "Remove embedded objects"
	implements = list(
		TOOL_HEMOSTAT = 80,
		TOOL_IMPROVISED_HEMOSTAT = 65,
		TOOL_HAND = 50,
	)
	time = 3.2 SECONDS
	accept_hand = TRUE
	preop_sound = 'sound/surgery/organ2.ogg'
	success_sound = 'sound/surgery/organ1.ogg'

/datum/surgery_step/remove_object/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("I look for objects embedded in [target]'s [parse_zone(user.zone_selected)]..."),
		span_notice("[user] looks for objects embedded in [target]'s [parse_zone(user.zone_selected)]."),
		span_notice("[user] looks for something in [target]'s [parse_zone(user.zone_selected)].")
	)

/datum/surgery_step/remove_object/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = TRUE)
	var/obj/item/bodypart/bodypart = target.get_bodypart(check_zone(target_zone))

	var/objects = 0
	if(bodypart)
		for(var/obj/item/embedded as anything in bodypart.embedded_objects)
			objects++
			bodypart.remove_embedded_object(embedded)
	else
		for(var/obj/item/embedded as anything in target.get_embedded_objects())
			objects++
			target.simple_remove_embedded_object(embedded)

	var/s = (objects > 1 ? "s" : "")
	if(objects > 0)
		display_results(
			user,
			target,
			span_notice("I successfully remove [objects] object[s] from [target]'s [bodypart]."),
			span_notice("[user] successfully removes [objects] object[s] from [target]'s [bodypart]!"),
			span_notice("[user] successfully removes something from [target]!"),
		)

	else if(bodypart)
		to_chat(user, span_warning("I find no objects embedded in [target]'s [bodypart]!"))
	else
		to_chat(user, span_warning("I find no objects embedded in [target]!"))

	return TRUE
