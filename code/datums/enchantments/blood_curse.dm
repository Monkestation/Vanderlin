#define BLOOD_CURSE_BENEFIT 0
#define BLOOD_CURSE_MINDLESS 1
#define BLOOD_CURSE_AFFECTED 2
#define BLOOD_CURSE_MAX_STACKS 6
#define BLOOD_CURSE_COOLDOWN (3 SECONDS)


/datum/enchantment/bloodcurse
	enchantment_name = "Blood Curse"
	examine_text = span_bloody("Dark power clings to it, radiating the cloying smell of blood.")
	essence_recipe = list(
		/datum/thaumaturgical_essence/life = 25,
		/datum/thaumaturgical_essence/chaos = 15
	)
	var/list/last_used = list()

	// Volumes of poison added by the curse.
	var/poison_hit = 1.5
	var/poison_pickup = 5
	var/poison_equip = 7.5

/datum/enchantment/bloodcurse/register_triggers(atom/item)
	. = ..()
	registered_signals += COMSIG_ITEM_ATTACK
	RegisterSignal(item, COMSIG_ITEM_ATTACK, PROC_REF(on_hit))
	//registered_signals += COMSIG_ITEM_PICKUP
	//RegisterSignal(item, COMSIG_ITEM_PICKUP, PROC_REF(on_pickup))
	registered_signals += COMSIG_ITEM_EQUIPPED
	RegisterSignal(item, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equip))

/datum/enchantment/bloodcurse/proc/get_curse_effect(mob/target)
	if(HAS_TRAIT(target, TRAIT_VITAE_USER))
		return BLOOD_CURSE_BENEFIT
	if(!ishuman(target) || !target.mind)
		return BLOOD_CURSE_MINDLESS
	return BLOOD_CURSE_AFFECTED

/datum/enchantment/bloodcurse/proc/on_hit(obj/item/source, mob/living/carbon/human/target, mob/living/carbon/human/user, proximity_flag, click_parameters)
	if(!user.CanReach(target))
		return
	if(!ishuman(target) || target.stat >= HARD_CRIT)
		return
	if(world.time < (src.last_used[source] + BLOOD_CURSE_COOLDOWN))
		return
	if(!istype(source, /obj/item/weapon) || (istype(source, /obj/item/weapon/scabbard)))
		return

	var/curse_effect = get_curse_effect(target)
	if(!curse_effect || get_curse_effect(user))
		return
	var/vitae_gain = 0

	switch(curse_effect)
		if(BLOOD_CURSE_MINDLESS, BLOOD_CURSE_AFFECTED)
			to_chat(target, span_userdanger("My blood boils as my strength is sapped!"))
			target.apply_status_effect(/datum/status_effect/debuff/blood_curse, null, curse_effect)
			vitae_gain += 1
		if(BLOOD_CURSE_AFFECTED)
			target.reagents.add_reagent(/datum/reagent/poison/hexblood_poison, poison_hit)
			target.reagents.add_reagent(/datum/reagent/poison/bloodstone_essence, poison_hit)
			to_chat(user, span_bloody("[target] is poisoned by the blood curse."))
			vitae_gain += 2

	user.adjust_bloodpool(vitae_gain)
	last_used[source] = world.time
	return

/datum/enchantment/bloodcurse/proc/on_equip(obj/item/cursed_item, mob/living/carbon/human/user)
	var/curse_effect = get_curse_effect(user)
	if(!curse_effect || user.stat >= HARD_CRIT)
		return
	to_chat(user, span_userdanger("I'm holding a curse! My blood is boiling, I feel so weak!"))
	user.apply_status_effect(/datum/status_effect/debuff/blood_curse, null, curse_effect)
	if(curse_effect == BLOOD_CURSE_AFFECTED)
		user.reagents.add_reagent(/datum/reagent/poison/bloodstone_essence, poison_equip)

