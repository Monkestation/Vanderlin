
/**
*
 */
/datum/component/repairable
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	/// Associative list of repair item = repair threshold (0 to 1). For example, list(/obj/item/grown/log/tree/small = 1) fully repairs the parent.
	var/list/repair_thresholds
	/// Item used to call atom_fix() on the parent. Prioritized over repair_thresholds
	var/obj/item/item_repair_broken
	var/broken_parent = FALSE
	var/repair_sound
	var/repair_skill
	var/repair_skill_level
	/// Set to TRUE to interrupt any active repair attempts
	var/interrupt_repair

/datum/component/repairable/Initialize(list/_repair_thresholds, obj/item/_item_repair_broken, _repair_sound, _repair_skill, _repair_skill_level = 0)
	. = ..()

	if(isindestructiblewall(parent))
		return COMPONENT_INCOMPATIBLE

	if(!isclosedturf(parent) && !isstructure(parent))
		return COMPONENT_INCOMPATIBLE

	if(!islist(_repair_thresholds) && !_item_repair_broken)
		stack_trace("Both repair_thresholds and item_repair_broken not passed as args!")
		return COMPONENT_INCOMPATIBLE

	repair_thresholds = sortTim(_repair_thresholds, associative = TRUE)
	item_repair_broken = _item_repair_broken
	repair_sound = _repair_sound
	repair_skill = _repair_skill
	repair_skill_level = _repair_skill_level

	RegisterSignal(parent, COMSIG_ATOM_ATTACKBY, PROC_REF(attempt_repair))
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(parent, COMSIG_ATOM_FIX, PROC_REF(on_parent_fix))
	RegisterSignal(parent, COMSIG_ATOM_TAKE_DAMAGE, PROC_REF(on_take_damage))
	RegisterSignal(parent, COMSIG_ATOM_BREAK, PROC_REF(on_parent_break))
	if(isturf(parent))
		RegisterSignal(parent, COMSIG_TURF_CHANGE, PROC_REF(on_turf_changed))

/datum/component/repairable/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_ATOM_ATTACKBY, COMSIG_PARENT_EXAMINE, COMSIG_ATOM_FIX, COMSIG_ATOM_TAKE_DAMAGE, COMSIG_ATOM_BREAK, COMSIG_TURF_CHANGE))

/datum/component/repairable/proc/attempt_repair(datum/source, obj/item/attacking_item, mob/user, params)
	SIGNAL_HANDLER

	if(repair_skill && user.get_skill_level(repair_skill) < repair_skill_level)
		return

	var/atom/atom_parent = parent
	if(broken_parent)
		if(!istype(attacking_item, item_repair_broken))
			return

		. = COMPONENT_NO_AFTERATTACK
		INVOKE_ASYNC(src, PROC_REF(async_start), source, attacking_item, user, params)
	else
		var/parent_integrity = atom_parent.get_integrity() / atom_parent.max_integrity

		var/obj/item/repair_item_path
		var/repair_value
		for(var/item as anything in repair_thresholds)
			if(parent_integrity < repair_thresholds[item])
				repair_item_path = item
				repair_value = repair_thresholds[item] * atom_parent.max_integrity
				break

		if(!repair_item_path || !istype(attacking_item, repair_item_path))
			return

		. = COMPONENT_NO_AFTERATTACK
		INVOKE_ASYNC(src, PROC_REF(async_start), source, attacking_item, user, params, repair_value)

/datum/component/repairable/proc/async_start(datum/source, obj/item/attacking_item, mob/user, params, repair_threshold_value)
	var/atom/atom_parent = parent
	if(repair_sound)
		playsound(parent, repair_sound, 100, TRUE)
	user.visible_message(span_notice("[user] starts repairing [parent]."), span_notice("I start repairing [parent]."))
	var/repair_time = 10 SECONDS
	if(repair_skill)
		repair_time = 30 SECONDS / max(user.get_skill_level(repair_skill, TRUE), 1)  // 1 skill = 30 secs, 2 skill = 15 secs etc.
	interrupt_repair = FALSE
	if(!do_after(user, repair_time, parent, extra_checks = CALLBACK(src, PROC_REF(can_repair), user)))
		interrupt_repair = FALSE
		return
	interrupt_repair = FALSE
	if(repair_sound)
		playsound(parent, repair_sound, 100, TRUE)
	user.visible_message(span_notice("[user] finishes repairing [parent]."), span_notice("I finished repairing [parent]."))
	qdel(attacking_item)

	if(broken_parent)
		var/repair_amount = (atom_parent.integrity_failure * atom_parent.max_integrity) - atom_parent.get_integrity() + 1
		atom_parent.repair_damage(repair_amount)
	else
		atom_parent.repair_damage(repair_threshold_value - atom_parent.get_integrity())

/datum/component/repairable/proc/can_repair(mob/user)
	if(interrupt_repair)
		return FALSE
	return TRUE

/datum/component/repairable/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	var/atom/atom_parent = parent

	if(broken_parent)
		examine_list += span_notice("A [item_repair_broken.name] is needed to fix the broken [atom_parent.name] first.")
	else
		var/list/examine_strings = list()
		var/parent_integrity = atom_parent.get_integrity() / atom_parent.max_integrity
		for(var/obj/item as anything in repair_thresholds)
			var/threshold = repair_thresholds[item]
			if(parent_integrity < threshold)
				examine_strings += "A [item.name] will repair [atom_parent.name] to [threshold * 100]%."
		if(length(examine_strings))
			examine_list += span_notice("[examine_strings.Join(" ")]")

/datum/component/repairable/proc/on_parent_fix(datum/source)
	broken_parent = FALSE

/datum/component/repairable/proc/on_parent_break(datum/source, damage_flag)
	if(item_repair_broken)
		broken_parent = TRUE

/datum/component/repairable/proc/on_take_damage(datum/source, damage_amount)
	interrupt_repair = TRUE

/// If the wall becomes any other turf, delete us. Transforming into a different works fine as a fix.
/datum/component/repairable/proc/on_turf_changed()
	SIGNAL_HANDLER
	qdel(src)
