
/datum/surgery_operation/limb/amputate
	name = "Amputate Limb"
	desc = "Cut a limb off from a patient."

	implements = list(
		TOOL_SAW = 1,
		TOOL_SCALPEL = 1.2,
		TOOL_IMPROVISED_SAW = 1.25,
		/obj/item = 1.5,
	)

	required_bodytype = BODYPART_ORGANIC

	time = 6.4 SECONDS

	skill_min = SKILL_LEVEL_APPRENTICE
	skill_median = SKILL_LEVEL_JOURNEYMAN

	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/organ2.ogg'

	all_surgery_states_required = SURGERY_SKIN_OPEN|SURGERY_BONE_SAWED|SURGERY_VESSELS_CLAMPED

/datum/surgery_operation/limb/amputate/get_recommended_tool()
	return TOOL_SAW

/datum/surgery_operation/limb/amputate/get_default_radial_image()
	return image(/obj/item/weapon/surgery/saw)

/datum/surgery_operation/limb/amputate/tool_check(obj/item/tool)
	if(tool.sharpness < IS_SHARP)
		return FALSE

	return TRUE

/datum/surgery_operation/limb/amputate/state_check(obj/item/bodypart/limb)
	if(limb.body_zone == BODY_ZONE_CHEST)
		return FALSE

	if(HAS_TRAIT(limb.owner, TRAIT_NODISMEMBER))
		return FALSE

	return TRUE

/datum/surgery_operation/limb/amputate/on_preop(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	display_results(
		surgeon,
		limb.owner,
		span_notice("You begin to sever [limb.owner]'s [parse_zone(limb.body_zone)]..."),
		span_notice("[surgeon] begins to sever [limb.owner]'s [parse_zone(limb.body_zone)]."),
		span_notice("[surgeon] begins to sever [limb.owner]'s [parse_zone(limb.body_zone)] with [tool]."),
	)
	display_pain(limb.owner, "I feel a gruesome pain in my [parse_zone(limb.body_zone)]'s joint!")

/datum/surgery_operation/limb/amputate/on_success(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	display_results(
		surgeon,
		limb.owner,
		span_notice("You successfully amputate [limb.owner]'s [parse_zone(limb.body_zone)]!"),
		span_notice("[surgeon] successfully amputates [limb.owner]'s [parse_zone(limb.body_zone)]!"),
		span_notice("[surgeon] finishes severing [limb.owner]'s [parse_zone(limb.body_zone)]."),
	)
	display_pain(limb.owner, "I can no longer feel my [parse_zone(limb.body_zone)]!")
	limb.drop_limb()

/datum/surgery_operation/limb/amputate/pegleg
	name = "Detach Wooden Limb"
	desc = "Saw off a patient's wooden limb."

	required_bodytype = BODYPART_ROBOTIC
	operation_flags = parent_type::operation_flags | OPERATION_MECHANIC

	implements = list(
		TOOL_SAW = 1,
		/obj/item/weapon/axe = 1.33,
		TOOL_SCALPEL = 4,
	)

	time = 3 SECONDS

	skill_used = /datum/attribute/skill/craft/engineering

	preop_sound = 'sound/foley/sewflesh.ogg'
	success_sound = 'sound/items/wood_sharpen.ogg'

	all_surgery_states_required = NONE

/datum/surgery_operation/limb/amputate/pegleg/all_required_strings()
	. = ..()
	. += "the limb must be wooden"
