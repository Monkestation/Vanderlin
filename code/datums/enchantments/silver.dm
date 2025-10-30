#define AFFECTED_VLORD 1
#define AFFECTED 2

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
	registered_signals += COMSIG_ITEM_AFTERATTACK
	RegisterSignal(item, COMSIG_ITEM_AFTERATTACK, PROC_REF(on_hit))
	registered_signals += COMSIG_ITEM_PICKUP
	RegisterSignal(item, COMSIG_ITEM_PICKUP, PROC_REF(on_pickup))
	registered_signals += COMSIG_ITEM_EQUIPPED
	RegisterSignal(item, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equip))

/datum/enchantment/silver/proc/affected_by_bane(mob/target)
	if(!ishuman(target) || !target.mind)
		return UNAFFECTED

	var/datum/antagonist/vampire/vamp_datum = target.mind.has_antag_datum(/datum/antagonist/vampire)
	var/datum/antagonist/werewolf/wolf_datum = target.mind.has_antag_datum(/datum/antagonist/werewolf)

	if(istype(vamp_datum, /datum/antagonist/vampire/lord))
		var/datum/antagonist/vampire/lord/lord_datum = vamp_datum
		return (!lord_datum.ascended) ? AFFECTED_VLORD : UNAFFECTED

	if(!vamp_datum && !wolf_datum)
		return UNAFFECTED

	if(wolf_datum?.transformed == TRUE || vamp_datum)
		return AFFECTED
	return UNAFFECTED

/datum/enchantment/silver/proc/on_hit(obj/item/source, mob/living/carbon/human/target, mob/living/carbon/human/user, proximity_flag, click_parameters)
	if(!proximity_flag)
		return
	if(!ishuman(target))
		return
	if(world.time < (src.last_used[source] + (1 MINUTES + 40 SECONDS))) //thanks borbop
		return
	if(!istype(source, /obj/item/weapon) || (istype(source, /obj/item/weapon/scabbard)))
		return
	var/affected = affected_by_bane(target)
	var/datum/antagonist/vampire/vamp_datum = target.mind?.has_antag_datum(/datum/antagonist/vampire)
	var/datum/antagonist/werewolf/wolf_datum = target.mind?.has_antag_datum(/datum/antagonist/werewolf)

	///Normal check for the vampire and werewolves
	if(affected)
		to_chat(target, span_userdanger("I am struck by my BANE!"))
		if(target.clan)
			target.rollfrenzy()
			ADD_TRAIT(target, TRAIT_COVEN_BANE, VAMPIRE_TRAIT)
			addtimer(TRAIT_CALLBACK_REMOVE(target, TRAIT_COVEN_BANE, VAMPIRE_TRAIT), 30 SECONDS)
			target.clan.disable_covens(target)
		else
			target.Immobilize(15)
			target.Stun(7.5)
		target.adjustFireLoss(25)
		target.adjust_divine_fire_stacks(3)
		target.IgniteMob()
		if(wolf_datum)
			target.apply_status_effect(/datum/status_effect/debuff/silver_curse)
		if(vamp_datum && affected != AFFECTED_VLORD)
			target.apply_status_effect(/datum/status_effect/debuff/silver_curse)
			if(SEND_SIGNAL(target, COMSIG_DISGUISE_STATUS))
				target.visible_message("<font color='white'>[target]'s curse manifests!</font>", ignored_mobs = list(target))
		last_used[source] = world.time
		return


/datum/enchantment/silver/proc/on_equip(obj/item/i, mob/living/carbon/human/user)
	var/affected = affected_by_bane(user)
	if(!affected)
		return

	to_chat(user, span_userdanger("I have worn my BANE!"))
	user.Knockdown(10)
	user.Paralyze(10)

	if(affected != AFFECTED_VLORD)
		user.adjustFireLoss(25)
		user.fire_act(1, 10)

/datum/enchantment/silver/proc/on_pickup(obj/item/i, mob/living/carbon/human/user)
	var/affected = affected_by_bane(user)
	if(!affected)
		return

	to_chat(user, span_userdanger("I have held my BANE!"))
	user.Knockdown(10)
	user.Paralyze(10)

	if(affected != AFFECTED_VLORD)
		user.adjustFireLoss(25)
		user.fire_act(1, 10)

#undef AFFECTED
#undef AFFECTED_VLORD
