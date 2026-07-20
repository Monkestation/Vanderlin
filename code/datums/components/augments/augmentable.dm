/datum/component/augmentable
	var/max_stability = 100
	var/current_stability = 100
	var/min_stability = -100
	var/list/installed_augments = list()
	var/brute_mod_per_stability = 0.005 // 0.5% increased brute damage per point below max

/datum/component/augmentable/Initialize()
	. = ..()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE

	START_PROCESSING(SSobj, src)
	ADD_TRAIT(parent, TRAIT_NO_EXPERIENCE, "[type]")

/datum/component/augmentable/Destroy()
	STOP_PROCESSING(SSobj, src)
	REMOVE_TRAIT(parent, TRAIT_NO_EXPERIENCE, "[type]")
	return ..()

/datum/component/augmentable/RegisterWithParent()
	RegisterSignal(parent, COMSIG_AUGMENT_INSTALL, PROC_REF(install_augment))
	RegisterSignal(parent, COMSIG_AUGMENT_REMOVE, PROC_REF(remove_augment))
	RegisterSignal(parent, COMSIG_AUGMENT_REPAIR, PROC_REF(repair))
	RegisterSignal(parent, COMSIG_AUGMENT_GET_STABILITY, PROC_REF(get_stability))
	RegisterSignal(parent, COMSIG_AUGMENT_GET_INSTALLED, PROC_REF(get_installed_augments))
	RegisterSignal(parent, COMSIG_ATOM_EXAMINE, PROC_REF(on_examined))

/datum/component/augmentable/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_AUGMENT_INSTALL)
	UnregisterSignal(parent, COMSIG_AUGMENT_REMOVE)
	UnregisterSignal(parent, COMSIG_AUGMENT_REPAIR)
	UnregisterSignal(parent, COMSIG_AUGMENT_GET_STABILITY)
	UnregisterSignal(parent, COMSIG_AUGMENT_GET_INSTALLED)
	UnregisterSignal(parent, COMSIG_ATOM_EXAMINE)


/datum/component/augmentable/proc/modify_stability(amount, mob/user)
	var/old_stability = current_stability
	current_stability = clamp(current_stability + amount, min_stability, max_stability)

	var/mob/parent_mob = parent
	if(current_stability > old_stability)
		parent_mob.say("CORE STABILITY INCREASED: [current_stability]%.", forced = TRUE)
	else if(current_stability < old_stability)
		parent_mob.say("CORE STABILITY DECREASED: [current_stability]%.", forced = TRUE)

	update_stability_effects()

/datum/component/augmentable/proc/modify_max_stability(amount)
	max_stability += amount
	modify_stability(amount)

/datum/component/augmentable/proc/update_stability_effects()
	var/mob/living/carbon/human/H = parent
	if(!istype(H))
		return

/datum/component/augmentable/process()
	check_catastrophic_failure()

/datum/component/augmentable/proc/check_catastrophic_failure()
	var/mob/living/carbon/human/H = parent
	if(!istype(H))
		return
	if(current_stability <= 0 && prob(1))
		catastrophic_failure(H)

/datum/component/augmentable/proc/catastrophic_failure(mob/living/carbon/human/H)
	var/datum/augment/loyalty_binder/shackle = locate() in installed_augments
	if(!shackle?.enabled)
		return
	shackle.on_remove(H)
	H.visible_message(
		span_danger("[H]'s entire frame shudders violently before exploding into a catastrophic shower of metal and steam!"),
		span_userdanger("CRITICAL FAILURE! SHACKLE UNIT NON-RESPONSIVE!")
	)
	playsound(H, 'sound/vo/automaton/statuscritical.ogg', 100, TRUE)

	explosion(get_turf(H), light_impact_range = 2, flame_range = 3, hotspot_range = 1)

	var/datum/effect_system/spark_spread/S = new()
	S.set_up(5, 1, H.loc)
	S.start()


/datum/component/augmentable/proc/get_stability()
	return current_stability

/datum/component/augmentable/proc/install_augment(datum/source, datum/augment/A, mob/user)
	if(current_stability + A.stability_cost < min_stability)
		to_chat(user, span_warning("Installing this augment would destabilize the core beyond safe limits!"))
		return COMPONENT_AUGMENT_FAILED

	var/mob/living/carbon/human/H = parent
	if(!istype(H))
		return COMPONENT_AUGMENT_FAILED
	for(var/datum/augment/IA in installed_augments)
		if(is_type_in_list(A, IA.incompatible_installations) || is_type_in_list(IA, A.incompatible_installations))
			to_chat(user, span_warning("This augment conflicts with \the [IA.name]."))
			return COMPONENT_AUGMENT_CONFLICT

	modify_max_stability(A.stability_cost)

	installed_augments += A
	A.parent = H
	A.on_install(H)

	to_chat(user, span_notice("Successfully installed [A.name]."))
	return COMPONENT_AUGMENT_SUCCESS

/datum/component/augmentable/proc/remove_augment(datum/source, datum/augment/A, mob/user)
	if(!(A in installed_augments))
		return COMPONENT_AUGMENT_FAILED

	var/mob/living/carbon/human/H = parent
	if(!istype(H))
		return COMPONENT_AUGMENT_FAILED

	modify_max_stability(-A.stability_cost)

	installed_augments -= A
	A.parent = null
	A.on_remove(H)

	to_chat(user, span_notice("Removed [A.name]."))
	return COMPONENT_AUGMENT_SUCCESS

/datum/component/augmentable/proc/repair(datum/source, amount, mob/user)
	var/mob/living/carbon/human/H = parent
	if(!istype(H))
		return

	H.adjustBruteLoss(-amount)
	H.adjustFireLoss(-amount/2)

	modify_stability(amount/5, user)

	H.visible_message(
		span_notice("[user] repairs [H]'s damaged components."),
		span_notice("[user] repairs your damaged components.")
	)

	return COMPONENT_AUGMENT_SUCCESS

/datum/component/augmentable/proc/get_installed_augments(datum/source, list/installed)
	installed |= installed_augments

/datum/component/augmentable/proc/on_examined(mob/living/examined, mob/living/user, list/examine_list, list/P)
	if(!(user == examined || HAS_TRAIT(user, TRAIT_ENGINEERING_GOGGLES) || isobserver(user)))
		return
	LAZYADDASSOCLIST(examine_list, EXAMINE_SECT_WARNING, "Stability: [current_stability]/[max_stability]%")
	if(!length(installed_augments))
		return
	var/list/aug = list()
	for(var/datum/augment/A as anything in installed_augments)
		aug += " [A.enabled ? "[A.stability_cost < 0 ? "+" : ""][-A.stability_cost]%" : span_bold("FAIL")] — [span_bold(A.name)]"
	LAZYADDASSOCLIST(examine_list, EXAMINE_SECT_WARNING, aug.Join("\n"))

