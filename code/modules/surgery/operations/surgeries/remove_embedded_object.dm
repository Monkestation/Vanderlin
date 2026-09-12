/datum/surgery_operation/limb/embedded_removal
	name = "Removal of embedded objects"
	desc = "Remove any object's embedded in a patient's limb."

	operation_flags = OPERATION_STANDING_ALLOWED

	implements = list(
		TOOL_HEMOSTAT = 1,
		TOOL_IMPROVISED_HEMOSTAT = 1.35,
		IMPLEMENT_HAND = 1.45,
	)

	time = 3.5 SECONDS

	preop_sound = 'sound/surgery/organ2.ogg'
	success_sound = 'sound/surgery/organ1.ogg'

	skill_min = SKILL_LEVEL_NOVICE
	skill_median = SKILL_LEVEL_NOVICE

	all_surgery_states_required = SURGERY_SKIN_OPEN

/datum/surgery_operation/limb/embedded_removal/get_default_radial_image()
	return image(/obj/item/ammo_casing/caseless/arrow)

/datum/surgery_operation/limb/embedded_removal/state_check(obj/item/bodypart/limb)
	return !!length(limb.embedded_objects)

/datum/surgery_operation/limb/embedded_removal/on_preop(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	display_results(
		surgeon,
		limb.owner,
		span_notice("I look for objects embedded in [limb.owner]'s [parse_zone(limb.body_zone)]..."),
		span_notice("[surgeon] looks for objects embedded in [limb.owner]'s [parse_zone(limb.body_zone)]."),
		span_notice("[surgeon] looks for something in [limb.owner]'s [parse_zone(limb.body_zone)].")
	)

/datum/surgery_operation/limb/embedded_removal/on_success(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	var/objects = 0
	for(var/obj/item/embedded as anything in limb.embedded_objects)
		objects++
		limb.remove_embedded_object(embedded)

	var/s = (objects > 1 ? "s" : "")
	if(objects > 0)
		display_results(
			surgeon,
			limb.owner,
			span_notice("I successfully remove [objects] object[s] from [limb.owner]'s [limb]."),
			span_notice("[surgeon] successfully removes [objects] object[s] from [limb.owner]'s [limb]!"),
			span_notice("[surgeon] successfully removes something from [limb.owner]!"),
		)
