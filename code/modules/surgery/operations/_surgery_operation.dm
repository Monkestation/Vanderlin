/**
 * ## Surgery operation datum
 *
 * A singleton datum which represents a surgical operation that can be performed on a mob.
 *
 * Surgery operations can be something simple, like moving between surgery states (tend wounds, clamp vessels),
 * or more complex, like outright replacing limbs or organs. As such the datum is very flexible.
 *
 * At most basic, you must implement the vars:
 * * - [name][/datum/surgery_operation/var/name]
 * * - [desc][/datum/surgery_operation/var/desc]
 * * - [implements][/datum/surgery_operation/var/implements]
 * And the procs:
 * * - [on success][/datum/surgery_operation/proc/on_success] - put the effects of the operation here
 * Other noteworthy vars and procs you probably want to implement or override:
 * * - [operation flags][/datum/surgery_operation/var/operation_flags] - flags modifying the behavior of the operation
 * * - [required surgery state][/datum/surgery_operation/var/all_surgery_states_required] - target must have ALL of these states to be eligible for the operation
 * * - [blocked surgery state][/datum/surgery_operation/var/any_surgery_states_blocked] - target must NOT have ANY these states to be eligible for the operation
 * * - [state check][/datum/surgery_operation/proc/state_check] - extra checks for if the operating target is valid
 * * - [get default radial image][/datum/surgery_operation/proc/get_default_radial_image] - what icon to use for this operation on the radial menu
 *
 * It's recommended to work off of [/datum/surgery_operation/limb] or [/datum/surgery_operation/organ]
 * as they implement a lot of common functionality for targeting limbs or organs for you.
 *
 * See also [/datum/surgery_operation/basic], which is a bit more complex to use
 * but allows for operations to target any mob type, rather than only those with limbs or organs.
 */
/datum/surgery_operation
	abstract_type = /datum/surgery_operation
	/// Required - Name of the operation, keep it short and format it like an action - "amputate limb", "remove organ"
	/// Don't capitalize it, it will be capitalized automatically where necessary.
	var/name
	/// Required - Description of the operation, keep it short and format it like an action - "Amputate a patient's limb.", "Remove a patient's organ.".
	// Use "a patient" instead of "the patient" to keep it generic.
	var/desc
	/// Category for the book
	var/category
	/// Heretical, gives a warning in the book
	var/heretical = FALSE

	/**
	 * What tool(s) can be used to perform this operation?
	 *
	 * Assoc list of item typepath, TOOL_X, or IMPLEMENT_HAND to a multiplier for how effective that tool is at performing the operation.
	 * For example, list(TOOL_SCALPEL = 2, TOOL_SAW = 0.5) means that you can use a scalpel to operate, and it will double the time the operation takes.
	 * Likewise using a saw will halve the time it takes. If a tool is not listed, it cannot be used for this operation.
	 *
	 * Order matters! If a tool matches multiple entries, the first one will always be used.
	 * For example, if you have list(TOOL_SCREWDRIVER = 2, /obj/item/screwdriver = 1), and use a screwdriver
	 * it will use the TOOL_SCREWDRIVER modifier, making your operation 2x slower, even though the latter entry would have been faster.
	 *
	 * For this, it is handy to keep in mind SURGERY_MODIFIER_FAILURE_THRESHOLD.
	 * While speeds are soft capped and cannot be reduced beyond this point, larger modifiers still increase failure chances.
	 *
	 * Lastly, while most operations have its main tool with a 1x modifier (representing the "intended" tool),
	 * some will have its main tool's multiplier above or below 1x to represent an innately easier or harder operation
	 */
	var/list/implements
	/// Base time to perform this operation
	var/time = 1 SECONDS

	/// Flags modifying the behavior of this operation
	var/operation_flags = NONE

	/// The target must have ALL of these surgery states for the operation to be available
	var/all_surgery_states_required = NONE
	/// The target must have ANY of these surgery states for the operation to be available
	var/any_surgery_states_required = NONE
	/// The target must NOT have ANY of these surgery states for the operation to be available
	var/any_surgery_states_blocked = NONE

	/// SFX played before the do-after begins
	/// Can be a sound path or an assoc list of item typepath to sound path to make different sounds for different tools
	var/preop_sound
	/// SFX played on success, after the do-after
	/// Can be a sound path or an assoc list of item typepath to sound path to make different sounds for different tools
	var/success_sound
	/// SFX played on failure, after the do-after
	/// Can be a sound path or an assoc list of item typepath to sound path to make different sounds for different tools
	var/failure_sound

	/// The default radial menu choice for this operation, lazily created on first use
	/// Some subtypes won't have this set as they provide their own options
	VAR_PRIVATE/datum/radial_menu_choice/main_option

	/// Skill used to perform this surgery
	var/datum/attribute/skill/skill_used = /datum/attribute/skill/misc/medicine
	/// Necessary skill MINIMUM to perform this surgery, of skill_used
	var/skill_min = SKILL_LEVEL_NOVICE
	/// Skill median used to apply success and speed bonuses
	var/skill_median = SKILL_LEVEL_JOURNEYMAN

	/// Requirement threshold for the diceroll as a baseline
	var/dice_requirement = 25
	/// Crit window for the diceroll
	var/dice_crit = 8
	/// Number of dice rolled
	var/dice_num = 3
	/// Sides per die
	var/dice_sides = 20

