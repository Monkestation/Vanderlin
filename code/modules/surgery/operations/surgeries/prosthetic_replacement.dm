/datum/surgery_operation/limb_replacement
	name = "Limb Replacement"
	desc = "Replace a patient's missing limb with a new one."

	implements = list(
		/obj/item/bodypart = 1,
	)

	time = 3 SECONDS

	skill_min = SKILL_LEVEL_APPRENTICE
	skill_median = SKILL_LEVEL_JOURNEYMAN

	var/required_replacement = BODYPART_ORGANIC

/datum/surgery_operation/limb_replacement/prosthetic
	name = "Prosthetic Replacement"
	desc = "Replace a patient's limb with a prosthetic."

	skill_used = /datum/attribute/skill/craft/engineering

	required_replacement = BODYPART_ROBOTIC

/datum/surgery_operation/limb_replacement/tool_check(obj/item/tool)
	if(!istype(tool, /obj/item/bodypart))
		return FALSE

	var/obj/item/bodypart/limb = tool
	if(limb.item_flags & (ABSTRACT | DROPDEL))
		return FALSE

	if(limb.animal_origin)
		return FALSE

	return (limb.status == required_replacement)

/datum/surgery_operation/limb_replacement/snowflake_check_availability(atom/movable/operating_on, mob/living/surgeon, tool, operated_zone)
	if(!isliving(operating_on))
		return FALSE

	var/mob/living/patient = operating_on
	if(patient.get_bodypart(operated_zone))
		return FALSE

	return TRUE

/datum/surgery_operation/limb_replacement/on_preop(atom/movable/operating_on, mob/living/surgeon, tool, list/operation_args)
	display_results(
		surgeon,
		operating_on,
		span_notice("I begin to replace [operating_on]'s [parse_zone(operation_args[OPERATION_TARGET_ZONE])] with [tool]..."),
		span_notice("[surgeon] begins to replace [operating_on]'s [parse_zone(operation_args[OPERATION_TARGET_ZONE])] with [tool]."),
		span_notice("[surgeon] begins to replace [operating_on]'s [parse_zone(operation_args[OPERATION_TARGET_ZONE])]."),
	)

/datum/surgery_operation/limb_replacement/on_success(atom/movable/operating_on, mob/living/surgeon, obj/item/bodypart/tool, list/operation_args)
	display_results(
		surgeon,
		operating_on,
		span_notice("I succeed transplanting [operating_on]'s [parse_zone(operation_args[OPERATION_TARGET_ZONE])]."),
		span_notice("[surgeon] successfully transplants [operating_on]'s [parse_zone(operation_args[OPERATION_TARGET_ZONE])] with [tool]!"),
		span_notice("[surgeon] successfully transplants [operating_on]'s [parse_zone(operation_args[OPERATION_TARGET_ZONE])]!"),
	)

	if(tool.attach_limb(operating_on) && tool.attach_wound)
		tool.add_wound(tool.attach_wound)

	surgeon.update_inv_hands() // attach_limb moves to nullspace
