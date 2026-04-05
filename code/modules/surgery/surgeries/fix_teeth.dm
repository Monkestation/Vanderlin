/datum/surgery/insert_teeth
	name = "Insert Teeth"
	requires_bodypart_type = BODYPART_ORGANIC

	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/insert_teeth,
	)

	possible_locs = list(BODY_ZONE_PRECISE_MOUTH)

/datum/surgery/insert_teeth/surgery_valid(mob/living/surgeon, mob/living/carbon/patient, obj/item/implement)
	. = ..()
	if(!.)
		return

	var/obj/item/bodypart/mouth/mouth = patient.get_bodypart(BODY_ZONE_PRECISE_MOUTH)
	if(!mouth)
		return FALSE

	return mouth.get_teeth_amount() < mouth.max_teeth

/datum/surgery_step/insert_teeth
	name = "Insert Teeth"

	implements = list(
		/obj/item/natural/teeth = 100,
		/obj/item/natural/bundle/teeth = 75,
	)

	time = 3 SECONDS

/datum/surgery_step/insert_teeth/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(
		user,
		target,
		span_notice("I begin placing teeth into [target]'s mouth..."),
		span_notice("[user] begins fixing [target]'s teeth."),
		span_notice("[user] begins performing surgery on [target]'s mouth."),
	)
	return TRUE

/datum/surgery_step/insert_teeth/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	var/obj/item/bodypart/mouth/jaw = target.get_bodypart(BODY_ZONE_PRECISE_MOUTH)
	if(!jaw)
		return FALSE

	var/space = jaw.max_teeth - jaw.get_teeth_amount()
	if(!space)
		return FALSE

	if(istype(tool, /obj/item/natural/bundle/teeth))
		var/obj/item/natural/bundle/teeth/bundle = tool
		var/obj/item/natural/bundle/teeth/existing = locate(bundle.type) in jaw.teeth
		if(existing)
			var/amount_to_add = min(bundle.amount, space)
			existing.amount += amount_to_add
			bundle.amount -= amount_to_add
			if(!bundle.amount)
				qdel(bundle)
		else
			bundle.amount = min(bundle.amount, space)
			bundle.forceMove(jaw)
			jaw.teeth += bundle

	else if(istype(tool, /obj/item/natural/teeth))
		var/obj/item/natural/teeth/single = tool
		// Find matching bundle type for this tooth
		var/bundle_type = single.bundletype
		var/obj/item/natural/bundle/teeth/existing = locate(bundle_type) in jaw.teeth
		if(existing)
			existing.amount = min(existing.amount + 1, jaw.max_teeth)
		else
			var/obj/item/natural/bundle/teeth/new_bundle = new bundle_type(jaw)
			new_bundle.amount = 1
			jaw.teeth += new_bundle
		qdel(single)

	jaw.update_teeth()
	display_results(
		user,
		target,
		span_notice("I successfully fix [target]'s teeth."),
		span_notice("[user] successfully fixes [target]'s teeth!"),
		span_notice("[user] completes the surgery on [target]'s mouth."),
	)
	return TRUE

/datum/surgery_step/insert_teeth/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent, success_prob)
	var/obj/item/bodypart/mouth/jaw = target.get_bodypart(BODY_ZONE_PRECISE_MOUTH)
	if(jaw?.get_teeth_amount())
		jaw.knock_out_teeth(1)
		display_results(
			user,
			target,
			span_warning("I accidentally knock out one of [target]'s teeth!"),
			span_warning("[user] accidentally knocks out one of [target]'s teeth!"),
			span_warning("[user] accidentally knocks out one of [target]'s teeth!"),
			TRUE,
		)
	return TRUE