/**
 * Checks to see if this operation can be performed
 * This is the main entry point for checking availability
 */
/datum/surgery_operation/proc/check_availability(mob/living/patient, atom/movable/operating_on, mob/living/surgeon, tool, operated_zone)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_BE_PURE(TRUE)

	if(isnull(patient) || isnull(operating_on))
		return FALSE

	if(!(operation_flags & OPERATION_STANDING_ALLOWED) && !IS_LYING_OR_CANNOT_LIE(patient) && !patient.buckled)
		return FALSE

	if(operation_flags & OPERATION_NOT_SELF_OPERABLE && patient == surgeon)
		return FALSE

	if(get_tool_quality(tool) <= 0)
		return FALSE

	if(!is_available(operating_on, operated_zone))
		return FALSE

	return snowflake_check_availability(operating_on, surgeon, tool, operated_zone)

/**
 * Snowflake checks for surgeries which need many interconnected conditions to be met
 */
/datum/surgery_operation/proc/snowflake_check_availability(atom/movable/operating_on, mob/living/surgeon, tool, operated_zone)
	PROTECTED_PROC(TRUE)

	return TRUE

/**
 * Returns the quality of the passed tool for this operation
 * Quality directly affects the time taken to perform the operation
 *
 * 0 = unusable
 * 1 = standard quality
 */
/datum/surgery_operation/proc/get_tool_quality(tool = IMPLEMENT_HAND)
	PROTECTED_PROC(TRUE)

	if(!length(implements))
		return 1

	if(!isitem(tool))
		return implements[tool]

	if(!tool_check(tool))
		return 0

	var/obj/item/realtool = tool
	return (realtool.toolspeed) * (implements[realtool.tool_behaviour] || is_type_in_list(realtool, implements, zebra = TRUE) || 0)

/**
 * Return a radial slice, a list of radial slices, or an assoc list of radial slice to operation info
 *
 * By default it returns a single option with the operation name and description,
 * but you can override this proc to return multiple options for one operation, like selecting which organ to operate on.
 */
/datum/surgery_operation/proc/get_radial_options(atom/movable/operating_on, obj/item/tool, operating_zone)
	if(!main_option)
		main_option = new()
		main_option.image = get_default_radial_image()
		main_option.name = name
		main_option.info = desc

	return main_option

/**
 * Checks to see if this operation can be performed on the provided target
 */
/datum/surgery_operation/proc/is_available(atom/movable/operating_on, operated_zone)
	PROTECTED_PROC(TRUE)
	SHOULD_CALL_PARENT(TRUE)

	if(all_surgery_states_required && !has_surgery_state(operating_on, all_surgery_states_required))
		return FALSE

	if(any_surgery_states_required && !has_any_surgery_state(operating_on, any_surgery_states_required))
		return FALSE

	if(any_surgery_states_blocked && has_any_surgery_state(operating_on, any_surgery_states_blocked))
		return FALSE

	if(!state_check(operating_on))
		return FALSE

	var/mob/living/patient = get_patient(operating_on)
	if(!(operation_flags & OPERATION_IGNORE_CLOTHES) && !patient.is_location_accessible(operated_zone, IGNORED_OPERATION_CLOTHING_SLOTS))
		return FALSE

	return TRUE

/// Check if the movable being operated on has all the passed surgery states
/datum/surgery_operation/proc/has_surgery_state(atom/movable/operating_on, state)
	PROTECTED_PROC(TRUE)

	return FALSE

/// Check if the movable being operated on has any of the passed surgery states
/datum/surgery_operation/proc/has_any_surgery_state(atom/movable/operating_on, state)
	PROTECTED_PROC(TRUE)

	return FALSE

/**
 * Any operation specific state checks, such as checking for traits or more complex state requirements
 */
/datum/surgery_operation/proc/state_check(atom/movable/operating_on)
	PROTECTED_PROC(TRUE)

	return TRUE

/**
 * Checks to see if the provided tool is valid for this operation
 * You can override this to add more specific checks, such as checking sharpness
 */
/datum/surgery_operation/proc/tool_check(obj/item/tool)
	PROTECTED_PROC(TRUE)

	return TRUE

