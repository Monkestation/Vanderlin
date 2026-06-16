/datum/surgery_operation/limb/fix_bones
	name = "Fix Limb Bone"
	desc = "Repair a patient's cut or broken bones. \
		Clears \"bone sawed\" surgical state and repairs fractures."

	implements = list(
		TOOL_BONESETTER = 1,
		IMPLEMENT_HAND = 3,
	)

	time = 6.4 SECONDS

	skill_min = SKILL_LEVEL_APPRENTICE
	skill_median = SKILL_LEVEL_JOURNEYMAN

	all_surgery_states_required = SURGERY_SKIN_OPEN
	any_surgery_states_required = SURGERY_BONE_SAWED

/datum/surgery_operation/limb/fix_bones/get_default_radial_image()
	return image(/obj/item/weapon/surgery/bonesetter)

/datum/surgery_operation/limb/fix_bones/all_required_strings()
	return ..() + list("the limb must have bones")

/datum/surgery_operation/limb/fix_bones/state_check(obj/item/bodypart/limb)
	return LIMB_HAS_BONES(limb) && limb.has_wound(/datum/wound/fracture)

/datum/surgery_operation/limb/fix_bones/on_preop(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	display_results(
		surgeon,
		limb.owner,
		span_notice("I begin to set the bones in [limb.owner]'s [parse_zone(limb.body_zone)]..."),
		span_notice("[surgeon] begins to set the bones in [limb.owner]'s [parse_zone(limb.body_zone)]."),
		span_notice("[surgeon] begins to set the bones in [limb.owner]'s [parse_zone(limb.body_zone)]."),
	)
	display_pain(limb.owner, "I feel a grinding sensation in my [parse_zone(limb.body_zone)] as the bones are set back in place.")

/datum/surgery_operation/limb/fix_bones/on_success(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	display_results(
		surgeon,
		limb.owner,
		span_notice("I successfully set the bone in [limb.owner]'s [parse_zone(limb.body_zone)]."),
		span_notice("[surgeon] successfully sets the bone in [limb.owner]'s [parse_zone(limb.body_zone)]."),
		span_notice("[surgeon] successfully sets the bone in [limb.owner]'s [parse_zone(limb.body_zone)]."),
	)

	for(var/datum/wound/fracture/bone in limb.wounds)
		bone.set_bone()

/datum/surgery_operation/limb/fix_bones/on_failure(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	display_results(
		surgeon,
		limb.owner,
		span_warning("I fail to set the bone in [limb.owner]'s [parse_zone(limb.body_zone)]! It's more out of place!"),
		span_warning("[surgeon] fails to set the bone in [limb.owner]'s [parse_zone(limb.body_zone)]!"),
		span_warning("[surgeon] fails to set the bone in [limb.owner]'s [parse_zone(limb.body_zone)]!"),
	)
	display_pain(limb.owner, "I feel a sharp pain in my [parse_zone(limb.body_zone)] as the bone slides back out of place!")

	limb.receive_damage(25, flashes = TRUE)
	limb.owner.emote("scream")
