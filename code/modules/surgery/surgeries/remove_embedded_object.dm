/datum/surgery/embedded_removal
	name = "Removal of embedded objects"
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/clamp,
		/datum/surgery_step/remove_object,
	)

/datum/surgery_step/remove_object
	name = "Remove embedded objects"
	implements = list(
		TOOL_HEMOSTAT = 80,
		TOOL_IMPROVISED_HEMOSTAT = 65,
		TOOL_HAND = 50,
	)
	minimum_time = 2.2 SECONDS
	maximum_time = 4.2 SECONDS
	accept_hand = TRUE
	surgery_flags = SURGERY_INCISED
	skill_min = SKILL_LEVEL_NOVICE
	skill_median = SKILL_LEVEL_NOVICE
	preop_sound = 'sound/surgery/organ2.ogg'
	success_sound = 'sound/surgery/organ1.ogg'

/datum/surgery_step/remove_object/validate_bodypart(mob/user, mob/living/carbon/target, obj/item/bodypart/bodypart, target_zone)
	. = ..()
	if(!.)
		return
	return length(bodypart.embedded_objects)

/datum/surgery_step/remove_object/validate_target(mob/user, mob/living/target, target_zone, datum/intent/intent)
	. = ..()
	if(!.)
		return
	return length(target.get_embedded_objects())

/datum/surgery_step/remove_object/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, "<span class='notice'>I look for objects embedded in [target]'s [parse_zone(user.zone_selected)]...</span>",
		"<span class='notice'>[user] looks for objects embedded in [target]'s [parse_zone(user.zone_selected)].</span>",
		"<span class='notice'>[user] looks for something in [target]'s [parse_zone(user.zone_selected)].</span>")
	return TRUE

/datum/surgery_step/remove_object/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	var/obj/item/bodypart/bodypart = target.get_bodypart(check_zone(target_zone))
	var/objects = 0
	if(bodypart)
		for(var/obj/item/embedded as anything in bodypart.embedded_objects)
			objects++
			bodypart.remove_embedded_object(embedded)
	for(var/obj/item/embedded as anything in target.simple_embedded_objects)
		objects++
		target.simple_remove_embedded_object(embedded)

	var/s = (objects > 1 ? "s" : "")
	if(objects > 0)
		display_results(user, target, "<span class='notice'>I successfully remove [objects] object[s] from [target]'s [bodypart].</span>",
			"<span class='notice'>[user] successfully removes [objects] object[s] from [target]'s [bodypart]!</span>",
			"<span class='notice'>[user] successfully removes [objects] object[s] from [target]'s [bodypart]!</span>")
	else if(bodypart)
		to_chat(user, "<span class='warning'>I find no objects embedded in [target]'s [bodypart]!</span>")
	else
		to_chat(user, "<span class='warning'>I find no objects embedded in [target]!</span>")
	return TRUE
