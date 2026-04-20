// Basic operations for moving back and forth between surgery states
/// First step of every surgery, makes an incision in the skin
/datum/surgery_operation/limb/incise_skin
	name = "make skin incision"
	// rnd_name = "Laparotomy / Craniotomy / Myotomy (Make Incision)" // Maybe we keep this one simple
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

	any_surgery_states_blocked = ALL_SURGERY_SKIN_STATES

/datum/surgery_operation/limb/incise_skin/get_any_tool()
	return "Any sharp edged item"

/datum/surgery_operation/limb/incise_skin/get_default_radial_image()
	return image(/obj/item/weapon/surgery/scalpel)

/datum/surgery_operation/limb/incise_skin/tool_check(obj/item/tool)
	// Require edged sharpness OR a tool behavior match
	if((tool.get_sharpness() >= IS_SHARP) || implements[tool.tool_behaviour])
		return TRUE

	return FALSE

/datum/surgery_operation/limb/incise_skin/on_preop(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	display_results(
		surgeon,
		limb.owner,
		span_notice("You begin to make an incision in [limb.owner]'s [parse_zone(limb.body_zone)]..."),
		span_notice("[surgeon] begins to make an incision in [limb.owner]'s [parse_zone(limb.body_zone)]."),
		span_notice("[surgeon] begins to make an incision in [limb.owner]'s [parse_zone(limb.body_zone)]."),
	)
	display_pain(limb.owner, "You feel a stabbing in your [parse_zone(limb.body_zone)].")

/datum/surgery_operation/limb/incise_skin/on_success(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	. = ..() // default success message
	limb.add_wound(/datum/wound/slash/incision)

	display_results(
		surgeon,
		limb.owner,
		span_notice("Blood pools around the incision in [limb.owner]'s [parse_zone(limb.body_zone)]."),
		span_notice("Blood pools around the incision in [limb.owner]'s [parse_zone(limb.body_zone)]."),
		span_notice("Blood pools around the incision in [limb.owner]'s [parse_zone(limb.body_zone)]."),
	)

/// Pulls the skin back to access internals
/datum/surgery_operation/limb/retract_skin
	name = "retract skin"
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
		span_notice("You begin to retract the skin in [limb.owner]'s [parse_zone(limb.body_zone)]..."),
		span_notice("[surgeon] begins to retract the skin in [limb.owner]'s [parse_zone(limb.body_zone)]."),
		span_notice("[surgeon] begins to retract the skin in [limb.owner]'s [parse_zone(limb.body_zone)]."),
	)
	display_pain(limb.owner, "You feel a severe stinging pain spreading across your [parse_zone(limb.body_zone)] as the skin is pulled back.")

/datum/surgery_operation/limb/retract_skin/on_success(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	. = ..()

	limb.add_embedded_object(tool)

/// Closes the skin
/datum/surgery_operation/limb/close_skin
	name = "mend skin incision"
	desc = "Mend the incision in the patient's skin, closing it up. \
		Clears most surgical states."

	implements = list(
		TOOL_CAUTERY = 1,
		/obj/item/needle = 1,
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
	return LIMB_HAS_SKIN(limb)

/datum/surgery_operation/limb/close_skin/tool_check(obj/item/tool)
	if(istype(tool, /obj/item/needle))
		return TRUE

	return tool.get_temperature() > 0

/datum/surgery_operation/limb/close_skin/on_preop(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	display_results(
		surgeon,
		limb.owner,
		span_notice("You begin to mend the incision in [limb.owner]'s [parse_zone(limb.body_zone)]..."),
		span_notice("[surgeon] begins to mend the incision in [limb.owner]'s [parse_zone(limb.body_zone)]."),
		span_notice("[surgeon] begins to mend the incision in [limb.owner]'s [parse_zone(limb.body_zone)]."),
	)
	display_pain(limb.owner, "Your [parse_zone(limb.body_zone)] is being [istype(tool, /obj/item/needle) ? "pinched" : "burned"]!")

/datum/surgery_operation/limb/close_skin/on_success(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	. = ..()
	if(tool.get_temperature())
		limb.receive_damage(burn = 20)
	limb.remove_wound(/datum/wound/slash/incision)
	limb.remove_surgical_state(ALL_SURGERY_STATES_UNSET_ON_CLOSE)

/// Clamps bleeding blood vessels to prevent blood loss
/datum/surgery_operation/limb/clamp_bleeders
	name = "clamp bleeders"
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
		span_notice("You begin to clamp bleeders in [limb.owner]'s [parse_zone(limb.body_zone)]..."),
		span_notice("[surgeon] begins to clamp bleeders in [limb.owner]'s [parse_zone(limb.body_zone)]."),
		span_notice("[surgeon] begins to clamp bleeders in [limb.owner]'s [parse_zone(limb.body_zone)]."),
	)
	display_pain(limb.owner, "You feel a pinch as the bleeding in your [parse_zone(limb.body_zone)] is slowed.")

/datum/surgery_operation/limb/clamp_bleeders/on_success(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	. = ..()

	limb.add_embedded_object(tool)

	if(limb.can_be_disabled)
		limb.update_disabled()

/// Saws through bones to access organs
/datum/surgery_operation/limb/saw_bones
	name = "saw limb bone"
	desc = "Saw through the patient's bones to access their internal organs. \
		Causes \"bone sawed\" surgical state."

	implements = list(
		TOOL_SAW = 1.15,
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
		span_notice("You begin to saw through the bone in [limb.owner]'s [parse_zone(limb.body_zone)]..."),
		span_notice("[surgeon] begins to saw through the bone in [limb.owner]'s [parse_zone(limb.body_zone)]."),
		span_notice("[surgeon] begins to saw through the bone in [limb.owner]'s [parse_zone(limb.body_zone)]."),
	)
	display_pain(limb.owner, "You feel a horrid ache spread through the inside of your [parse_zone(limb.body_zone)]!")

/datum/surgery_operation/limb/saw_bones/on_success(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	. = ..()

	if(!limb.has_wound(/datum/wound/fracture))
		var/fracture_type = /datum/wound/fracture
		//yes we ignore crit resist here because this is a proper surgical procedure, not a crit
		switch(limb.body_zone)
			if(BODY_ZONE_HEAD)
				fracture_type = /datum/wound/fracture/head
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
		span_notice("You saw [limb.owner]'s [parse_zone(limb.body_zone)] open."),
		span_notice("[surgeon] saws [limb.owner]'s [parse_zone(limb.body_zone)] open!"),
		span_notice("[surgeon] saws [limb.owner]'s [parse_zone(limb.body_zone)] open!"),
	)
	display_pain(limb.owner, "Something just broke in your [parse_zone(limb.body_zone)]!")

	limb.owner.emote("scream")

/// Fixes sawed bones back together
/datum/surgery_operation/limb/fix_bones
	name = "fix limb bone"
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
	return LIMB_HAS_BONES(limb)

/datum/surgery_operation/limb/fix_bones/on_preop(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	display_results(
		surgeon,
		limb.owner,
		span_notice("You begin to set the bones in [limb.owner]'s [parse_zone(limb.body_zone)]..."),
		span_notice("[surgeon] begins to set the bones in [limb.owner]'s [parse_zone(limb.body_zone)]."),
		span_notice("[surgeon] begins to set the bones in [limb.owner]'s [parse_zone(limb.body_zone)]."),
	)
	display_pain(limb.owner, "You feel a grinding sensation in your [parse_zone(limb.body_zone)] as the bones are set back in place.")

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
