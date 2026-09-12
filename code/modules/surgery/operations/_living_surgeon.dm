// File for living procs related to surgery
/**
 * Attempts to perform a surgery with whatever tool is passed
 *
 * * src - the surgeon
 * * patient - the mob being operated on
 * * potential_tool - the tool being used for the operation (can be null / IMPLEMENT_HAND)
 * * intentionally_fail - if TRUE, forces the operation to fail (for testing purposes)
 *
 * Returns an ITEM_INTERACT_* flag
 */
/mob/living/proc/perform_surgery(mob/living/patient, potential_tool = IMPLEMENT_HAND, intentionally_fail = FALSE)
	if(DOING_INTERACTION(src, DOAFTER_SOURCE_SURGERY))
		patient.balloon_alert(src, "already performing surgery!")
		return ITEM_INTERACT_BLOCKING

	var/operating_zone = zone_selected
	var/list/operations = get_available_operations(patient, potential_tool, operating_zone)

	// we failed to undertake any operations?
	if(!length(operations))
		if(!isitem(potential_tool))
			return NONE
		var/obj/item/realtool = potential_tool
		// for surgical tools specifically, we have some special handling
		if(!(realtool.item_flags & SURGICAL_TOOL))
			return NONE
		// at this point we can be relatively sure they messed up so let's give a feedback message...
		if(!patient.is_location_accessible(operating_zone, IGNORED_OPERATION_CLOTHING_SLOTS))
			patient.balloon_alert(src, "operation site is obstructed!")
		else if(!IS_LYING_OR_CANNOT_LIE(patient))
			patient.balloon_alert(src, "not lying down!")
		else
			patient.balloon_alert(src, "nothing to do with [realtool.name]!")
		//  ...then, block attacking. prevents the surgeon from viciously stabbing the patient on a mistake
		return ITEM_INTERACT_BLOCKING

	var/list/radial_operations = list()
	for(var/radial_slice in operations)
		radial_operations[radial_slice] = radial_slice // weird but makes it easier to index later

	sortTim(radial_operations, GLOBAL_PROC_REF(cmp_name_asc))

	var/picked = show_radial_menu(
		user = src,
		anchor = patient,
		choices = radial_operations,
		radius = 35,
		custom_check = CALLBACK(src, PROC_REF(surgery_check), potential_tool, patient),
		require_near = TRUE,
		radial_slice_icon = "radial_thaum",
		autopick_single_option = TRUE,
	)
	if(isnull(picked))
		return ITEM_INTERACT_BLOCKING

	var/datum/surgery_operation/picked_op = operations[picked][1]
	var/atom/movable/operating_on = operations[picked][2]
	var/list/op_info = operations[picked][3]
	op_info[OPERATION_TARGET_ZONE] = operating_zone
	op_info[OPERATION_FORCE_FAIL] = intentionally_fail

	return picked_op.try_perform(operating_on, src, potential_tool, op_info)

/**
 * Returns a list of all surgery operations the mob can currently perform on the patient with the potential tool
 *
 * * src - the surgeon
 * * patient - the mob being operated on
 * * potential_tool - the tool being used for the operation (can be null / IMPLEMENT_HAND)
 * * operating_zone - the body zone being operated on
 *
 * Returns a list where the keys are radial menu slices and the values are lists of:
 * * [0] - the operation datum
 * * [1] - the atom being operated on
 * * [2] - a list of option-specific info
 */
/mob/living/proc/get_available_operations(mob/living/patient, potential_tool = IMPLEMENT_HAND, operating_zone = zone_selected)
	// List of typepaths of operations we *can* do
	var/list/possible_operations = GLOB.operations.unlocked.Copy()
	// Signals can add operation types to the list to unlock special ones
	SEND_SIGNAL(src, COMSIG_LIVING_OPERATING_ON, patient, possible_operations)
	SEND_SIGNAL(patient, COMSIG_LIVING_BEING_OPERATED_ON, patient, possible_operations)

	var/list/operations = list()
	for(var/datum/surgery_operation/operation as anything in GLOB.operations.get_instances_from(possible_operations))
		var/atom/movable/operate_on = operation.get_operation_target(patient, operating_zone)
		if(!operation.check_availability(patient, operate_on, src, potential_tool, operating_zone))
			continue
		var/potential_options = operation.get_radial_options(operate_on, potential_tool, operating_zone)
		if(!islist(potential_options))
			potential_options = list(potential_options)
		for(var/datum/radial_menu_choice/radial_slice as anything in potential_options)
			if(operations[radial_slice])
				stack_trace("Duplicate radial surgery option '[radial_slice.name]' detected for operation '[operation.type]'.")
				continue
			var/option_specific_info = potential_options[radial_slice] || list("[OPERATION_ACTION]" = "default")
			operations[radial_slice] = list(operation, operate_on, option_specific_info)

	return operations

/// Callback for checking if the surgery radial can be kept open
/mob/living/proc/surgery_check(obj/item/tool, mob/living/patient)
	var/obj/item/holding = get_active_held_item()

	if(tool == IMPLEMENT_HAND)
		return isnull(holding) // still holding nothing (or "hands")

	if(QDELETED(holding))
		return FALSE // i dunno, a stack item? not our problem

	return tool == holding.get_proxy_attacker_for(patient, src) // tool (or its proxy) is still being held
