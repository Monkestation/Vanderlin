/datum/element/interrupt_on_damage
	element_flags = ELEMENT_BESPOKE
	id_arg_index = 2

/datum/element/interrupt_on_damage/Attach(mob/living/target)
	. = ..()
	if(!isliving(target))
		return ELEMENT_INCOMPATIBLE
	target.AddElement(/datum/element/relay_attackers)
	RegisterSignal(target, COMSIG_DO_AFTER_BEGAN, PROC_REF(on_do_after_begin))

/datum/element/interrupt_on_damage/Detach(mob/living/target)
	. = ..()
	target.RemoveElement(/datum/element/relay_attackers)
	UnregisterSignal(target, list(
		COMSIG_DO_AFTER_BEGAN,
		COMSIG_DO_AFTER_ENDED,
		COMSIG_ATOM_WAS_ATTACKED,
	))

/datum/element/interrupt_on_damage/proc/on_do_after_begin(mob/living/source)
	SIGNAL_HANDLER
	RegisterSignal(source, COMSIG_ATOM_WAS_ATTACKED, PROC_REF(on_attacked), override = TRUE)
	RegisterSignal(source, COMSIG_DO_AFTER_ENDED, PROC_REF(on_do_after_end), override = TRUE)

/datum/element/interrupt_on_damage/proc/on_do_after_end(mob/living/source)
	SIGNAL_HANDLER
	UnregisterSignal(source, list(
		COMSIG_ATOM_WAS_ATTACKED,
		COMSIG_DO_AFTER_ENDED,
	))

/datum/element/interrupt_on_damage/proc/on_attacked(mob/living/source, atom/attacker, damage)
	SIGNAL_HANDLER
	if(!damage)
		return
	UnregisterSignal(source, list(
		COMSIG_ATOM_WAS_ATTACKED,
		COMSIG_DO_AFTER_ENDED,
	))
	source.stop_all_doing()
	on_do_after_end(source)
