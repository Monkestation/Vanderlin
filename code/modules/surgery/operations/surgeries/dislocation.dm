/datum/surgery_operation/limb/relocation
	name = "Bone Relocation"
	desc = "Relocate a patient's bones."

	operation_flags = OPERATION_STANDING_ALLOWED

	implements = list(
		TOOL_BONESETTER = 1,
		IMPLEMENT_HAND = 3,
	)

	time = 5 SECONDS

	skill_min = SKILL_LEVEL_APPRENTICE
	skill_median = SKILL_LEVEL_JOURNEYMAN

/datum/surgery_operation/limb/relocation/get_default_radial_image()
	return image(/obj/item/weapon/surgery/bonesetter)

/datum/surgery_operation/limb/relocation/all_required_strings()
	return list("the limb must be dislocated") + ..()

/datum/surgery_operation/limb/relocation/state_check(obj/item/bodypart/limb)
	if(!locate(/datum/wound/dislocation) in limb.wounds)
		return FALSE

	return TRUE

/datum/surgery_operation/limb/relocation/on_preop(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	display_results(
		surgeon,
		limb.owner,
		span_notice("I begin to relocate the bone in [limb.owner]'s [parse_zone(limb.body_zone)]..."),
		span_notice("[surgeon] begins to relocate the bone in [limb.owner]'s [parse_zone(limb.body_zone)]."),
		span_notice("[surgeon] begins to relocate the bone in [limb.owner]'s [parse_zone(limb.body_zone)].")
	)

/datum/surgery_operation/limb/relocation/on_success(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	display_results(
		surgeon,
		limb.owner,
		span_notice("I successfully relocate the bone in [limb.owner]'s [parse_zone(limb.body_zone)]."),
		span_notice("[surgeon] successfully relocates the bone in [limb.owner]'s [parse_zone(limb.body_zone)]!"),
		span_notice("[surgeon] successfully relocates the bone in [limb.owner]'s [parse_zone(limb.body_zone)]!"),
	)

	for(var/datum/wound/dislocation/bone in limb.wounds)
		bone.relocate_bone()
