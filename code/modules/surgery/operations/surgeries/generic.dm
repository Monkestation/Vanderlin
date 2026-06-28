// Basic operations for moving back and forth between surgery states
/// First step of every surgery, makes an incision in the skin
/datum/surgery_operation/limb/incise_skin
	name = "Make Skin Incision"
	desc = "Make an incision in the patient's skin to access internal organs. \
		Causes \"cut skin\" surgical state."

	implements = list(
		TOOL_SCALPEL = 1,
		/obj/item/weapon/knife = 1.5,
		/obj/item/natural/glass/shard = 2.25,
		/obj/item = 3.33,
	)

	time = 1.6 SECONDS

	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/scalpel2.ogg'

/datum/surgery_operation/limb/incise_skin/get_any_tool()
	return "Any sharp edged item"

/datum/surgery_operation/limb/incise_skin/get_default_radial_image()
	return image(/obj/item/weapon/surgery/scalpel)

/datum/surgery_operation/limb/incise_skin/tool_check(obj/item/tool)
	// Require edged sharpness OR a tool behavior match
	if((tool.get_sharpness() >= IS_SHARP) || implements[tool.tool_behaviour])
		return TRUE

	return FALSE

/datum/surgery_operation/limb/incise_skin/state_check(obj/item/bodypart/limb)
	if(!LIMB_HAS_SKIN(limb)) // Already counts
		return FALSE

	if(limb.get_incision(surgical_only = TRUE))
		return FALSE

	return TRUE

