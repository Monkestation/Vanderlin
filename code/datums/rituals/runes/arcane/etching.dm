/obj/effect/decal/cleanable/ritual_rune/arcyne/focus_etch
	name = "arcyne etching seal"
	desc = "A sigil of inscription. Place a blank focus and invoke to etch one of your known spells into it."
	icon = 'icons/effects/160x160.dmi'
	icon_state = "imbuement"
	tier = 1
	runesize = 2
	SET_BASE_PIXEL(-64, -64)
	pixel_z = 0
	invocation = "Ven'sha kael imn'dorath!"
	can_be_scribed = TRUE
	color = "#3BBE5A"

	/// The blank focus staged on this rune
	var/obj/item/spell_focus/staged_focus = null
	/// How many charges to etch in
	var/chosen_charges = 1
	/// The spell type chosen at invoke time
	var/datum/action/cooldown/spell/chosen_spell_type = null
	/// TRUE while animating
	var/animating = FALSE

/obj/effect/decal/cleanable/ritual_rune/arcyne/focus_etch/attack_hand(mob/living/user)
	if(animating)
		to_chat(user, span_notice("The seal is already working..."))
		return
	if(!user.get_active_held_item())
		if(staged_focus)
			try_invoke(user)
		else
			to_chat(user, span_hierophant_warning("Place a blank arcyne focus on the seal first."))
		return

/obj/effect/decal/cleanable/ritual_rune/arcyne/focus_etch/attackby(obj/item/W, mob/user, list/modifiers)
	if(animating)
		to_chat(user, span_notice("The seal is already working..."))
		return
	if(istype(W, /obj/item/spell_focus))
		var/obj/item/spell_focus/focus = W
		if(focus.stored_spell_type)
			to_chat(user, span_warning("That focus is already etched with [focus.stored_spell_name]."))
			return
		if(staged_focus)
			to_chat(user, span_notice("A focus is already placed here."))
			return
		user.temporarilyRemoveItemFromInventory(W)
		W.forceMove(get_turf(src))
		W.anchored = TRUE
		staged_focus = focus
		animate(W, pixel_x = 0, pixel_y = 0, time = 0.5 SECONDS, flags = ANIMATION_END_NOW)
		to_chat(user, span_cultsmall("The focus settles onto the seal..."))
		playsound(src, 'sound/magic/glass.ogg', 60, TRUE)
		return
	return ..()

/obj/effect/decal/cleanable/ritual_rune/arcyne/focus_etch/proc/try_invoke(mob/living/user)
	if(GET_MOB_SKILL_VALUE(user, /datum/attribute/skill/magic/arcane) <= SKILL_LEVEL_NONE)
		to_chat(user, span_warning("You aren't able to invoke these symbols."))
		return
	if(rune_in_use)
		to_chat(user, span_notice("The seal is already active."))
		return

	// Build eligible spell list, exclude essence and already-temporary spells
	var/list/eligible = list()
	for(var/datum/action/cooldown/spell/S in user.actions)
		if(S.spell_type == SPELL_ESSENCE)
			continue
		if(S.spell_flags & SPELL_TEMPORARY)
			continue
		if(S.spell_flags & SPELL_UNETCHABLE)
			continue
		eligible[S.name] = S

	if(!eligible.len)
		to_chat(user, span_warning("You have no storable spells."))
		return

	var/chosen_name = tgui_input_list(user, "Choose a spell to etch:", "Etch Focus", eligible)
	if(!chosen_name || !eligible[chosen_name])
		return
	if(!staged_focus || QDELETED(staged_focus)) // race guard
		return

	var/datum/action/cooldown/spell/chosen = eligible[chosen_name]

	// Ask how many charges (1-3, capped by mana availability)
	var/max_possible_charges = min(3, floor(user.mana_pool.amount / max(1, chosen.spell_cost * 2)))
	if(max_possible_charges < 1)
		to_chat(user, span_hierophant_warning("You don't have enough mana to etch even one charge of [chosen.name]."))
		return

	var/charge_options = list()
	for(var/i = 1, i <= max_possible_charges, i++)
		charge_options += "[i] (costs [chosen.spell_cost * 2 * i] mana)"

	var/charge_choice = tgui_input_list(user, "How many charges?", "Etch Focus", charge_options)
	if(!charge_choice || !staged_focus || QDELETED(staged_focus))
		return

	// Parse the chosen number back out
	chosen_charges = text2num(charge_choice)
	chosen_spell_type = chosen.type

	rune_in_use = TRUE
	animating = TRUE

	user.say(invocation, language = /datum/language/common, ignore_spam = TRUE, forced = "cult invocation")
	playsound(src, 'sound/magic/cosmic_expansion.ogg', 60, TRUE)
	SpinAnimation(speed = 1.5 SECONDS, loops = 1, clockwise = TRUE, segments = 6, parallel = TRUE)

	INVOKE_ASYNC(src, PROC_REF(run_etch_animation), user)