/**
 * Returns the name of whatever tool is recommended for this operation, such as "hemostat"
 */
/datum/surgery_operation/proc/get_recommended_tool()
	if(!length(implements))
		return null
	var/recommendation = implements[1]
	if(istext(recommendation))
		return recommendation // handles tools or IMPLEMENT_HAND
	if(recommendation == /obj/item)
		return get_any_tool()
	if(ispath(recommendation, /obj/item))
		var/obj/item/tool = recommendation
		return tool::name
	return null

/**
 * For surgery operations that can be performed with any item, this explains what kind of item is needed
 */
/datum/surgery_operation/proc/get_any_tool()
	return "Any item"

/**
 * Return a list of lists of strings indicating the various requirements for this operation
 */
/datum/surgery_operation/proc/get_requirements()
	SHOULD_NOT_OVERRIDE(TRUE)

	return list(
		all_required_strings(),
		any_required_strings(),
		any_optional_strings(),
		all_blocked_strings(),
	)

/// Returns a list of strings indicating requirements for this operation
/// "All requirements" are formatted as "All of the following must be true:"
/datum/surgery_operation/proc/all_required_strings()
	SHOULD_CALL_PARENT(TRUE)

	. = bitfield_to_list(all_surgery_states_required, SURGERY_STATE_GUIDES("must"))
	if(!(operation_flags & OPERATION_STANDING_ALLOWED))
		. += "the patient must be lying down"

/// Returns a list of strings indicating any of the requirements for this operation
/// "Any requirements" are formatted as "At least one of the following must be true:"
/datum/surgery_operation/proc/any_required_strings()
	SHOULD_CALL_PARENT(TRUE)

	. = list()
	// grouped states are filtered down to make it more readable
	var/parsed_any_flags = any_surgery_states_required
	if((parsed_any_flags & ALL_SURGERY_BONE_STATES) == ALL_SURGERY_BONE_STATES)
		parsed_any_flags &= ~ALL_SURGERY_BONE_STATES
		. += "the bone must be sawn"

	if((parsed_any_flags & ALL_SURGERY_SKIN_STATES) == ALL_SURGERY_SKIN_STATES)
		parsed_any_flags &= ~ALL_SURGERY_SKIN_STATES
		. += "the skin must be cut or opened"

	if((parsed_any_flags & ALL_SURGERY_VESSEL_STATES) == ALL_SURGERY_VESSEL_STATES)
		parsed_any_flags &= ~ALL_SURGERY_VESSEL_STATES
		. += "the blood vessels must be clamped or unclamped" // weird phrasing but whatever

	. += bitfield_to_list(parsed_any_flags, SURGERY_STATE_GUIDES("must"))

/// Returns a list of strings indicating optional conditions for this operation
/// "Optional conditions" are formatted as "Additionally, any of the following may be true:"
/datum/surgery_operation/proc/any_optional_strings()
	SHOULD_CALL_PARENT(TRUE)

	. = list()
	if(operation_flags & OPERATION_NOT_SELF_OPERABLE)
		. += "a surgeon may not perform this on themselves"

/// Returns a list of strings indicating blocked states for this operation
/// "Blocked requirements" are formatted as "However, none of the following may be true:"
/datum/surgery_operation/proc/all_blocked_strings()
	SHOULD_CALL_PARENT(TRUE)

	. = list()
	// grouped states are filtered down to make it more readable
	var/parsed_blocked_flags = any_surgery_states_blocked
	if((parsed_blocked_flags & ALL_SURGERY_BONE_STATES) == ALL_SURGERY_BONE_STATES)
		parsed_blocked_flags &= ~ALL_SURGERY_BONE_STATES
		. += "the bone must be intact"

	if((parsed_blocked_flags & ALL_SURGERY_SKIN_STATES) == ALL_SURGERY_SKIN_STATES)
		parsed_blocked_flags &= ~ALL_SURGERY_SKIN_STATES
		. += "the skin must be intact"

	if((parsed_blocked_flags & ALL_SURGERY_VESSEL_STATES) == ALL_SURGERY_VESSEL_STATES)
		parsed_blocked_flags &= ~ALL_SURGERY_VESSEL_STATES
		. += "the blood vessels must be intact"

	. += bitfield_to_list(parsed_blocked_flags, SURGERY_STATE_GUIDES("must not"))
	if(!(operation_flags & OPERATION_IGNORE_CLOTHES))
		. += "the operation site must not be obstructed by clothing"

/**
 * Returns what icon this surgery uses by default on the radial wheel if it does not implement its own radial options
 */
/datum/surgery_operation/proc/get_default_radial_image()
	return image(icon = 'icons/obj/structures_spawners.dmi', icon_state = "questionmark")

/**
 * Helper for constructing overlays to apply to a radial image
 *
 * Input can be
 * * - An atom typepath
 * * - An atom instance
 * * - Another image
 *
 * Returns a list of images
 */
