/datum/action/innate/clench_fists
	name = "Clench Fists"
	desc = "Assume a fistfighting stance."
	button_icon_state = "giants_strength"

	var/obj/item/weapon/clenched_fist/fisticuffs

/datum/action/innate/clench_fists/Destroy(force)
	if(!QDELETED(fisticuffs))
		qdel(fisticuffs)
	fisticuffs = null
	return ..()

/datum/action/innate/clench_fists/Activate()
	. = ..()

	if(!owner.check_stamina(5))
		owner.balloon_alert(owner, "exhausted!")
		return

	owner.adjust_stamina(5)

	if(QDELETED(fisticuffs))
		fisticuffs = new(owner)

	if(!owner.put_in_active_hand(fisticuffs))
		owner.balloon_alert(owner, "hand full!")
		clean_fists()
		return

	owner.balloon_alert_to_viewers("clenches [owner.p_their()] fist")
	RegisterSignal(fisticuffs, COMSIG_QDELETING, PROC_REF(clean_fists))
	active = TRUE

/datum/action/innate/clench_fists/Deactivate()
	. = ..()

	if(QDELETED(fisticuffs))
		return

	owner.balloon_alert_to_viewers("unclenches [owner.p_their()] fist")
	clean_fists()
	active = FALSE

/datum/action/innate/clench_fists/proc/clean_fists()
	SIGNAL_HANDLER

	if(!QDELETED(fisticuffs))
		qdel(fisticuffs)
	active = FALSE
	build_all_button_icons(UPDATE_BUTTON_STATUS)
	fisticuffs = null
