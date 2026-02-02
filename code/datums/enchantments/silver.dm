#define AFFECTED_VLORD 1
#define AFFECTED 2
#define SILVER_BANE_MAX_STACKS 6
#define SILVER_BANE_COOLDOWN (5 SECONDS)

/datum/enchantment/silver
	enchantment_name = "Nightlurkers Bane"
	examine_text = span_silver("It's a bane to all who lurk at night.")
	essence_recipe = list(
		/datum/thaumaturgical_essence/order = 25,
		/datum/thaumaturgical_essence/light = 15
	)
	var/list/last_used = list()

/datum/enchantment/silver/register_triggers(atom/item)
	. = ..()
	registered_signals += COMSIG_ITEM_ATTACK
	RegisterSignal(item, COMSIG_ITEM_ATTACK, PROC_REF(on_hit))
	registered_signals += COMSIG_ITEM_PICKUP
	RegisterSignal(item, COMSIG_ITEM_PICKUP, PROC_REF(on_pickup))
	registered_signals += COMSIG_ITEM_EQUIPPED
	RegisterSignal(item, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equip))

/datum/enchantment/silver/proc/affected_by_bane(mob/target)
	if(!ishuman(target) || !target.mind)
		return UNAFFECTED
	var/datum/antagonist/vampire/vamp_datum = target.mind.has_antag_datum(/datum/antagonist/vampire)
	var/datum/antagonist/werewolf/wolf_datum = IS_WEREWOLF(target)
	if(istype(vamp_datum, /datum/antagonist/vampire/lord))
		var/datum/antagonist/vampire/lord/lord_datum = vamp_datum
		return (!lord_datum.ascended) ? AFFECTED_VLORD : UNAFFECTED
	if(!vamp_datum && !wolf_datum)
		return UNAFFECTED
	if(wolf_datum?.transformed || vamp_datum)
		return AFFECTED
	return UNAFFECTED

/datum/enchantment/silver/proc/on_hit(obj/item/source, mob/living/carbon/human/target, mob/living/carbon/human/user, proximity_flag, click_parameters)
	if(!user.CanReach(target))
		return
	if(!ishuman(target))
		return
	if(world.time < (src.last_used[source] + SILVER_BANE_COOLDOWN))
		return
	if(!istype(source, /obj/item/weapon) || (istype(source, /obj/item/weapon/scabbard)))
		return

	var/affected = affected_by_bane(target)
	if(!affected)
		return

	var/datum/antagonist/vampire/vamp_datum = target.mind?.has_antag_datum(/datum/antagonist/vampire)

	to_chat(target, span_userdanger("I am struck by my BANE!"))

	target.apply_status_effect(/datum/status_effect/debuff/silver_bane, null, affected)

	// Fire damage
	target.adjustFireLoss(10)
	target.adjust_divine_fire_stacks(1)
	target.IgniteMob()

	if(vamp_datum && affected != AFFECTED_VLORD)
		if(SEND_SIGNAL(target, COMSIG_DISGUISE_STATUS))
			target.visible_message("<font color='white'>[target]'s curse manifests!</font>", ignored_mobs = list(target))

	last_used[source] = world.time
	return

/datum/enchantment/silver/proc/on_equip(obj/item/i, mob/living/carbon/human/user)
	var/affected = affected_by_bane(user)
	if(!affected)
		return
	to_chat(user, span_userdanger("I have worn my BANE!"))
	user.apply_status_effect(/datum/status_effect/debuff/silver_bane, null, affected)
	if(affected != AFFECTED_VLORD)
		user.adjustFireLoss(25)
		user.fire_act(1, 10)

/datum/enchantment/silver/proc/on_pickup(obj/item/i, mob/living/carbon/human/user)
	var/affected = affected_by_bane(user)
	if(!affected)
		return
	to_chat(user, span_userdanger("I have held my BANE!"))
	user.apply_status_effect(/datum/status_effect/debuff/silver_bane, null, affected)
	if(affected != AFFECTED_VLORD)
		user.adjustFireLoss(25)
		user.fire_act(1, 10)

/datum/status_effect/debuff/silver_bane
	id = "silver_bane"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/silver_bane
	duration = 30 SECONDS
	tick_interval = -1 // No ticking needed
	effectedstats = list(STATKEY_STR = -2, STATKEY_PER = -2, STATKEY_INT = -2, STATKEY_CON = -2, STATKEY_END = -2, STATKEY_SPD = -2, STATKEY_LCK = -2)
	var/stacks = 0
	var/max_stacks = SILVER_BANE_MAX_STACKS
	var/affected_type = AFFECTED // Will be set on application
	var/is_stunned = FALSE

/datum/status_effect/debuff/silver_bane/on_creation(mob/living/new_owner, duration_override, affected)
	affected_type = affected || AFFECTED
	ADD_TRAIT(new_owner, TRAIT_COVEN_BANE, VAMPIRE_TRAIT)
	if(new_owner.clan)
		new_owner.clan.disable_covens(new_owner)
	. = ..()

/datum/status_effect/debuff/silver_bane/on_apply()
	. = ..()
	stacks = 1
	update_alert()
	if(owner.stat != DEAD && IS_WEREWOLF(owner))
		var/mob/living/carbon/human/human = owner
		human.rage_datum.update_rage(-5)
	return TRUE

/datum/status_effect/debuff/silver_bane/on_remove()
	REMOVE_TRAIT(owner, TRAIT_COVEN_BANE, VAMPIRE_TRAIT)
	. = ..()

/datum/status_effect/debuff/silver_bane/refresh(mob/living/new_owner, duration_override, new_affected_type)
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
		human.rage_datum.update_rage(-5)

/datum/status_effect/debuff/silver_bane/proc/trigger_stun()
	if(!owner || is_stunned)
		return

	is_stunned = TRUE
	to_chat(owner, span_userdanger("The silver's curse overwhelms me!"))

	if(affected_type == AFFECTED_VLORD)
		// Vampire lords get lighter punishment
		owner.Knockdown(30)
		owner.Paralyze(15)
	else
		// Normal creatures get full punishment
		owner.Immobilize(45)
		owner.Stun(22.5)

	update_alert()

	addtimer(CALLBACK(src, PROC_REF(end_stun)), 8 SECONDS)

/datum/status_effect/debuff/silver_bane/proc/end_stun()
	if(!owner)
		qdel(src)
		return

	to_chat(owner, span_notice("The silver's overwhelming curse fades..."))
	qdel(src)

/datum/status_effect/debuff/silver_bane/proc/update_alert()
	if(!owner)
		return
	var/atom/movable/screen/alert/status_effect/debuff/silver_bane/alert = owner.alerts[id]
	if(istype(alert))
		alert.update_info(stacks, is_stunned)

/atom/movable/screen/alert/status_effect/debuff/silver_bane
	name = "Silver's Bane"
	desc = "My BANE!"
	icon_state = "hunger4"

/atom/movable/screen/alert/status_effect/debuff/silver_bane/proc/update_info(stacks, is_stunned)
	if(is_stunned)
		name = "Silver's Curse - OVERWHELMED"
		desc = span_warning("I am overwhelmed by the silver's curse! I cannot move!")
	else
		name = "Silver's Bane ([stacks]/[SILVER_BANE_MAX_STACKS])"
		desc = span_warning("I am cursed by silver. [SILVER_BANE_MAX_STACKS - stacks] more contact[SILVER_BANE_MAX_STACKS - stacks == 1 ? "" : "s"] will overwhelm me!")

#undef AFFECTED
#undef AFFECTED_VLORD
#undef SILVER_BANE_MAX_STACKS
#undef SILVER_BANE_COOLDOWN