/datum/surgery_operation/proc/add_radial_overlays(list/overlay_icons)
	SHOULD_NOT_OVERRIDE(TRUE)
	PROTECTED_PROC(TRUE)

	if(!islist(overlay_icons))
		overlay_icons = list(overlay_icons)

	var/list/created_list = list()
	for(var/input in overlay_icons)
		var/image/created = isimage(input) ? input : image(input)
		created.layer = FLOAT_LAYER
		created.plane = FLOAT_PLANE
		created.pixel_w = 0
		created.pixel_x = 0
		created.pixel_y = 0
		created.pixel_z = 0
		created_list += created

	return created_list

/// Returns the result that must be rolled to succeed the surgery
/datum/surgery_operation/proc/get_roll_requirement(atom/movable/operating_on, mob/living/surgeon, tool)
	var/requirement = dice_requirement

	if(skill_used)
		var/skill_level = GET_MOB_SKILL_VALUE(surgeon, skill_used) || 0
		var/skill_delta = (skill_level - skill_median) * 0.5
		requirement += skill_delta

	var/tool_quality = get_tool_quality(tool)
	requirement += round((1 - tool_quality) * 6)

	var/loc_mod = get_location_modifier(get_turf(operating_on))
	requirement += round((loc_mod - 1) * 8, 1)

	var/overseer_bonus = get_overseer_bonus(surgeon)
	if(overseer_bonus > 1)
		requirement += overseer_bonus
		to_chat(surgeon, span_notice("You feel more confident with an experienced eye watching over you."))

	return FLOOR(clamp(requirement, dice_num, dice_num * dice_sides), 1)

/// Display roll to the surgeon
/datum/surgery_operation/proc/display_roll(mob/living/surgeon, result_label, requirement)
	if(!surgeon.client?.prefs.read_preference(/datum/preference/toggle/showrolls))
		return

	if(requirement != null)
		to_chat(surgeon, span_warning("[result_label] (requirement was [requirement]/[dice_num * dice_sides])"))
	else
		to_chat(surgeon, span_warning("[result_label]"))

/// Collates all time modifiers for this operation and returns the final modifier
/datum/surgery_operation/proc/get_time_modifiers(atom/movable/operating_on, mob/living/surgeon, tool)
	PROTECTED_PROC(TRUE)

	var/total_mod = 1.0
	total_mod *= get_tool_quality(tool) || 1.0
	// Ignore alllll the penalties (but also all the bonuses)
	if(!HAS_TRAIT(surgeon, TRAIT_IGNORE_SURGERY_MODIFIERS))
		var/mob/living/patient = get_patient(operating_on)
		total_mod *= get_location_modifier(get_turf(patient))
		total_mod *= get_skill_modifier(surgeon)

	return round(total_mod, 0.01)

/// Gets the bonus from skill
/datum/surgery_operation/proc/get_skill_modifier(mob/living/surgeon)
	if(!skill_used)
		return 1.0

	var/skill_level = GET_MOB_SKILL_VALUE(surgeon, skill_used)

	var/difference = skill_median - skill_level

	if(difference == 0)
		return 1.0

	if(difference > 0)
		return (1.0 - (0.015 * difference))

	if(difference < 0)
		return (1.0 + (0.01 * difference))

	return 1.0

/// Gets the bonus for someone with better skill watching over the surgery
/datum/surgery_operation/proc/get_overseer_bonus(mob/living/surgeon)
	var/best_bonus = 1.0
	var/our_skill = GET_MOB_SKILL_VALUE(surgeon, skill_used)
	if(our_skill >= skill_median)
		return best_bonus

	for(var/mob/living/carbon/human/nearby in oview(3, surgeon))
		if(nearby == surgeon)
			continue

		if(nearby.stat != CONSCIOUS)
			continue

		var/overseer_skill = GET_MOB_SKILL_VALUE(nearby, skill_used)
		if(overseer_skill < skill_median)
			continue

		if(overseer_skill <= our_skill)
			continue

		// every 10 above is 5% time reduction
		var/bonus = 1.0 - ((overseer_skill - skill_median) * 0.005)
		if(bonus > best_bonus)
			best_bonus = bonus

	return best_bonus

/// Gets the surgery speed modifier for a given mob, based off what sort of table/bed/whatever is on their turf.
/datum/surgery_operation/proc/get_location_modifier(turf/operation_turf)
	PROTECTED_PROC(TRUE)

	// Technically this IS a typecache, just not the usual kind :3
	// The order of the modifiers matter, latter entries override earlier ones
	var/static/list/modifiers = zebra_typecacheof(list(
		/obj/structure/table/optable = 1.0,
		/obj/structure/bed = 1.25,
		/obj/structure/table = 1.5,
	))

	var/mod = 2.0
	for(var/obj/thingy in operation_turf)
		mod = min(mod, modifiers[thingy.type] || 2.0)

	return mod

