#define BLOOD_CURSE_PULSE 15 SECONDS
#define BLOOD_CURSE_DURATION BLOOD_CURSE_PULSE + 2 SECONDS

#define BLOOD_CURSE_HARMLESS 0
#define BLOOD_CURSE_STUDENT 1
#define BLOOD_CURSE_WEAKENED 2
#define BLOOD_CURSE_GLOVED 3
#define BLOOD_CURSE_TOXIC 4

#define BLOOD_CURSE_MAX_STACKS 6
#define BLOOD_CURSE_HIT_COOLDOWN (5 SECONDS)


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
	/// Repeat application on curse pulse.
	var/poison_pulse = 3.5
	var/active_item = FALSE

/datum/enchantment/bloodcurse/register_triggers(atom/item)
	. = ..()
	registered_signals += COMSIG_ITEM_ATTACK
	RegisterSignal(item, COMSIG_ITEM_ATTACK, PROC_REF(on_hit))
	//registered_signals += COMSIG_ITEM_PICKUP
	//RegisterSignal(item, COMSIG_ITEM_PICKUP, PROC_REF(on_pickup))
	registered_signals += COMSIG_ITEM_EQUIPPED
	RegisterSignal(item, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equip))
	registered_signals += COMSIG_ITEM_DROPPED
	RegisterSignal(item, COMSIG_ITEM_DROPPED, PROC_REF(on_drop))

/datum/enchantment/bloodcurse/proc/on_drop(obj/item/i, mob/living/user)
	if(active_item)
		active_item = FALSE
	STOP_PROCESSING(SSenchantment, src)

/datum/enchantment/bloodcurse/proc/get_curse_effect(mob/living/carbon/human/target)
	if(HAS_TRAIT(target, TRAIT_VITAE_USER) || target.has_status_effect(/datum/status_effect/buff/blood_mark/curse_shield))
		return BLOOD_CURSE_HARMLESS
	if(HAS_TRAIT(target, TRAIT_BLOOD_STUDENT))
		return BLOOD_CURSE_STUDENT
	if(!ishuman(target))
		return BLOOD_CURSE_WEAKENED
	return BLOOD_CURSE_TOXIC

/datum/enchantment/bloodcurse/proc/on_hit(obj/item/source, mob/living/carbon/human/target, mob/living/carbon/human/user, proximity_flag, click_parameters)
	if(!user.CanReach(target))
		return
	if(!ishuman(target) || target.stat >= HARD_CRIT)
		return
	if(world.time < (src.last_used["ON_HIT"] + BLOOD_CURSE_HIT_COOLDOWN))
		return
	if(!istype(source, /obj/item/weapon) || (istype(source, /obj/item/weapon/scabbard)))
		return

	var/curse_effect = get_curse_effect(source, target)
	if(!curse_effect || get_curse_effect(source, user) >= BLOOD_CURSE_WEAKENED)
		return
	var/vitae_gain = 0

	switch(curse_effect)
		if(BLOOD_CURSE_STUDENT)
			to_chat(target, span_userdanger("My strength is sapped by the blood curse!"))
			to_chat(target, span_bloody("My training helps resist some of the curse's effects."))
			target.apply_status_effect(/datum/status_effect/debuff/blood_curse_lesser, null, curse_effect)
			vitae_gain += 1
		if(BLOOD_CURSE_WEAKENED, BLOOD_CURSE_TOXIC)
			to_chat(target, span_userdanger("My strength is sapped by the blood curse!"))
			target.apply_status_effect(/datum/status_effect/debuff/blood_curse, null, curse_effect)
			vitae_gain += 1
		if(BLOOD_CURSE_TOXIC)
			to_chat(target, span_userdanger("The curse is seeping into my blood! It burns!"))
			target.reagents.add_reagent(/datum/reagent/poison/hexblood_poison, poison_hit)
			target.reagents.add_reagent(/datum/reagent/poison/bloodstone_essence, poison_hit)
			to_chat(user, span_bloody("[target] is poisoned by the blood curse."))
			if(target.mind)
				vitae_gain += 2

	user.adjust_bloodpool(vitae_gain)
	last_used["ON_HIT"] = world.time
	last_used["PULSE"] = (world.time + BLOOD_CURSE_PULSE)
	return

/datum/enchantment/bloodcurse/proc/on_equip(obj/item/cursed_item, mob/living/carbon/human/user)
	active_item = TRUE
	var/curse_effect = get_curse_effect(user)
	if(!curse_effect || user.stat >= HARD_CRIT)
		return

	if(check_curse_guard(cursed_item, user))
		curse_effect = BLOOD_CURSE_GLOVED

	last_used["PULSE"] = world.time
	switch(curse_effect)
		if(BLOOD_CURSE_STUDENT)
			to_chat(user, span_userdanger("My strength is sapped by the blood curse."))
			to_chat(user, span_bloody("My training helps resist some of the curse's effects."))
			user.apply_status_effect(/datum/status_effect/debuff/blood_curse_lesser, null, curse_effect)
		if(BLOOD_CURSE_WEAKENED, BLOOD_CURSE_GLOVED)
			to_chat(user, span_userdanger("I feel weak holding this."))
			user.apply_status_effect(/datum/status_effect/debuff/blood_curse, null, curse_effect)
		if(BLOOD_CURSE_TOXIC)
			to_chat(user, span_userdanger("The curse is seeping into my blood! It burns!"))
			user.apply_status_effect(/datum/status_effect/debuff/blood_curse, null, curse_effect)
			user.reagents.add_reagent(/datum/reagent/poison/bloodstone_essence, poison_equip)
	START_PROCESSING(SSenchantment, src)

