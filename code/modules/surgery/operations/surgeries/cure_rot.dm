/datum/surgery_operation/limb/cure_rot
	name = "Cure Rot"
	desc = "Cleanse a limb of rot, lethal to deadites when performed on the chest."

	implements = list(
		TOOL_CAUTERY = 1.2,
		/obj/item/clothing/neck/psycross/silver = 1.4,
		/obj/item = 1.55,
	)

	time = 2.5 SECONDS

	preop_sound = 'sound/surgery/cautery1.ogg'
	success_sound = 'sound/surgery/cautery2.ogg'

	skill_min = SKILL_LEVEL_APPRENTICE

	any_surgery_states_required = ALL_SURGERY_SKIN_STATES

/datum/surgery_operation/limb/amputate/get_recommended_tool()
	return TOOL_CAUTERY

/datum/surgery_operation/limb/amputate/get_default_radial_image()
	return image(/obj/item/weapon/surgery/cautery)

/datum/surgery_operation/limb/cure_rot/state_check(obj/item/bodypart/limb)
	if(!HAS_TRAIT(limb, TRAIT_ROTTEN))
		return FALSE

	return TRUE

/datum/surgery_operation/limb/cure_rot/tool_check(obj/item/tool)
	if(!istype(tool, /obj/item/clothing/neck/psycross) && !tool.get_temperature())
		return FALSE

	return TRUE

/datum/surgery_operation/limb/cure_rot/on_preop(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	display_results(
		surgeon,
		limb.owner,
		span_notice("I begin to burn the rot within [limb.owner]'s [parse_zone(limb.body_zone)]..."),
		span_notice("[surgeon] begins to burn the rot from [limb.owner]'s [parse_zone(limb.body_zone)]."),
		span_notice("[surgeon] begins to burn the flesh of [limb.owner]'s [parse_zone(limb.body_zone)]."),
	)

/datum/surgery_operation/limb/cure_rot/on_success(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	var/mob/living/limb_owner = limb.owner

	display_results(
		surgeon,
		limb_owner,
		span_notice("I burn away the rot from [limb_owner]'s [parse_zone(limb.body_zone)]."),
		span_notice("[surgeon] burns the rot from [limb_owner]'s [parse_zone(limb.body_zone)]."),
		span_notice("[surgeon] burns the flesh of [limb_owner]'s [parse_zone(limb.body_zone)]."),
	)

	if(limb.body_zone == BODY_ZONE_CHEST && IS_DEADITE(limb_owner))
		limb_owner.mind.remove_antag_datum(/datum/antagonist/zombie)
		limb_owner.death()

	limb.revive_limb()
	limb.germ_level = 0

	// I would rather not have this but afaik this is the only way to reduce this outside of the cure rot miracle
	var/datum/component/rot/rot = limb_owner?.GetComponent(/datum/component/rot)
	if(rot) // ew
		rot.amount = 0

	limb_owner?.update_body()

	if(ishuman(limb_owner))
		var/mob/living/carbon/human/H = limb_owner
		H?.funeral = FALSE

	limb.receive_damage(burn = 20 - (GET_MOB_SKILL_VALUE(surgeon, skill_used) / 3))