/**
 * Gets what movable is being operated on by a surgeon during this operation
 * Determines what gets passed into the try_perform() proc
 * If null is returned, the operation cannot be performed
 *
 * * patient - The mob being operated on
 * * body_zone - The body zone being operated on
 *
 * Returns the atom/movable being operated on
 */
/datum/surgery_operation/proc/get_operation_target(mob/living/patient, body_zone)
	return patient

/**
 * Called by operating computers to hint that this surgery could come next given the target's current state
 */
/datum/surgery_operation/proc/show_as_next_step(mob/living/potential_patient, operated_zone)
	var/atom/movable/operate_on = get_operation_target(potential_patient, operated_zone)
	return !isnull(operate_on) && is_available(operate_on, operated_zone)


/**
 * The actual chain of performing the operation
 *
 * * operating_on - The atom being operated on, probably a bodypart or occasionally a mob directly
 * * surgeon - The mob performing the operation
 * * tool - The tool being used to perform the operation. CAN BE A STRING, ie, IMPLEMENT_HAND, be careful
 * * operation_args - Additional arguments passed into the operation. Contains largely niche info that only certain operations care about or can be accessed through other means
 *
 * Returns an item interaction flag - intended to be invoked from the interaction chain
 */
/datum/surgery_operation/proc/try_perform(atom/movable/operating_on, mob/living/surgeon, tool, list/operation_args = list())
	SHOULD_NOT_OVERRIDE(TRUE)

	var/mob/living/patient = get_patient(operating_on)

	if(!check_availability(patient, operating_on, surgeon, tool, operation_args[OPERATION_TARGET_ZONE]))
		return ITEM_INTERACT_BLOCKING

	if(!start_operation(operating_on, surgeon, tool, operation_args))
		return ITEM_INTERACT_BLOCKING

	var/result = NONE

	SEND_SIGNAL(patient, COMSIG_LIVING_SURGERY_STARTED, src, operating_on, tool)

	do
		operation_args[OPERATION_SPEED] = get_time_modifiers(operating_on, surgeon, tool)

		if(!do_after(
			user = surgeon,
			// Actual delay is capped - think of the excess time as being added to failure chance instead
			delay = time * min(operation_args[OPERATION_SPEED], 2.5),
			target = patient,
			extra_checks = CALLBACK(src, PROC_REF(operate_check), patient, operating_on, surgeon, tool, operation_args),
			interaction_key = DOAFTER_SOURCE_SURGERY,
		))
			result |= ITEM_INTERACT_BLOCKING
			break

		if(ishuman(surgeon))
			var/mob/living/carbon/human/surgeon_human = surgeon
			//surgeon_human.add_blood_DNA_to_items(patient.get_blood_dna_list(), ITEM_SLOT_GLOVES)
			surgeon_human.add_blood_DNA()
		else
			surgeon.add_mob_blood(patient)

		var/force_fail = operation_args[OPERATION_FORCE_FAIL]

		var/failure_message = "intentional failure"
		if(!force_fail && (GET_MOB_SKILL_VALUE(surgeon, skill_used) < skill_min))
			force_fail = TRUE
			failure_message = "lack of skill"

		var/roll_result = NONE
		var/roll_requirement = 0

		if(force_fail)
			roll_result = DICE_FAILURE
			display_roll(surgeon, "[uppertext(failure_message)]", null)
		else
			roll_requirement = get_roll_requirement(operating_on, surgeon, tool)
			roll_result = surgeon.diceroll(
				requirement = roll_requirement,
				crit = dice_crit,
				dice_num = dice_num,
				dice_sides = dice_sides,
			)

		var/was_critical = (roll_result == DICE_CRIT_FAILURE) || (roll_result == DICE_CRIT_SUCCESS)

		switch(roll_result)
			if(DICE_FAILURE, DICE_CRIT_FAILURE)
				failure(operating_on, surgeon, tool, operation_args, was_critical)
				display_roll(surgeon, "[was_critical ? "CRITICAL " : ""]FAILURE", roll_requirement)
				result |= ITEM_INTERACT_BLOCKING
			if(DICE_SUCCESS, DICE_CRIT_SUCCESS)
				success(operating_on, surgeon, tool, operation_args, was_critical)
				display_roll(surgeon, "[was_critical ? "CRITICAL " : ""]SUCCESS", roll_requirement)
				result |= ITEM_INTERACT_BLOCKING

		if(isbundle(tool))
			var/obj/item/natural/bundle/tool_bundle = tool
			tool_bundle.use(1)

	while ((operation_flags & OPERATION_LOOPING) && can_loop(patient, operating_on, surgeon, tool, operation_args))

	SEND_SIGNAL(patient, COMSIG_LIVING_SURGERY_FINISHED, src, operating_on, tool)

	return result

