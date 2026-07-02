/datum/surgery_operation/basic/insert_teeth
	name = "Insert Teeth"
	desc = "Insert a tooth or teeth into the patient's jaw."

	implements = list(
		/obj/item/natural/teeth = 1,
		/obj/item/natural/bundle/teeth = 1.4,
	)

	time = 3 SECONDS

	target_zone = BODY_ZONE_PRECISE_MOUTH

	skill_min = SKILL_LEVEL_APPRENTICE
	skill_median = SKILL_LEVEL_JOURNEYMAN

/datum/surgery_operation/basic/insert_teeth/get_default_radial_image()
	return image(/obj/item/natural/teeth)

/datum/surgery_operation/basic/insert_teeth/all_required_strings()
	return list("patient needs to be missing teeth") + ..()

/datum/surgery_operation/basic/insert_teeth/state_check(mob/living/patient)
	var/obj/item/bodypart/mouth/mouth = patient.get_bodypart(BODY_ZONE_PRECISE_MOUTH)
	if(!mouth)
		return FALSE

	return (mouth.get_teeth_amount() < mouth.max_teeth)


/datum/surgery_operation/basic/insert_teeth/on_preop(mob/living/patient, mob/living/surgeon, tool, list/operation_args)
	display_results(
		surgeon,
		patient,
		span_notice("I begin placing teeth into [patient]'s mouth..."),
		span_notice("[surgeon] begins fixing [patient]'s teeth."),
		span_notice("[surgeon] begins performing surgery on [patient]'s mouth."),
	)

/datum/surgery_operation/basic/insert_teeth/on_success(mob/living/patient, mob/living/surgeon, tool, list/operation_args)
	display_results(
		surgeon,
		patient,
		span_notice("I successfully fix [patient]'s teeth."),
		span_notice("[surgeon] successfully fixes [patient]'s teeth!"),
		span_notice("[surgeon] completes the surgery on [patient]'s mouth."),
	)

	var/obj/item/bodypart/mouth/jaw = patient.get_bodypart(BODY_ZONE_PRECISE_MOUTH)
	if(!jaw)
		return

	var/space = jaw.max_teeth - jaw.get_teeth_amount()
	if(!space)
		return

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
