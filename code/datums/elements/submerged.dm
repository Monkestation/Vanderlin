/// Element for handling mob submerged behavior
/datum/element/submerged
	var/sink_interval = 3 SECONDS

/datum/element/submerged/Attach(datum/target)
	. = ..()
	if(!isliving(target))
		return ELEMENT_INCOMPATIBLE

	if(HAS_TRAIT(target, TRAIT_SUBMERGED))
		return ELEMENT_INCOMPATIBLE

	ADD_TRAIT(target, TRAIT_SUBMERGED, ELEMENT_TRAIT(type))
	RegisterSignal(target, COMSIG_LIVING_SWIM, PROC_REF(handle_swim))
	RegisterSignal(target, COMSIG_MOB_EQUIPPED_ITEM, PROC_REF(check_sinking))
	RegisterSignal(target, COMSIG_MOB_UNEQUIPPED_ITEM, PROC_REF(check_sinking))
	check_sinking(target)

/datum/element/submerged/Detach(mob/living/source)
	REMOVE_TRAIT(source, TRAIT_SINKING, ELEMENT_TRAIT(type))
	REMOVE_TRAIT(source, TRAIT_MOVE_SWIMMING, ELEMENT_TRAIT(type))
	REMOVE_TRAIT(source, TRAIT_SUBMERGED, ELEMENT_TRAIT(type))
	UnregisterSignal(source, list(COMSIG_LIVING_SWIM, COMSIG_MOB_EQUIPPED_ITEM, COMSIG_MOB_UNEQUIPPED_ITEM))

	return ..()

/datum/element/submerged/proc/handle_swim(mob/living/target, swimming)
	SIGNAL_HANDLER
	if(!swimming || HAS_TRAIT(target, TRAIT_SINKING))
		REMOVE_TRAIT(target, TRAIT_MOVE_SWIMMING, ELEMENT_TRAIT(type))
	else
		ADD_TRAIT(target, TRAIT_MOVE_SWIMMING, ELEMENT_TRAIT(type))

/datum/element/submerged/proc/check_sinking(mob/living/target)
	SIGNAL_HANDLER
	if(target.encumbrance >= (HAS_TRAIT(target, TRAIT_GOOD_SWIM) ? ENCUMBRANCE_HEAVY : ENCUMBRANCE_MEDIUM))
		ADD_TRAIT(target, TRAIT_SINKING, ELEMENT_TRAIT(type))
		handle_swim(target, FALSE)
		handle_sinking(target)
		to_chat(target, span_warning("The weight you bear pulls you down."))
	else
		REMOVE_TRAIT(target, TRAIT_SINKING, ELEMENT_TRAIT(type))
		handle_swim(target, TRUE)

/datum/element/submerged/proc/handle_sinking(mob/living/target)
	if(!HAS_TRAIT(target, TRAIT_SINKING))
		return
	target.zSwim(DOWN, TRUE)
	addtimer(CALLBACK(src, PROC_REF(handle_sinking), target), sink_interval)