/// Called after an operation to check if it can be repeated/looped
/datum/surgery_operation/proc/can_loop(mob/living/patient, atom/movable/operating_on, mob/living/surgeon, tool, list/operation_args)
	PROTECTED_PROC(TRUE)

	return operate_check(patient, operating_on, surgeon, tool, operation_args)

/// Called during the do-after to check if the operation can continue
/datum/surgery_operation/proc/operate_check(mob/living/patient, atom/movable/operating_on, mob/living/surgeon, tool, list/operation_args)
	PROTECTED_PROC(TRUE)

	if(isbundle(tool))
		var/obj/item/natural/bundle/tool_bundle = tool
		if(tool_bundle.amount <= 0)
			return FALSE

	if(!surgeon.surgery_check(tool, patient))
		return FALSE

	if(!check_availability(patient, operating_on, surgeon, tool, operation_args[OPERATION_TARGET_ZONE]))
		return FALSE

	return TRUE

/**
 * Allows for any extra checks or setup when the operation starts
 * If you want user input before for an operation, do it here
 *
 * This proc can sleep, sanity checks are automatically performed after it completes
 *
 * Return FALSE to cancel the operation
 * Return TRUE to continue
 */
/datum/surgery_operation/proc/pre_preop(atom/movable/operating_on, mob/living/surgeon, tool, list/operation_args)
	PROTECTED_PROC(TRUE)

	return TRUE

/// Used to display messages to the surgeon and patient
/datum/surgery_operation/proc/display_results(mob/living/surgeon, mob/living/target, self_message, detailed_message, vague_message, target_detailed = FALSE)
	SHOULD_NOT_OVERRIDE(TRUE)
	PROTECTED_PROC(TRUE)

	ASSERT(istext(self_message), "[type] operation display_results must have a self_message!")
	ASSERT(istext(detailed_message), "[type] operation display_results must have a detailed_message!")
	ASSERT(istext(vague_message) || target_detailed, "[type] operation display_results must have either a vague_message or target_detailed = TRUE!")

	surgeon.visible_message(
		message = detailed_message,
		self_message = self_message,
		vision_distance = 1,
		ignored_mobs = target_detailed ? null : target
	)
	if(target_detailed)
		return

	var/you_feel = pick("a brief pain", "your body tense up", "an unnerving sensation")
	target.show_message(
		msg = vague_message || detailed_message || span_notice("You feel [you_feel] as you are operated on."),
		type = MSG_VISUAL,
		alt_msg = span_notice("You feel [you_feel] as you are operated on."),
	)

/// Display pain message to the target based on their traits and condition
/datum/surgery_operation/proc/display_pain(mob/living/target, pain_message, mechanical_surgery = FALSE)
	SHOULD_NOT_OVERRIDE(TRUE)
	PROTECTED_PROC(TRUE)

	if(!pain_message)
		return

	if(target.stat >= UNCONSCIOUS || HAS_TRAIT(target, TRAIT_KNOCKEDOUT))
		return

	if(HAS_TRAIT(target, TRAIT_NOPAIN))
		to_chat(target, span_notice("You feel a dull, numb sensation as your body is surgically operated on."))
		return

	to_chat(target, span_userdanger(pain_message))

	if(prob(30) && !mechanical_surgery)
		target.emote("scream")

/// Plays a sound for the operation based on the tool used
/datum/surgery_operation/proc/play_operation_sound(atom/movable/operating_on, mob/living/surgeon, tool, sound_or_sound_list)
	PROTECTED_PROC(TRUE)

	if(isitem(tool) && (operation_flags & OPERATION_MECHANIC))
		var/obj/item/realtool = tool
		realtool.play_tool_sound(operating_on)
		return

	var/sound_to_play
	if(islist(sound_or_sound_list))
		var/list/sounds = sound_or_sound_list
		if(isitem(tool))
			var/obj/item/realtool = tool
			sound_to_play = sounds[realtool.tool_behaviour] || is_type_in_list(realtool, sounds, zebra = TRUE)
		else
			sound_to_play = sounds[tool]
	else
		sound_to_play = sound_or_sound_list

	if(sound_to_play)
		playsound(surgeon, sound_to_play, 50, TRUE)

/// Helper for getting the mob who is ultimately being operated on, given the movable that is truly being operated on.
/// For example in limb surgeries this would return the mob the limb is attached to.
/datum/surgery_operation/proc/get_patient(atom/movable/operating_on) as /mob/living
	return operating_on

/**
 * Called when the operation initiates
 * Don't touch this proc, override on_preop() instead
 */
