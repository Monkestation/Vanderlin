/datum/component/trap_springer
	var/trap_chance = 25
	var/trap_uses = -1
	var/datum/trap_datum/trap

/datum/component/trap_springer/Initialize(datum/trap_datum/trap, trap_chance = 25, trap_uses = 0)
	. = ..()
	if(!trap)
		return COMPONENT_INCOMPATIBLE
	src.trap = trap
	src.trap_chance = trap_chance
	src.trap_uses = trap_uses

/datum/component/trap_springer/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_TRAP_TRIGGERED, PROC_REF(trap_triggered))

/datum/component/trap_springer/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, COMSIG_TRAP_TRIGGERED)

/datum/component/trap_springer/proc/trap_triggered(mob/living/triggerer)
	if(!prob(trap_chance))
		return

	if(trap_uses)
		trap_uses--

	trap.trigger_trap(triggerer, parent)

	if(trap_uses == 0)
		qdel(src)
