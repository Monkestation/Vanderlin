/datum/component/augmentable
	var/max_stability = 100
	var/current_stability = 100
	var/min_stability = 0
	var/list/installed_augments = list()
	var/brute_mod_per_stability = 0.005 // 0.5% increased brute damage per point below max
	var/limb_explosion_threshold = 20
	var/limb_explosion_chance = 5

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
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examined))

/datum/component/augmentable/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_AUGMENT_INSTALL)
	UnregisterSignal(parent, COMSIG_AUGMENT_REMOVE)
	UnregisterSignal(parent, COMSIG_AUGMENT_REPAIR)
	UnregisterSignal(parent, COMSIG_AUGMENT_GET_STABILITY)
	UnregisterSignal(parent, COMSIG_AUGMENT_GET_INSTALLED)
	UnregisterSignal(parent, COMSIG_PARENT_EXAMINE)


/datum/component/augmentable/proc/get_brute_modifier()
	var/stability_loss = max_stability - current_stability
	return 1 + (stability_loss * brute_mod_per_stability)

/datum/component/augmentable/proc/modify_stability(amount, mob/user)
	current_stability = clamp(current_stability + amount, min_stability, max_stability)

	var/mob/parent_mob = parent
	if(amount > 0)
		parent_mob.say("CORE STABILITY INCREASED: [current_stability]%.", forced = TRUE)
	else
		parent_mob.say("CORE STABILITY DECREASED: [current_stability]%.", forced = TRUE)

	update_stability_effects()

/datum/component/augmentable/proc/modify_max_stability(amount)
	max_stability += amount
	modify_stability(amount)

/datum/component/augmentable/proc/update_stability_effects()
	var/mob/living/carbon/human/H = parent
	if(!istype(H))
		return

	if(H.dna?.species)
		var/modifier = get_brute_modifier()
		H.physiology.brute_mod = modifier

/datum/component/augmentable/process()
	if(current_stability <= limb_explosion_threshold)
		check_catastrophic_failure()

/datum/component/augmentable/proc/check_catastrophic_failure()
	var/mob/living/carbon/human/H = parent
	if(!istype(H))
		return

	if(current_stability <= 0)
		catastrophic_failure(H)
		return

	if(prob(limb_explosion_chance))
		explode_random_limb(H)

/datum/component/augmentable/proc/explode_random_limb(mob/living/carbon/human/H)
	var/list/valid_limbs = list()
	for(var/obj/item/bodypart/BP in H.bodyparts)
		if(BP.body_zone != BODY_ZONE_CHEST && BP.body_zone != BODY_ZONE_HEAD)
			valid_limbs += BP

	if(!valid_limbs.len)
		return

	var/obj/item/bodypart/chosen = pick(valid_limbs)
	H.visible_message(
		span_danger("[H]'s [chosen] suddenly explodes in a shower of sparks and debris!"),
		span_userdanger("Your [chosen] catastrophically fails and explodes!")
	)

	playsound(H, 'sound/misc/explode/explosion.ogg', 75, TRUE)
	var/datum/effect_system/spark_spread/S = new()
	S.set_up(3, 1, H.loc)
	S.start()

	chosen.dismember()
	modify_stability(-10)

/datum/component/augmentable/proc/catastrophic_failure(mob/living/carbon/human/H)
	H.visible_message(
		span_danger("[H]'s entire frame shudders violently before exploding into a catastrophic shower of metal and steam!"),
		span_userdanger("CRITICAL FAILURE - SYSTEM MELTDOWN!")
	)

	playsound(H, 'sound/misc/explode/explosion.ogg', 100, TRUE)

	for(var/obj/item/bodypart/BP in H.bodyparts)
		if(BP.body_zone != BODY_ZONE_CHEST && BP.body_zone != BODY_ZONE_HEAD)
			BP.dismember()

	var/datum/effect_system/spark_spread/S = new()
	S.set_up(5, 1, H.loc)
	S.start()

	H.adjustFireLoss(50)
	H.Unconscious(100)

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
		aug += " [A.stability_cost < 0 ? "+" : ""][-A.stability_cost]% — [span_bold(A.name)]"
	LAZYADDASSOCLIST(examine_list, EXAMINE_SECT_WARNING, aug.Join("\n"))

