#define CONDUIT_FILTER "blood_conduit"

/datum/component/blood_conduit
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/outline_color = COLOR_BLOOD_MAGIC
	var/datum/weakref/owner_ref

/datum/component/blood_conduit/Initialize(outline_color_override, mob/living/owner)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	if(outline_color_override)
		outline_color = outline_color_override
	if(owner)
		owner_ref = WEAKREF(owner)
		RegisterSignal(owner, COMSIG_LIVING_DEATH, PROC_REF(on_owner_death))
	var/obj/item/I = parent
	I.add_filter(CONDUIT_FILTER, 2, outline_filter(1, outline_color))
	RegisterSignal(parent, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))

/datum/component/blood_conduit/UnregisterFromParent()
	var/obj/item/I = parent
	if(istype(I))
		I.remove_filter(CONDUIT_FILTER)
	UnregisterSignal(parent, COMSIG_ATOM_EXAMINE)
	var/mob/living/owner = owner_ref?.resolve()
	if(owner)
		UnregisterSignal(owner, COMSIG_LIVING_DEATH)

/datum/component/blood_conduit/proc/on_owner_death()
	SIGNAL_HANDLER
	var/mob/living/owner = owner_ref?.resolve()
	if(owner)
		var/datum/status_effect/buff/blood_bound/M = owner.has_status_effect(/datum/status_effect/buff/blood_bound)
		if(M)
			M.bound_weapon = null
	qdel(src)

/datum/component/blood_conduit/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	examine_list += span_notice("This weapon pulses with dark energies. It is bound as a blood conduit, the reaping tool of a blood mage.")

#undef CONDUIT_FILTER
