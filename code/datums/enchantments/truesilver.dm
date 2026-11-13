#define TRUESILVER_UNAFFECTED 0
#define TRUESILVER_RESISTANT 1
#define TRUESILVER_AFFECTED 2
#define TRUESILVER_VULNERABLE 3
#define TRUESILVER_BANE_MAX_STACKS 6
#define TRUESILVER_BANE_COOLDOWN (4 SECONDS)

/datum/enchantment/truesilver
	enchantment_name = "Truesilver's light"
	examine_text = span_silver("Noc's light shines through it. The absolute bane of nitecreachers.")
	essence_recipe = list(
		/datum/thaumaturgical_essence/order = 150,
		/datum/thaumaturgical_essence/light = 75,
		/datum/thaumaturgical_essence/magic = 75
	)
	var/list/last_used = list()
	var/active_item = FALSE

/datum/enchantment/truesilver/register_triggers(atom/item)
	. = ..()
	registered_signals += COMSIG_ITEM_ATTACK
	RegisterSignal(item, COMSIG_ITEM_ATTACK, PROC_REF(on_hit))
	//registered_signals += COMSIG_ITEM_PICKUP
	//RegisterSignal(item, COMSIG_ITEM_PICKUP, PROC_REF(on_pickup))
	registered_signals += COMSIG_ITEM_EQUIPPED
	RegisterSignal(item, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equip))
	registered_signals += COMSIG_ITEM_DROPPED
	RegisterSignal(item, COMSIG_ITEM_DROPPED, PROC_REF(on_drop))

/datum/enchantment/truesilver/proc/on_drop(obj/item/i, mob/living/user)
	active_item = FALSE
	STOP_PROCESSING(SSenchantment, src)

/datum/enchantment/truesilver/proc/affected_by_bane(mob/target)
	if(!ishuman(target) || !target.mind || HAS_TRAIT(target, TRAIT_TRUESILVER_IMMUNE))
		return TRUESILVER_UNAFFECTED
	var/datum/antagonist/vampire/vamp_datum = target.mind.has_antag_datum(/datum/antagonist/vampire)
	var/datum/antagonist/werewolf/wolf_datum = IS_WEREWOLF(target)
	var/lesser_wolf = FALSE
	if(istype(wolf_datum, /datum/antagonist/werewolf/lesser))
		lesser_wolf = TRUE
	if(istype(vamp_datum, /datum/antagonist/vampire/lord))
		var/datum/antagonist/vampire/lord/lord_datum = vamp_datum
		if((lord_datum.ascension_resistance() == 1) || HAS_TRAIT(target, TRAIT_SILVER_IMMUNE))
			return TRUESILVER_RESISTANT
		else
			return TRUESILVER_AFFECTED

	if(!vamp_datum && !wolf_datum)
		return TRUESILVER_UNAFFECTED
	if(HAS_TRAIT(target, TRAIT_SILVER_IMMUNE))
		return TRUESILVER_RESISTANT
	if((lesser_wolf && wolf_datum?.transformed) || vamp_datum)
		return TRUESILVER_VULNERABLE
	if(wolf_datum?.transformed)
		return TRUESILVER_AFFECTED
	return TRUESILVER_UNAFFECTED

/datum/enchantment/truesilver/proc/on_hit(obj/item/source, mob/living/carbon/human/target, mob/living/carbon/human/user, proximity_flag, click_parameters)
	if(!user.CanReach(target))
		return
	if(!ishuman(target))
		return
	if(world.time < (src.last_used["ON-HIT"] + TRUESILVER_BANE_COOLDOWN))
		return
	if(!istype(source, /obj/item/weapon) || (istype(source, /obj/item/weapon/scabbard)))
		return

	var/affected = affected_by_bane(target)
	if(!affected)
		return

	var/datum/antagonist/vampire/vamp_datum = target.mind?.has_antag_datum(/datum/antagonist/vampire)

	to_chat(target, span_userdanger("I am struck by TRUESILVER!"))

	target.apply_status_effect(/datum/status_effect/debuff/truesilver_bane, null, affected)

	// Fire damage
	switch(affected)
		if(TRUESILVER_RESISTANT)
			target.adjustFireLoss(10)
		if(TRUESILVER_AFFECTED)
			target.adjustFireLoss(15)
			target.adjust_divine_fire_stacks(1)
		if(TRUESILVER_VULNERABLE)
			target.adjustFireLoss(20)
			target.adjust_divine_fire_stacks(3)

	if(vamp_datum && affected > TRUESILVER_RESISTANT)
		target.IgniteMob()
		if(SEND_SIGNAL(target, COMSIG_DISGUISE_STATUS))
			target.visible_message("<font color='white'>[target]'s curse manifests!</font>", ignored_mobs = list(target))

	last_used["ON-HIT"] = world.time
	return

