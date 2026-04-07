/datum/augment/special
	var/list/granted_actions = list()
	color = COLOR_ASSEMBLY_RED

/datum/augment/special/on_install(mob/living/carbon/human/H)
	. = ..()
	if(!.)
		return
	for(var/action_type in granted_actions)
		var/datum/action/augment/spell = new action_type
		spell.Grant(H)
		spell.augment = src

/datum/augment/special/on_remove(mob/living/carbon/human/H)
	. = ..()
	if(!.)
		return
	for(var/action_type in granted_actions)
		var/datum/action/A = locate(action_type) in H.actions
		if(A)
			A.Remove(H)

/datum/augment/special/get_examine_info()
	var/list/info = list()
	if(granted_actions.len)
		info += span_info("Grants special abilities")
	return info


/datum/augment/special/dualwield
	name = "Marauder Unit"
	desc = "One of the assemblies that sealed Heartfelt's fate. Allows for simultaneous attacks with dual weaponry."
	stability_cost = -25
	engineering_difficulty = SKILL_RANK_EXPERT
	installation_time = 20 SECONDS

/datum/augment/special/dualwield/on_install(mob/living/carbon/human/H)
	. = ..()
	if(!.)
		return
	RegisterSignal(H, COMSIG_MOB_ITEM_ATTACK, PROC_REF(on_item_attack))

/datum/augment/special/dualwield/on_remove(mob/living/carbon/human/H)
	. = ..()
	if(!.)
		return
	UnregisterSignal(H, COMSIG_MOB_ITEM_ATTACK)

/datum/augment/special/dualwield/proc/on_item_attack(datum/source, mob/target, mob/user, list/modifiers, obj/item/weapon)
	SIGNAL_HANDLER

	var/mob/living/carbon/human/H = source
	if(!istype(H))
		return

	if(!(H.cmode))
		return

	if(weapon != H.get_active_held_item())
		return

	var/obj/item/offhand = H.get_inactive_held_item()
	if(!offhand)
		return

	var/attack_time = (user.next_move - world.time) * 0.5
	addtimer(CALLBACK(src, PROC_REF(complement_attack), H, offhand, target), attack_time, TIMER_UNIQUE)

/datum/augment/special/dualwield/proc/complement_attack(mob/living/carbon/human/H, obj/item/item, mob/target)
	if(QDELETED(H) || QDELETED(target))
		return

	if(H.get_inactive_held_item() != item)
		return

	if(H.CanReach(target, item))
		UnregisterSignal(H, COMSIG_MOB_ITEM_ATTACK)
		item.attack(target, H)
		RegisterSignal(H, COMSIG_MOB_ITEM_ATTACK, PROC_REF(on_item_attack))


/datum/action/augment
	var/datum/augment/augment

/datum/action/augment/sandevistan
	name = "Chronos"
	desc = "Activate Chronos to slow time around you."
	button_icon_state = "time_slow"

/datum/action/augment/sandevistan/Trigger(trigger_flags)
	if(!..())
		return FALSE

	var/datum/augment/special/sandevistan/sandy = augment
	if(istype(sandy))
		sandy.activate()
	return TRUE

/datum/augment/special/sandevistan
	name = "\improper CHRONOS unit"
	desc = "One of the assemblies that sealed Heartfelt's fate. Activates a localized chrono-distortion field, slowing time for everything around you while you move at normal speed."
	stability_cost = -30
	engineering_difficulty = SKILL_RANK_LEGENDARY
	installation_time = 30 SECONDS
	granted_actions = list(/datum/action/augment/sandevistan)

	var/cooldown_time = 45 SECONDS
	var/active_time = 15 SECONDS
	var/active = FALSE
	COOLDOWN_DECLARE(in_the_zone)

/datum/augment/special/sandevistan/on_install(mob/living/carbon/human/H)
	. = ..()
	to_chat(H, span_redtextbig("HEARTFELT CONNECTION RECEIVED. ORDERS: SURVEY."))

/datum/augment/special/sandevistan/proc/activate()
	var/mob/living/carbon/human/H = parent
	if(!istype(H))
		return

	if(active)
		to_chat(H, span_warning("The CHRONOS unit is already active!"))
		return

	if(!COOLDOWN_FINISHED(src, in_the_zone))
		to_chat(H, span_warning("The augment is recharging... ([DisplayTimeText(COOLDOWN_TIMELEFT(src, in_the_zone))] remaining)"))
		return

	COOLDOWN_START(src, in_the_zone, cooldown_time)
	active = TRUE

	playsound(H, 'sound/magic/timestop.ogg', 100, FALSE)
	H.AddComponent(/datum/component/after_image, 16, 0.5, TRUE)
	H.AddComponent(/datum/component/slowing_field, 0.1, 5, 3)

	to_chat(H, span_notice("Time seems to slow around you..."))

	addtimer(CALLBACK(src, PROC_REF(deactivate)), active_time)

/datum/augment/special/sandevistan/proc/deactivate()
	var/mob/living/carbon/human/H = parent
	if(!istype(H))
		return

	active = FALSE

	var/datum/component/after_image/AI = H.GetComponent(/datum/component/after_image)
	if(AI)
		qdel(AI)

	var/datum/component/slowing_field/SF = H.GetComponent(/datum/component/slowing_field)
	if(SF)
		qdel(SF)

	to_chat(H, span_notice("Time returns to normal."))

/datum/augment/special/sandevistan/get_examine_info()
	var/list/info = ..()
	info += span_info("Cooldown: [DisplayTimeText(cooldown_time)]")
	info += span_info("Duration: [DisplayTimeText(active_time)]")
	return info
