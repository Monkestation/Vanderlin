/**
 * A holder for simple behaviour that can be attached to many different types
 *
 * Only one element of each type is instanced during game init.
 * Otherwise acts basically like a lightweight component.
 */
/datum/element
	/// Option flags for element behaviour
	var/element_flags = NONE

	var/id_arg_index = 1

/// Activates the functionality defined by the element on the given target datum
/datum/element/proc/Attach(datum/target)
	SHOULD_CALL_PARENT(TRUE)
	if(type == /datum/element)
		return ELEMENT_INCOMPATIBLE
	if(element_flags & ELEMENT_DETACH_ON_HOST_DESTROY)
		RegisterSignal(target, COMSIG_PARENT_QDELETING, PROC_REF(Detach), override = TRUE)

/// Deactivates the functionality defines by the element on the given datum
/datum/element/proc/Detach(datum/source, ...)
	SHOULD_CALL_PARENT(TRUE)
	UnregisterSignal(source, COMSIG_PARENT_QDELETING)

/datum/element/Destroy(force)
	if(!force)
		return QDEL_HINT_LETMELIVE
	SSdcs.elements_by_type -= type
	return ..()

//DATUM PROCS

/// Finds the singleton for the element type given and attaches it to src
/datum/proc/_AddElement(list/arguments)
	if(QDELING(src))
		CRASH("We just tried to add an element to a qdeleted datum, something is fucked")
	var/datum/element/ele = SSdcs.GetElement(arguments)
	arguments[1] = src
	if(ele.Attach(arglist(arguments)) == ELEMENT_INCOMPATIBLE)
		CRASH("Incompatible [arguments[1]] assigned to a [type]! args: [json_encode(args)]")

/**
 * Finds the singleton for the element type given and detaches it from src
 * You only need additional arguments beyond the type if you're using ELEMENT_BESPOKE
 */
/datum/proc/_RemoveElement(list/arguments)
	var/datum/element/ele = SSdcs.GetElement(arguments)
	if(ele.element_flags & ELEMENT_COMPLEX_DETACH)
		arguments[1] = src
		ele.Detach(arglist(arguments))
	else
		ele.Detach(src)