/obj/effect/decal/cleanable/ritual_rune/arcyne/focus_etch/proc/run_etch_animation(mob/living/user)
	animate(staged_focus,
		transform = matrix() * 0.3,
		alpha = 80,
		time = 1.0 SECONDS,
		flags = ANIMATION_END_NOW
	)
	sleep(1.0 SECONDS)

	var/success = do_etch(user)

	animate(staged_focus,
		transform = matrix(),
		alpha = 255,
		time = 0.5 SECONDS,
		flags = ANIMATION_END_NOW
	)
	sleep(0.5 SECONDS)

	if(success)
		playsound(src, 'sound/magic/blink.ogg', 80, TRUE)
	else
		for(var/i in 1 to 3)
			animate(staged_focus, pixel_x = -4, time = 0.1 SECONDS, flags = ANIMATION_END_NOW)
			sleep(0.1 SECONDS)
			animate(staged_focus, pixel_x = 4, time = 0.1 SECONDS, flags = ANIMATION_END_NOW)
			sleep(0.1 SECONDS)
		animate(staged_focus, pixel_x = 0, time = 0.1 SECONDS, flags = ANIMATION_END_NOW)
		sleep(0.1 SECONDS)

	staged_focus.anchored = FALSE
	animate(staged_focus, pixel_x = 0, pixel_y = 0, time = 0.3 SECONDS, flags = ANIMATION_END_NOW)
	staged_focus = null
	chosen_charges = 1
	chosen_spell_type = null

	animating = FALSE
	rune_in_use = FALSE
	do_invoke_glow()

/// Handles multi-charge mana deduction.
/obj/effect/decal/cleanable/ritual_rune/arcyne/focus_etch/proc/do_etch(mob/living/user)
	// Find the live spell again (user may have lost it between input and animation unfortunately)
	var/datum/action/cooldown/spell/live = null
	for(var/datum/action/cooldown/spell/S in user.actions)
		if(S.type == chosen_spell_type)
			live = S
			break
	if(!live)
		to_chat(user, span_warning("You no longer know that spell."))
		return FALSE

	var/total_mana = live.spell_cost * 2 * chosen_charges
	if(user.mana_pool.amount < total_mana)
		to_chat(user, span_phobia("You no longer have enough mana ([total_mana] needed)."))
		return FALSE

	user.mana_pool.adjust_mana(-total_mana)
	live.StartCooldown()

	staged_focus.stored_spell_type = chosen_spell_type
	staged_focus.stored_spell_name = live.name
	staged_focus.spell_tier = initial(live.spell_tier)
	staged_focus.grant_charges = chosen_charges
	staged_focus.name = "[live.name] focus"
	staged_focus.desc = "A focus etched with [live.name]. It can be consumed by an imbuing seal."
	staged_focus.update_appearance(UPDATE_OVERLAYS | UPDATE_NAME | UPDATE_DESC)

	user.visible_message(
		span_notice("[user] traces the seal, the focus blazes with [live.name]!"),
		span_notice("You etch [chosen_charges] charge\s of [live.name] into the focus.")
	)
	return TRUE

/obj/effect/decal/cleanable/ritual_rune/arcyne/focus_etch/proc/abort_etch()
	if(staged_focus && !QDELETED(staged_focus))
		staged_focus.anchored = FALSE
		animate(staged_focus, pixel_x = 0, pixel_y = 0, time = 0.5 SECONDS, flags = ANIMATION_END_NOW)
	staged_focus = null
	chosen_charges = 1
	chosen_spell_type = null
	animating = FALSE
	rune_in_use = FALSE

/obj/effect/decal/cleanable/ritual_rune/arcyne/focus_etch/Destroy()
	abort_etch()
	return ..()
