/datum/surgery_step/insert_teeth
	name = "Fix teeth"
	implements = list(
		/obj/item/natural/bundle/teeth = 80,
		/obj/item/natural/teeth = 70,
	)
	minimum_time = 2.2 SECONDS
	maximum_time = 3.5 SECONDS
	surgery_flags = SURGERY_INCISED
	possible_locs = list(BODY_ZONE_PRECISE_MOUTH)
	requires_bodypart_type = BODYPART_ORGANIC

/datum/surgery_step/insert_teeth/validate_bodypart(mob/user, mob/living/carbon/target, obj/item/bodypart/mouth/bodypart, target_zone)
	. = ..()
	if(!.)
		return FALSE
	if(!istype(bodypart))
		return FALSE
	return bodypart.get_teeth_amount() < bodypart.max_teeth

/datum/surgery_step/insert_teeth/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target,
		"<span class='notice'>I begin placing teeth into [target]'s mouth...</span>",
		"<span class='notice'>[user] begins fixing [target]'s teeth.</span>",
		"<span class='notice'>[user] begins performing surgery on [target]'s mouth.</span>")
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
	display_results(user, target,
		"<span class='notice'>I successfully fix [target]'s teeth.</span>",
		"<span class='notice'>[user] successfully fixes [target]'s teeth!</span>",
		"<span class='notice'>[user] completes the surgery on [target]'s mouth.</span>")
	return TRUE

/datum/surgery_step/insert_teeth/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent, success_prob)
	display_results(user, target, "<span class='warning'>I screwed up!</span>",
		"<span class='warning'>[user] screws up!</span>",
		"<span class='notice'>[user] trys putting [target]'s teeth back in.</span>", TRUE)
	target.take_bodypart_damage(9, 0, required_status = BODYPART_ORGANIC)
	return TRUE

