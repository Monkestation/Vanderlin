/datum/augment/special
	var/list/granted_actions = list()

/datum/augment/special/on_install(mob/living/carbon/human/H)
	for(var/action_type in granted_actions)
		var/datum/action/augment/spell = new action_type
		spell.Grant(H)
		spell.augment = src

/datum/augment/special/on_remove(mob/living/carbon/human/H)
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
	name = "C.C.M.S implant"
	desc = "Short for Complementary Combat Maneuvering System. Processes spinal nerve signals to enact forced complementary maneuvers, allowing dual wielding of weapons."
	stability_cost = -20
	engineering_difficulty = SKILL_LEVEL_EXPERT
	installation_time = 25 SECONDS

/datum/augment/special/dualwield/on_install(mob/living/carbon/human/H)
	RegisterSignal(H, COMSIG_MOB_ITEM_ATTACK, PROC_REF(on_item_attack))
	to_chat(H, span_notice("Your motor systems synchronize with the C.C.M.S implant."))

/datum/augment/special/dualwield/on_remove(mob/living/carbon/human/H)
	UnregisterSignal(H, COMSIG_MOB_ITEM_ATTACK)
	to_chat(H, span_notice("The C.C.M.S implant's connection to your motor systems fades."))

/datum/augment/special/dualwield/proc/on_item_attack(datum/source, mob/target, mob/user, params, obj/item/weapon)
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

	if(handle_side_effects(H, item, target))
		return

	if(H.CanReach(target, item))
		UnregisterSignal(H, COMSIG_MOB_ITEM_ATTACK)
		item.attack(target, H)
		RegisterSignal(H, COMSIG_MOB_ITEM_ATTACK, PROC_REF(on_item_attack))

/datum/augment/special/dualwield/proc/handle_side_effects(mob/living/carbon/human/H, obj/item/item, mob/target)
	return FALSE

/datum/augment/special/dualwield/refurbished
	name = "refurbished C.C.M.S implant"
	desc = "A refurbished dual wielding implant. The nerve filaments have degraded and may misfire or cause damage."
	stability_cost = -10
	engineering_difficulty = SKILL_LEVEL_JOURNEYMAN
	installation_time = 20 SECONDS

/datum/augment/special/dualwield/refurbished/handle_side_effects(mob/living/carbon/human/H, obj/item/item, mob/target)
	if(prob(20))
		H.visible_message(
			span_warning("[H]'s arm twitches."),
			span_danger("Your C.C.M.S misfires!")
		)
		return TRUE

	if(prob(30))
		H.visible_message(
			span_warning("[H]'s arm spazzes out!"),
			span_danger("Your arm spazzes out!")
		)
		var/obj/item/bodypart/arm = H.get_holding_bodypart_of_item(item)
		arm?.receive_damage(brute = 10)

	return FALSE

/datum/action/augment
	var/datum/augment/augment

/datum/action/augment/sandevistan
	name = "Sandevistan Activation"
	desc = "Activate your sandevistan to slow time around you."
	button_icon_state = "time_slow"

/datum/action/augment/sandevistan/Trigger(trigger_flags)
	if(!..())
		return FALSE

	var/datum/augment/special/sandevistan/sandy = augment
	if(istype(sandy))
		sandy.activate()
	return TRUE

/datum/augment/special/sandevistan
	name = "Militech Apogee Sandevistan"
	desc = "Experimental timeslowing implant. Activates a localized chrono-distortion field, slowing time for everything around you while you move at normal speed."
	stability_cost = -25
	engineering_difficulty = SKILL_LEVEL_MASTER
	installation_time = 30 SECONDS
	granted_actions = list(/datum/action/augment/sandevistan)

	var/cooldown_time = 45 SECONDS
	var/active_time = 15 SECONDS
	var/active = FALSE
	COOLDOWN_DECLARE(in_the_zone)

/datum/augment/special/sandevistan/on_install(mob/living/carbon/human/H)
	. = ..()
	to_chat(H, span_notice("Neural interface established. Sandevistan ready."))

/datum/augment/special/sandevistan/proc/activate()
	var/mob/living/carbon/human/H = parent
	if(!istype(H))
		return

	if(active)
		to_chat(H, span_warning("The sandevistan is already active!"))
		return

	if(!COOLDOWN_FINISHED(src, in_the_zone))
		to_chat(H, span_warning("The implant is recharging... ([DisplayTimeText(COOLDOWN_TIMELEFT(src, in_the_zone))] remaining)"))
		return

	COOLDOWN_START(src, in_the_zone, cooldown_time)
	active = TRUE

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

/datum/augment/special/sandevistan/refurbished
	name = "refurbished sandevistan"
	desc = "A hastily refurbished sandevistan. The chrono-field generator is unstable and may cause neural feedback."
	stability_cost = -15
	engineering_difficulty = SKILL_LEVEL_EXPERT
	cooldown_time = 65 SECONDS

/datum/augment/special/sandevistan/refurbished/activate()
	var/mob/living/carbon/human/H = parent
	if(!istype(H))
		return

	if(prob(45))
		H.adjustOrganLoss(ORGAN_SLOT_BRAIN, 10)
		to_chat(H, span_warning("Neural feedback! Your mind reels from the information overload!"))

	return ..()

/datum/augment/special/sandevistan/refurbished/deactivate()
	var/mob/living/carbon/human/H = parent
	if(!istype(H))
		return

	..()

	H.adjustBruteLoss(10)
	to_chat(H, span_warning("Your body strains from the temporal stress, causing minor injuries."))