/datum/surgery_operation/proc/start_operation(atom/movable/operating_on, mob/living/surgeon, tool, list/operation_args)
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)

	var/preop_time = world.time
	var/mob/living/patient = get_patient(operating_on)
	if(!pre_preop(operating_on, surgeon, tool, operation_args))
		return FALSE
	// if pre_preop slept, sanity check that everything is still valid
	if(preop_time != world.time && (patient != get_patient(operating_on) || !surgeon.Adjacent(patient) || !surgeon.is_holding(tool) || !operate_check(patient, operating_on, surgeon, tool, operation_args)))
		return FALSE

	play_operation_sound(operating_on, surgeon, tool, preop_sound)
	on_preop(operating_on, surgeon, tool, operation_args)
	return TRUE

/**
 * Used to customize behavior when the operation starts
 */
/datum/surgery_operation/proc/on_preop(atom/movable/operating_on, mob/living/surgeon, tool, list/operation_args)
	PROTECTED_PROC(TRUE)
	var/mob/living/patient = get_patient(operating_on)

	display_results(
		surgeon,
		patient,
		span_notice("You begin to operate on [patient]..."),
		span_notice("[surgeon] begins to operate on [patient]."),
		span_notice("[surgeon] begins to operate on [patient]."),
	)

/**
 * Called when the operation is successful
 * Don't touch this proc, override on_success() instead
 */
/datum/surgery_operation/proc/success(atom/movable/operating_on, mob/living/surgeon, tool, list/operation_args, was_critical)
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	if(operation_flags & OPERATION_NOTABLE)
		SSblackbox.record_feedback("tally", "surgeries_completed", 1, type)

	SEND_SIGNAL(surgeon, COMSIG_LIVING_SURGERY_SUCCESS, src, operating_on, tool)
	play_operation_sound(operating_on, surgeon, tool, success_sound)
	on_success(operating_on, surgeon, tool, operation_args)

	if(was_critical)
		on_crit_success(operating_on, surgeon, tool, operation_args)

	surgeon.mind?.add_sleep_experience(skill_used, GET_MOB_ATTRIBUTE_VALUE(surgeon, STAT_INTELLIGENCE) * (skill_min / 30))

/// Used to customize behavior when the operation is successful
/datum/surgery_operation/proc/on_success(atom/movable/operating_on, mob/living/surgeon, tool, list/operation_args)
	PROTECTED_PROC(TRUE)

	var/mob/living/patient = get_patient(operating_on)

	display_results(
		surgeon,
		patient,
		span_notice("You succeed."),
		span_notice("[surgeon] succeeds!"),
		span_notice("[surgeon] finishes."),
	)

/// Additional crit affects after the main success effect
/datum/surgery_operation/proc/on_crit_success(atom/movable/operating_on, mob/living/surgeon, tool, list/operation_args)
	return

/**
 * Called when the operation fails
 * Don't touch this proc, override on_failure() instead
 */
/datum/surgery_operation/proc/failure(atom/movable/operating_on, mob/living/surgeon, tool, list/operation_args, was_critical)
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	if(operation_flags & OPERATION_NOTABLE)
		SSblackbox.record_feedback("tally", "surgeries_failed", 1, type)

	SEND_SIGNAL(surgeon, COMSIG_LIVING_SURGERY_FAILED, src, operating_on, tool)
	play_operation_sound(operating_on, surgeon, tool, failure_sound)
	on_failure(operating_on, surgeon, tool, operation_args)

	if(was_critical)
		on_crit_failure(operating_on, surgeon, tool, operation_args)

	surgeon.mind?.add_sleep_experience(skill_used, GET_MOB_ATTRIBUTE_VALUE(surgeon, STAT_INTELLIGENCE) * (skill_min / 60))

/// Used to customize behavior when the operation fails
/datum/surgery_operation/proc/on_failure(atom/movable/operating_on, mob/living/surgeon, tool, list/operation_args)
	PROTECTED_PROC(TRUE)

	var/mob/living/patient = get_patient(operating_on)

	var/screwedmessage = ""
	if(operation_args[OPERATION_FORCE_FAIL])
		screwedmessage = " Intentionally."

	display_results(
		surgeon,
		patient,
		span_warning("You screw up![screwedmessage]"),
		span_warning("[surgeon] screws up!"),
		span_notice("[surgeon] finishes."),
		TRUE, //By default the patient will notice if the wrong thing has been cut
	)

/// Additional crit affects after the main failure effect
/datum/surgery_operation/proc/on_crit_failure(atom/movable/operating_on, mob/living/surgeon, tool, list/operation_args)
	return

