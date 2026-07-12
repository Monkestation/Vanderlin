GLOBAL_DATUM_INIT(operations, /datum/operation_holder, new)

/// Singleton containing all surgery operation, as well as some helpers for organizing them
/datum/operation_holder
	/// All operation singletons, indexed by typepath
	/// It is recommended to use get_instances_from() where possible, rather than accessing this directly
	var/list/operations_by_typepath
	/// All operation typepaths which are unlocked by default, indexed by typepath
	var/list/unlocked
	/// All operation typepaths which are locked by something, indexed by typepath
	var/list/locked

/datum/operation_holder/New()
	. = ..()
	operations_by_typepath = list()
	unlocked = list()
	locked = list()

	for(var/datum/surgery_operation/operation_type as anything in subtypesof(/datum/surgery_operation))
		if(IS_ABSTRACT(operation_type))
			continue

		var/datum/surgery_operation/operation = new operation_type()
		if(isnull(operation.name))
			stack_trace("Surgery operation '[operation_type]' is missing a name!")

		operations_by_typepath[operation_type] = operation
		if(operation.operation_flags & OPERATION_LOCKED)
			locked += operation_type
		else
			unlocked += operation_type

/// Takes in a list of operation typepaths and returns their singleton instances.
/datum/operation_holder/proc/get_instances_from(list/typepaths)
	var/list/result = list()
	for(var/datum/surgery_operation/operation_type as anything in typepaths)
		var/datum/surgery_operation/operation = operations_by_typepath[operation_type]
		if(isnull(operation))
			continue
		result += operation
	return result