/datum/enchantment/bloodcurse/proc/on_pickup(obj/item/cursed_item, mob/living/carbon/human/user)
	var/curse_effect = get_curse_effect(user)
	if(!curse_effect || user.stat >= HARD_CRIT)
		return
	to_chat(user, span_userdanger("I'm holding a curse! My blood is boiling, I feel so weak!"))
	user.apply_status_effect(/datum/status_effect/debuff/blood_curse, null, curse_effect)
	if(curse_effect == BLOOD_CURSE_AFFECTED)
		user.reagents.add_reagent(/datum/reagent/poison/bloodstone_essence, poison_pickup)

/datum/status_effect/debuff/blood_curse
	id = "blood_curse"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/blood_curse
	duration = 15 SECONDS
	tick_interval = -1 // No ticking needed
	effectedstats = list(STAT_STRENGTH = -2, STAT_CONSTITUTION = -2, STAT_ENDURANCE = -2, STAT_SPEED = -2)
	var/stacks = 0
	var/max_stacks = BLOOD_CURSE_MAX_STACKS
	var/curse_type = BLOOD_CURSE_AFFECTED // Will be set on application
	var/is_stunned = FALSE

/datum/status_effect/debuff/blood_curse/on_creation(mob/living/new_owner, duration_override, curse_effect)
	curse_type = curse_effect || BLOOD_CURSE_AFFECTED
	. = ..()

/datum/status_effect/debuff/blood_curse/on_apply()
	. = ..()
	stacks = 1
	update_alert()
	return TRUE

/datum/status_effect/debuff/blood_curse/on_remove()
	to_chat(owner, span_notice("The blood curse fades..."))
	. = ..()

/datum/status_effect/debuff/blood_curse/refresh(mob/living/new_owner, duration_override, new_affected_type)
	// Don't stack if already stunned
	if(is_stunned)
		duration = initial(duration)
		return

	// Increment stacks
	stacks = min(stacks + 1, max_stacks)
	duration = initial(duration)

	// Check if we hit max stacks
	if(stacks >= max_stacks && !is_stunned)
		trigger_stun()
	else
		update_alert()

/datum/status_effect/debuff/blood_curse/proc/trigger_stun()
	if(!owner || is_stunned)
		return

	is_stunned = TRUE
	to_chat(owner, span_userdanger("The blood curse overwhelms me!"))

	if(curse_type == BLOOD_CURSE_MINDLESS)
		// Mindless mobs have lighter consequences.
		owner.Knockdown(30)
		owner.Stun(15)
	else
		// Normal creatures get full punishment
		owner.Immobilize(45)
		owner.Stun(22.5)

	update_alert()

	QDEL_IN(src, 8 SECONDS)

/datum/status_effect/debuff/blood_curse/proc/update_alert()
	if(!owner)
		return
	var/atom/movable/screen/alert/status_effect/debuff/blood_curse/alert = owner.alerts[id]
	if(istype(alert))
		alert.update_info(stacks, max_stacks, is_stunned)

/atom/movable/screen/alert/status_effect/debuff/blood_curse
	name = "Blood Curse"
	desc = "My blood is boiling!"
	icon_state = "bloodcurse"

/atom/movable/screen/alert/status_effect/debuff/blood_curse/proc/update_info(stacks, max_stacks, is_stunned)
	if(is_stunned)
		name = "Blood Curse - OVERWHELMEING"
		desc = span_warning("I am overwhelmed by the power of the Blood Curse! I cannot move!")
	else
		name = "Blood Curse ([stacks]/[max_stacks])"
		desc = span_warning("I am blood cursed. [max_stacks - stacks] more contact[max_stacks - stacks == 1 ? "" : "s"] will overwhelm me!")

#undef BLOOD_CURSE_BENEFIT
#undef BLOOD_CURSE_MINDLESS
#undef BLOOD_CURSE_AFFECTED
#undef BLOOD_CURSE_MAX_STACKS
#undef BLOOD_CURSE_COOLDOWN
