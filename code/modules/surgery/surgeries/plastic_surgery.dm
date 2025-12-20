/datum/surgery/plastic_surgery
	name = "Plastic surgery"
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/clamp,
		/datum/surgery_step/retract,
		/datum/surgery_step/reshape_face,
		/datum/surgery_step/cauterize,
	)
	possible_locs = list(BODY_ZONE_HEAD)

/// Reshape face
/datum/surgery_step/reshape_face
	name = "Reshape face"
	implements = list(
		TOOL_SCALPEL = 70,
		TOOL_WIRECUTTER = 50,
		TOOL_SHARP = 35,
	)
	possible_locs = list(BODY_ZONE_HEAD)
	time = 6.4 SECONDS
	surgery_flags = SURGERY_BLOODY | SURGERY_INCISED | SURGERY_CLAMPED | SURGERY_RETRACTED
	skill_min = SKILL_LEVEL_APPRENTICE
	skill_median = SKILL_LEVEL_EXPERT

/datum/surgery_step/reshape_face/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	user.visible_message(span_notice("[user] begins to alter [target]'s appearance."), span_notice("I begin to alter [target]'s appearance..."))
	display_results(user, target, span_notice("I begin to alter [target]'s appearance..."),
		span_notice("[user] begins to alter [target]'s appearance."),
		span_notice("[user] begins to make an incision in [target]'s face."))
	return TRUE

/datum/surgery_step/reshape_face/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	var/obj/item/bodypart/bodypart = target.get_bodypart(check_zone(target_zone))
	if(bodypart?.has_wound(/datum/wound/facial/disfigurement))
		display_results(user, target, span_notice("I successfully restore [target]'s appearance."),
			span_notice("[user] successfully restores [target]'s appearance!"),
			span_notice("[user] finishes the operation on [target]'s face."))
		bodypart.remove_wound(/datum/wound/facial/disfigurement)
		return TRUE
	var/list/names = list("Custom...")
	if(target && ishuman(target))
		var/mob/living/carbon/human/human_target = target
		var/datum/species/species = human_target?.dna?.species
		if(species)
			names += species.random_name(target.gender, TRUE)
	var/chosen_name
	if(length(names) < 1)
		chosen_name = browser_input_list(user, "Choose a new name to assign.", "Plastic Surgery", names)
	if(!chosen_name || chosen_name == "Custom...")
		chosen_name = browser_input_text(user, "What name?", "Plastic surgery")
	chosen_name = reject_bad_name(chosen_name)
	if(!chosen_name)
		return
	var/oldname = target.real_name
	target.real_name = chosen_name
	display_results(user, target, span_notice("I alter [oldname]'s appearance completely, [target.p_they()] is now [target.real_name]."),
		span_notice("[user] alters [oldname]'s appearance completely, [target.p_they()] is now [target.real_name]!"),
		span_notice("[user] finishes the operation on [target]'s face."))
	return TRUE

/datum/surgery_step/reshape_face/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent, success_prob)
	display_results(user, target, span_warning("I screw up, leaving [target]'s appearance disfigured!"),
		span_notice("[user] screws up, disfiguring [target]'s appearance!"),
		span_notice("[user] finishes the operation on [target]'s face."))
	var/obj/item/bodypart/bodypart = target.get_bodypart(check_zone(target_zone))
	bodypart?.add_wound(/datum/wound/facial/disfigurement)
	target.emote("scream")
	return FALSE
