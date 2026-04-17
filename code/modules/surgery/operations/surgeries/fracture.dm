/datum/surgery_operation/limb/set_bone
	name = "Bone fixing"

	implements = list(
		TOOL_BONESET = 1,
		IMPLEMENT_HAND = 3,
	)

	time = 6.4 SECONDS

	skill_min = SKILL_LEVEL_APPRENTICE
	skill_median = SKILL_LEVEL_JOURNEYMAN

/datum/surgery_operation/limb/set_bone/get_default_radial_image()
	return image(/obj/item/weapon/surgery/bonesetter)

/datum/surgery_operation/limb/set_bone/all_required_strings()
	return list("the limb must be fractured") + ..()

/datum/surgery_operation/limb/set_bone/state_check(obj/item/bodypart/limb)
	if(!locate(/datum/wound/fracture) in limb.wounds)
		return FALSE

	return TRUE

/datum/surgery_operation/limb/set_bone/on_preop(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	display_results(
		surgeon,
		limb.owner,
		span_notice("I begin to set the bone in [limb.owner]'s [parse_zone(limb.body_zone)]..."),
		span_notice("[surgeon] begins to set the bone in [limb.owner]'s [parse_zone(limb.body_zone)]."),
		span_notice("[surgeon] begins to set the bone in [limb.owner]'s [parse_zone(limb.body_zone)].")
	)

/datum/surgery_operation/limb/set_bone/on_success(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	display_results(
		surgeon,
		limb.owner,
		span_notice("I successfully relocate the bone in [limb.owner]'s [parse_zone(limb.body_zone)]."),
		span_notice("[surgeon] successfully sets the bone in [limb.owner]'s [parse_zone(limb.body_zone)]!"),
		span_notice("[surgeon] successfully sets the bone in [limb.owner]'s [parse_zone(limb.body_zone)]!"),
	)

	for(var/datum/wound/fracture/bone in limb.wounds)
		bone.set_bone()
