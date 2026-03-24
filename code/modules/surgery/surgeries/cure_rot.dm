/datum/surgery/cure_rot
	name = "Cure Rot"
	surgery_flags = parent_type::surgery_flags | SURGERY_REQUIRES_REAL_LIMB

	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/burn_rot,
	)

	possible_locs = list(BODY_ZONE_CHEST)

	skill_min = SKILL_LEVEL_APPRENTICE
	skill_median = SKILL_LEVEL_JOURNEYMAN

/datum/surgery_step/burn_rot
	name = "burn rot"

	implements = list(
		TOOL_CAUTERY = 100,
		/obj/item/clothing/neck/psycross/silver = 80,
		/obj/item = 45,
	)

	time = 8 SECONDS

	preop_sound = 'sound/surgery/cautery1.ogg'
	success_sound = 'sound/surgery/cautery2.ogg'

/datum/surgery_step/burn_rot/tool_check(mob/user, obj/item/tool)
	if(implement_type != /obj/item/clothing/neck/psycross && !tool.get_temperature())
		return FALSE
	return TRUE

/datum/surgery_step/burn_rot/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("I begin to burn the rot within [target]..."),
		span_notice("[user] begins to burn the rot from [target]'s heart."),
		span_notice("[user] begins to burn the rot from [target]'s heart."),
	)

// most of this is copied from the Cure Rot spell
/datum/surgery_step/burn_rot/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/burndam = 20 - (GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/misc/medicine) * 3)

	var/was_zombie = target.mind?.has_antag_datum(/datum/antagonist/zombie)
	var/has_rot = FALSE
	if(!was_zombie)
		for(var/obj/item/bodypart/bodypart as anything in target.bodyparts)
			if(bodypart.rotted)
				has_rot = TRUE
				break

	if(!has_rot && !was_zombie)
		to_chat(user, span_warning("Nothing happens."))
		return TRUE

	if(was_zombie)
		target.mind.remove_antag_datum(/datum/antagonist/zombie)
		target.death()

	var/datum/component/rot/rot = target.GetComponent(/datum/component/rot)
	if(rot)
		rot.amount = 0

	for(var/obj/item/bodypart/rotty in target.bodyparts)
		rotty.rotted = FALSE

	target.update_body()

	display_results(
		user,
		target,
		span_notice("You burn away the rot inside of [target]."),
		span_notice("[user] burns the rot within [target]."),
		span_notice("[user] takes a [tool] to [target]'s innards."),
	)

	target.funeral = FALSE

	target.take_bodypart_damage(burn = burndam)

	return TRUE