/datum/enchantment/truesilver/proc/on_equip(obj/item/i, mob/living/carbon/human/user)
	apply_bane(i, user, FALSE)
	START_PROCESSING(SSenchantment, src)

/datum/enchantment/truesilver/proc/on_pickup(obj/item/i, mob/living/carbon/human/user)
	apply_bane(i, user, FALSE)
	START_PROCESSING(SSenchantment, src)

/datum/enchantment/truesilver/proc/apply_bane(obj/item/i, mob/living/carbon/human/user, pulse)
	if(pulse && (world.time < (last_used["PULSE"] + 10 SECONDS)))
		return FALSE
	var/affected = affected_by_bane(user)
	if(!affected)
		return FALSE

	if(check_curse_guard(i, user))
		affected = TRUESILVER_RESISTANT

	last_used["PULSE"] = world.time
	if(pulse)
		to_chat(user, span_userdanger("[enchanted_item] continues to affect me!"))
	else
		to_chat(user, span_userdanger("I have held TRUESILVER!"))
	user.apply_status_effect(/datum/status_effect/debuff/truesilver_bane, null, affected)
	switch(affected)
		if(TRUESILVER_RESISTANT)
			user.adjustFireLoss(20)
		if(TRUESILVER_VULNERABLE)
			user.adjustFireLoss(45)
			user.fire_act(2, 12)
		else
			user.adjustFireLoss(35)
			user.fire_act(1, 10)
	return TRUE

/datum/enchantment/truesilver/proc/apply_blessing(obj/item/i, mob/living/carbon/human/user)
	if(world.time < (last_used["BLESSING"] + 15 SECONDS))
		return FALSE
	var/affected = affected_by_bane(user)
	if(affected)
		return FALSE

	last_used["BLESSING"] = world.time
	user.apply_status_effect(/datum/status_effect/buff/truesilver_blessing)
	return TRUE

/datum/enchantment/truesilver/proc/on_bite(obj/item/i, mob/living/carbon/human/user)
	var/affected = affected_by_bane(user)
	if(!affected)
		return FALSE
	to_chat(user, span_userdanger("They wear TRUESILVER!"))
	user.apply_status_effect(/datum/status_effect/debuff/truesilver_bane, null, affected)
	switch(affected)
		if(TRUESILVER_RESISTANT)
			user.adjustFireLoss(10)
		if(TRUESILVER_AFFECTED)
			user.Paralyze(2 SECONDS)
			user.adjustFireLoss(10)
		if(TRUESILVER_VULNERABLE)
			user.Paralyze(3 SECONDS)
			user.adjustFireLoss(15)
			user.fire_act(1, 2)
	return TRUE

/datum/enchantment/truesilver/process(delta_time)
	if(!enchanted_item)
		STOP_PROCESSING(SSenchantment, src)
		return
	if(!active_item)
		STOP_PROCESSING(SSenchantment, src)
		return
	var/mob/living/carbon/human/victim = enchanted_item.loc
	if(!ishuman(victim))
		active_item = FALSE
		return
	if(apply_bane(enchanted_item, victim, TRUE))
		return
	apply_blessing(enchanted_item, victim)

/datum/status_effect/buff/truesilver_blessing
	id = "truesilver_blessing"
	alert_type = /atom/movable/screen/alert/status_effect/buff/truesilver_blessing
	duration = 17 SECONDS
	tick_interval = -1 // No ticking needed
	effectedstats = list(STAT_PERCEPTION = 1, STAT_INTELLIGENCE = 1)

/atom/movable/screen/alert/status_effect/buff/truesilver_blessing
	name = "Truesilver's Blessing"
	desc = "The blessing of such a divine metal."
	icon_state = "intelligence"

/datum/status_effect/debuff/truesilver_bane
	id = "truesilver_bane"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/truesilver_bane
	duration = 17 SECONDS
	tick_interval = -1 // No ticking needed
	effectedstats = list(STAT_STRENGTH = -2, STAT_PERCEPTION = -2, STAT_INTELLIGENCE = -2, STAT_CONSTITUTION = -2, STAT_ENDURANCE = -2, STAT_SPEED = -2, STAT_FORTUNE = -2)
	var/stacks = 0
	var/max_stacks = TRUESILVER_BANE_MAX_STACKS
	var/affected_type = TRUESILVER_AFFECTED // Will be set on application
	var/is_stunned = FALSE

