// Some operations that mirror basic carbon state-moving operations but for basic mobs
/// Incision of skin for basic mobs
/datum/surgery_operation/basic/incise_skin
	name = "Make Incision (basic)"
	desc = "Make an incision in the patient's skin to access internals. \
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
	target_zone = null

/datum/surgery_operation/basic/incise_skin/get_any_tool()
	return "Any sharp edged item"

/datum/surgery_operation/basic/incise_skin/all_blocked_strings()
	return ..() + list("The patient must not have complex anatomy")

/datum/surgery_operation/basic/incise_skin/get_default_radial_image()
	return image(/obj/item/weapon/surgery/scalpel)

/datum/surgery_operation/basic/incise_skin/state_check(mob/living/patient)
	return !patient.has_limbs // Only for limbless mobs

/datum/surgery_operation/basic/incise_skin/tool_check(obj/item/tool)
	// Require edged sharpness OR a tool behavior match
	if((tool.get_sharpness() >= IS_SHARP) || implements[tool.tool_behaviour])
		return TRUE

	return FALSE

/datum/surgery_operation/basic/incise_skin/on_preop(mob/living/patient, mob/living/surgeon, obj/item/tool, list/operation_args)
	display_results(
		surgeon,
		patient,
		span_notice("I begin to make an incision in [patient]..."),
		span_notice("[surgeon] begins to make an incision in [patient]."),
		span_notice("[surgeon] begins to make an incision in [patient]."),
	)
	display_pain(patient, "I feel a sharp stabbing sensation!")

/datum/surgery_operation/basic/incise_skin/on_success(mob/living/patient, mob/living/surgeon, obj/item/tool, list/operation_args)
	. = ..()
	patient.apply_status_effect(/datum/status_effect/basic_surgery_state, SURGERY_SKIN_OPEN)

/datum/surgery_operation/basic/saw_bone
	name = "Saw Bone (basic)"
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
	target_zone = null

/datum/surgery_operation/basic/saw_bone/get_any_tool()
	return "Any sharp edged item with decent force"

/datum/surgery_operation/basic/saw_bone/all_blocked_strings()
	return ..() + list("The patient must not have complex anatomy")

/datum/surgery_operation/basic/saw_bone/get_default_radial_image()
	return image(/obj/item/weapon/surgery/saw)

/datum/surgery_operation/basic/saw_bone/state_check(mob/living/patient)
	return !patient.has_limbs // Only for limbless mobs

/datum/surgery_operation/basic/saw_bone/tool_check(obj/item/tool)
	// Require edged sharpness and sufficient force OR a tool behavior match
	return (((tool.get_sharpness()>= IS_SHARP) && tool.force >= 10) || implements[tool.tool_behaviour])

/datum/surgery_operation/basic/saw_bone/on_preop(mob/living/patient, mob/living/surgeon, obj/item/tool, list/operation_args)
	display_results(
		surgeon,
		patient,
		span_notice("I begin to saw through [patient]'s bones..."),
		span_notice("[surgeon] begins to saw through [patient]'s bones."),
		span_notice("[surgeon] begins to saw through [patient]'s bones."),
	)
	display_pain(patient, "I feel a horrid ache spread through my insides!")

/datum/surgery_operation/basic/saw_bone/on_success(mob/living/patient, mob/living/surgeon, obj/item/tool, list/operation_args)
	. = ..()
	patient.apply_status_effect(/datum/status_effect/basic_surgery_state, SURGERY_BONE_SAWED)
	display_results(
		surgeon,
		patient,
		span_notice("I saw [patient] open."),
		span_notice("[surgeon] saws [patient] open!"),
		span_notice("[surgeon] saws [patient] open!"),
	)
	display_pain(patient, "It feels like something just broke!")

// Closing of skin for basic mobs
/datum/surgery_operation/basic/close_skin
	name = "Mend Incision (basic)"
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

	any_surgery_states_required = ALL_SURGERY_STATES_UNSET_ON_CLOSE // we're not picky
	target_zone = null

/datum/surgery_operation/basic/close_skin/get_any_tool()
	return "Any heat source"

/datum/surgery_operation/basic/close_skin/all_blocked_strings()
	return ..() + list("The patient must not have complex anatomy")

/datum/surgery_operation/basic/close_skin/get_default_radial_image()
	return image(/obj/item/weapon/surgery/cautery)

/datum/surgery_operation/basic/close_skin/state_check(mob/living/patient)
	return !patient.has_limbs // Only for limbless mobs

/datum/surgery_operation/basic/close_skin/tool_check(obj/item/tool)
	if(istype(tool, /obj/item/needle))
		return TRUE

	return tool.get_temperature() > 0

/datum/surgery_operation/basic/close_skin/on_preop(mob/living/patient, mob/living/surgeon, obj/item/tool, list/operation_args)
	display_results(
		surgeon,
		patient,
		span_notice("I begin to mend the incision in [patient]..."),
		span_notice("[surgeon] begins to mend the incision in [patient]."),
		span_notice("[surgeon] begins to mend the incision in [patient]."),
	)
	display_pain(patient, "I am being [istype(tool, /obj/item/needle) ? "pinched" : "burned"]!")

/datum/surgery_operation/basic/close_skin/on_success(mob/living/patient, mob/living/surgeon, obj/item/tool, list/operation_args)
	. = ..()
	// Just nuke the status effect, wipe the slate clean
	patient.remove_status_effect(/datum/status_effect/basic_surgery_state)