/datum/surgery_operation/limb/incise_skin/on_preop(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	display_results(
		surgeon,
		limb.owner,
		span_notice("I begin to make an incision in [limb.owner]'s [parse_zone(limb.body_zone)]..."),
		span_notice("[surgeon] begins to make an incision in [limb.owner]'s [parse_zone(limb.body_zone)]."),
		span_notice("[surgeon] begins to make an incision in [limb.owner]'s [parse_zone(limb.body_zone)]."),
	)
	display_pain(limb.owner, "I feel a stabbing in my [parse_zone(limb.body_zone)].")

/datum/surgery_operation/limb/incise_skin/on_success(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	limb.create_injury(WOUND_SLASH, BLEED_DAMAGE_RATIO / 6, surgical = TRUE)

	if(!limb.bleeds)
		return ..()

	display_results(
		surgeon,
		limb.owner,
		span_notice("I make an incision in [limb.owner]'s [parse_zone(limb.body_zone)]."),
		span_notice("Blood pools around the incision in [limb.owner]'s [parse_zone(limb.body_zone)]."),
		span_notice("Blood pools around the incision in [limb.owner]'s [parse_zone(limb.body_zone)]."),
	)

/datum/surgery_operation/limb/incise_skin/on_failure(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	limb.create_injury(WOUND_SLASH, 65, surgical = TRUE)

	if(!limb.bleeds)
		return ..()

	display_results(
		surgeon,
		limb.owner,
		span_notice("I make a messy cut on [limb.owner]'s [parse_zone(limb.body_zone)]."),
		span_notice("Blood pools around the cut on [limb.owner]'s [parse_zone(limb.body_zone)]."),
		span_notice("Blood pools around the cut on [limb.owner]'s [parse_zone(limb.body_zone)]."),
	)

/// Pulls the skin back to access internals
/datum/surgery_operation/limb/retract_skin
	name = "Retract Skin"
	desc = "Retract the patient's skin to access their internal organs. \
		Causes \"skin open\" surgical state."

	implements = list(
		TOOL_RETRACTOR = 1,
		TOOL_IMPROVISED_RETRACTOR = 1.5,
	)

	time = 2.4 SECONDS

	preop_sound = 'sound/surgery/retractor1.ogg'
	success_sound = 'sound/surgery/retractor2.ogg'

	all_surgery_states_required = SURGERY_SKIN_CUT

/datum/surgery_operation/limb/retract_skin/get_default_radial_image()
	return image(/obj/item/weapon/surgery/retractor)

/datum/surgery_operation/limb/retract_skin/on_preop(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	display_results(
		surgeon,
		limb.owner,
		span_notice("I begin to retract the skin in [limb.owner]'s [parse_zone(limb.body_zone)]..."),
		span_notice("[surgeon] begins to retract the skin in [limb.owner]'s [parse_zone(limb.body_zone)]."),
		span_notice("[surgeon] begins to retract the skin in [limb.owner]'s [parse_zone(limb.body_zone)]."),
	)
	display_pain(limb.owner, "I feel a severe stinging pain spreading across my [parse_zone(limb.body_zone)] as the skin is pulled back.")

/datum/surgery_operation/limb/retract_skin/on_success(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	. = ..()

	limb.add_embedded_object(tool)

/datum/surgery_operation/limb/retract_skin/on_failure(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	. = ..()

	limb.receive_damage(5)

/// Closes the skin
/datum/surgery_operation/limb/close_skin
	name = "Mend Skin Incision"
	desc = "Mend the incision in the patient's skin, closing it up. \
		Clears most surgical states."

	implements = list(
		TOOL_CAUTERY = 1,
		/obj/item/needle = 1.4,
		/obj/item = 3.33,
	)

	time = 2.4 SECONDS

	preop_sound = list(
		/obj/item/needle = 'sound/surgery/retractor1.ogg',
		/obj/item = 'sound/surgery/cautery1.ogg',
	)

	success_sound = list(
		/obj/item/needle = 'sound/surgery/retractor2.ogg',
		/obj/item = 'sound/surgery/cautery2.ogg',
	)

	any_surgery_states_required = ALL_SURGERY_SKIN_STATES

/datum/surgery_operation/limb/close_skin/get_any_tool()
	return "Any heat source"

/datum/surgery_operation/limb/close_skin/get_default_radial_image()
	return image(/obj/item/weapon/surgery/cautery)

/datum/surgery_operation/limb/close_skin/all_required_strings()
	return ..() + list("the limb must have skin")

/datum/surgery_operation/limb/close_skin/state_check(obj/item/bodypart/limb)
	return LIMB_HAS_SKIN(limb) && limb.get_incision()

/datum/surgery_operation/limb/close_skin/tool_check(obj/item/tool)
	if(istype(tool, /obj/item/needle))
		return TRUE

	return tool.get_temperature() > 0

/datum/surgery_operation/limb/close_skin/on_preop(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	display_results(
		surgeon,
		limb.owner,
		span_notice("I begin to mend the incision in [limb.owner]'s [parse_zone(limb.body_zone)]..."),
		span_notice("[surgeon] begins to mend the incision in [limb.owner]'s [parse_zone(limb.body_zone)]."),
		span_notice("[surgeon] begins to mend the incision in [limb.owner]'s [parse_zone(limb.body_zone)]."),
	)
	display_pain(limb.owner, "My [parse_zone(limb.body_zone)] is being [istype(tool, /obj/item/needle) ? "pinched" : "burned"]!")

/datum/surgery_operation/limb/close_skin/on_success(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	. = ..()
	if(tool.get_temperature())
		limb.receive_damage(burn = 20)

	var/datum/injury/incision = limb.get_incision()
	if(incision)
		qdel(incision)

/datum/surgery_operation/limb/close_skin/on_failure(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	. = ..()
	if(tool.get_temperature())
		limb.receive_damage(burn = 15)
	else
		limb.receive_damage(10)

/// Clamps bleeding blood vessels to prevent blood loss
/datum/surgery_operation/limb/clamp_bleeders
	name = "Clamp Bleeders"
	desc = "Clamp bleeding blood vessels in the patient's body to prevent blood loss. \
		Causes \"vessels clamped\" surgical state."

	implements = list(
		TOOL_HEMOSTAT = 1,
		TOOL_IMPROVISED_HEMOSTAT = 1.5,
	)

	time = 2.4 SECONDS

	preop_sound = 'sound/surgery/hemostat1.ogg'

	all_surgery_states_required = SURGERY_SKIN_OPEN|SURGERY_VESSELS_UNCLAMPED

/datum/surgery_operation/limb/clamp_bleeders/get_default_radial_image()
	return image(/obj/item/weapon/surgery/hemostat)

/datum/surgery_operation/limb/clamp_bleeders/on_preop(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	display_results(
		surgeon,
		limb.owner,
		span_notice("I begin to clamp bleeders in [limb.owner]'s [parse_zone(limb.body_zone)]..."),
		span_notice("[surgeon] begins to clamp bleeders in [limb.owner]'s [parse_zone(limb.body_zone)]."),
		span_notice("[surgeon] begins to clamp bleeders in [limb.owner]'s [parse_zone(limb.body_zone)]."),
	)
	display_pain(limb.owner, "I feel a pinch as the bleeding in my [parse_zone(limb.body_zone)] is slowed.")

/datum/surgery_operation/limb/clamp_bleeders/on_success(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	. = ..()

	limb.add_embedded_object(tool)

	if(limb.can_be_disabled)
		limb.update_disabled()

/// Saws through bones to access organs
/datum/surgery_operation/limb/saw_bones
	name = "Saw Limb Bone"
	desc = "Saw through the patient's bones to access their internal organs. \
		Causes \"bone sawed\" surgical state."

	implements = list(
		TOOL_SAW = 1,
		TOOL_IMPROVISED_SAW = 1.35,
		/obj/item/weapon/shovel = 1.6,
		/obj/item = 3.33,
	)

	time = 5.4 SECONDS

	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/organ2.ogg'

	all_surgery_states_required = SURGERY_SKIN_OPEN
	any_surgery_states_blocked = SURGERY_BONE_SAWED|SURGERY_BONE_DRILLED

/datum/surgery_operation/limb/saw_bones/get_any_tool()
	return "Any sharp edged item with decent force"

/datum/surgery_operation/limb/saw_bones/get_default_radial_image()
	return image(/obj/item/weapon/surgery/saw)

/datum/surgery_operation/limb/saw_bones/tool_check(obj/item/tool)
	// Require edged sharpness and sufficient force OR a tool behavior match
	return (((tool.get_sharpness() >= IS_SHARP) && tool.force >= 10) || implements[tool.tool_behaviour])

/datum/surgery_operation/limb/saw_bones/on_preop(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	display_results(
		surgeon,
		limb.owner,
		span_notice("I begin to saw through the bone in [limb.owner]'s [parse_zone(limb.body_zone)]..."),
		span_notice("[surgeon] begins to saw through the bone in [limb.owner]'s [parse_zone(limb.body_zone)]."),
		span_notice("[surgeon] begins to saw through the bone in [limb.owner]'s [parse_zone(limb.body_zone)]."),
	)
	display_pain(limb.owner, "I feel a horrid ache spread through the inside of my [parse_zone(limb.body_zone)]!")

/datum/surgery_operation/limb/saw_bones/on_success(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	. = ..()

	if(!limb.has_wound(/datum/wound/fracture))
		var/fracture_type = /datum/wound/fracture
		//yes we ignore crit resist here because this is a proper surgical procedure, not a crit
		switch(surgeon.zone_selected)
			if(BODY_ZONE_HEAD)
				fracture_type = /datum/wound/fracture/head/surgical
			if(BODY_ZONE_PRECISE_NECK)
				fracture_type = /datum/wound/fracture/neck
			if(BODY_ZONE_CHEST)
				fracture_type = /datum/wound/fracture/chest
			if(BODY_ZONE_PRECISE_GROIN)
				fracture_type = /datum/wound/fracture/groin
		limb.add_wound(fracture_type)

	display_results(
		surgeon,
		limb.owner,
		span_notice("I saw [limb.owner]'s [parse_zone(limb.body_zone)] open."),
		span_notice("[surgeon] saws [limb.owner]'s [parse_zone(limb.body_zone)] open!"),
		span_notice("[surgeon] saws [limb.owner]'s [parse_zone(limb.body_zone)] open!"),
	)
	display_pain(limb.owner, "Something just broke in my [parse_zone(limb.body_zone)]!")

	limb.owner.emote("scream")

/datum/surgery_operation/limb/saw_bones/on_failure(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	display_results(
		surgeon,
		limb.owner,
		span_warning("I fail to saw [limb.owner]'s [parse_zone(limb.body_zone)] open!"),
		span_warning("[surgeon] fails to saw [limb.owner]'s [parse_zone(limb.body_zone)] open!"),
		span_warning("[surgeon] fails to saw [limb.owner]'s [parse_zone(limb.body_zone)] open!"),
	)
	display_pain(limb.owner, "I feel my bones ache and crack in my [parse_zone(limb.body_zone)]!")

	limb.receive_damage(30)
	limb.owner.emote("scream")