/*
/datum/enchantment/bloodcurse/proc/on_pickup(obj/item/cursed_item, mob/living/carbon/human/user)
	active_item = TRUE
	var/curse_effect = get_curse_effect(user)
	if(!curse_effect || user.stat >= HARD_CRIT)
		return

	if(check_curse_guard(cursed_item, user))
		curse_effect = BLOOD_CURSE_GLOVED

	last_used["PULSE"] = world.time
	switch(curse_effect)
		if(BLOOD_CURSE_STUDENT)
			to_chat(user, span_userdanger("My strength is sapped by the blood curse."))
			to_chat(user, span_bloody("My training helps resist some of the curse's effects."))
			user.apply_status_effect(/datum/status_effect/debuff/blood_curse_lesser, null, curse_effect)
		if(BLOOD_CURSE_WEAKENED, BLOOD_CURSE_GLOVED)
			to_chat(user, span_userdanger("I feel weak holding this."))
			user.apply_status_effect(/datum/status_effect/debuff/blood_curse, null, curse_effect)
		if(BLOOD_CURSE_TOXIC)
			to_chat(user, span_userdanger("The curse is seeping into my blood! It burns!"))
			user.apply_status_effect(/datum/status_effect/debuff/blood_curse, null, curse_effect)
			user.reagents.add_reagent(/datum/reagent/poison/bloodstone_essence, poison_pickup)
	START_PROCESSING(SSenchantment, src)
*/

/datum/enchantment/bloodcurse/proc/curse_pulse(mob/living/carbon/human/victim)
	if(!active_item)
		return
	if(world.time < (last_used["PULSE"] + BLOOD_CURSE_PULSE))
		return
	var/curse_effect = get_curse_effect(victim)
	if(!curse_effect || victim.stat >= HARD_CRIT)
		last_used["PULSE"] = world.time
		return

	if(check_curse_guard(enchanted_item, victim))
		curse_effect = BLOOD_CURSE_GLOVED

	to_chat(victim, span_userdanger("[enchanted_item] blazes with power. The Blood Curse pulses once more."))
	switch(curse_effect)
		if(BLOOD_CURSE_STUDENT)
			to_chat(victim, span_bloody("My training helps resist some of the curse's effects."))
			victim.apply_status_effect(/datum/status_effect/debuff/blood_curse_lesser, null, curse_effect)
		if(BLOOD_CURSE_WEAKENED, BLOOD_CURSE_GLOVED)
			victim.apply_status_effect(/datum/status_effect/debuff/blood_curse, null, curse_effect)
		if(BLOOD_CURSE_TOXIC)
			victim.apply_status_effect(/datum/status_effect/debuff/blood_curse, null, curse_effect)
			victim.reagents.add_reagent(/datum/reagent/poison/bloodstone_essence, poison_pulse)
	last_used["PULSE"] = world.time

/datum/enchantment/bloodcurse/process(delta_time)
	if(!enchanted_item)
		STOP_PROCESSING(SSenchantment, src)
		return
	if(!active_item)
		return
	var/mob/living/carbon/human/victim = enchanted_item.loc
	if(!ishuman(victim))
		active_item = FALSE
		return
	curse_pulse(victim)

/datum/status_effect/debuff/blood_curse
	id = "blood_curse"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/blood_curse
	duration = BLOOD_CURSE_DURATION
	tick_interval = -1 // No ticking needed
	effectedstats = list(STAT_STRENGTH = -2, STAT_CONSTITUTION = -2, STAT_ENDURANCE = -2, STAT_SPEED = -2)
	var/stacks = 0
	var/max_stacks = BLOOD_CURSE_MAX_STACKS
	var/curse_type = BLOOD_CURSE_TOXIC // Will be set on application
	var/is_stunned = FALSE

/datum/status_effect/debuff/blood_curse/on_creation(mob/living/new_owner, duration_override, curse_effect)
	curse_type = curse_effect || BLOOD_CURSE_TOXIC
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

	if(curse_type == BLOOD_CURSE_WEAKENED)
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
	desc = "My strength is being sapped by the Blood Curse!"
	icon_state = "bloodcurse"

/atom/movable/screen/alert/status_effect/debuff/blood_curse/proc/update_info(stacks, max_stacks, is_stunned)
	if(is_stunned)
		name = "Blood Curse - OVERWHELMEING"
		desc = span_warning("I am overwhelmed by the power of the Blood Curse! I cannot move!")
	else
		name = "Blood Curse ([stacks]/[max_stacks])"
		desc = span_warning("I am blood cursed. [max_stacks - stacks] more contact[max_stacks - stacks == 1 ? "" : "s"] will overwhelm me!")

/datum/status_effect/debuff/blood_curse_lesser
	id = "blood_curse_lesser"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/blood_curse_lesser
	duration = 15 SECONDS
	tick_interval = -1 // No ticking needed
	effectedstats = list(STAT_STRENGTH = -1, STAT_CONSTITUTION = -1, STAT_ENDURANCE = -1, STAT_SPEED = -1)

/atom/movable/screen/alert/status_effect/debuff/blood_curse_lesser
	name = "Lesser Blood Curse"
	desc = "My strength is being sapped by the Blood Curse!"
	icon_state = "bloodcurse"


#undef BLOOD_CURSE_HARMLESS
#undef BLOOD_CURSE_STUDENT
#undef BLOOD_CURSE_WEAKENED
#undef BLOOD_CURSE_GLOVED
#undef BLOOD_CURSE_TOXIC

#undef BLOOD_CURSE_MAX_STACKS
#undef BLOOD_CURSE_HIT_COOLDOWN

#undef BLOOD_CURSE_PULSE
#undef BLOOD_CURSE_DURATION
