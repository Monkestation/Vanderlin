/**
 * # Holy Weakness
 *
 * A weakness that causes affected
 * mobs to periodically light on fire
 * when entering holy areas. Currently
 * "holy areas" means churches.
 */
/datum/element/holy_weakness
	element_flags = ELEMENT_DETACH
	var/list/entered = list()

/datum/element/holy_weakness/Attach(datum/target)
	. = ..()

	if (!isliving(target))
		return ELEMENT_INCOMPATIBLE

	RegisterSignal(target, COMSIG_HUMAN_LIFE, PROC_REF(handle_church))

/datum/element/holy_weakness/Detach(datum/source, force)
	UnregisterSignal(source, COMSIG_HUMAN_LIFE)
	entered -= source

	return ..()

/datum/element/holy_weakness/proc/handle_church(mob/living/cursed_mob)
	SIGNAL_HANDLER

	// Holy weakness only triggers on entering churches
	if (!istype(get_area(cursed_mob), /area/indoors/town/church))
		if((cursed_mob in entered))
			entered -= cursed_mob
		return

	if(!(cursed_mob in entered))
		to_chat(cursed_mob, span_danger("Leave this holy place!"))
		entered |= cursed_mob

	if (!prob(6.25))
		return

	to_chat(cursed_mob, span_warning("You don't belong in this holy place!"))

	cursed_mob.apply_damage(20, BURN)
	cursed_mob.adjust_fire_stacks(6)
	cursed_mob.IgniteMob()


