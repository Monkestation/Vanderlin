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
	limb.add_surgical_state(SURGERY_SKIN_CUT|SURGERY_VESSELS_UNCLAMPED) // ouch, cuts the vessels
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

/datum/surgery_operation/limb/retract_skin/on_success(obj/item/bodypart/limb)
	. = ..()
	limb.add_surgical_state(SURGERY_SKIN_OPEN)
	limb.remove_surgical_state(SURGERY_SKIN_CUT)

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
	if(LIMB_HAS_SURGERY_STATE(limb, SURGERY_BONE_SAWED))
		limb.heal_damage(40)
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

/datum/surgery_operation/limb/clamp_bleeders/on_success(obj/item/bodypart/limb)
	. = ..()
	// free brute healing if you do it after sawing bones
	if(LIMB_HAS_SURGERY_STATE(limb, SURGERY_BONE_SAWED))
		limb.heal_damage(20)
	limb.add_surgical_state(SURGERY_VESSELS_CLAMPED)
	limb.remove_surgical_state(SURGERY_VESSELS_UNCLAMPED)

/// Unclamps blood vessels to allow blood flow again
/datum/surgery_operation/limb/unclamp_bleeders
	name = "unclamp bleeders"
	desc = "Unclamp blood vessels in the patient's body to allow blood flow again. \
		Clears \"vessels clamped\" surgical state."

	implements = list(
		TOOL_HEMOSTAT = 1,
		TOOL_IMPROVISED_HEMOSTAT = 1.5,
	)

	time = 2.4 SECONDS

	preop_sound = 'sound/surgery/hemostat1.ogg'
	all_surgery_states_required = SURGERY_SKIN_OPEN|SURGERY_VESSELS_CLAMPED

/datum/surgery_operation/limb/unclamp_bleeders/get_default_radial_image()
	return image(/obj/item/weapon/surgery/hemostat)

/datum/surgery_operation/limb/unclamp_bleeders/all_required_strings()
	return ..() + list("the limb must have blood vessels")

/datum/surgery_operation/limb/unclamp_bleeders/state_check(obj/item/bodypart/limb)
	return LIMB_HAS_VESSELS(limb)

/datum/surgery_operation/limb/unclamp_bleeders/on_preop(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	display_results(
		surgeon,
		limb.owner,
		span_notice("You begin to unclamp bleeders in [limb.owner]'s [parse_zone(limb.body_zone)]..."),
		span_notice("[surgeon] begins to unclamp bleeders in [limb.owner]'s [parse_zone(limb.body_zone)]."),
		span_notice("[surgeon] begins to unclamp bleeders in [limb.owner]'s [parse_zone(limb.body_zone)]."),
	)
	display_pain(limb.owner, "You feel a pressure release as blood starts flowing in your [parse_zone(limb.body_zone)] again.")

/datum/surgery_operation/limb/unclamp_bleeders/on_success(obj/item/bodypart/limb)
	. = ..()
	limb.add_surgical_state(SURGERY_VESSELS_UNCLAMPED)
	limb.remove_surgical_state(SURGERY_VESSELS_CLAMPED)

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

	limb.add_surgical_state(SURGERY_BONE_SAWED)
	limb.receive_damage(50)

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
	display_pain(limb.owner, "It feels like something just broke in your [parse_zone(limb.body_zone)]!")

	limb.owner.emote("scream")

/// Fixes sawed bones back together
/datum/surgery_operation/limb/fix_bones
	name = "fix limb bone"
	desc = "Repair a patient's cut or broken bones. \
		Clears \"bone sawed\" surgical state."

	implements = list(
		TOOL_BONESET = 1,
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
		span_notice("You begin to fix the bones in [limb.owner]'s [parse_zone(limb.body_zone)]..."),
		span_notice("[surgeon] begins to fix the bones in [limb.owner]'s [parse_zone(limb.body_zone)]."),
		span_notice("[surgeon] begins to fix the bones in [limb.owner]'s [parse_zone(limb.body_zone)]."),
	)
	display_pain(limb.owner, "You feel a grinding sensation in your [parse_zone(limb.body_zone)] as the bones are set back in place.")

/datum/surgery_operation/limb/fix_bones/on_success(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	display_results(
		surgeon,
		limb.owner,
		span_notice("I successfully relocate the bone in [limb.owner]'s [parse_zone(limb.body_zone)]."),
		span_notice("[surgeon] successfully sets the bone in [limb.owner]'s [parse_zone(limb.body_zone)]!"),
		span_notice("[surgeon] successfully sets the bone in [limb.owner]'s [parse_zone(limb.body_zone)]!"),
	)

	for(var/datum/wound/fracture/bone in limb.wounds)
		bone.set_bone()

	limb.remove_surgical_state(SURGERY_BONE_SAWED)
	limb.heal_damage(40)

// /datum/surgery_operation/limb/incise_organs
// 	name = "incise organs"
// 	desc = "Make an incision in patient's internal organ tissue to allow for manipulation or repair. \
// 		Causes \"organs cut\" surgical state."

// 	implements = list(
// 		TOOL_SCALPEL = 1,
// 		/obj/item/weapon/knife = 1.5,
// 		/obj/item/natural/glass/shard = 2.25,
// 		/obj/item = 3.33,
// 	)

// 	time = 2.4 SECONDS

// 	preop_sound = 'sound/surgery/scalpel1.ogg'
// 	success_sound = 'sound/surgery/organ1.ogg'

// 	all_surgery_states_required = SURGERY_SKIN_OPEN
// 	any_surgery_states_blocked = SURGERY_ORGANS_CUT

// /datum/surgery_operation/limb/incise_organs/get_any_tool()
// 	return "Any sharp edged item"

// /datum/surgery_operation/limb/incise_organs/get_default_radial_image()
// 	return image(/obj/item/weapon/surgery/scalpel)

// /datum/surgery_operation/limb/incise_organs/tool_check(obj/item/tool)
// 	// Require edged sharpness OR a tool behavior match. Also saws are a no-go, you'll rip up the organs!
// 	return ((tool.get_sharpness() >= IS_SHARP) || implements[tool.tool_behaviour]) && tool.tool_behaviour != TOOL_SAW

// /datum/surgery_operation/limb/incise_organs/on_preop(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
// 	display_results(
// 		surgeon,
// 		limb.owner,
// 		span_notice("You begin to make an incision in the organs within [limb.owner]'s [parse_zone(limb.body_zone)]..."),
// 		span_notice("[surgeon] begins to make an incision in the organs within [limb.owner]'s [parse_zone(limb.body_zone)]."),
// 		span_notice("[surgeon] begins to make an incision in the organs within [limb.owner]'s [parse_zone(limb.body_zone)]."),
// 	)
// 	display_pain(limb.owner, "You feel a stabbing in your [parse_zone(limb.body_zone)].")

// /datum/surgery_operation/limb/incise_organs/on_success(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
// 	. = ..()
// 	limb.add_surgical_state(SURGERY_ORGANS_CUT)
// 	limb.receive_damage(10)

// 	display_results(
// 		surgeon,
// 		limb.owner,
// 		span_notice("You make an incision in the organs within [limb.owner]'s [parse_zone(limb.body_zone)]."),
// 		span_notice("[surgeon] makes an incision in the organs within [limb.owner]'s [parse_zone(limb.body_zone)]!"),
// 		span_notice("[surgeon] makes an incision in the organs within [limb.owner]'s [parse_zone(limb.body_zone)]!"),
// 	)

// 	display_pain(limb.owner, "You feel a sharp pain from inside your [parse_zone(limb.body_zone)]!")