/**
 * Basic operations are a simple base type for surgeries that
 * 1. Target a specific zone on humans
 * 2. Work on non-humans
 *
 * Use this as a bsae if your surgery needs to work on everyone
 *
 * "operating_on" is the mob being operated on, be it carbon or non-carbon.
 * If the mob is carbon, we check the relevant bodypart for surgery states and traits. No bodypart, no operation.
 * If the mob is non-carbon, we just check the mob directly.
 */
/datum/surgery_operation/basic
	abstract_type = /datum/surgery_operation/basic
	/// Biotype required to perform this operation
	var/required_biotype = ~MOB_ROBOTIC
	/// The zone we are expected to be working on, even if the target is a non-carbon mob
	var/target_zone = BODY_ZONE_CHEST
	/// When working on carbons, what bodypart are we working on? Keep it representative of the required biotype
	var/required_bodytype = BODYPART_ORGANIC

/datum/surgery_operation/basic/all_required_strings()
	. = list()
	if(required_biotype)
		. += "operate on [target_zone ? "[parse_zone(target_zone)] (target [parse_zone(target_zone)])" : "patient"]"
	else if(target_zone)
		. += "operate on [parse_zone(target_zone)] (target [parse_zone(target_zone)])"
	. += ..()

/datum/surgery_operation/basic/all_blocked_strings()
	. = ..()
	if(required_biotype & MOB_ROBOTIC)
		. += "the patient must not be organic"
	else if(required_biotype)
		. += "the patient must not be metallic"

/datum/surgery_operation/basic/is_available(mob/living/patient, operated_zone)
	SHOULD_NOT_OVERRIDE(TRUE)

	if(target_zone && target_zone != operated_zone)
		return FALSE

	if(required_biotype && !(patient.mob_biotypes & required_biotype))
		return FALSE

	if(!patient.has_limbs || !target_zone)
		return ..()

	var/obj/item/bodypart/carbon_part = patient.get_bodypart(target_zone)
	if(isnull(carbon_part))
		return FALSE

	if(required_bodytype && !(carbon_part.status == required_bodytype))
		return FALSE

	return ..()

/datum/surgery_operation/basic/has_surgery_state(mob/living/patient, state)
	var/obj/item/bodypart/carbon_part = patient.get_bodypart(target_zone)
	if(isnull(carbon_part)) // non-carbon
		var/datum/status_effect/basic_surgery_state/state_holder = patient.has_status_effect(__IMPLIED_TYPE__)
		return HAS_SURGERY_STATE(state_holder?.surgery_state, state & (SURGERY_BONE_SAWED|SURGERY_SKIN_OPEN)) // these are the only states basic mobs support, update this if that changes

	return LIMB_HAS_SURGERY_STATE(carbon_part, state)

/datum/surgery_operation/basic/has_any_surgery_state(mob/living/patient, state)
	var/obj/item/bodypart/carbon_part = patient.get_bodypart(target_zone)
	if(isnull(carbon_part)) // non-carbon
		var/datum/status_effect/basic_surgery_state/state_holder = patient.has_status_effect(__IMPLIED_TYPE__)
		return HAS_ANY_SURGERY_STATE(state_holder?.surgery_state, state)

	return LIMB_HAS_ANY_SURGERY_STATE(carbon_part, state)

/**
 * Limb opterations are a base focused on the limb the surgeon is targeting
 *
 * Use this if your surgery targets a specific limb on the mob
 *
 * "operating_on" is asserted to be a bodypart - the bodypart the surgeon is targeting.
 * If there is no bodypart, there's no operation.
 */
/datum/surgery_operation/limb
	abstract_type = /datum/surgery_operation/limb
	/// Body type required to perform this operation
	var/required_bodytype = NONE

/datum/surgery_operation/limb/all_blocked_strings()
	. = ..()
	if(required_bodytype == BODYPART_ROBOTIC)
		. += "the limb must not be organic"
	else if(required_bodytype == BODYPART_ORGANIC)
		. += "the limb must not be prostetic"

/datum/surgery_operation/limb/get_operation_target(mob/living/patient, body_zone)
	return patient.get_bodypart(deprecise_zone(body_zone))

/datum/surgery_operation/limb/is_available(obj/item/bodypart/limb, operated_zone)
	SHOULD_NOT_OVERRIDE(TRUE)

	// targeting groin will redirect you to the chest
	if(limb.body_zone != deprecise_zone(operated_zone))
		return FALSE

	if(required_bodytype && !(limb.status == required_bodytype))
		return FALSE

	return ..()

/datum/surgery_operation/limb/has_surgery_state(obj/item/bodypart/limb, state)
	return LIMB_HAS_SURGERY_STATE(limb, state)

/datum/surgery_operation/limb/has_any_surgery_state(obj/item/bodypart/limb, state)
	return LIMB_HAS_ANY_SURGERY_STATE(limb, state)

/datum/surgery_operation/limb/get_patient(obj/item/bodypart/limb)
	return limb.owner
