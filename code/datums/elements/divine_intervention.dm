/datum/element/divine_intervention
	element_flags = ELEMENT_BESPOKE
	id_arg_index = 2
	var/datum/stress_event/stress_event
	var/datum/patron/patron
	var/allows_pantheon
	var/sets_alight

/datum/element/divine_intervention/Attach(datum/target, patron = /datum/patron/divine/astrata, allows_pantheon = PUNISHMENT_NONE, stress_event = null, sets_alight = FALSE)
	. = ..()
	if(!istype(target))
		return ELEMENT_INCOMPATIBLE
	src.patron = GLOB.patron_list[patron]
	src.allows_pantheon = allows_pantheon
	src.stress_event = stress_event
	src.sets_alight = sets_alight
	RegisterSignal(target, COMSIG_ITEM_AFTER_PICKUP, PROC_REF(on_pickup))

/datum/element/divine_intervention/Detach(obj/item/item)
	. = ..()
	UnregisterSignal(item, COMSIG_ITEM_AFTER_PICKUP)

/datum/element/divine_intervention/proc/on_pickup(obj/item/source, mob/user)
	SIGNAL_HANDLER
	if(!iscarbon(user))
		return
	var/mob/living/carbon/mob = user
	if(!mob.patron)
		return
	var/datum/patron/mob_patron = mob.patron
	if(istype(mob_patron, patron))
		return
	var/punishment = PUNISHMENT_BURN
	if(allows_pantheon && ispath(mob_patron.associated_faith, patron.associated_faith))
		punishment = allows_pantheon

	if(punishment == PUNISHMENT_NONE)
		return

	if(stress_event && punishment >= PUNISHMENT_STRESS)
		to_chat(mob, span_warning("I feel the eyes of [patron.name] upon me..."))
		mob.add_stress(/datum/stress_event/divine_punishment)

	if(sets_alight && punishment >= PUNISHMENT_BURN)
		to_chat(mob, "[span_cult(patron.name)] bellows, [span_userdanger("Drop it.")]")
		addtimer(CALLBACK(src, PROC_REF(immolation), source, user), 3 SECONDS)

/datum/element/divine_intervention/proc/immolation(obj/item/holy, mob/living/cooked)
	if(QDELETED(holy) || QDELETED(cooked))
		return
	if(holy.loc != cooked)
		return
	to_chat(cooked, span_warning("[patron.name] spurns me for holding their sacred item, \the [holy]!"))
	cooked.adjust_divine_fire_stacks(5)
	cooked.IgniteMob()
	cooked.drop_all_held_items()