/datum/status_effect/debuff/truesilver_bane/on_creation(mob/living/new_owner, duration_override, affected)
	affected_type = affected || TRUESILVER_AFFECTED
	update_stats()
	ADD_TRAIT(new_owner, TRAIT_COVEN_BANE, VAMPIRE_TRAIT)
	if(new_owner.clan)
		new_owner.clan.disable_covens(new_owner)
	. = ..()

/datum/status_effect/debuff/truesilver_bane/proc/update_stats()
	switch(affected_type)
		if(TRUESILVER_RESISTANT)
			effectedstats = list(STAT_STRENGTH = -1, STAT_PERCEPTION = -1, STAT_INTELLIGENCE = -1, STAT_CONSTITUTION = -1, STAT_ENDURANCE = -1, STAT_SPEED = -3, STAT_FORTUNE = -1)
		if(TRUESILVER_AFFECTED)
			effectedstats = list(STAT_STRENGTH = -2, STAT_PERCEPTION = -2, STAT_INTELLIGENCE = -2, STAT_CONSTITUTION = -2, STAT_ENDURANCE = -2, STAT_SPEED = -2, STAT_FORTUNE = -2)
		if(TRUESILVER_VULNERABLE)
			effectedstats = list(STAT_STRENGTH = -3, STAT_PERCEPTION = -3, STAT_INTELLIGENCE = -3, STAT_CONSTITUTION = -3, STAT_ENDURANCE = -3, STAT_SPEED = -3, STAT_FORTUNE = -3)


/datum/status_effect/debuff/truesilver_bane/on_apply()
	. = ..()
	stacks = 1
	update_alert()
	if(owner.stat != DEAD && IS_WEREWOLF(owner))
		var/mob/living/carbon/human/human = owner
		human.rage_datum.update_rage(-7)
	return TRUE

/datum/status_effect/debuff/truesilver_bane/on_remove()
	to_chat(owner, span_notice("The truesilver's overwhelming curse fades..."))
	REMOVE_TRAIT(owner, TRAIT_COVEN_BANE, VAMPIRE_TRAIT)
	. = ..()

/datum/status_effect/debuff/truesilver_bane/refresh(mob/living/new_owner, duration_override, new_affected_type)
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
	if(owner.stat != DEAD && IS_WEREWOLF(owner))
		var/mob/living/carbon/human/human = owner
		human.rage_datum.update_rage(-7)

/datum/status_effect/debuff/truesilver_bane/proc/trigger_stun()
	if(!owner || is_stunned)
		return

	is_stunned = TRUE
	to_chat(owner, span_userdanger("The truesilver's curse overwhelms me!"))

	switch(affected_type)
		if(TRUESILVER_RESISTANT)
			owner.Knockdown(30)
			owner.Stun(15)
		if(TRUESILVER_AFFECTED)
			owner.Knockdown(40)
			owner.Stun(20)
		if(TRUESILVER_VULNERABLE)
			owner.Immobilize(55)
			owner.Stun(27.5)

	update_alert()

	QDEL_IN(src, 10 SECONDS)

/datum/status_effect/debuff/truesilver_bane/proc/update_alert()
	if(!owner)
		return
	var/atom/movable/screen/alert/status_effect/debuff/truesilver_bane/alert = owner.alerts[id]
	if(istype(alert))
		alert.update_info(stacks, is_stunned)

/atom/movable/screen/alert/status_effect/debuff/truesilver_bane
	name = "Truesilver's Bane"
	desc = "My BANE!"
	icon_state = "silvercurse"

/atom/movable/screen/alert/status_effect/debuff/truesilver_bane/proc/update_info(stacks, is_stunned)
	if(is_stunned)
		name = "Truesilver's Curse - OVERWHELMED"
		desc = span_warning("I am overwhelmed by the truesilver's curse! I cannot move!")
	else
		name = "Truesilver's Bane ([stacks]/[TRUESILVER_BANE_MAX_STACKS])"
		desc = span_warning("I am cursed by truesilver. [TRUESILVER_BANE_MAX_STACKS - stacks] more contact[TRUESILVER_BANE_MAX_STACKS - stacks == 1 ? "" : "s"] will overwhelm me!")

#undef TRUESILVER_UNAFFECTED
#undef TRUESILVER_RESISTANT
#undef TRUESILVER_AFFECTED
#undef TRUESILVER_VULNERABLE
#undef TRUESILVER_BANE_MAX_STACKS
#undef TRUESILVER_BANE_COOLDOWN
