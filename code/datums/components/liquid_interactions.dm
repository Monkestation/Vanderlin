///This element allows for items to interact with liquids on turfs.
/datum/component/liquids_interaction
	///Callback interaction called when the turf has some liquids on it
	var/datum/callback/interaction_callback

/datum/component/liquids_interaction/Initialize(on_interaction_callback)
	. = ..()

	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE

	interaction_callback = CALLBACK(parent, on_interaction_callback)

/datum/component/liquids_interaction/Destroy(force)
	interaction_callback = null
	return ..()

/datum/component/liquids_interaction/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ITEM_INTERACTING_WITH_ATOM, PROC_REF(try_interact)) //The only signal allowing item -> turf interaction

/datum/component/liquids_interaction/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_ATOM_ITEM_INTERACTION)

/datum/component/liquids_interaction/proc/try_interact(datum/source, mob/living/user, atom/target, list/modifiers)
	SIGNAL_HANDLER

	if(!isturf(target))
		return NONE

	var/turf/target_turf = target

	if(interaction_callback.Invoke(source, target, user, target_turf.liquids))
		return ITEM_INTERACT_SUCCESS
